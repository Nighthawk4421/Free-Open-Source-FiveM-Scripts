--local QBCore = exports['qb-core']:GetCoreObject()
--
--RegisterCommand('throwdookie', function()
--    local player = PlayerPedId() -- Get the player's ped (character) ID
--    if player then
--        local ped = PlayerPedId() -- Again, get the player's ped ID (redundant, but ensures it's accessible locally)
--        local hash = 'prop_big_shit_02' -- Define the model hash for the object to be thrown (a turd in this case)
--        local x, y, z = table.unpack(GetOffsetFromEntityInWorldCoords(ped, 0.0, 1.0, -1.0)) 
--        -- Get the position slightly in front of and below the player (1 meter forward, 1 meter down)
--
--        QBCore.Functions.LoadModel(hash) -- Load the specified model into memory
--        turdObj = CreateObjectNoOffset(hash, x, y, z, true, false) 
--        -- Create the object (turd) at the calculated position without offset
--
--        SetModelAsNoLongerNeeded(hash) -- Free up memory for the model as it is no longer needed
--        AttachEntityToEntity(turdObj, ped, GetPedBoneIndex(ped, 57005), 0.15, 0, 0, 0, 270.0, 60.0, true, true, false, true, 1, true) -- Attach the object to the player's right hand (bone index 57005) with specified offsets and rotations
--
--        local forwardVector = GetEntityForwardVector(ped) -- Get the forward direction vector of the player
--        local force = 50.0 -- Define the force to apply to the object when thrown
--        local animDict = "melee@unarmed@streamed_variations" -- Define the animation dictionary
--        local anim = "plyr_takedown_front_slap" -- Define the animation to play (a slapping motion)
--
--        ClearPedTasks(ped) -- Clear any existing animations or tasks the player is performing
--        QBCore.Functions.RequestAnimDict(animDict) -- Request the animation dictionary to be loaded
--        TaskPlayAnim(ped, animDict, anim, 8.0, -8.0, -1, 0, 0.0, false, false, false) -- Play the specified animation with defined speed and flags
--
--        Wait(500) -- Wait for half a second to synchronize the animation with the throw
--
--        DetachEntity(turdObj) -- Detach the object from the player's hand
--        ApplyForceToEntity(turdObj, 1, forwardVector.x * force, forwardVector.y * force + 5.0, forwardVector.z, 0, 0, 0, 0, false, true, true, false, true) 
--        -- Apply a forward force to the object to simulate the throw, adding a bit of extra force in the Y direction
--
--        turdID = ObjToNet(turdObj) -- Convert the object to a network ID to sync with other players
--        SetNetworkIdExistsOnAllMachines(turdObj, true) -- Ensure the object exists on all clients in the network
--    end
--end)
RegisterCommand('throwdookie', function()
    local ped = PlayerPedId() -- Get the player's ped (character) ID
    if ped then
        local hash = GetHashKey('prop_big_shit_02') -- Convert the object name to a hash
        local x, y, z = table.unpack(GetOffsetFromEntityInWorldCoords(ped, 0.0, 1.0, -1.0)) 
        -- Get the position slightly in front of and below the player

        -- Load the model into memory
        RequestModel(hash)
        while not HasModelLoaded(hash) do
            Wait(10) -- Wait until the model is loaded
        end

        -- Create the object at the specified position
        local turdObj = CreateObjectNoOffset(hash, x, y, z, true, false)

        -- Free up memory for the model
        SetModelAsNoLongerNeeded(hash)

        -- Attach the object to the player's right hand
        AttachEntityToEntity(
            turdObj, 
            ped, 
            GetPedBoneIndex(ped, 57005), -- Bone index for the right hand
            0.15, 0.0, 0.0, -- Position offsets
            0.0, 270.0, 60.0, -- Rotation offsets
            true, true, false, true, 1, true
        )

        -- Get the forward direction vector of the player
        local forwardVector = GetEntityForwardVector(ped)
        local force = 50.0 -- Define the force to apply to the object

        -- Define the animation details
        local animDict = "melee@unarmed@streamed_variations"
        local anim = "plyr_takedown_front_slap"

        -- Request the animation dictionary
        RequestAnimDict(animDict)
        while not HasAnimDictLoaded(animDict) do
            Wait(10) -- Wait until the animation dictionary is loaded
        end

        -- Clear existing tasks and play the throwing animation
        ClearPedTasks(ped)
        TaskPlayAnim(ped, animDict, anim, 8.0, -8.0, -1, 0, 0.0, false, false, false)

        -- Wait for the animation to sync with the throw
        Wait(500)

        -- Detach the object and apply a forward force
        DetachEntity(turdObj, true, true)
        ApplyForceToEntity(
            turdObj, 
            1, 
            forwardVector.x * force, 
            forwardVector.y * force + 5.0, 
            forwardVector.z, 
            0, 0, 0, 
            0, false, true, true, false, true
        )

        -- Convert the object to a network entity and sync with all clients
        local turdID = ObjToNet(turdObj)
        SetNetworkIdExistsOnAllMachines(turdObj, true)
    end
end)


--[[                IGNORE THIS SECTION IGNORE THIS SECTION IGNORE THIS SECTION IGNORE THIS SECTION IGNORE THIS SECTION IGNORE THIS SECTION IGNORE THIS SECTION IGNORE THIS SECTION
RegisterNetEvent('ownablePets:throwDookie',function()
    local player = PlayerPedId()
    if player then
        local ped = PlayerPedId()
        local hash = 'prop_big_shit_02'
        local x, y, z = table.unpack(GetOffsetFromEntityInWorldCoords(ped,0.0,1.0,-1.0))
        QBCore.Functions.LoadModel(hash)
        turdObj = CreateObjectNoOffset(hash, x, y, z, true, false)
        SetModelAsNoLongerNeeded(hash)
        AttachEntityToEntity(turdObj, ped, GetPedBoneIndex(ped, 57005), 0.15, 0, 0, 0, 270.0, 60.0, true, true, false, true, 1, true) -- object is attached to right hand 
        local forwardVector = GetEntityForwardVector(ped)
        local force = 50.0
        local animDict = "melee@unarmed@streamed_variations"
        local anim = "plyr_takedown_front_slap"
        ClearPedTasks(ped)
        QBCore.Functions.RequestAnimDict(animDict)
        TaskPlayAnim(ped, animDict, anim, 8.0, -8.0, -1, 0, 0.0, false, false, false)
        Wait(500)
        DetachEntity(turdObj)
        ApplyForceToEntity(turdObj,1,forwardVector.x*force,forwardVector.y*force + 5.0,forwardVector.z,0,0,0,0,false,true,true,false,true)
        turdID = ObjToNet(turdObj)
        SetNetworkIdExistsOnAllMachines(turdObj,true)
    end
end)]]