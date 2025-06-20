fx_version 'bodacious'
lua54 'yes'
game  'gta5'

client_scripts{
	'@es_extended/locale.lua',
	'client.lua'
}

server_scripts{
	'@es_extended/locale.lua',
	'logs.lua',
	'server.lua'
}


shared_scripts {
	'@ox_lib/init.lua',
	'@es_extended/imports.lua', 
	'config.lua',
  }

ui_page('index.html')

files {
    'index.html'
}

escrow_ignore {
'logs.lua',
'config.lua',
}
dependency '/assetpacks'
