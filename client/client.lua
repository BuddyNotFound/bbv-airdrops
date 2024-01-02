Main = {
	Reward = {}
}
item = {}
inbound = false
owner = false
objecttest = nil
taken = false

RegisterCommand('drop',function(source,args)
    local pos = vector3(tonumber(args[1]),tonumber(args[2]),tonumber(args[3]))
	owner = true
	local str = ''

	for i=4, #args, 1 do
		str = args[i]
		item[i - 3] = str
	end


    TriggerServerEvent('bbv-drop:create:server:admin',pos,item)
end)



RegisterNetEvent('bbv-airdrops:itemdrop',function(data)
	if inbound then 
		Wrapper:Notify('There is already an active drop')
		return
	end
	inbound = true
    local pos = GetEntityCoords(PlayerPedId())

	RequestWeaponAsset(GetHashKey("weapon_flare")) 
    while not HasWeaponAssetLoaded(GetHashKey("weapon_flare")) do
        Wait(0)
    end

	ShootSingleBulletBetweenCoords(pos.x,pos.y,pos.z, pos.x,pos.y ,pos.z - 1, 0, false, GetHashKey("weapon_flare"), 0, true, true, -1.0)
	owner = true
	-- Wait(3000)
	-- --print(json.encode(Items[data].Reward))
	TriggerServerEvent('bbv-drop:create:server',pos,Items[data].Reward)
end)

RegisterNetEvent('bbv-airdrops:itemdrop:global',function(data,datapos)
	if inbound then 
		-- Wrapper:Notify('already drop')
		return
	end
	Wrapper:Notify('Global Airdrop Inbound')
	inbound = true
	pos = datapos
	RequestWeaponAsset(GetHashKey("weapon_flare")) 
    while not HasWeaponAssetLoaded(GetHashKey("weapon_flare")) do
        Wait(0)
    end

	ShootSingleBulletBetweenCoords(pos.x,pos.y,pos.z, pos.x,pos.y ,pos.z - 1, 0, false, GetHashKey("weapon_flare"), 0, true, true, -1.0)
	owner = true
	--print(pos .. ' itemdrop')
	--print(json.encode(data) .. ' itemdrop')
	-- Wait(3000)
	-- --print(json.encode(Items[data].Reward))
	TriggerServerEvent('bbv-drop:create:server',pos,data)
end)


RegisterNetEvent('bbv-drop:create:client',function(a,b)
    if Config.Drop.Broadcast then 
        Wrapper:Notify(Config.Drop.BroadcastMSG)
        PlaySoundFrontend(-1, "TIMER_STOP", "HUD_MINI_GAME_SOUNDSET", 1)
    end
	inbound = true
	
    if Config.Debug then
        --print('Drop on : '.. a.x .. ' '.. a.y.. ' ' .. a.z .. ' ' .. ' Items : ')
    end
	Main.Reward = b
	--print(Main.Reward)
    local _pos =  a
    local _item = b
    Wrapper:Blip('drop',Config.Blip.Label,_pos,Config.Blip.Sprite,Config.Blip.Color,Config.Blip.Scale)
    taken = false
    radius = AddBlipForRadius(_pos, 100.0) -- need to have .0
    SetBlipColour(radius, 1)
    SetBlipAlpha(radius, 128)
    Main:SpawnPlane(_pos)
end)

function Main:SpawnPlane(a,b)
    local model = GetHashKey(Config.Vehicle.Model)
	LoadModel(model)

	local pilotModel = GetHashKey(Config.Vehicle.Pilot)
	LoadModel(pilotModel)
	
	local startTime = GetGameTimer()
	local lastUpdate = startTime

	local rad = GetRandomFloatInRange(-3.14, 3.14)
	local direction = vector3(math.cos(rad), math.sin(rad), 0.0)
	local vehicleCoords = vector3(3500,-3500, Config.Vehicle.Height)
	local heading = rad * 57.2958 - 90
	color = 1
	Vehicle = CreateVehicle(model, vehicleCoords.x, vehicleCoords.y, vehicleCoords.z, heading, false, true)
	Pilot = CreatePed(4, pilotModel, vehicleCoords.x, vehicleCoords.y, vehicleCoords.z, heading, false, true)
	if Config.BlipForPlane then 
    	planeblip = AddBlipForEntity(Vehicle)
        SetBlipSprite(planeblip,307)
		SetBlipRotation(planeblip,GetEntityHeading(Pilot))
    end
	SetPedIntoVehicle(Pilot, Vehicle, -1)

	ControlLandingGear(Vehicle, 3)
	SetVehicleEngineOn(Vehicle, true, true, false)
	SetEntityVelocity(Vehicle, direction.x * Config.Vehicle.Speed, direction.y * Config.Vehicle.Speed, 0.0)
    
    while DoesEntityExist(Vehicle) do
		if not NetworkHasControlOfEntity(Vehicle) then
			NetworkRequestControlOfEntity(Vehicle)
			Citizen.Wait(50)
		end
		if Config.BlipForPlane then 
			SetBlipRotation(planeblip,Ceil(GetEntityHeading(Pilot)))
			if color == 1 then 
				SetBlipColour(planeblip,6)
				color = 2
			else
				SetBlipColour(planeblip,3)
				color = 1
			end
		end

		local delta = (GetGameTimer() - lastUpdate) / 1000.0
		lastUpdate = GetGameTimer()
		
		local coords = coords
		local vehicle = 0
		if ped then

			

			if IsPedInAnyHeli(ped) or IsPedInAnyPlane(ped) then
				vehicle = GetVehiclePedIsIn(ped)
			end
		else
			ped = 0
		end
		local _pos = a
		local _item = b
		TaskPlaneMission(Pilot, Vehicle, vehicle, ped, _pos.x, _pos.y, _pos.z + 250, 6, 0, 0, heading, 2000.0, 400.0)
		local pcoords = GetEntityCoords(Vehicle)
        local dist = #(pcoords - _pos)
        if Config.Debug then 
            --print('dist : ' ..dist)
        end
        if dist < 350 or dropped then
            dropped = true
            Wait(1000)
            if dropped then  end
            TaskPlaneMission(Pilot, Vehicle, vehicle, ped, -3500,3500, Config.Vehicle.Height, 6, 0, 0, heading, 2000.0, 400.0)
			--print('drop')
			--print(_pos)
			TriggerEvent('bbv-drop:drop',_pos)
            if dist > 1500 then 
                DeleteEntity(Vehicle)
                Vehicle = 0
                DeleteEntity(Pilot)
                Pilot = 0
                return
            end
        end

		Citizen.Wait(1000)
	end

	Citizen.Wait(5000)


