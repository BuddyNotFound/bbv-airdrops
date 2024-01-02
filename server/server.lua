local taken = false

RegisterNetEvent('bbv-drop:create:server',function(a,b)
    local pos = a
    local item = b
    local src = source
    local id = Wrapper:Identifiers(src)
    TriggerClientEvent('bbv-drop:create:client', -1, pos,item)
end)

RegisterNetEvent('bbv-drop:create:server:admin',function(a,b)
    local pos = a
    local item = b
    local src = source
    local id = Wrapper:Identifiers(src)
    if not Config.Restricted then 
        TriggerClientEvent('bbv-drop:create:client', -1, pos,item)
    end
    if Config.Restricted then 
        for k,v in pairs(Config.Allowed) do 
            if v == id.discord then 
                TriggerClientEvent('bbv-drop:create:client', -1, pos,item)
            end
        end
    end
end)

RegisterNetEvent('bbv-drop:synctarget:server',function(a,b,c,d,e,f,g)
    -- print(g .. ' sync server')
    
    TriggerClientEvent('bbv-drop:synctarget:client',-1,a,b,c,d,e,f,g)
end)

RegisterNetEvent('bbv-drop:end:server',function()
    TriggerClientEvent('bbv-drop:end:client',-1)
    TriggerClientEvent('bbv-drop:remove:client',-1)
    Wait(10000)
    taken = false
end)

RegisterNetEvent('bbv-drop:server:pickup', function()
    local src = source
    if not taken then
        taken = true
        TriggerClientEvent('bbv-drop:pickup', src)
        TriggerClientEvent('bbv-drop:pickup:taken', -1)
    end
end)