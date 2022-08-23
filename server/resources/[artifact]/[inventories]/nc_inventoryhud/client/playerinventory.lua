local blur = "MenuMGIn"
local Accessory_Items   = {}
local Vehicle_Key       = {}
local isHotbar          = false;
local fastItemsHotbar   = {};
local fastWeapons       = {
	[1] = nil,
	[2] = nil,
	[3] = nil,
	[4] = nil,
	[5] = nil
}

function openInventory()
    StartScreenEffect(blur, 1, true)
    loadPlayerInventory()
    isInInventory = true
    SendNUIMessage(
        {
            action = "display",
            type = "normal"
        }
    )
    SetNuiFocus(true, true)
end

function loadPlayerInventory()
    local PlayerId = GetPlayerServerId(PlayerId())
    local playerPed = PlayerPedId()
    items = {}
    fastItems = {}

    if Config.Items then
        itemData = {
            label ="บัตรประชาชน",
            name = "id_card",
            type = "item_account",
            count = 1,
            limit = 1,
            usable = true,
            rare = false,
            canRemove = false
        }

        table.insert(items, itemData)
    end

    if Config.Items then
        itemData = {
            label ="ใบขับขี่",
            name = "driver_license",
            type = "item_account",
            count = 1,
            limit = 1,
            usable = true,
            rare = false,
            canRemove = false
        }

        table.insert(items, itemData)
    end

    if ESX.PlayerData.money > 0 then
        table.insert(items, {
            label     = 'เงิน',
            count     = ESX.PlayerData.money,
            type      = 'item_money',
            name      = "cash",
            usable    = false,
            rare      = false,
            canRemove = true
        })
    end

    if Config.IncludeAccounts and ESX.PlayerData.accounts ~= nil then
        for key, value in pairs(ESX.PlayerData.accounts) do
            if ESX.PlayerData.accounts[key].money > 0 then
                accountData = {
                    label = 'เงินแดง',
                    count = ESX.PlayerData.accounts[key].money,
                    type = "item_account",
                    name = ESX.PlayerData.accounts[key].name,
                    usable = false,
                    rare = false,
                    limit = -1,
                    canRemove = true
                }
                table.insert(items, accountData)
            end
        end
    end

    for i=1, #Accessory_Items, 1 do
        local founditem = false
        for slot, item in pairs(fastWeapons) do
            if item.label == Accessory_Items[i].label then
                table.insert(fastItems, {
                    label = Accessory_Items[i].label,
                    count = 1,
                    limit = -1,
                    type = "item_accessories",
                    name = Accessory_Items[i].name,
                    usable = true,
                    rare = false,
                    canRemove = false,
                    itemnum = Accessory_Items[i].itemnum,
                    itemskin = Accessory_Items[i].itemskin,
                    slot = slot
                })
                founditem = true
                break
            end
        end
        
        if founditem == false then
            table.insert(items, {
                label = Accessory_Items[i].label,
                count = 1,
                limit = -1,
                type = "item_accessories",
                name = Accessory_Items[i].name,
                usable = true,
                rare = false,
                canRemove = false,
                itemnum = Accessory_Items[i].itemnum,
                itemskin = Accessory_Items[i].itemskin
            })
        end
    end
	
	if Config.EnableVehicleKey == true then
        for i=1, #Vehicle_Key, 1 do
            table.insert(items, {
                label = Vehicle_Key[i].plate,
                count = 1,
                limit = -1,
                type = "item_key",
                name = "key",
                usable = true,
                rare = true,
                canRemove = true
            })
        end
    end
			
    for i=1, #ESX.PlayerData.inventory, 1 do
        if ESX.PlayerData.inventory[i].count > 0 then
            local founditem = false
            for slot, item in pairs(fastWeapons) do
                if item.name == ESX.PlayerData.inventory[i].name then
                    table.insert(fastItems, {
                        label     = ESX.PlayerData.inventory[i].label,
                        count     = ESX.PlayerData.inventory[i].count,
                        limit     = ESX.PlayerData.inventory[i].limit,
                        type      = 'item_standard',
                        name      = ESX.PlayerData.inventory[i].name,
                        usable    = ESX.PlayerData.inventory[i].usable,
                        rare      = ESX.PlayerData.inventory[i].rare,
                        canRemove = ESX.PlayerData.inventory[i].canRemove,
                        slot = slot
                    })
                    founditem = true
                    break
                end
            end
            
            if founditem == false then
                table.insert(items, {
                    label     = ESX.PlayerData.inventory[i].label,
                    count     = ESX.PlayerData.inventory[i].count,
                    limit     = ESX.PlayerData.inventory[i].limit,
                    type      = 'item_standard',
                    name      = ESX.PlayerData.inventory[i].name,
                    usable    = ESX.PlayerData.inventory[i].usable,
                    rare      = ESX.PlayerData.inventory[i].rare,
                    canRemove = ESX.PlayerData.inventory[i].canRemove
                })
            end
        end
    end
	
	if Config.IncludeWeapons then
        for i=1, #Config.Weapons, 1 do
            local weaponHash = GetHashKey(Config.Weapons[i].name)
            local playerPed = PlayerPedId()

            if HasPedGotWeapon(playerPed, weaponHash, false) and Config.Weapons[i].name ~= 'WEAPON_UNARMED' then
                local ammo = GetAmmoInPedWeapon(playerPed, weaponHash)
                local founditem = false
                for slot, item in pairs(fastWeapons) do
                    if item.name == Config.Weapons[i].name then
                        table.insert(fastItems, {
                            label     = Config.Weapons[i].label,
                            count     = ammo,
                            limit       = -1,
                            type      = 'item_weapon',
                            name     = Config.Weapons[i].name,
                            usable    = false,
                            rare      = false,
                            canRemove = true,
                            slot = slot
                        })
                        founditem = true
                        break
                    end
                end
                
                if founditem == false then
                    table.insert(items, {
                        label     = Config.Weapons[i].label,
                        count     = ammo,
                        limit       = -1,
                        type      = 'item_weapon',
                        name     = Config.Weapons[i].name,
                        usable    = false,
                        rare      = false,
                        canRemove = true
                    })
                end
            end
        end
    end
    
    for k, v in pairs(items) do
        local founditem = false
        for category, value in pairs(Config.Category) do
            for index, data in pairs(value) do
                if Config.Category[category][index] == items[k].name then
                    items[k].category = category;
                    founditem = true
                    break
                end
            end
        end
        
        if founditem == false then
            if items[k].type == "item_key" or items[k].type == "item_keyhouse" then
                items[k].category = "inventory_keys";
            elseif items[k].type == "item_weapon" then
                items[k].category = "inventory_weapon";
            elseif items[k].type == "item_accessories" then
                items[k].category = "inventory_clothes";
            else
                items[k].category = "inventory_all";
            end
        end
    end
    
    fastItemsHotbar =  fastItems
    SendNUIMessage(
        {
            action = "setItems",
            itemList = items,
            text = texts,
            fastItems = fastItems,
        }
    )
    
