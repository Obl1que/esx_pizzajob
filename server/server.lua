ESX = nil 
onDuty = false
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

RegisterNetEvent('esx_pizzajob:payMoney')
AddEventHandler('esx_pizzajob:payMoney', function(amount)
    xPlayer = ESX.GetPlayerFromId(source)
    xPlayer.addMoney(amount)
end)
RegisterNetEvent('esx_pizzajob:addInventoryItem')
AddEventHandler('esx_pizzajob:addInventoryItem', function(item, count)
    xPlayer = ESX.GetPlayerFromId(source)
    xPlayer.addInventoryItem(item, count)
end)
RegisterNetEvent('esx_pizzajob:removeInventoryItem')
AddEventHandler('esx_pizzajob:removeInventoryItem', function(item, count)
    xPlayer = ESX.GetPlayerFromId(source)
    xPlayer.removeInventoryItem(item, count)
end)
RegisterNetEvent('esx_pizzajob:removeMoney')
AddEventHandler('esx_pizzajob:removeMoney', function(amount)
    XPlayer = ESX.GetPlayerFromId(source)
    xPlayer.removeMoney(amount)
end)
ESX.RegisterUsableItem('pizza', function(playerId)
    local xPlayer = ESX.GetPlayerFromId(playerId)
    if onDuty then
        TriggerClientEvent('esx:showNotification', playerId, "~r~You can't eat pizza while working!")
    else
        xPlayer.removeInventoryItem('pizza', 1)
        TriggerClientEvent('esx:showNotification', playerId, 'That was delicious... right?')
    end
end)
RegisterNetEvent('esx_pizzajob:setOnDuty')
AddEventHandler('esx_pizzajob:setOnDuty', function(setTo)
    onDuty = setTo
end)