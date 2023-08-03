fx_version 'cerulean'
games { 'gta5' }
author 'TacoTheDev x Lina <3'
version '1.0.0'
lua54 'yes'

ui_page 'ui/ui.html'

files {
    'ui/ui.html',
    'ui/ui.js'
}

shared_scripts {
    'encf.lua'
}

client_scripts {
    'client/functions/commen.lua',
    'client/functions/ui.lua',
    'client/base.lua',
}

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'server/functions/commen.lua',
    'server/debug.lua',
    'server/base.lua',
}