data = {}

if Config.Settings.Framework == "QB" then 
    for k ,v in pairs(Items) do
        QBCore.Functions.CreateUseableItem(Items[k].Item, function(source, item)
            local src = source
            local Player = QBCore.Functions.GetPlayer(src)
            if Player.Functions.GetItemByName(item.name) then
                Player.Functions.RemoveItem(item.name, 1)
                TriggerClientEvent('bbv-airdrops:itemdrop',src,Items[k].Item)
            end
        end)
    end
end

if Config.Settings.Framework == "ESX" then 
    for k ,v in pairs(Items) do
        ESX.RegisterUsableItem(Items[k].Item, function(source)
            local src = source
            local xPlayer = ESX.GetPlayerFromId(src)
            xPlayer.removeInventoryItem(Items[k].Item, 1)
            TriggerClientEvent('bbv-airdrops:itemdrop',src,Items[k].Item)
        end)
    end
end

