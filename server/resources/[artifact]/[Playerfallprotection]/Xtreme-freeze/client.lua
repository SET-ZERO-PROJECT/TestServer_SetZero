Keys = {
	["ESC"] = 322, ["F1"] = 288, ["F2"] = 289, ["F3"] = 170, ["F5"] = 166, ["F6"] = 167, ["F7"] = 168, ["F8"] = 169, ["F9"] = 56, ["F10"] = 57,
	["~"] = 243, ["1"] = 157, ["2"] = 158, ["3"] = 160, ["4"] = 164, ["5"] = 165, ["6"] = 159, ["7"] = 161, ["8"] = 162, ["9"] = 163, ["-"] = 84, ["="] = 83, ["BACKSPACE"] = 177,
	["TAB"] = 37, ["Q"] = 44, ["W"] = 32, ["E"] = 38, ["R"] = 45, ["T"] = 245, ["Y"] = 246, ["U"] = 303, ["P"] = 199, ["["] = 39, ["]"] = 40, ["ENTER"] = 18,
	["CAPS"] = 137, ["A"] = 34, ["S"] = 8, ["D"] = 9, ["F"] = 23, ["G"] = 47, ["H"] = 74, ["K"] = 311, ["L"] = 182,
	["LEFTSHIFT"] = 21, ["Z"] = 20, ["X"] = 73, ["C"] = 26, ["V"] = 0, ["B"] = 29, ["N"] = 249, ["M"] = 244, [","] = 82, ["."] = 81,
	["LEFTCTRL"] = 36, ["LEFTALT"] = 19, ["SPACE"] = 22, ["RIGHTCTRL"] = 70,
	["HOME"] = 213, ["PAGEUP"] = 10, ["PAGEDOWN"] = 11, ["DELETE"] = 178,
	["LEFT"] = 174, ["RIGHT"] = 175, ["TOP"] = 27, ["DOWN"] = 173,
	["NENTER"] = 201, ["N4"] = 108, ["N5"] = 60, ["N6"] = 107, ["N+"] = 96, ["N-"] = 97, ["N7"] = 117, ["N8"] = 61, ["N9"] = 118, ["Enter"] = 191
}
local script_name = GetCurrentResourceName()
Xtreme = nil
local notfreeze = true

Citizen.CreateThread(function()
	while Xtreme == nil do
		TriggerEvent('esx:getSharedObject', function(obj) Xtreme = obj end)
		Citizen.Wait(0)
	end
end) 

Citizen.CreateThread(function()
	Citizen.Wait(1000)
	print("^2 [loading] ^1"..script_name.." By.Thiradej https://discord.gg/8BD5dVZKWY")
end)

Citizen.CreateThread(function()
	while notfreeze do
		Citizen.Wait(0)
		FreezeEntityPosition(PlayerPedId(), true)
		DrawTxt(0.930, 0.700, 1.0,1.0,0.55,"~b~กด ~w~[G] ~w~เพื่อเดิน", 255,255,255,255)
		if IsControlJustReleased(0, Keys['G']) then
			notfreeze = false
			FreezeEntityPosition(PlayerPedId(), false)
		end
	end
end)

RegisterFontFile('Mitr')
fontId = RegisterFontId('Mitr')

function DrawTxt(x,y ,width,height,scale, text, r,g,b,a)
	SetTextFont(fontId)
	SetTextProportional(0)
	SetTextScale(scale, scale)
	SetTextColour(r, g, b, a)
	SetTextDropShadow(0, 0, 0, 0,255)
	SetTextEdge(1, 0, 0, 0, 255)
	SetTextOutline()
	SetTextEntry("STRING")
	AddTextComponentString(text)
	DrawText(x - width/2, y - height/2 + 0.005)
end