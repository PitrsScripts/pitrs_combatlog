fx_version 'cerulean'
game 'gta5'

author 'Pitrs'
version '1.0.0'

lua54 'yes'  


shared_scripts {
    '@ox_lib/init.lua',  
    'config.lua'  
}

client_scripts {
    'client.lua'  
}

server_scripts {
    'server.lua'  
}

dependencies {
    'oxmysql',   
    'ox_lib', 
    'es_extended',  
}