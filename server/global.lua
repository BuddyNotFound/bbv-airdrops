globalwait = Global.Settings.Time * 60000
--print(globalwait)

CreateThread(function()
    while true do
        Wait(globalwait)
        if Global.Settings.Enabled then 
            TriggerEvent('bbv-airdrops:randomevent')
        end
    end
end)

RegisterNetEvent('bbv-airdrops:randomevent',function()
    local chance = math.random(1,#Global.Settings.Rewards)
    local Reward = Global.Settings.Rewards[chance]
    local poschance = math.random(1,#Global.Settings.Positions)
    local pos = Global.Settings.Positions[poschance]

    TriggerClientEvent('bbv-airdrops:itemdrop:global', -1, Reward,pos)
end)

RegisterCommand('globalairdrop', function(source,args)
    local src = source
    --print(src)
    local id = Wrapper:Identifiers(src)
    for k,v in pairs(Config.Allowed) do 
        if v == id.discord then 
            local chance = math.random(1,#Global.Settings.Rewards)
            local Reward = Global.Settings.Rewards[chance]
            local poschance = math.random(1,#Global.Settings.Positions)
            local pos = Global.Settings.Positions[poschance]
            --print(Reward)
            --print(pos)
            TriggerClientEvent('bbv-airdrops:itemdrop:global', -1, Reward,pos)
        end
    end
end)