end

RegisterNetEvent('esx:addWeapon')
AddEventHandler('esx:addWeapon', function(weaponName, ammo)
	local playerPed  = PlayerPedId()
	local weaponHash = GetHashKey(weaponName)
	GiveWeaponToPed(playerPed, weaponHash, ammo, false, false)
end)

RegisterNetEvent('esx:addWeaponComponent')
AddEventHandler('esx:addWeaponComponent', function(weaponName, weaponComponent)
	local playerPed  = PlayerPedId()
	local weaponHash = GetHashKey(weaponName)
	local componentHash = ESX.GetWeaponComponent(weaponName, weaponComponent).hash
	GiveWeaponComponentToPed(playerPed, weaponHash, componentHash)
end)

RegisterNetEvent('esx:removeWeapon')
AddEventHandler('esx:removeWeapon', function(weaponName, ammo)
	local playerPed  = PlayerPedId()
	local weaponHash = GetHashKey(weaponName)
	RemoveWeaponFromPed(playerPed, weaponHash)
	if ammo then
		local pedAmmo = GetAmmoInPedWeapon(playerPed, weaponHash)
		local finalAmmo = math.floor(pedAmmo - ammo)
		SetPedAmmo(playerPed, weaponHash, finalAmmo)
	else
		SetPedAmmo(playerPed, weaponHash, 0) -- remove leftover ammo
	end
end)


RegisterNetEvent('esx:removeWeaponComponent')
AddEventHandler('esx:removeWeaponComponent', function(weaponName, weaponComponent)
	local playerPed  = PlayerPedId()
	local weaponHash = GetHashKey(weaponName)
	local componentHash = ESX.GetWeaponComponent(weaponName, weaponComponent).hash

	RemoveWeaponComponentFromPed(playerPed, weaponHash, componentHash)
end)

RegisterNetEvent('esx:setAccountMoney')
AddEventHandler('esx:setAccountMoney', function(account)
    for k,v in ipairs(ESX.PlayerData.accounts) do
        if 'black_money' == account.name then
            ESX.PlayerData.accounts[k] = account
            break
        end
    end

    if isInInventory then
		loadPlayerInventory()
	end
end)

