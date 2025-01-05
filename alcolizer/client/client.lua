local nuiOpen = false 

-- Commands and Keymappings -- 
RegisterCommand("showalcolizer", function()
    TriggerEvent('alcolizer:shownui')
end)

RegisterKeyMapping("showalcolizer", "Show Alcolizer Device", "keyboard", "f7")

RegisterCommand("aboutalcolizer", function()
    TriggerEvent('chat:addMessage', { args = { "~g~Alcolizer was made by kaynegraham on github"}})
end)

-- Events -- 
RegisterNetEvent('alcolizer:shownui')
AddEventHandler('alcolizer:shownui', function()
    if not nuiOpen then 
        SendNUIMessage({
            type = "opennui"
        })
        SetNuiFocus(true, true)
        nuiOpen = true 
    else 
        SendNUIMessage({
            type = "closenui"
        })
        SetNuiFocus(false, false)
        nuiOpen = false 
    end 
end)

RegisterNetEvent('alcolizer:askforresult')
AddEventHandler('alcolizer:askforresult', function()
    AddTextEntry("askforresult", "Enter your Blood Alcohol Content (Legal Limit is 0.05)")
    DisplayOnscreenKeyboard(1, "askforresult", "", "", "", "", "", 10)
    while (UpdateOnscreenKeyboard() == 0) do
        DisableAllControlActions(0)
        Wait(0)
    end

    if (GetOnscreenKeyboardResult()) then 
        Result = GetOnscreenKeyboardResult()
        TriggerServerEvent('alcolizer:senddatatoserver', Result)
    end
end)

RegisterNetEvent('alcolizer:fetchresult')
AddEventHandler('alcolizer:fetchresult', function(result)
    BacResult = result
end)

-- NUI Callbacks --
RegisterNuiCallback('resetalcolizer', function(data, cb)
    TriggerEvent('alcolizer:shownui')
    cb({})
end)

RegisterNuiCallback('alcolizeped', function(data, cb)
    -- BreathalyzerAnim()
    -- BreathalyzerProp()
    TriggerEvent('alcolizer:shownui')
    local closestPlayerId = GetPlayerServerId(GetClosestPlayer(3.0))
    local officerId = GetPlayerServerId(PlayerId())
    TriggerServerEvent('alcolizer:getresult', closestPlayerId, officerId)
    Wait(5000)
    cb(BacResult)
   -- need to callback once result is returned not hard coded!
end)

-- Functions -- 
function GetClosestPlayer(maxDistance)
    local players = GetActivePlayers() 
    local ped = GetPlayerPed(-1)
    local coords = GetEntityCoords(ped) 
    local closestPlayer 
   
    for i,v in ipairs(players) do 
       local target = GetPlayerPed(v) 
   
       if target ~= ped then 
       local targetCoords = GetEntityCoords(target) 
       local distance = Vdist(targetCoords.x, targetCoords.y, targetCoords.z, coords.x, coords.y, coords.z)
   
       if distance < maxDistance then
           closestPlayer = v
               end
            end
       end
       return closestPlayer
   end

function BreathalyzerProp()
    local hash = `prop_inhaler_01`
    local coords = GetEntityCoords(PlayerPedId())
    local bone = 28422
    RequestModel(hash)
    while not HasModelLoaded(hash) do 
        Wait(0)
    end
    local breatho = CreateObject(hash, coords.x, coords.y, coords.z, true, false, false)
    local breathoId = ObjToNet(breatho)
    local pos = vec3(0.0600,0.0210,-0.0400)
    local rot = vec3(-90.00,-180.00,-85.000)
    AttachEntityToEntity(breatho, PlayerPedId(), GetPedBoneIndex(PlayerPedId(), bone), pos.x, pos.y, pos.z, rot.x, rot.y, rot.z, true, true, false, true, 0, true)
    SetModelAsNoLongerNeeded(hash)
    Wait(5000)
    DeleteEntity(breatho)
end

RegisterCommand('test', function()
    BreathalyzerAnim()
    BreathalyzerProp()
end)

function BreathalyzerAnim()
    local dict = "weapons@first_person@aim_rng@generic@projectile@shared@core"
    local clip = "idlerng_med"
    RequestAnimDict(dict)
    while not HasAnimDictLoaded(dict) do 
        Wait(100)
    end
    TaskPlayAnim(PlayerPedId(), dict, clip, 1.0, -1, 5000, 50, 0, false, false, false)
    BreathalyzerProp()
    Wait(5000)
    ClearPedTasksImmediately(PlayerPedId())
    RemoveAnimDict(dict)
end