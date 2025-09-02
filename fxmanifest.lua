fx_version 'cerulean'
game 'gta5'

author 'SeuNome'
description 'Speedometer HUD circular - QBCore'
version '1.0.0'

ui_page 'html/index.html'

files {
  'html/index.html',
  'html/style.css',
  'html/app.js',
  'html/icons/*.svg',
  'html/fonts/*.ttf'
}

client_scripts {
  'config.lua',
  'client/main.lua',
  'client/compat.lua',
  'client/exports.lua'
}

shared_scripts { '@qb-core/shared/locale.lua' }

lua54 'yes'


