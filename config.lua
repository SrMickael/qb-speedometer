Config = {}

-- posição/escala
Config.Position = { x = 0.82, y = 0.78 }   -- âncora superior-esquerda (NUI vai usar)
Config.Scale    = 1.0

-- unidades
Config.Unit = 'KMH'        -- 'KMH' ou 'MPH'

-- limites & alertas
Config.FuelLowThreshold   = 30          -- %
Config.EngineBadThreshold = 400.0       -- health < => avaria
Config.SmoothFactor       = 0.18        -- 0..1 (lerp ponteiro/display)

-- mostrar/ocultar elementos
Config.ShowSeatbeltIcon   = true
Config.ShowFuelIcon       = true
Config.ShowEngineIcon     = true
Config.ShowNitro          = true
Config.ShowConsumable2    = true        -- Água/Óleo

-- hotkey
Config.ToggleCommand = 'togglespeedo'
-- registre sua tecla em F8 > settings > keybinds (ou 'K' de exemplo):
-- Add in client: RegisterKeyMapping(Config.ToggleCommand, 'Mostrar/ocultar velocímetro', 'keyboard', 'K')

-- compatibilidade de recursos (altere se o nome for diferente no seu server)
Config.FuelResourcePreference  = { 'qb-fuel', 'LegacyFuel' }
Config.NitroResourcePreference = { 'ps-nitro', 'cw-nitro' }

-- caso não tenha um "consumível 2", mantenha como função que retorna nil para ocultar
Config.Consumable2Provider = function(veh)
  -- Exemplo: ler “coolant” de state bag, metadata, export do seu script, etc.
  -- return levelPercent (0..100) ou nil para ocultar
  return nil
end

