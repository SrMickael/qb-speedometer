local function resourceExists(name)
  return GetResourceState(name) == 'started' or GetResourceState(name) == 'starting'
end

Speedo = Speedo or {}
Speedo.exports = {}

-- FUEL (qb-fuel ou LegacyFuel)
function Speedo.exports.GetFuelLevel(veh)
  if not veh or veh == 0 then return 0 end
  for _,res in ipairs(Config.FuelResourcePreference) do
    if resourceExists(res) then
      if res == 'qb-fuel' and exports['qb-fuel'] and exports['qb-fuel'].GetFuel then
        return math.max(0, math.min(100, exports['qb-fuel']:GetFuel(veh)))
      end
      if res == 'LegacyFuel' and exports['LegacyFuel'] and exports['LegacyFuel'].GetFuel then
        return math.max(0, math.min(100, exports['LegacyFuel']:GetFuel(veh)))
      end
    end
  end
  -- fallback: use decor / nativo
  local f = GetVehicleFuelLevel(veh) or 0.0
  return math.max(0, math.min(100, f))
end

-- NITRO (ps-nitro / cw-nitro)
function Speedo.exports.GetNitroPercent(veh)
  if not veh or veh == 0 then return nil end
  for _,res in ipairs(Config.NitroResourcePreference) do
    if resourceExists(res) then
      if res == 'ps-nitro' and exports['ps-nitro'] and exports['ps-nitro'].HasNitro then
        if exports['ps-nitro']:HasNitro(veh) then
          return exports['ps-nitro']:GetNitroLevel(veh) or 0
        else return nil end
      end
      if res == 'cw-nitro' and exports['cw-nitro'] and exports['cw-nitro'].GetNitroLevel then
        local lvl = exports['cw-nitro']:GetNitroLevel(veh)
        return lvl ~= nil and lvl or nil
      end
    end
  end
  return nil
end

-- SEATBELT: ouvimos eventos comuns e também exponho nosso próprio
Speedo.state = { seatbelt = false }
RegisterNetEvent('seatbelt:client:ToggleSeatbelt', function()
  Speedo.state.seatbelt = not Speedo.state.seatbelt
end)
RegisterNetEvent('qb-seatbelt:client:update', function(state) Speedo.state.seatbelt = state end)

exports('SetSeatbeltState', function(state)
  Speedo.state.seatbelt = state and true or false
end)
exports('GetSeatbeltState', function() return Speedo.state.seatbelt end)


