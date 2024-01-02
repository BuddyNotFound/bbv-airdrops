Config = {}
Config.Debug = true
Config.BlipForPlane = true
Config.CrateBlip = true
Config.Restricted = true -- if the commands should be restriced or no [ /drop | /globalairdrop ]

-- ESX = exports["es_extended"]:getSharedObject()
QBCore = exports['qb-core']:GetCoreObject()

Config.Drop = {
    Prop = 'prop_drop_armscrate_01', -- Supply Drop, Prop
    Label = "Pick up",
    Veolicty = 0.01, -- the speed at which the drop will fall.
    Broadcast = true, -- if set to true when there is a supply drop there will be notifiaction.
    BroadcastMSG = 'Airdrop Inbound' -- the notification ^
}

Config.Blip = {
    Label = "Supply Drop", -- Blip Name
    Sprite = 550, -- Blip Sprite # https://docs.fivem.net/docs/game-references/blips/
    Color = 1, -- Blip Color  # https://docs.fivem.net/docs/game-references/blips/
    Scale = 0.7, -- Blip Scale
}

Config.Settings = {
    Framework = 'QB', -- /QB/ESX/Custom
    Target = "ST", -- OX/QB/No # If you DON'T use target set it to 'No'
}

Config.Vehicle = {
    Pilot = "s_m_m_pilot_02", -- Pilot ped 
    Model = "titan", -- Plane model
    Height = 500.0, -- Plane Height
    Speed = 95.0, -- Plane Speed
}

Config.Allowed = {
    'discord:333941426721390592',
}

