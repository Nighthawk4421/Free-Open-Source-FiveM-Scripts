-- Server-side script for checking player-specific permissions via QBCore Notify
QBCore = exports['qb-core']:GetCoreObject()

-- Register the /checkpermissions command
QBCore.Commands.Add('checkpermissions', 'Check your permissions from server.cfg', {}, false, function(source, args)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    
    if not Player then
        TriggerClientEvent('QBCore:Notify', src, 'Error: Player data not found.', 'error', 5000)
        return
    end

    -- Prepare notification message for the player
    local chatMessage = "Your Permissions:\n"

    -- Check QBCore permissions
    local qbPermissions = QBCore.Functions.GetPermission(src)
    chatMessage = chatMessage .. "QBCore Permissions:\n"
    local hasQbPerm = false
    for perm, enabled in pairs(qbPermissions) do
        if enabled then
            chatMessage = chatMessage .. "- " .. perm .. "\n"
            hasQbPerm = true
        end
    end
    if not hasQbPerm then
        chatMessage = chatMessage .. "- None\n"
    end

    -- Check ACE permissions (only show allowed)
    chatMessage = chatMessage .. "ACE Permissions:\n"
    local acePermsToCheck = {'qbcore.god', 'qbcore.admin', 'qbcore.mod', 'group.admin', 'command', 'test.perm', 'wasabi.adminmenu.allow', 'fire-ems-pager.group.supervisor'} -- Add relevant permissions
    local hasAcePerm = false
    for _, perm in ipairs(acePermsToCheck) do
        if IsPlayerAceAllowed(src, perm) then
            chatMessage = chatMessage .. "- " .. perm .. "\n"
            hasAcePerm = true
        end
    end
    if not hasAcePerm then
        chatMessage = chatMessage .. "- None\n"
    end

    -- Send permissions to player's chat via QBCore Notify
    TriggerClientEvent('QBCore:Notify', src, chatMessage, 'success', 10000) -- 10-second display
end, 'user')