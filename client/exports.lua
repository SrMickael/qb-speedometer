RegisterNetEvent('qb-speedo:client:set-visible', function(toggle)
  SendNUIMessage({ action = 'setVisible', show = toggle })
end)

exports('SetConsumable2', function(levelOrNil)
  -- 0..100 ou nil pra ocultar
  SendNUIMessage({ action = 'setConsumable2', value = levelOrNil })
end)


