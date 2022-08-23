resource_manifest_version "44febabe-d386-4d18-afbe-5e627f4af937"

description "ESX Inventory HUD"

version "1.1"

ui_page "html/ui.html"

client_scripts {
	"@es_extended/locale.lua",
	"locales/en.lua",
	"client/client.lua",
	"client/property.lua",
	"client/player.lua",
	"client/vault.lua",
	"client/playerinventory.lua",
	"config.lua",
	'config_weapons.lua',
	'@xzero_trunk/export/trunk.lua',
}

server_scripts {
	"@es_extended/locale.lua",
	"@mysql-async/lib/MySQL.lua",
	"config.lua",
	"server/server.lua",
	"locales/en.lua",
}

files {
    "html/ui.html",
    "html/css/*.css",
    "html/js/*.js",
	-- IMAGES
    "html/img/logo.png",
    "html/img/bullet.png",
	-- ICONS
	"html/img/*.png",
	"html/img/items/*.png",	
	"html/img/category/*.png",
}

