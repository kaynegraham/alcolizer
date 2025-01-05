fx_version 'cerulean'
game 'gta5'

author 'Kayne'
description 'Alcolizer LE5 Breathalyser'
version '1.0.0'

client_scripts {
    'client/*.lua'
}

shared_scripts {
    'shared/config.lua'
}

server_scripts {
    'server/*.lua'
}

ui_page 'ui/index.html'

files {
    "ui/index.html",
    "ui/style.css",
    "ui/script.js",
    "ui/img/alcolizer.png",
    "stream/prop_inhaler_01.ydr",
    "stream/prop_inhaler_01.ytyp"
}

data_file "DLC_ITYP_REQUEST" "stream/prop_inhaler_01.ytyp"