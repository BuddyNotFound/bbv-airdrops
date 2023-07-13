RegisterNetEvent('bbv-drop:create:server',function(a,b)
    print('drop')
    local pos = a
    local item = b
    local src = source
    local id = Wrapper:Identifiers(src)
    print(pos,item)
    for k,v in pairs(Config.Allowed) do 
        print(v,id.discord)
        if v == id.discord then 
            TriggerClientEvent('bbv-drop:create:client', -1, pos,item)
        end
    end
end)

RegisterNetEvent('bbv-drop:synctarget:server',function(a,b,c,d,e,f,g,item)
    TriggerClientEvent('bbv-drop:synctarget:client',-1,a,b,c,d,e,f,g,item)
end)

RegisterNetEvent('bbv-drop:end:server',function()
    TriggerClientEvent('bbv-drop:end:client',-1)
end)