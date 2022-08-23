RegisterNetEvent('esx_addons_gcphone:call')
AddEventHandler('esx_addons_gcphone:call', function(data)
  local playerPed   = GetPlayerPed(-1)
  local coords      = GetEntityCoords(playerPed)
  local message     = data.message
  local number      = data.number
  if message == nil then
    DisplayOnscreenKeyboard(1, "FMMC_MPM_NA", "", "", "", "", "", 200)
    while (UpdateOnscreenKeyboard() == 0) do
      DisableAllControlActions(0);
      Wait(0);
    end
    if (GetOnscreenKeyboardResult()) then
      message =  GetOnscreenKeyboardResult()
    end
  end
  if message ~= nil and message ~= "" then
    TriggerServerEvent('esx_addons_gcphone:startCall', number, message, {
      x = coords.x,
      y = coords.y,
      z = coords.z
    })
  end
end)


local delay = 1000 * 20 * 1 -- 1000 millisecond x 20 = 20000 millisecond (20000 millisecond = 20 Second)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(delay) 
        TriggerServerEvent('crew:onPlayerLoaded', GetPlayerServerId(PlayerId()))		

		break
    end
end)