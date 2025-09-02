local QBCore = exports["qb-core"]:GetCoreObject()
local showHud = true
local inVehicle = false
local isLoggedIn = false -- Nova variável para o status de login
local last = { speed=0.0, fuel=0.0, nitro=nil, cons2=nil, engineHealth=1000.0 }
local mphFactor = 2.236936
local kmhFactor = 3.6

-- Evento para atualizar o status de login

AddEventHandler("onResourceStart", function(resourceName)
    if GetCurrentResourceName() ~= resourceName then return end

    CreateThread(function()

        while not LocalPlayer.state.isLoggedIn do
            Wait(200)
        end

        isLoggedIn = true

        TriggerEvent("QBCore:Client:OnPlayerLoaded", QBCore.Functions.GetPlayerData())
    end)
end)


RegisterNetEvent("QBCore:Client:OnPlayerLoaded", function()
    isLoggedIn = true
end)

RegisterNetEvent("QBCore:Client:OnPlayerUnload", function()
    isLoggedIn = false
    SendNUIMessage({ action='setVisible', show=false })
end)

RegisterCommand(Config.ToggleCommand, function()
  showHud = not showHud
  if isLoggedIn and inVehicle and showHud then
    SendNUIMessage({ action='setVisible', show=true })
  else
    SendNUIMessage({ action='setVisible', show=false })
  end
end, false)
RegisterKeyMapping(Config.ToggleCommand, 'Mostrar/ocultar velocímetro', 'keyboard', 'K')

-- util
local function lerp(a,b,t) return a + (b-a)*t end

-- loop principal otimizado
CreateThread(function()
  SendNUIMessage({
    action='init',
    pos = Config.Position, scale = Config.Scale, unit = Config.Unit
  })

  while true do
    -- Verifica o status de login a cada iteração
    if not isLoggedIn then
        SendNUIMessage({ action='setVisible', show=false })
        Wait(1000) -- Espera mais tempo se não estiver logado
        goto continue
    end

    local ped = PlayerPedId()
    local veh = GetVehiclePedIsIn(ped,false)
    local wasInVehicle = inVehicle

    if veh ~= 0 and GetPedInVehicleSeat(veh, -1) == ped then
      inVehicle = true
      
      -- Se acabou de entrar no veículo e o HUD está habilitado, mostrar
      if not wasInVehicle and showHud then
        SendNUIMessage({ action='setVisible', show=true })
      end

      local factor = (Config.Unit == 'MPH') and mphFactor or kmhFactor

      local speed = GetEntitySpeed(veh) * factor
      last.speed = lerp(last.speed, speed, Config.SmoothFactor)

      -- combustível
      local fuel = Speedo.exports.GetFuelLevel(veh)
      last.fuel = lerp(last.fuel, fuel, 0.25)

      -- nitro
      local nitro = Config.ShowNitro and Speedo.exports.GetNitroPercent(veh) or nil
      if nitro ~= nil then last.nitro = lerp(last.nitro or nitro, nitro, 0.2) else last.nitro = nil end

      -- consumível 2
      local c2 = Config.ShowConsumable2 and Config.Consumable2Provider(veh) or nil
      if c2 ~= nil then last.cons2 = lerp(last.cons2 or c2, c2, 0.2) else last.cons2 = nil end

      -- motor
      local eng = GetVehicleEngineHealth(veh)
      last.engineHealth = lerp(last.engineHealth, eng, 0.12)

      -- enviar para NUI (menor payload possível)
      if showHud then
        SendNUIMessage({
          action = 'update',
          spd = last.speed,
          fuel = last.fuel,
          unit = Config.Unit,
          seatbelt = Speedo.state.seatbelt,
          fuelLow = (fuel <= Config.FuelLowThreshold),
          engineBad = (eng <= Config.EngineBadThreshold),
          nitro = last.nitro,     -- nil = oculto
          cons2 = last.cons2      -- nil = oculto
        })
      end

      Wait(60)  -- rápido e suave dentro do carro
    else
      inVehicle = false
      
      -- Se saiu do veículo, esconder HUD
      if wasInVehicle then
        SendNUIMessage({ action='setVisible', show=false })
      end
      
      Wait(500) -- verificação mais lenta quando fora do carro
    end
    ::continue::
  end
end)



CreateThread(function()
    while true do
        Wait(500) -- otimização, não precisa ser rápido

        local ped = PlayerPedId()
        local veh = GetVehiclePedIsIn(ped, false)

        if veh ~= 0 and GetPedInVehicleSeat(veh, -1) == ped then
            DisplayRadar(true)  -- mostra o radar
        else
            DisplayRadar(false) -- esconde o radar
        end
    end
end)



-- Ajusta o radar para formato 4:3
CreateThread(function()
    RequestStreamedTextureDict("squaremap", false)
    while not HasStreamedTextureDictLoaded("squaremap") do
        Wait(10)
    end

    -- Substitui máscara circular por quadrada
    AddReplaceTexture("platform:/textures/graphics", "radarmasksm", "squaremap", "radarmasksm")

    SetMinimapClipType(0)

    -- Radar principal (ajustado no X para afastar da borda)
    SetMinimapComponentPosition('minimap', 'L', 'B', 0.015, -0.035, 0.1638, 0.183)

    -- Máscara quadrada
    SetMinimapComponentPosition('minimap_mask', 'L', 'B', 0.015, 0.0, 0.128, 0.20)

    -- Remove o blur (zerado)
    SetMinimapComponentPosition('minimap_blur', 'L', 'B', 0.0, 0.0, 0.0, 0.0)

    -- Safezone fix para aplicar corretamente
    SetRadarBigmapEnabled(true, false)
    Wait(0)
    SetRadarBigmapEnabled(false, false)
end)

