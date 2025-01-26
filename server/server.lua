RegisterNetEvent('alcolizer:requestbac')
AddEventHandler('alcolizer:requestbac', function(closestplayerId, officerId)
    TriggerClientEvent('alcolizer:enterbac', closestplayerId, officerId)
end)

RegisterNetEvent('alcolizer:submitbac')
AddEventHandler('alcolizer:submitbac', function(officerId, bacResult)
    TriggerClientEvent("alcolizer:recievebac", officerId, bacResult)
end)

RegisterNetEvent('alcolizer:invalidbac')
AddEventHandler('alcolizer:invalidbac', function(officerId)
    TriggerClientEvent("alcolizer:showInvalid", officerId)
end)