RegisterNetEvent('esx:removeInventoryItem')
AddEventHandler('esx:removeInventoryItem', function(item, count)
	for k,v in ipairs(ESX.PlayerData.inventory) do
		if v.name == item.name then
			ESX.PlayerData.inventory[k] = item
			break
		end
    end
	if isInInventory then
		loadPlayerInventory()
	end
end)
RegisterNetEvent('esx_inventoryhud:refreshInventory')
AddEventHandler('esx_inventoryhud:refreshInventory', function()
	print("refresh")
	loadPlayerInventory()
end)

RegisterNetEvent('esx:addInventoryItem')
AddEventHandler('esx:addInventoryItem', function(item, count)
	for k,v in ipairs(ESX.PlayerData.inventory) do
        if v.name == item.name then
            ESX.PlayerData.inventory[k] = item
			break
		end
	end

	if isInInventory then
		loadPlayerInventory()
	end
end)

RegisterNetEvent('es:activateMoney')
AddEventHandler('es:activateMoney', function(money)
    ESX.PlayerData.money = money
    if isInInventory then
		loadPlayerInventory()
	end
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
    TriggerServerEvent("esx_inventoryhud:getOwnerVehicle")
    TriggerServerEvent("esx_inventoryhud:getOwnerAccessories")
    TriggerServerEvent("esx_inventoryhud:black_money")
    ESX.PlayerData = xPlayer
end)

AddEventHandler('onResourceStart', function(resource)
	if resource == GetCurrentResourceName() then
	    TriggerServerEvent("esx_inventoryhud:getOwnerVehicle")
        TriggerServerEvent("esx_inventoryhud:getOwnerAccessories")
        TriggerServerEvent("esx_inventoryhud:black_money")
	end
end)

RegisterNetEvent("esx_inventoryhud:getOwnerAccessories")
AddEventHandler("esx_inventoryhud:getOwnerAccessories",function()
    TriggerServerEvent("esx_inventoryhud:getOwnerAccessories")
end)

RegisterNetEvent("esx_inventoryhud:setOwnerAccessories")
AddEventHandler("esx_inventoryhud:setOwnerAccessories", function(result)
    Accessory_Items = result
end)

RegisterNetEvent("esx_inventoryhud:getOwnerVehicle")
AddEventHandler("esx_inventoryhud:getOwnerVehicle",function()
    TriggerServerEvent("esx_inventoryhud:getOwnerVehicle")
end)

RegisterNetEvent("esx_inventoryhud:setOwnerVehicle")
AddEventHandler("esx_inventoryhud:setOwnerVehicle", function(result)
    Vehicle_Key = result
end)

function showHotbar()
	if not isHotbar then
		isHotbar = true
		SendNUIMessage({
			action = "showhotbar",
			fastItems = fastItemsHotbar
		})
		isHotbar = false
	end
end

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		HudForceWeaponWheel(false)
		HudWeaponWheelIgnoreSelection()
		DisableControlAction(1, 37, true)
		DisableControlAction(1, 157, true)
		DisableControlAction(1, 158, true)
		DisableControlAction(1, 160, true)
		DisableControlAction(1, 164, true)
		DisableControlAction(1, 165, true)
		DisableControlAction(2, 157, true)-- disable changing weapon
		DisableControlAction(2, 158, true)-- disable changing weapon
		DisableControlAction(2, 159, true)-- disable changing weapon
		DisableControlAction(2, 160, true)-- disable changing weapon
		DisableControlAction(2, 161, true)-- disable changing weapon
		DisableControlAction(2, 162, true)-- disable changing weapon
		DisableControlAction(2, 163, true)-- disable changing weapon
		DisableControlAction(2, 164, true)-- disable changing weapon
		DisableControlAction(2, 165, true)-- disable changing weapon
	end
end)

