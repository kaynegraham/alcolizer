RegisterNetEvent('alcolizer:getresult')
AddEventHandler('alcolizer:getresult', function(closestplayerId, officerId)
    returnId = officerId
    TriggerClientEvent('alcolizer:askforresult', closestplayerId)
end)

RegisterNetEvent('alcolizer:senddatatoserver')
AddEventHandler('alcolizer:senddatatoserver', function(data)
    TriggerClientEvent("alcolizer:fetchresult", returnId, data)
end)