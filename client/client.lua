local nuiOpen = false 

-- Commands and Keymappings -- 
RegisterCommand(Config.alcolizerCommand, function()
    TriggerEvent('alcolizer:shownui')
end)

RegisterKeyMapping(Config.alcolizerCommand, "Show Alcolizer Device", "keyboard", Config.alcolizerKeybind)

RegisterCommand("aboutalcolizer", function()
    TriggerEvent('chat:addMessage', { args = { "~g~Alcolizer 1.0 was made by kaynegraham on github"}})
end)

-- Events -- 
RegisterNetEvent('alcolizer:alert')
AddEventHandler('alcolizer:alert', function (message, type) 
    showAlert(message, type)
end)

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

RegisterNetEvent('alcolizer:enterbac')
AddEventHandler('alcolizer:enterbac', function(officerId)
    local open = true 
    AddTextEntry("askforresult", "Enter your Blood Alcohol Content (Legal Limit is " .. Config.legalLimit .. ")")
    DisplayOnscreenKeyboard(1, "askforresult", "", "", "", "", "", 10)
    while (UpdateOnscreenKeyboard() == 0) do
        DisableAllControlActions(0)
        Wait(0)
    end

    local Result = GetOnscreenKeyboardResult()
    
    if Result and Result ~= "" then
        TriggerServerEvent('alcolizer:submitbac', officerId, Result)
    else
        showAlert("You entered an invalid BAC reading. Please enter a valid number.", "error")

        TriggerServerEvent('alcolizer:invalidbac', officerId)
        DisplayOnscreenKeyboard(1, "askforresult", "", "", "", "", "", 10)
    end
end)

RegisterNetEvent('alcolizer:recievebac')
AddEventHandler('alcolizer:recievebac', function(result)
    SendNUIMessage({
        type = "showbac",
        bac = result
    })
end)

RegisterNetEvent('alcolizer:showInvalid')
AddEventHandler('alcolizer:showInvalid', function()
    showAlert("Suspect entered an invalid BAC Reading.", "error")
end)


RegisterNuiCallback('resetalcolizer', function(data, cb)
    TriggerEvent('alcolizer:shownui')
    cb({})
end)

RegisterNuiCallback('alcolizeped', function(data, cb)
    local closestPlayer = GetClosestPlayer(3.0)

    if closestPlayer == nil then 
        TriggerEvent('alcolizer:shownui')
        showAlert("There is no player nearby to alcolize.", "error")
        return 
    end 

    local closestPlayerId = GetPlayerServerId(GetClosestPlayer(3.0))
    local officerId = GetPlayerServerId(PlayerId())

    -- Get Result
    TriggerServerEvent('alcolizer:requestbac', closestPlayerId, officerId)

    -- Configurable duration for animation and prop
    BreathalyzerAnim()

    -- Callback 
    cb({})
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
    local pos = vec3(0.1450,0.0210,-0.0600)
    local rot = vec3(-90.00,-180.00,-85.000)
    AttachEntityToEntity(breatho, PlayerPedId(), GetPedBoneIndex(PlayerPedId(), bone), pos.x, pos.y, pos.z, rot.x, rot.y, rot.z, true, true, false, true, 0, true)
    SetModelAsNoLongerNeeded(hash)
    Wait(Config.animationDuration)
    DeleteEntity(breatho)
end

function BreathalyzerAnim()
    local dict = "weapons@first_person@aim_rng@generic@projectile@shared@core"
    local clip = "idlerng_med"
    RequestAnimDict(dict)
    while not HasAnimDictLoaded(dict) do 
        Wait(100)
    end
    TaskPlayAnim(PlayerPedId(), dict, clip, 1.0, -1, Config.animationDuration, 50, 0, false, false, false)
    BreathalyzerProp()
    ClearPedTasksImmediately(PlayerPedId())
    RemoveAnimDict(dict)
end

function showAlert(message, type)
    SendNUIMessage({
        type = "notification",
        text = message,
        notifType = type or "info"
    })
end