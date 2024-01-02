fx_version 'cerulean'
game 'gta5'

description 'j'
version '1.2.0'


client_scripts {
    'wrapper/cl_wrapper.lua',
    'client/client.lua',
}

server_scripts {
    'wrapper/sv_wrapper.lua',
    'server/server.lua',
    'server/items.lua',
    'server/global.lua',
}

shared_scripts {
    'configs/config.lua',
    'configs/items.lua',
    'configs/global.lua',
}

escrow_ignore {
    'configs/*.lua', 
    'wrapper/*.lua'
  }

lua54 'yes'