Citizen.CreateThread(function()
	while ESX == nil do Citizen.Wait(10) end
	while true do
		Citizen.Wait(7)
		if not IsPlayerDead(PlayerId()) then
			DisableControlAction(0, 37, true)

			if  IsDisabledControlJustReleased(0, 157) then
				if fastWeapons[1] ~= nil then
                    if fastWeapons[1].type == "item_weapon" then
                        SetWeapon(fastWeapons[1])
                    elseif fastWeapons[1].type == "item_accessories" then
                        useItems(fastWeapons[1])
                    else
					    TriggerServerEvent("esx:useItem", fastWeapons[1].name)
                    end
				end
			elseif IsDisabledControlJustReleased(0, 158) then
				if fastWeapons[2] ~= nil then
                    if fastWeapons[2].type == "item_weapon" then
                        SetWeapon(fastWeapons[2])
                    elseif fastWeapons[2].type == "item_accessories" then
                        useItems(fastWeapons[2])
                    else
					    TriggerServerEvent("esx:useItem", fastWeapons[2].name)
                    end
				end
			elseif IsDisabledControlJustReleased(0, 160) then
				if fastWeapons[3] ~= nil then
                    if fastWeapons[3].type == "item_weapon" then
                        SetWeapon(fastWeapons[3])
                    elseif fastWeapons[3].type == "item_accessories" then
                        useItems(fastWeapons[3])
                    else
					    TriggerServerEvent("esx:useItem", fastWeapons[3].name)
                    end
				end
			elseif IsDisabledControlJustReleased(0, 164) then
				if fastWeapons[4] ~= nil then
                    if fastWeapons[4].type == "item_weapon" then
                        SetWeapon(fastWeapons[4])
                    elseif fastWeapons[4].type == "item_accessories" then
                        useItems(fastWeapons[4])
                    else
					    TriggerServerEvent("esx:useItem", fastWeapons[4].name)
                    end
				end
			elseif IsDisabledControlJustReleased(4, 165) then
				if fastWeapons[5] ~= nil then
                    if fastWeapons[5].type == "item_weapon" then
                        SetWeapon(fastWeapons[5])
                    elseif fastWeapons[5].type == "item_accessories" then
                        useItems(fastWeapons[5])
                    else
					    TriggerServerEvent("esx:useItem", fastWeapons[5].name)
                    end
				end
            elseif IsDisabledControlJustReleased(0, 159) then
				if fastWeapons[6] ~= nil then
                    if fastWeapons[6].type == "item_weapon" then
                        SetWeapon(fastWeapons[6])
                    elseif fastWeapons[6].type == "item_accessories" then
                        useItems(fastWeapons[6])
                    else
					    TriggerServerEvent("esx:useItem", fastWeapons[6].name)
                    end
				end
            elseif IsDisabledControlJustReleased(0, 161) then
				if fastWeapons[7] ~= nil then
                    if fastWeapons[7].type == "item_weapon" then
                        SetWeapon(fastWeapons[7])
                    elseif fastWeapons[7].type == "item_accessories" then
                        useItems(fastWeapons[7])
                    else
					    TriggerServerEvent("esx:useItem", fastWeapons[7].name)
                    end
				end
            elseif IsDisabledControlJustReleased(0, 162) then
				if fastWeapons[8] ~= nil then
                    if fastWeapons[8].type == "item_weapon" then
                        SetWeapon(fastWeapons[8])
                    elseif fastWeapons[8].type == "item_accessories" then
                        useItems(fastWeapons[8])
                    else
					    TriggerServerEvent("esx:useItem", fastWeapons[8].name)
                    end
				end
            elseif IsDisabledControlJustReleased(0, 163) then
				if fastWeapons[9] ~= nil then
                    if fastWeapons[9].type == "item_weapon" then
                        SetWeapon(fastWeapons[9])
                    elseif fastWeapons[9].type == "item_accessories" then
                        useItems(fastWeapons[9])
                    else
					    TriggerServerEvent("esx:useItem", fastWeapons[9].name)
                    end
				end
			elseif IsDisabledControlJustReleased(0, 37) then
				HudForceWeaponWheel(false)
				showHotbar()
			end
		else
			Citizen.Wait(1000)
		end
	end
end)

IsSetWeapon = false
SetWeapon = function(data)
	
    if not IsSetWeapon then
        SetCurrentPedWeapon(PlayerPedId(), GetHashKey(data.name), true)
        IsSetWeapon = true
    else
        IsSetWeapon = false
        SetCurrentPedWeapon(PlayerPedId(), GetHashKey("WEAPON_UNARMED"), true)
    end
end

RegisterNUICallback("PutIntoFast", function(data, cb)
	if data.item.slot ~= nil then
		fastWeapons[data.item.slot] = nil
	end

	fastWeapons[data.slot] = data.item
	loadPlayerInventory()
	cb("ok")
end)

RegisterNUICallback("TakeFromFast", function(data, cb)
	fastWeapons[data.item.slot] = nil
	loadPlayerInventory()
	cb("ok")
end)

