local Keys = {
	["ESC"] = 322, ["F1"] = 288, ["F2"] = 289, ["F3"] = 170, ["F5"] = 166, ["F6"] = 167, ["F7"] = 168, ["F8"] = 169, ["F9"] = 56, ["F10"] = 57,
	["~"] = 243, ["1"] = 157, ["2"] = 158, ["3"] = 160, ["4"] = 164, ["5"] = 165, ["6"] = 159, ["7"] = 161, ["8"] = 162, ["9"] = 163, ["-"] = 84, ["="] = 83, ["BACKSPACE"] = 177,
	["TAB"] = 37, ["Q"] = 44, ["W"] = 32, ["E"] = 38, ["R"] = 45, ["T"] = 245, ["Y"] = 246, ["U"] = 303, ["P"] = 199, ["["] = 39, ["]"] = 40, ["ENTER"] = 18,
	["CAPS"] = 137, ["A"] = 34, ["S"] = 8, ["D"] = 9, ["F"] = 23, ["G"] = 47, ["H"] = 74, ["K"] = 311, ["L"] = 182,
	["LEFTSHIFT"] = 21, ["Z"] = 20, ["X"] = 73, ["C"] = 26, ["V"] = 0, ["B"] = 29, ["N"] = 249, ["M"] = 244, [","] = 82, ["."] = 81,
	["LEFTCTRL"] = 36, ["LEFTALT"] = 19, ["SPACE"] = 22, ["RIGHTCTRL"] = 70,
	["HOME"] = 213, ["PAGEUP"] = 10, ["PAGEDOWN"] = 11, ["DELETE"] = 178,
	["LEFT"] = 174, ["RIGHT"] = 175, ["TOP"] = 27, ["DOWN"] = 173,
	["NENTER"] = 201, ["N4"] = 108, ["N5"] = 60, ["N6"] = 107, ["N+"] = 96, ["N-"] = 97, ["N7"] = 117, ["N8"] = 61, ["N9"] = 118
}

ESX = nil
local food, water, stress = 0
local status = nil
local script_name = GetCurrentResourceName()

Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        Citizen.Wait(100)
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(100)
        local ped = GetPlayerPed(-1)
        if GetPedMaxHealth(ped) ~= 200 and not IsEntityDead(ped) then
        SetPedMaxHealth(ped, 200)
        SetEntityHealth(ped, GetEntityHealth(ped) + 25)
        end
    end
end)

Citizen.CreateThread(function()
	Citizen.Wait(1000)
	print("^2 [loading] ^3"..script_name.." ^2For ^17K")
	print("^2 [" ..script_name.."] ^4Version ^31.2.3 ")
end)

Citizen.CreateThread(function() 
    while true do 
        Citizen.Wait(0)
        SetPedMaxHealth(GetPlayerPed(-1), 200)
    end
end)


Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1)
        HideHudComponentThisFrame(3) -- CASH
        HideHudComponentThisFrame(4) -- MP CASH
        HideHudComponentThisFrame(2) -- weapon icon
        HideHudComponentThisFrame(9) -- STREET NAME
        HideHudComponentThisFrame(7) -- Area NAME
        HideHudComponentThisFrame(8) -- Vehicle Class
        HideHudComponentThisFrame(6) -- Vehicle Name
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(Config['LoopTime'])
		if true then
            if IsPedSittingInAnyVehicle(PlayerPedId()) then
                DisplayRadar(true)
            else
                DisplayRadar(false)
            end
        else
            DisplayRadar(true)
        end

        local ped = GetPlayerPed(-1)
        local Pid = PlayerId()
        local ID = GetPlayerServerId(Pid)
        local health = GetEntityHealth(ped)
        local playerHealth = (GetEntityHealth(ped) - 100)
        local playerArmor = GetPedArmour(ped)
        local playerStamina = 100 - GetPlayerSprintStaminaRemaining(Pid)
        local playerDive = GetPlayerUnderwaterTimeRemaining(Pid) * 10	

        SendNUIMessage({
            show = IsPauseMenuActive(),
            health = playerHealth,
            stamina = playerStamina,
            dive = playerDive,
            armor = playerArmor,
            food = food,
            water = water,
            stress = stress,
            id = ID
        })
    end
end)

RegisterNetEvent(Config["Update"])
AddEventHandler(Config["Update"], function(status)

    TriggerEvent('esx_status:getStatus', 'hunger', function(status)
        food = status.val / 10000
    end)

    TriggerEvent('esx_status:getStatus', 'thirst', function(status)
        water = status.val / 10000
    end)

    if (Config['Stress']) then
        TriggerEvent('esx_status:getStatus', 'stress', function(status)
            stress = status.val / 10000
        end)
    end

end)
