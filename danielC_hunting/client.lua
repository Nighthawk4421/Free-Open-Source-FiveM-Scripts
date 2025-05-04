-- client.lua
local QBCore = exports['qb-core']:GetCoreObject()
local isSkinning = false

-- List of GTA V animal ped hashes
local Animals = {
    {hash = `a_c_boar`, name = "Boar", meat = "meat_boar", pelt = "pelt_boar"},
    --{hash = `a_c_cat_01`, name = "Cat", meat = "meat_cat", pelt = "pelt_cat"}, ****hurts Justins feelings :(
    {hash = `a_c_chickenhawk`, name = "Hawk", meat = "meat_bird", pelt = "feather"},
    {hash = `a_c_cormorant`, name = "Cormorant", meat = "meat_bird", pelt = "feather"},
    {hash = `a_c_cow`, name = "Cow", meat = "meat_cow", pelt = "pelt_cow"},
    {hash = `a_c_coyote`, name = "Coyote", meat = "meat_coyote", pelt = "pelt_coyote"},
    {hash = `a_c_crow`, name = "Crow", meat = "meat_bird", pelt = "feather"},
    {hash = `a_c_deer`, name = "Deer", meat = "meat_deer", pelt = "pelt_deer"},
    {hash = `a_c_hen`, name = "Hen", meat = "meat_chicken", pelt = "feather"},
    {hash = `a_c_mtlion`, name = "Mountain Lion", meat = "meat_lion", pelt = "pelt_lion"},
    {hash = `a_c_pig`, name = "Pig", meat = "meat_pig", pelt = "pelt_pig"},
    {hash = `a_c_pigeon`, name = "Pigeon", meat = "meat_bird", pelt = "feather"},
    {hash = `a_c_rabbit_01`, name = "Rabbit", meat = "meat_rabbit", pelt = "pelt_rabbit"},
    {hash = `a_c_rat`, name = "Rat", meat = "meat_rat", pelt = "pelt_rat"},
    {hash = `a_c_seagull`, name = "Seagull", meat = "meat_bird", pelt = "feather"}
}

-- Function to check if entity is an animal
local function IsAnimal(entity)
    local model = GetEntityModel(entity)
    for _, animal in pairs(Animals) do
        if model == animal.hash then
            return animal
        end
    end
    return nil
end

-- Skinning function
local function SkinAnimal(animal, entity)
    if isSkinning then return end
    
    isSkinning = true
    local playerPed = PlayerPedId()
    
    -- Face the animal
    TaskTurnPedToFaceEntity(playerPed, entity, 1000)
    Wait(1000)
    
    -- Start skinning animation
    TaskStartScenarioInPlace(playerPed, "WORLD_HUMAN_GARDENER_PLANT", 0, true)
    
    -- Show progress bar
    QBCore.Functions.Progressbar("skinning_animal", "Skinning " .. animal.name .. "...", 10000, false, true, {
        disableMovement = true,
        disableCarMovement = true,
        disableMouse = false,
        disableCombat = true,
    }, {}, {}, {}, function() -- Done
        ClearPedTasks(playerPed)
        
        -- Give rewards
        TriggerServerEvent('qb-hunting:reward', animal.meat, animal.pelt)
        
        -- Delete the animal corpse
        DeleteEntity(entity)
        isSkinning = false
    end, function() -- Cancel
        ClearPedTasks(playerPed)
        QBCore.Functions.Notify("Skinning cancelled", "error")
        isSkinning = false
    end)
end

-- Initialize qb-target for dead animals
Citizen.CreateThread(function()
    for _, animal in pairs(Animals) do
        exports['qb-target']:AddTargetModel({animal.hash}, {
            options = {
                {
                    type = "client",
                    event = "qb-hunting:skin",
                    icon = "fas fa-knife",
                    label = "Skin " .. animal.name,
                    canInteract = function(entity)
                        return IsPedDeadOrDying(entity, true) and not isSkinning
                    end
                }
            },
            distance = 2.0
        })
    end
end)

-- Client event for skinning
RegisterNetEvent('qb-hunting:skin')
AddEventHandler('qb-hunting:skin', function(data)
    local entity = data.entity
    local animal = IsAnimal(entity)
    if animal then
        SkinAnimal(animal, entity)
    end
end)

-- Check if player killed an animal
Citizen.CreateThread(function()
    while true do
        Wait(1000)
        local playerPed = PlayerPedId()
        local coords = GetEntityCoords(playerPed)
        
        for _, animal in pairs(Animals) do
            local nearbyAnimals = GetClosestPed(coords, animal.hash)
            if nearbyAnimals and DoesEntityExist(nearbyAnimals) then
                if IsPedDeadOrDying(nearbyAnimals, true) then
                    -- Animal is already handled by qb-target
                end
            end
        end
    end
end)

-- Helper function to get closest ped (not included in QBCore by default)
function GetClosestPed(coords, model)
    local ped = nil
    local closestDist = 1000.0
    local nearbyPeds = GetGamePool('CPed')
    
    for _, entity in pairs(nearbyPeds) do
        if GetEntityModel(entity) == model then
            local dist = #(coords - GetEntityCoords(entity))
            if dist < closestDist then
                closestDist = dist
                ped = entity
            end
        end
    end
    
    return ped
end