function useItems(data)
    local player = GetPlayerPed(-1)	
    closeInventory()			 
   
    if data.name == "helmet" then
        TriggerEvent('skinchanger:getSkin', function(skin)
            if skin["helmet_1"] == -1 then

                local dict = "veh@bicycle@roadfront@base"
                local anim = "put_on_helmet"
    
                RequestAnimDict(dict)
                while (not HasAnimDictLoaded(dict)) do Citizen.Wait(0) end
                
                TaskPlayAnim(player, dict, anim, 8.0, 2.0, -1, 48, 2, 0, 0, 0 )
    
                Wait(1000)

                local accessorySkin = {}
                accessorySkin['helmet_1'] = data.itemnum
                accessorySkin['helmet_2'] = data.itemskin

                TriggerEvent('skinchanger:loadClothes', skin, accessorySkin)
            else

                 if IsPedInAnyVehicle(PlayerPedId(), true) == false then
                    local dict = "veh@bike@common@front@base"
                    local anim = "take_off_helmet_walk"

                    RequestAnimDict(dict)
                    while (not HasAnimDictLoaded(dict)) do Citizen.Wait(0) end
                    
                    TaskPlayAnim(player, dict, anim, 8.0, 2.0, -1, 48, 2, 0, 0, 0 )
        
                    Wait(800)
                end

                local accessorySkin = {}
                accessorySkin['helmet_1'] = -1
                accessorySkin['helmet_2'] = 0
                TriggerEvent('skinchanger:loadClothes', skin, accessorySkin)
            end
            
        end)
    elseif data.name == "mask" then
        TriggerEvent('skinchanger:getSkin', function(skin)
            if skin["mask_1"] == -1 then

                local dict = "veh@bicycle@roadfront@base"
                local anim = "put_on_helmet"
    
                RequestAnimDict(dict)
                while (not HasAnimDictLoaded(dict)) do Citizen.Wait(0) end
                
                TaskPlayAnim(player, dict, anim, 8.0, 2.0, -1, 48, 2, 0, 0, 0 )
    
                Wait(1000)

                local accessorySkin = {}
                accessorySkin['mask_1'] = data.itemnum
                accessorySkin['mask_2'] = data.itemskin
                TriggerEvent('skinchanger:loadClothes', skin, accessorySkin)
            else

                if IsPedInAnyVehicle(PlayerPedId(), true) == false then
                    local dict = "veh@bike@common@front@base"
                    local anim = "take_off_helmet_walk"

                    RequestAnimDict(dict)
                    while (not HasAnimDictLoaded(dict)) do Citizen.Wait(0) end
                    
                    TaskPlayAnim(player, dict, anim, 8.0, 2.0, -1, 48, 2, 0, 0, 0 )
        
                    Wait(800)
                end

                local accessorySkin = {}
                accessorySkin['mask_1'] = -1
                accessorySkin['mask_2'] = 0
                TriggerEvent('skinchanger:loadClothes', skin, accessorySkin)
            end
            
        end)
    elseif data.name == "glasses" then
        TriggerEvent('skinchanger:getSkin', function(skin)
            if skin["glasses_1"] == -1 then

                if IsPedInAnyVehicle(PlayerPedId(), true) == false then
                    local dict = "clothingspecs"
                    local anim = "try_glasses_positive_a"
        
                    RequestAnimDict(dict)
                    while (not HasAnimDictLoaded(dict)) do Citizen.Wait(0) end
                    
                    TaskPlayAnim(player, dict, anim, 8.0, 2.0, -1, 48, 2, 0, 0, 0 )
        
                    Wait(800)
                end

                local accessorySkin = {}
                accessorySkin['glasses_1'] = data.itemnum
                accessorySkin['glasses_2'] = data.itemskin
                TriggerEvent('skinchanger:loadClothes', skin, accessorySkin)

            else

                if IsPedInAnyVehicle(PlayerPedId(), true) == false then
                    local dict = "clothingspecs"
                    local anim = "take_off"
        
                    RequestAnimDict(dict)
                    while (not HasAnimDictLoaded(dict)) do Citizen.Wait(0) end
                    
                    TaskPlayAnim(player, dict, anim, 8.0, 2.0, -1, 48, 2, 0, 0, 0 )
        
                    Wait(1000)
                end

                local accessorySkin = {}
                accessorySkin['glasses_1'] = -1
                accessorySkin['glasses_2'] = 0
                TriggerEvent('skinchanger:loadClothes', skin, accessorySkin)
            end
            
        end)
    -------------------------------------------------------------------[1]-------------------------------------------------------------------           
    -- tshirt
