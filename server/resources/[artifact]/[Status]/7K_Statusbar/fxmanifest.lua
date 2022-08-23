client_script '@X.Brain/Shared/xGuardPlayer.lua'
fx_version 'adamant'

game 'gta5'

description '7K_Statusbar'

version '0.1'

ui_page 'html/ui.html'

files {
    'html/ui.html',
    'html/ui.css',
    'html/ui.js',
    'html/font/digital-7.ttf',
    'html/img/*.png',
    'html/img/*.gif',
}

client_script {
    'config.lua',
    'client.lua'
}
