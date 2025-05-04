-- server.lua
local QBCore = exports['qb-core']:GetCoreObject()

RegisterServerEvent('qb-hunting:reward')
AddEventHandler('qb-hunting:reward', function(meat, pelt)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    
    if Player then
        -- Random amount of meat (1-3)
        local meatAmount = math.random(1, 3)
        -- 50% chance for pelt
        local peltAmount = 1
        
        Player.Functions.AddItem(meat, meatAmount)
        TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items[meat], "add", meatAmount)
        
        if peltAmount > 0 then
            Player.Functions.AddItem(pelt, peltAmount)
            TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items[pelt], "add", peltAmount)
        end
        
        TriggerClientEvent('QBCore:Notify', src, 'You finished skinning the animal', 'success')
    end
end)