elseif data.name == "tshirt" then
    TriggerEvent('skinchanger:getSkin', function(skin)

        if skin["tshirt_1"] == -1 then

        if Config.Options.enabled and IsPedInAnyVehicle(PlayerPedId(), true) == false then
            RequestAnimDict(Config.Options.dicton)
            while (not HasAnimDictLoaded(Config.Options.dicton)) do Citizen.Wait(0) end
            TaskPlayAnim(player, Config.Options.dicton, Config.Options.animon, 8.0, 1.0, -1, 0, 0.5, 0, 0)
            Wait(2000)
        end

        local accessorySkin = {}
        accessorySkin['tshirt_1']  = data.itemnum
        accessorySkin['tshirt_2']  = data.itemskin
        TriggerEvent('skinchanger:loadClothes', skin, accessorySkin)
        exports['mythic_notify']:DoHudText('success', Config.Text.torsoon)              
    else

        if Config.Options.enabledoff and IsPedInAnyVehicle(PlayerPedId(), true) == false then
            RequestAnimDict(Config.Options.dictoff)
            while (not HasAnimDictLoaded(Config.Options.dictoff)) do Citizen.Wait(0) end
            TaskPlayAnim(player, Config.Options.dictoff, Config.Options.animoff, 8.0, 1.0, -1, 0, 0.3, 0, 0)
            Wait(2000)
        end

        local accessorySkin = {}
        accessorySkin['tshirt_1'] = -1
        accessorySkin['tshirt_2'] = 0
        TriggerEvent('skinchanger:loadClothes', skin, accessorySkin)
        exports['mythic_notify']:DoHudText('error', Config.Text.torsooff) 
    end
    
end)
-- Torso
elseif data.name == "torso" then
    TriggerEvent('skinchanger:getSkin', function(skin)

        if skin["torso_1"] == -1 then

        if Config.Options.enabled and IsPedInAnyVehicle(PlayerPedId(), true) == false then
            RequestAnimDict(Config.Options.dicton)
            while (not HasAnimDictLoaded(Config.Options.dicton)) do Citizen.Wait(0) end
            TaskPlayAnim(player, Config.Options.dicton, Config.Options.animon, 8.0, 1.0, -1, 0, 0.5, 0, 0)
            Wait(2000)
        end

        local accessorySkin = {}
        accessorySkin['torso_1']   = data.itemnum
        accessorySkin['torso_2']   = data.itemskin
        TriggerEvent('skinchanger:loadClothes', skin, accessorySkin) 
        exports['mythic_notify']:DoHudText('success',  Config.Text.torsoon)             
    else

        if Config.Options.enabledoff and IsPedInAnyVehicle(PlayerPedId(), true) == false then
            RequestAnimDict(Config.Options.dictoff)
            while (not HasAnimDictLoaded(Config.Options.dictoff)) do Citizen.Wait(0) end
            TaskPlayAnim(player, Config.Options.dictoff, Config.Options.animoff, 8.0, 1.0, -1, 0, 0.3, 0, 0)
            Wait(2000)
        end

        local accessorySkin = {}
        accessorySkin['torso_1'] = -1
        accessorySkin['torso_2'] = 0
        TriggerEvent('skinchanger:loadClothes', skin, accessorySkin)
        exports['mythic_notify']:DoHudText('error',  Config.Text.torsooff)      
    end
    
end)
-- arms
elseif data.name == "arms" then
TriggerEvent('skinchanger:getSkin', function(skin)

    if skin["arms"] == 15 then

    if Config.Options.enabled and IsPedInAnyVehicle(PlayerPedId(), true) == false then
        RequestAnimDict(Config.Options.dicton)
        while (not HasAnimDictLoaded(Config.Options.dicton)) do Citizen.Wait(0) end
        TaskPlayAnim(player, Config.Options.dicton, Config.Options.animon, 8.0, 1.0, -1, 0, 0.5, 0, 0)
        Wait(2000)
    end

    local accessorySkin = {}
    accessorySkin['arms']   = data.itemnum
    accessorySkin['arms_2']   = data.itemskin
    TriggerEvent('skinchanger:loadClothes', skin, accessorySkin)  
    exports['mythic_notify']:DoHudText('success',  Config.Text.torsoon)              
else

    if Config.Options.enabledoff and IsPedInAnyVehicle(PlayerPedId(), true) == false then
        RequestAnimDict(Config.Options.dictoff)
        while (not HasAnimDictLoaded(Config.Options.dictoff)) do Citizen.Wait(0) end
        TaskPlayAnim(player, Config.Options.dictoff, Config.Options.animoff, 8.0, 1.0, -1, 0, 0.3, 0, 0)
        Wait(2000)
    end

    local accessorySkin = {}
    accessorySkin['arms'] = 15
    accessorySkin['arms_2'] = 0
    TriggerEvent('skinchanger:loadClothes', skin, accessorySkin)
    exports['mythic_notify']:DoHudText('error',  Config.Text.torsooff)  
end       
end)
elseif data.name == "pants" then
TriggerEvent('skinchanger:getSkin', function(skin)
    if skin["pants_1"] == 21 then

        if Config.Options.enabled and IsPedInAnyVehicle(PlayerPedId(), true) == false then
            RequestAnimDict(Config.Options.dicton)
            while (not HasAnimDictLoaded(Config.Options.dicton)) do Citizen.Wait(0) end
            TaskPlayAnim(player, Config.Options.dicton, Config.Options.animon, 8.0, 1.0, -1, 0, 0.5, 0, 0)
            Wait(2000)
        end

        local accessorySkin = {}
        accessorySkin['pants_1'] = data.itemnum
        accessorySkin['pants_2'] = data.itemskin
        TriggerEvent('skinchanger:loadClothes', skin, accessorySkin)
        exports['mythic_notify']:DoHudText('success', Config.Text.pantson)  

    else

        if Config.Options.enabledoff and IsPedInAnyVehicle(PlayerPedId(), true) == false then
            RequestAnimDict(Config.Options.dictoff)
            while (not HasAnimDictLoaded(Config.Options.dictoff)) do Citizen.Wait(0) end
            TaskPlayAnim(player, Config.Options.dictoff, Config.Options.animoff, 8.0, 1.0, -1, 0, 0.3, 0, 0)
            Wait(2000)
        end

        local accessorySkin = {}
        accessorySkin['pants_1'] = 21
        accessorySkin['pants_2'] = 0
        TriggerEvent('skinchanger:loadClothes', skin, accessorySkin)
        exports['mythic_notify']:DoHudText('error',  Config.Text.pantsoff)  
    end
    
end)
elseif data.name == "shoes" then
TriggerEvent('skinchanger:getSkin', function(skin)
    if skin["shoes_1"] == 34 then

        if Config.Options.enabled and IsPedInAnyVehicle(PlayerPedId(), true) == false then
            RequestAnimDict(Config.Options.dicton)
            while (not HasAnimDictLoaded(Config.Options.dicton)) do Citizen.Wait(0) end
            TaskPlayAnim(player, Config.Options.dicton, Config.Options.animon, 8.0, 1.0, -1, 0, 0.5, 0, 0)
            Wait(2000)
        end

        local accessorySkin = {}
        accessorySkin['shoes_1'] = data.itemnum
        accessorySkin['shoes_2'] = data.itemskin
        TriggerEvent('skinchanger:loadClothes', skin, accessorySkin)
        exports['mythic_notify']:DoHudText('success',  Config.Text.shoeson)  

        ClearPedTasks(player)
    else

        if Config.Options.enabledoff and IsPedInAnyVehicle(PlayerPedId(), true) == false then
            RequestAnimDict(Config.Options.dictoff)
            while (not HasAnimDictLoaded(Config.Options.dictoff)) do Citizen.Wait(0) end
            TaskPlayAnim(player, Config.Options.dictoff, Config.Options.animoff, 8.0, 1.0, -1, 0, 0.3, 0, 0)
            Wait(2000)
        end

        local accessorySkin = {}
        accessorySkin['shoes_1'] = 34
        accessorySkin['shoes_2'] = 0
        TriggerEvent('skinchanger:loadClothes', skin, accessorySkin)
        exports['mythic_notify']:DoHudText('error',  Config.Text.shoesoff)  
    end
    
end)			
    elseif data.name == "earring" then
        TriggerEvent('skinchanger:getSkin', function(skin)
            if skin["ears_1"] == -1 then

                if IsPedInAnyVehicle(PlayerPedId(), true) == false then
                    local dict = "mini@ears_defenders"
                    local anim = "takeoff_earsdefenders_idle"
        
                    RequestAnimDict(dict)
                    while (not HasAnimDictLoaded(dict)) do Citizen.Wait(0) end
                    
                    TaskPlayAnim(player, dict, anim, 8.0, 2.0, -1, 48, 2, 0, 0, 0 )
        
                    Wait(800)
                end

                local accessorySkin = {}
                accessorySkin['ears_1'] = data.itemnum
                accessorySkin['ears_2'] = data.itemskin
                TriggerEvent('skinchanger:loadClothes', skin, accessorySkin)
            else

                if IsPedInAnyVehicle(PlayerPedId(), true) == false then
                    local dict = "mini@ears_defenders"
                    local anim = "takeoff_earsdefenders_idle"
        
                    RequestAnimDict(dict)
                    while (not HasAnimDictLoaded(dict)) do Citizen.Wait(0) end
                    
                    TaskPlayAnim(player, dict, anim, 8.0, 2.0, -1, 48, 2, 0, 0, 0 )
        
                    Wait(800)
                end

                local accessorySkin = {}
                accessorySkin['ears_1'] = -1
                accessorySkin['ears_2'] = 0
                TriggerEvent('skinchanger:loadClothes', skin, accessorySkin)
            end
            
        end)
