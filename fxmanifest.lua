fx_version 'adamant'

game 'gta5'

description 'FeedM2'

author 'Karl Saunders'

version '0.0.1'

client_scripts {
    'config.lua',
    'client.lua',
    'demo.lua',
}

ui_page 'ui/ui.html'

files {
    'ui/ui.html',
    'ui/images/*',
    'ui/fonts/ChaletComprimeCologneSixty.ttf',
    'ui/css/app.css',
    'ui/js/app.js'
}

export 'ShowNotification'
-- export 'ShowAdvancedNotification'
-- export 'Clear'