fx_version 'cerulean'
game 'gta5'
lua54 'yes'
use_fxv2_oal 'yes'

author 'Razzway''
version '1.0.0'

shared_scripts {
    'config.lua',
}

client_scripts {
    'libs/RageUI//RMenu.lua',
    'libs/RageUI//menu/RageUI.lua',
    'libs/RageUI//menu/Menu.lua',
    'libs/RageUI//menu/MenuController.lua',
    'libs/RageUI//components/*.lua',
    'libs/RageUI//menu/elements/*.lua',
    'libs/RageUI//menu/items/*.lua',
    'libs/RageUI//menu/panels/*.lua',
    'libs/RageUI/menu/windows/*.lua',

    'client/*.lua',
}

server_scripts {
    '@mysql-async/lib/MySQL.lua',
    
    'server/*.lua',
}