end

function LoadModel(model)
	while not HasModelLoaded(model) do
		RequestModel(model)
		Citizen.Wait(25)
	end
end


RegisterNetEvent('bbv-drop:drop',function(a)
	blipi = true
    if drop == nil then
        local offset = math.random(-100,100)
        local pos = vector3(a.x + offset,a.y + offset,a.z + 150)
        local ground = vector3(a.x,a.y,a.z - 100)
        --print('in drop '..pos)
        RequestWeaponAsset(GetHashKey("weapon_flare")) 
        while not HasWeaponAssetLoaded(GetHashKey("weapon_flare")) do
            Wait(0)
        end
        if owner then 
            Wrapper:LoadModel(Config.Drop.Prop)
            ShootSingleBulletBetweenCoords(pos.x, pos.y, pos.z, ground.x, ground.y, ground.z, 0, false, GetHashKey("weapon_flare"), 0, true, true, -1.0)
            drop = CreateObject(Config.Drop.Prop, pos.x, pos.y, pos.z, true, true)
            SetObjectPhysicsParams(drop,99999.0, Config.Drop.Veolicty, 0.0, 0.0, 0.0, 700.0, 0.0, 0.0, 0.0, Config.Drop.Veolicty, 0.0)
			SetEntityLodDist(drop, 1000) -- so we can see it from the distance
			ActivatePhysics(drop)
			SetDamping(drop, 2, 0.1) -- no idea but Rockstar uses it
			SetEntityVelocity(drop, 0.0, 0.0, math.random() + math.random(-21000, -5500))
            -- print(drop .. '<--- clien obj id')
            netid = ObjToNet(drop)
            TriggerServerEvent('bbv-drop:synctarget:server','drop',Config.Drop.Label,pos,'bbv-drop:pickup',1,1, netid)
        end
        -- print(drop .. ' bbv-drop:drop')
        
    end
end)

AddEventHandler('onResourceStop', function(resourceName)
    if (GetCurrentResourceName() ~= resourceName) then
      return
    end
    DeleteObject(drop)
    DeleteObject(objecttest)
    DeleteEntity(Pilot)
    DeleteEntity(Vehicle)
end)
  
RegisterNetEvent('bbv-drop:synctarget:client',function(a,b,c,d,e,f,g)
    item = item
    -- print(g .. ' sync client')
    TriggerEvent('bbv-drop:standalone:target',c,g)
end)

RegisterNetEvent('bbv-drop:pickup',function()
    ExecuteCommand('e pickup')
    Wait(500)
    for i=1,#Main.Reward do 
        --print(Main.Reward[i])
        Wrapper:AddItem(Main.Reward[i],1)
        DeleteObject(drop)
        DeleteObject(objecttest)
        TriggerServerEvent('bbv-drop:end:server')
    end
end)

RegisterNetEvent('bbv-drop:remove:client',function()
    inbound = false
	taken = false
	blipi = true
    DeleteObject(drop)
    DeleteEntity(Pilot)
    DeleteEntity(Vehicle)
    DeleteObject(objecttest)
    drop = nil
    objecttest = nil
	b = nil
    dropped = false
    item = {}
    Wrapper:RemoveBlip('drop')
    RemoveBlip(radius)
end)

RegisterNetEvent('bbv-drop:end:client',function()
    inbound = false
	taken = false
    DeleteObject(drop)
    DeleteEntity(Pilot)
    DeleteEntity(Vehicle)
    DeleteObject(objecttest)
    drop = nil
	b = nil
    objecttest = nil
    dropped = false
    item = {}
    Wrapper:RemoveBlip('drop')
    RemoveBlip(radius)
end)

local blipi = true

RegisterNetEvent('bbv-drop:standalone:target',function(a,obj)
    _ped = PlayerPedId()
    -- print(obj.. ' <-- obj from server')
    local b = NetToObj(obj)
    -- print(a,b  .. ' sync end')
    -- print(DoesEntityExist(b))
    while b == 0 do 
        Wait(1000)
        b = NetToObj(obj)
        -- print(b .. ' <-- b in loop')
    end
	if Config.CrateBlip then
		objecttest = b
		local crateblip = AddBlipForEntity(b)
		SetBlipSprite(crateblip,306)
		blipi = false
	end
    while b ~= 0 do
        Wait(0)
        local pedpos = GetEntityCoords(_ped)
        local entitypos = GetEntityCoords(b)
        local dist = #(pedpos - entitypos)
        if dist < 3 and not taken then 
            Wrapper:Prompt('Press [E] to pickup')
            if IsControlJustReleased(2, 38) and not taken then
                taken = true
				DeleteObject(b)
                TriggerServerEvent('bbv-drop:server:pickup')
                -- TriggerEvent('bbv-drop:pickup')
            end
        end
    end
end)

RegisterNetEvent('bbv-drop:pickup:taken',function()
    taken = true
end)

