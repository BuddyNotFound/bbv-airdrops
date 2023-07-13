Main = {}
item = {}
owner = false


RegisterCommand('drop',function(source,args)
    local pos = vector3(tonumber(args[1]),tonumber(args[2]),tonumber(args[3]))
	owner = true
	local str = ''

	for i=4, #args, 1 do
		str = args[i]
		item[i - 3] = str
	end


    TriggerServerEvent('bbv-drop:create:server',pos,item)
end)



RegisterNetEvent('bbv-drop:create:client',function(a,b)

	
    if Config.Debug then
        print('Drop on : '.. a.x .. ' '.. a.y.. ' ' .. a.z .. ' ' .. ' Items : ')
    end
    local _pos =  a
    local _item = b
    Wrapper:Blip('drop',Config.Blip.Label,_pos,Config.Blip.Sprite,Config.Blip.Color,Config.Blip.Scale)
    radius = AddBlipForRadius(_pos, 100.0) -- need to have .0
    SetBlipColour(radius, 1)
    SetBlipAlpha(radius, 128)
    Main:SpawnPlane(_pos,_item)
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
            print('dist : ' ..dist)
        end
        if dist < 350 or dropped then
            dropped = true
            TaskPlaneMission(Pilot, Vehicle, vehicle, ped, -3500,3500, Config.Vehicle.Height, 6, 0, 0, heading, 2000.0, 400.0)
			TriggerEvent('bbv-drop:drop',_pos,b)
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



RegisterNetEvent('bbv-drop:drop',function(a,b)
	if drop == nil then 
		local offset = math.random(-100,100)
		local pos = vector3(a.x + offset,a.y + offset,a.z + 2)
		local ground = vector3(a.x,a.y,a.z - 100)

		RequestWeaponAsset(GetHashKey("weapon_flare")) 
        while not HasWeaponAssetLoaded(GetHashKey("weapon_flare")) do
            Wait(0)
        end
		
		local item = b 
		if owner then 
			Wrapper:LoadModel(Config.Drop.Prop)
			ShootSingleBulletBetweenCoords(pos, ground, 0, false, GetHashKey("weapon_flare"), 0, true, true, -1.0)
			drop = CreateObject(Config.Drop.Prop,pos,true,true)
		end
		local netid = drop
		TriggerServerEvent('bbv-drop:synctarget:server','drop',Config.Drop.Label,pos,'bbv-drop:pickup',1,1,drop,item)
	end
end)

AddEventHandler('onResourceStop', function(resourceName)
	if (GetCurrentResourceName() ~= resourceName) then
	  return
	end
	DeleteObject(drop)
	DeleteEntity(Pilot)
	DeleteEntity(Vehicle)
end)
  
RegisterNetEvent('bbv-drop:synctarget:client',function(a,b,c,d,e,f,g,item)
	item = item
	if Config.Settings.Target ~= "No" then 
		Wrapper:Target(a,b,c,d,e,f,g)
		if Config.CrateBlip then 
			local crateblip = AddBlipForEntity(g)
			SetBlipSprite(crateblip,306)
		end
	end
	if Config.Settings.Target == "No" then
		TriggerEvent('bbv-drop:standalone:target',c,g)
		if Config.CrateBlip then 
			local crateblip = AddBlipForEntity(g)
			SetBlipSprite(crateblip,306)
		end
	end
end)

RegisterNetEvent('bbv-drop:pickup',function()
	ExecuteCommand('e pickup')
	Wait(500)
	for i=1,#item do 
		Wrapper:AddItem(item[i],1)
		DeleteObject(drop)
		Wrapper:TargetRemove('drop')
		TriggerServerEvent('bbv-drop:end:server')
	end
end)

RegisterNetEvent('bbv-drop:end:client',function()
	Wait(15000)
	DeleteObject(drop)
	DeleteEntity(Pilot)
	DeleteEntity(Vehicle)
	drop = nil
	dropped = false
	item = {}
	Wrapper:RemoveBlip('drop')
	RemoveBlip(radius)
end)

RegisterNetEvent('bbv-drop:standalone:target',function(a,b)
	_ped = PlayerPedId()
	while DoesEntityExist(b) do 
		Wait(0)
		local pedpos = GetEntityCoords(_ped)
		local entitypos = GetEntityCoords(b)
		local dist = #(pedpos - entitypos)
		if dist < 3 then 
			Wrapper:Prompt('Press [E] to pickup')
			if IsControlJustReleased(2, 38) then
				TriggerEvent('bbv-drop:pickup')
			end
		end
	end
end)