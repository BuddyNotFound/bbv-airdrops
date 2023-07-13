fx_version 'cerulean'
game 'gta5'

description 'j'
version '1.2.0'


client_scripts {
    'config.lua',
    'wrapper/cl_wrapper.lua',
    'client/client.lua',
}

server_scripts {
    'wrapper/sv_wrapper.lua',
    'server/server.lua'
}

shared_scripts {
    'config.lua',
}

escrow_ignore {
    'config.lua', 
    'wrapper/*.lua'
  }

lua54 'yes'