elseif data.name == "decals" then
    TriggerEvent('skinchanger:getSkin', function(skin)

        if skin["decals_1"] == -1 then

        if Config.Options.enabled and IsPedInAnyVehicle(PlayerPedId(), true) == false then
            RequestAnimDict(Config.Options.dicton)
            while (not HasAnimDictLoaded(Config.Options.dicton)) do Citizen.Wait(0) end
            TaskPlayAnim(player, Config.Options.dicton, Config.Options.animon, 8.0, 1.0, -1, 0, 0.5, 0, 0)
            Wait(2000)
        end

        local accessorySkin = {}
        accessorySkin['decals_1']   = data.itemnum
        accessorySkin['decals_2']   = data.itemskin
        TriggerEvent('skinchanger:loadClothes', skin, accessorySkin) 
        exports['mythic_notify']:DoHudText('success',  Config.Text.torsoon)             
    else

        if Config.Options.enabledoff and IsPedInAnyVehicle(PlayerPedId(), true) == false then
            RequestAnimDict(Config.Options.dictoff)
            while (not HasAnimDictLoaded(Config.Options.dictoff)) do Citizen.Wait(0) end
            TaskPlayAnim(player, Config.Options.dictoff, Config.Options.animoff, 8.0, 1.0, -1, 0, 0.3, 0, 0)
            Wait(2000)
        end

        local accessorySkin = {}
        accessorySkin['decals_1'] = -1
        accessorySkin['decals_2'] = 0
        TriggerEvent('skinchanger:loadClothes', skin, accessorySkin)
        exports['mythic_notify']:DoHudText('error',  Config.Text.torsooff)      
    end
end)
elseif data.name == "chain" then
    TriggerEvent('skinchanger:getSkin', function(skin)

        if skin["chain_1"] == -1 then

        if Config.Options.enabled and IsPedInAnyVehicle(PlayerPedId(), true) == false then
            RequestAnimDict(Config.Options.dicton)
            while (not HasAnimDictLoaded(Config.Options.dicton)) do Citizen.Wait(0) end
            TaskPlayAnim(player, Config.Options.dicton, Config.Options.animon, 8.0, 1.0, -1, 0, 0.5, 0, 0)
            Wait(2000)
        end

        local accessorySkin = {}
        accessorySkin['chain_1']   = data.itemnum
        accessorySkin['chain_2']   = data.itemskin
        TriggerEvent('skinchanger:loadClothes', skin, accessorySkin) 
        exports['mythic_notify']:DoHudText('success',  Config.Text.torsoon)             
    else

        if Config.Options.enabledoff and IsPedInAnyVehicle(PlayerPedId(), true) == false then
            RequestAnimDict(Config.Options.dictoff)
            while (not HasAnimDictLoaded(Config.Options.dictoff)) do Citizen.Wait(0) end
            TaskPlayAnim(player, Config.Options.dictoff, Config.Options.animoff, 8.0, 1.0, -1, 0, 0.3, 0, 0)
            Wait(2000)
        end

        local accessorySkin = {}
        accessorySkin['chain_1'] = -1
        accessorySkin['chain_2'] = 0
        TriggerEvent('skinchanger:loadClothes', skin, accessorySkin)
        exports['mythic_notify']:DoHudText('error',  Config.Text.torsooff)      
    end
end)
elseif data.name == "bags" then
    TriggerEvent('skinchanger:getSkin', function(skin)

        if skin["bags_1"] == -1 then

        if Config.Options.enabled and IsPedInAnyVehicle(PlayerPedId(), true) == false then
            RequestAnimDict(Config.Options.dicton)
            while (not HasAnimDictLoaded(Config.Options.dicton)) do Citizen.Wait(0) end
            TaskPlayAnim(player, Config.Options.dicton, Config.Options.animon, 8.0, 1.0, -1, 0, 0.5, 0, 0)
            Wait(2000)
        end

        local accessorySkin = {}
        accessorySkin['bags_1']   = data.itemnum
        accessorySkin['bags_2']   = data.itemskin
        TriggerEvent('skinchanger:loadClothes', skin, accessorySkin) 
        exports['mythic_notify']:DoHudText('success',  Config.Text.torsoon)             
    else

        if Config.Options.enabledoff and IsPedInAnyVehicle(PlayerPedId(), true) == false then
            RequestAnimDict(Config.Options.dictoff)
            while (not HasAnimDictLoaded(Config.Options.dictoff)) do Citizen.Wait(0) end
            TaskPlayAnim(player, Config.Options.dictoff, Config.Options.animoff, 8.0, 1.0, -1, 0, 0.3, 0, 0)
            Wait(2000)
        end

        local accessorySkin = {}
        accessorySkin['bags_1'] = -1
        accessorySkin['bags_2'] = 0
        TriggerEvent('skinchanger:loadClothes', skin, accessorySkin)
        exports['mythic_notify']:DoHudText('error',  Config.Text.torsooff)      
    end
end)
end
end