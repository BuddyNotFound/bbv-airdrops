

Wrapper = {}

-- RegisterNetEvent("Wrapper:Bill",function(playerId, amount)
--     Wrapper:Bill(playerId, amount)
-- end)

RegisterNetEvent("Wrapper2:airdrop::AddItem",function(item,amount)
    --------print('Wrapper Server : Add Item ' ..item.. "  x"..amount)
    Wrapper:AddItemServer(item,amount)
end)

RegisterNetEvent("Wrapper2:airdrop::RemoveItem",function(item,amount)
    --------print('Wrapper Server : Remove Item ' ..item.. "  x"..amount)
    Wrapper:RemoveItemServer(item,amount)
end)

-- RegisterNetEvent("Wrapper:AddMoney",function(item,amount)
--     --------print('Wrapper Server : Add Item ' ..item.. "  x"..amount)
--     Wrapper:AddMoney(item,amount)
-- end)

RegisterNetEvent("Wrapper:Log",function(item,amount)
    local src = source
    Wrapper:Log(src, item,amount)
end)

-- function Wrapper:AddMoney(type,amount)
--     local src = source
--     local Player = QBCore.Functions.GetPlayer(src)
--     if not Player then return end
--     --------print('Wrapper Final AddMoney : '.. type.. "  x".. amount)
--     Player.Functions.AddMoney(type, amount) 
-- end

function Wrapper:AddItemServer(item,amount)
    if Config.Settings.Framework == "QB" then 
        local src = source
        local Player = QBCore.Functions.GetPlayer(src)
        if not Player then return end
        ----print('Wrapper Final AddItem : '.. item.. "  x".. amount)
        Player.Functions.AddItem(item, amount) 
        TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items[item], "add")
    end
    if Config.Settings.Framework == "QBX" then 
        local src = source
        local Player = QBCore.Functions.GetPlayer(src)
        if not Player then return end
        ----print('Wrapper Final AddItem : '.. item.. "  x".. amount)
        Player.Functions.AddItem(item, amount) 
        TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items[item], "add")
    end
    if Config.Settings.Framework == "ESX" then 
        local src = source 
        local xPlayer = ESX.GetPlayerFromId(src)
        xPlayer.addInventoryItem(item, amount)
    end
end

function Wrapper:RemoveItemServer(item,amount)
    if Config.Settings.Framework == "QB" then 
        local src = source
        local Player = QBCore.Functions.GetPlayer(src)
        if not Player then return end
        ------print('Wrapper Final RemoveItem : '.. item.. "  x".. amount)
        Player.Functions.RemoveItem(item, amount) 
        TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items[item], "remove")
    end
    if Config.Settings.Framework == "QBX" then 
        local src = source
        local Player = QBCore.Functions.GetPlayer(src)
        if not Player then return end
        ------print('Wrapper Final RemoveItem : '.. item.. "  x".. amount)
        Player.Functions.RemoveItem(item, amount) 
        TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items[item], "remove")
    end
    if Config.Settings.Framework == "ESX" then 
        local src = source 
        if Config.Settings.Inventory == "QS" then 
            exports['qs-inventory']:RemoveItem(src, item, amount)
            return
        end
        local xPlayer = ESX.GetPlayerFromId(src)
        xPlayer.removeInventoryItem(item, amount)
    end
end

-- function Wrapper:Log(_src,webhook,txt)
--     local src = _src
--     local name = GetPlayerName(src)
--     local steam = GetPlayerIdentifier(src)
--     local ip = GetPlayerEndpoint(src)
--     local identifiers = Wrapper:Identifiers(src)
--     local license = identifiers.license
--     local discord ="<@" ..identifiers.discord:gsub("discord:", "")..">" 
--     local disconnect = {
--             {
--                 ["color"] = "16711680", -- Color in decimal
--                 ["title"] = txt, -- Title of the embed message
--                 ["description"] = "Name: **"..name.."**\nSteam ID: **"..steam.."**\nIP: **" .. ip .."**\nGTA License: **" .. license .. "**\nDiscord Tag: **" .. discord .. "**\nLog: **"..txt.."**", -- Main Body of embed with the info about the person who left
--             }
--         }
    
--         PerformHttpRequest(webhook, function(err, text, headers) end, 'POST', json.encode({username = username, embeds = disconnect, tts = TTS}), { ['Content-Type'] = 'application/json' }) -- Perform the request to the discord webhook and send the specified message
-- end

-- function Wrapper:Bill(playerId, amount)
--     local biller = QBCore.Functions.GetPlayer(source)
--     local billed = QBCore.Functions.GetPlayer(tonumber(playerId))
--     local amount = tonumber(amount)
--     if biller.PlayerData.job.name == 'sotw' then
--         if billed ~= nil then
--             if biller.PlayerData.citizenid ~= billed.PlayerData.citizenid then
--                 if amount and amount > 0 then
--                     exports['oxmysql']:insert('INSERT INTO phone_invoices (citizenid, amount, society, sender) VALUES (:citizenid, :amount, :society, :sender)', {
--                         ['citizenid'] = billed.PlayerData.citizenid,
--                         ['amount'] = amount,
--                         ['society'] = biller.PlayerData.job.name,
--                         ['sender'] = biller.PlayerData.charinfo.firstname
--                     })
--                     TriggerClientEvent('qb-phone:RefreshPhone', billed.PlayerData.source)
--                     TriggerClientEvent('QBCore:Notify', source, 'Invoice Successfully Sent', 'success')
--                     TriggerClientEvent('QBCore:Notify', billed.PlayerData.source, 'New Invoice Received')
--                 else
--                     TriggerClientEvent('QBCore:Notify', source, 'Must Be A Valid Amount Above 0', 'error')
--                 end
--             else
--                 TriggerClientEvent('QBCore:Notify', source, 'You Cannot Bill Yourself', 'error')
--             end
--         else
--             TriggerClientEvent('QBCore:Notify', source, 'Player Not Online', 'error')
--         end
--     else
--         TriggerClientEvent('QBCore:Notify', source, 'No Access', 'error')
--     end
-- end

function Wrapper:Identifiers(src)
    local identifiers = {
        steam = "",
        ip = "",
        discord = "",
        license = "",
        xbl = "",
        live = ""
    }

    for i = 0, GetNumPlayerIdentifiers(src) - 1 do
        local id = GetPlayerIdentifier(src, i)

        if string.find(id, "steam") then
            identifiers.steam = id
        elseif string.find(id, "ip") then
            identifiers.ip = id
        elseif string.find(id, "discord") then
            identifiers.discord = id
        elseif string.find(id, "license") then
            identifiers.license = id
        elseif string.find(id, "xbl") then
            identifiers.xbl = id
        elseif string.find(id, "live") then
            identifiers.live = id
        end
    end

    return identifiers
end

