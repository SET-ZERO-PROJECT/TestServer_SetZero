ESX 			= nil
itemShopList 	= {}
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

RegisterServerEvent('esx_inventoryhud:getOwnerVehicle')
AddEventHandler('esx_inventoryhud:getOwnerVehicle', function()
	local _source = source
	local KeyItems = {}
	local xPlayer = ESX.GetPlayerFromId(source)

	KeyItems = MySQL.Sync.fetchAll('SELECT * FROM owned_vehicles WHERE owner = @identifier', {
		['@identifier'] = xPlayer.identifier
	})
	TriggerClientEvent("esx_inventoryhud:setOwnerVehicle", _source, KeyItems)
end)

-- RegisterServerEvent('esx_inventoryhud:getOwnerHouse')
-- AddEventHandler('esx_inventoryhud:getOwnerHouse', function()
-- 	local _source = source
-- 	local HouseItems = {}
-- 	local xPlayer = ESX.GetPlayerFromId(source)

-- 	HouseItems = MySQL.Sync.fetchAll('SELECT * FROM owned_properties WHERE owner = @identifier', {
-- 		['@identifier'] = xPlayer.identifier
-- 	})
-- 	TriggerClientEvent("esx_inventoryhud:setOwnerHouse", _source, HouseItems)
-- end)

RegisterServerEvent('esx_inventoryhud:getOwnerAccessories')
 AddEventHandler('esx_inventoryhud:getOwnerAccessories', function()
 	local _source = source
 	local xPlayer = ESX.GetPlayerFromId(source)
 	local AccessoriesItems = {}

 	-- Accessories Helmet หมวก
 	local Result_Helmet = MySQL.Sync.fetchAll('SELECT * FROM meeta_accessory_inventory WHERE owner = @owner AND type = @type', {
 		['@owner'] = xPlayer.identifier,
 		['@type'] = 'player_helmet'
	})

 	if Result_Helmet[1] then
 		for k,v in pairs(Result_Helmet) do
 			local skin = json.decode(v.skin)
 			table.insert(AccessoriesItems, {
 				label = v.label,
 				count = 1,
 				limit = -1,
 				type = "item_accessories",
 				id = v.id,
 				name = "helmet",
 				usable = true,
 				rare = false,
 				canRemove = false,
 				itemnum = skin["helmet_1"],
 				itemskin = skin["helmet_2"]
 			})
 		end
 	end

 	-- Accessories Mask หน้ากาก
 	local Result_Mask = MySQL.Sync.fetchAll('SELECT * FROM meeta_accessory_inventory WHERE owner = @owner AND type = @type', {
 		['@owner'] = xPlayer.identifier,
 		['@type'] = 'player_mask'
 	})

 	if Result_Mask[1] then
 		for k,v in pairs(Result_Mask) do
 			local skin = json.decode(v.skin)
 			table.insert(AccessoriesItems, {
 				label = v.label,
 				count = 1,
 				limit = -1,
 				type = "item_accessories",
 				id = v.id,
 				name = "mask",
 				usable = true,
 				rare = false,
 				canRemove = false,
 				itemnum = skin["mask_1"],
 				itemskin = skin["mask_2"]
 			})
 		end
 	end

-- 	-- Accessories Glasses แว่นตา
 	local Result_Glasses = MySQL.Sync.fetchAll('SELECT * FROM meeta_accessory_inventory WHERE owner = @owner AND type = @type', {
 		['@owner'] = xPlayer.identifier,
 		['@type'] = 'player_glasses'
 	})

 	if Result_Glasses[1] then
 		for k,v in pairs(Result_Glasses) do
 			local skin = json.decode(v.skin)
 			table.insert(AccessoriesItems, {
 				label = v.label,
 				count = 1,
 				limit = -1,
 				type = "item_accessories",
 				id = v.id,
 				name = "glasses",
 				usable = true,
 				rare = false,
 				canRemove = false,
 				itemnum = skin["glasses_1"],
 				itemskin = skin["glasses_2"]
 			})
 		end
 	end
	
	-- Accessories Tshirt เสื้อยึด
	local Result_Tshirt = MySQL.Sync.fetchAll('SELECT * FROM meeta_accessory_inventory WHERE owner = @owner AND type = @type', {
		['@owner'] = xPlayer.identifier,
		['@type'] = 'player_tshirt'
	})

	if Result_Tshirt[1] then
		for k,v in pairs(Result_Tshirt) do
			local skin = json.decode(v.skin)
			table.insert(AccessoriesItems, {
				label = v.label,
				count = 1,
				limit = -1,
				type = "item_accessories",
				id = v.id,
				name = "tshirt",
				usable = true,
				rare = false,
				canRemove = false,
				itemnum = skin["tshirt_1"],
				itemskin = skin["tshirt_2"],
			})
		end
	end
-- Accessories Torso เสื้อนอก
local Result_Torso = MySQL.Sync.fetchAll('SELECT * FROM meeta_accessory_inventory WHERE owner = @owner AND type = @type', {
	['@owner'] = xPlayer.identifier,
	['@type'] = 'player_torso'
})

if Result_Torso[1] then
	for k,v in pairs(Result_Torso) do
		local skin = json.decode(v.skin)
		table.insert(AccessoriesItems, {
			label = v.label,
			count = 1,
			limit = -1,
			type = "item_accessories",
			id = v.id,
			name = "torso",
			usable = true,
			rare = false,
			canRemove = false,
			itemnum = skin["torso_1"],
			itemskin = skin["torso_2"]
		})
	end
end
-- Accessories Arms แขน
local Result_Arms = MySQL.Sync.fetchAll('SELECT * FROM meeta_accessory_inventory WHERE owner = @owner AND type = @type', {
	['@owner'] = xPlayer.identifier,
	['@type'] = 'player_arms'
})

if Result_Arms[1] then
	for k,v in pairs(Result_Arms) do
		local skin = json.decode(v.skin)
		table.insert(AccessoriesItems, {
			label = v.label,
			count = 1,
			limit = -1,
			type = "item_accessories",
			id = v.id,
			name = "arms",
			usable = true,
			rare = false,
			canRemove = false,
			itemnum = skin["arms"],
			itemskin = skin["arms_2"]
		})
	end
end
	-- Accessories Pants กางเกง
	local Result_Pants = MySQL.Sync.fetchAll('SELECT * FROM meeta_accessory_inventory WHERE owner = @owner AND type = @type', {
		['@owner'] = xPlayer.identifier,
		['@type'] = 'player_pants'
	})

	if Result_Pants[1] then
		for k,v in pairs(Result_Pants) do
			local skin = json.decode(v.skin)
			table.insert(AccessoriesItems, {
				label = v.label,
				count = 1,
				limit = -1,
				type = "item_accessories",
				id = v.id,
				name = "pants",
				usable = true,
				rare = false,
				canRemove = false,
				itemnum = skin["pants_1"],
				itemskin = skin["pants_2"]
			})
		end
	end

	-- Accessories Shoes รองเท้า
	local Result_Shoes = MySQL.Sync.fetchAll('SELECT * FROM meeta_accessory_inventory WHERE owner = @owner AND type = @type', {
		['@owner'] = xPlayer.identifier,
		['@type'] = 'player_shoes'
	})

	if Result_Shoes[1] then
		for k,v in pairs(Result_Shoes) do
			local skin = json.decode(v.skin)
			table.insert(AccessoriesItems, {
				label = v.label,
				count = 1,
				limit = -1,
				type = "item_accessories",
				id = v.id,
				name = "shoes",
				usable = true,
				rare = false,
				canRemove = false,
				itemnum = skin["shoes_1"],
				itemskin = skin["shoes_2"]
			})
		end
	end
	
	-- Accessories Bags กระเป๋า
	local Result_Bags = MySQL.Sync.fetchAll('SELECT * FROM meeta_accessory_inventory WHERE owner = @owner AND type = @type', {
		['@owner'] = xPlayer.identifier,
		['@type'] = 'player_bags'
	})

	if Result_Bags[1] then
		for k,v in pairs(Result_Bags) do
			local skin = json.decode(v.skin)
			table.insert(AccessoriesItems, {
				label = v.label,
				count = 1,
				limit = -1,
				type = "item_accessories",
				id = v.id,
				name = "bags",
				usable = true,
				rare = false,
				canRemove = false,
				itemnum = skin["bags_1"],
				itemskin = skin["bags_2"]
			})
		end
	end
	
	local Result_bproof = MySQL.Sync.fetchAll('SELECT * FROM meeta_accessory_inventory WHERE owner = @owner AND type = @type', {
		['@owner'] = xPlayer.identifier,
		['@type'] = 'player_bproof'
	})

	if Result_bproof[1] then
		for k,v in pairs(Result_bproof) do
			local skin = json.decode(v.skin)
			table.insert(AccessoriesItems, {
				label = v.label,
				count = 1,
				limit = -1,
				type = "item_accessories",
				id = v.id,
				name = "bproof",
				usable = true,
				rare = false,
				canRemove = false,
				itemnum = skin["bproof_1"],
				itemskin = skin["bproof_2"]
			})
		end
	end
	
	-- Accessories Bags กระเป๋า
	local Result_chain = MySQL.Sync.fetchAll('SELECT * FROM meeta_accessory_inventory WHERE owner = @owner AND type = @type', {
		['@owner'] = xPlayer.identifier,
		['@type'] = 'player_chain'
	})

	if Result_chain[1] then
		for k,v in pairs(Result_chain) do
			local skin = json.decode(v.skin)
			table.insert(AccessoriesItems, {
				label = v.label,
				count = 1,
				limit = -1,
				type = "item_accessories",
				id = v.id,
				name = "chain",
				usable = true,
				rare = false,
				canRemove = false,
				itemnum = skin["chain_1"],
				itemskin = skin["chain_2"]
			})
		end
	end
	
	-- Accessories Bags กระเป๋า
	local Result_watches = MySQL.Sync.fetchAll('SELECT * FROM meeta_accessory_inventory WHERE owner = @owner AND type = @type', {
		['@owner'] = xPlayer.identifier,
		['@type'] = 'player_watches'
	})

	if Result_watches[1] then
		for k,v in pairs(Result_watches) do
			local skin = json.decode(v.skin)
			table.insert(AccessoriesItems, {
				label = v.label,
				count = 1,
				limit = -1,
				type = "item_accessories",
				id = v.id,
				name = "watches",
				usable = true,
				rare = false,
				canRemove = false,
				itemnum = skin["watches_1"],
				itemskin = skin["watches_2"]
			})
		end
	end
	
	-- Accessories Bags กระเป๋า
	local Result_bracelets = MySQL.Sync.fetchAll('SELECT * FROM meeta_accessory_inventory WHERE owner = @owner AND type = @type', {
		['@owner'] = xPlayer.identifier,
		['@type'] = 'player_bracelets'
	})

	if Result_bracelets[1] then
		for k,v in pairs(Result_bracelets) do
			local skin = json.decode(v.skin)
			table.insert(AccessoriesItems, {
				label = v.label,
				count = 1,
				limit = -1,
				type = "item_accessories",
				id = v.id,
				name = "bracelets",
				usable = true,
				rare = false,
				canRemove = false,
				itemnum = skin["bracelets_1"],
				itemskin = skin["bracelets_2"]
			})
		end
	end

 	-- Accessories Earring ต่างหู
 	local Result_Earring = MySQL.Sync.fetchAll('SELECT * FROM meeta_accessory_inventory WHERE owner = @owner AND type = @type', {
 		['@owner'] = xPlayer.identifier,
 		['@type'] = 'player_ears'
 	})

 	if Result_Earring[1] then
 		for k,v in pairs(Result_Earring) do
 			local skin = json.decode(v.skin)
 			table.insert(AccessoriesItems, {
 				label = v.label,
 				count = 1,
 				limit = -1,
 				type = "item_accessories",
 				id = v.id,
 				name = "earring",
 				usable = true,
 				rare = false,
 				canRemove = false,
 				itemnum = skin["ears_1"],
 				itemskin = skin["ears_2"]
 			})
 		end
 	end

 	TriggerClientEvent("esx_inventoryhud:setOwnerAccessories", _source, AccessoriesItems)

end)


RegisterServerEvent('esx_inventoryhud:updateKey')
AddEventHandler('esx_inventoryhud:updateKey', function(target, type, itemName)

	local _source = source

	local sourceXPlayer = ESX.GetPlayerFromId(_source)
	local targetXPlayer = ESX.GetPlayerFromId(target)

	local identifier = GetPlayerIdentifiers(source)[1]
	local identifier_target = GetPlayerIdentifiers(target)[1]
	if type == "item_key" then

		-- MySQL.Async.execute("UPDATE owned_vehicles SET owner = @newplayer, buyer = @newplayer WHERE owner = @identifier AND plate = @plate",
		MySQL.Async.execute("UPDATE owned_vehicles SET owner = @newplayer WHERE owner = @identifier AND plate = @plate",
		{
			['@identifier']		= identifier,
			['@newplayer']		= identifier_target,
			['@plate']		= itemName
		})
		
		TriggerClientEvent("pNotify:SendNotification", source, {
			text = 'ส่ง <strong class="amber-text">กุญแจรถ</strong> ทะเบียน <strong class="yellow-text">'..itemName..'</strong>',
			type = "success",
			timeout = 3000,
			layout = "bottomCenter",
			queue = "global"
		})
		TriggerClientEvent("pNotify:SendNotification", target, {
			text = 'ได้รับ <strong class="amber-text">กุญแจรถ</strong> ทะเบียน <strong class="yellow-text">'..itemName..'</strong>',
			type = "success",
			timeout = 3000,
			layout = "bottomCenter",
			queue = "global"
		})
		
		TriggerClientEvent("esx_inventoryhud:getOwnerVehicle", source)
		TriggerClientEvent("esx_inventoryhud:getOwnerVehicle", target)
		
		local sendToDiscord = '' .. sourceXPlayer.name .. ' ส่ง กุญแจรถ ทะเบียน ' .. itemName .. ' ไปยัง ' .. targetXPlayer.name .. ''
		TriggerEvent('azael_discordlogs:sendToDiscord', 'GiveKey', sendToDiscord, _source, '^3')
		
		Citizen.Wait(100)
		
		local sendToDiscord2 = '' .. targetXPlayer.name .. ' ได้รับ กุญแจรถ ทะเบียน ' .. itemName .. ' จาก ' .. sourceXPlayer.name .. ''
		TriggerEvent('azael_discordlogs:sendToDiscord', 'GiveKey', sendToDiscord2, target, '^2')

	elseif type == "item_keyhouse" then -- MEETA GiveKeyHouse

		MySQL.Async.execute("UPDATE owned_properties SET owner = @newplayer WHERE owner = @identifier AND id = @id",
		{
			['@identifier']		= identifier,
			['@newplayer']		= identifier_target,
			['@id']		= itemName
		})

		TriggerClientEvent("pNotify:SendNotification", source, {
			text = 'ส่ง <strong class="amber-text">กุญแจบ้าน</strong>',
			type = "success",
			timeout = 3000,
			layout = "bottomCenter",
			queue = "global"
		})
		TriggerClientEvent("pNotify:SendNotification", target, {
			text = 'ได้รับ <strong class="amber-text">กุญแจบ้าน</strong>',
			type = "success",
			timeout = 3000,
			layout = "bottomCenter",
			queue = "global"
		})

		TriggerClientEvent("esx_inventoryhud:getOwnerHouse", source)
		TriggerClientEvent("esx_inventoryhud:getOwnerHouse", target)
		
		local sendToDiscord = '' .. sourceXPlayer.name .. ' ส่ง กุญแจบ้าน ' .. itemName .. ' ไปยัง ' .. targetXPlayer.name .. ''
		TriggerEvent('azael_discordlogs:sendToDiscord', 'GiveKey', sendToDiscord, _source, '^3')

		Citizen.Wait(100)

		local sendToDiscord2 = '' .. targetXPlayer.name .. ' ได้รับ กุญแจบ้าน ' .. itemName .. ' จาก ' .. sourceXPlayer.name .. ''
		TriggerEvent('azael_discordlogs:sendToDiscord', 'GiveKey', sendToDiscord2, target, '^2')
	end
end)

RegisterServerEvent('esx_inventoryhud:black_money')
AddEventHandler('esx_inventoryhud:black_money', function()
	local xPlayer = ESX.GetPlayerFromId(source)
	xPlayer.removeAccountMoney('black_money', 0)
end)

RegisterServerEvent("suku:sendShopItems")
AddEventHandler("suku:sendShopItems", function(source, itemList)
	itemShopList = itemList
end)

ESX.RegisterServerCallback("suku:getShopItems", function(source, cb, shoptype)
	itemShopList = {}
	local itemResult = MySQL.Sync.fetchAll('SELECT * FROM items')
	local itemInformation = {}

	for i=1, #itemResult, 1 do

		if itemInformation[itemResult[i].name] == nil then
			itemInformation[itemResult[i].name] = {}
		end

		itemInformation[itemResult[i].name].name = itemResult[i].name
		itemInformation[itemResult[i].name].label = itemResult[i].label
		itemInformation[itemResult[i].name].limit = itemResult[i].limit
		itemInformation[itemResult[i].name].rare = itemResult[i].rare
		itemInformation[itemResult[i].name].can_remove = itemResult[i].can_remove
		itemInformation[itemResult[i].name].price = itemResult[i].price

		if shoptype == "regular" then
			for _, v in pairs(Config.Shops.RegularShop.Items) do
				if v.name == itemResult[i].name then
					table.insert(itemShopList, {
						type = "item_standard",
						name = itemInformation[itemResult[i].name].name,
						label = itemInformation[itemResult[i].name].label,
						limit = itemInformation[itemResult[i].name].limit,
						rare = itemInformation[itemResult[i].name].rare,
						can_remove = itemInformation[itemResult[i].name].can_remove,
						price = itemInformation[itemResult[i].name].price,
						count = 1
					})
				end
			end
		end
		if shoptype == "robsliquor" then
			for _, v in pairs(Config.Shops.RobsLiquor.Items) do
				if v.name == itemResult[i].name then
					table.insert(itemShopList, {
						type = "item_standard",
						name = itemInformation[itemResult[i].name].name,
						label = itemInformation[itemResult[i].name].label,
						limit = itemInformation[itemResult[i].name].limit,
						rare = itemInformation[itemResult[i].name].rare,
						can_remove = itemInformation[itemResult[i].name].can_remove,
						price = itemInformation[itemResult[i].name].price,
						count = 1
					})
				end
			end
		end
		if shoptype == "youtool" then
			for _, v in pairs(Config.Shops.YouTool.Items) do
				if v.name == itemResult[i].name then
					table.insert(itemShopList, {
						type = "item_standard",
						name = itemInformation[itemResult[i].name].name,
						label = itemInformation[itemResult[i].name].label,
						limit = itemInformation[itemResult[i].name].limit,
						rare = itemInformation[itemResult[i].name].rare,
						can_remove = itemInformation[itemResult[i].name].can_remove,
						price = itemInformation[itemResult[i].name].price,
						count = 1
					})
				end
			end
		end
		if shoptype == "prison" then
			for _, v in pairs(Config.Shops.PrisonShop.Items) do
				if v.name == itemResult[i].name then
					table.insert(itemShopList, {
						type = "item_standard",
						name = itemInformation[itemResult[i].name].name,
						label = itemInformation[itemResult[i].name].label,
						limit = itemInformation[itemResult[i].name].limit,
						rare = itemInformation[itemResult[i].name].rare,
						can_remove = itemInformation[itemResult[i].name].can_remove,
						price = itemInformation[itemResult[i].name].price,
						count = 1
					})
				end
			end
		end
	end
	cb(itemShopList)
end)

function GetLicenses(source)
    TriggerEvent('esx_license:getLicenses', source, function (licenses)
        TriggerClientEvent('suku:GetLicenses', source, licenses)
    end)
end

AddEventHandler('esx:playerLoaded', function (source)
    GetLicenses(source)
end)

RegisterNetEvent("suku:SellItemToPlayer")
AddEventHandler("suku:SellItemToPlayer",function(source, type, item, count)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)

    if type == "item_standard" then
        local targetItem = xPlayer.getInventoryItem(item)
        if targetItem.limit == -1 or ((targetItem.count + count) <= targetItem.limit) then
            local list = itemShopList
            for i = 1, #list, 1 do
				if list[i].name == item then
					local totalPrice = count * list[i].price
					if xPlayer.getMoney() >= totalPrice then
						xPlayer.removeMoney(totalPrice)
						xPlayer.addInventoryItem(item, count)
						TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'success', text = 'You purchased '..count.." "..list[i].label })
					else
						TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'error', text = 'You do not have enough money!' })
					end
				end
            end
        else
            TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'error', text = 'You do not have enough space in your inventory!' })
        end
	end
end)

ESX.RegisterServerCallback("esx_inventoryhud:getPlayerInventory",function(source, cb, target)
	local targetXPlayer = ESX.GetPlayerFromId(target)
	if targetXPlayer ~= nil then
		cb({inventory = targetXPlayer.inventory, money = targetXPlayer.getMoney(), accounts = targetXPlayer.accounts, weapons = targetXPlayer.loadout})
	else
		cb(nil)
	end
end)

RegisterServerEvent("esx_inventoryhud:tradePlayerItem")
AddEventHandler("esx_inventoryhud:tradePlayerItem",function(from, target, type, itemName, itemCount)
	local _source = from
	local sourceXPlayer = ESX.GetPlayerFromId(_source)
	local targetXPlayer = ESX.GetPlayerFromId(target)

	if type == "item_standard" then
		local sourceItem = sourceXPlayer.getInventoryItem(itemName)
		local targetItem = targetXPlayer.getInventoryItem(itemName)

		if itemCount > 0 and sourceItem.count >= itemCount then
			if targetItem.limit ~= -1 and (targetItem.count + itemCount) > targetItem.limit then
			else
				sourceXPlayer.removeInventoryItem(itemName, itemCount)
				targetXPlayer.addInventoryItem(itemName, itemCount)

				local sendToDiscord = '' .. targetXPlayer.name .. ' ยึด ' .. sourceItem.label .. ' จาก ' .. sourceXPlayer.name .. ' จำนวน ' .. ESX.Math.GroupDigits(itemCount) .. ''
				TriggerEvent('azael_discordlogs:sendToDiscord', 'SeizeItem', sendToDiscord, targetXPlayer.source, '^2')

				Citizen.Wait(100)
														
				local sendToDiscord2 = '' .. sourceXPlayer.name .. ' ถูกยึด ' .. sourceItem.label .. ' โดย ' .. targetXPlayer.name .. ' จำนวน ' .. ESX.Math.GroupDigits(itemCount) .. ''
				TriggerEvent('azael_discordlogs:sendToDiscord', 'SeizeItem', sendToDiscord2, sourceXPlayer.source, '^3')
			end
		end
	elseif type == "item_money" then
		if itemCount > 0 and sourceXPlayer.getMoney() >= itemCount then
			sourceXPlayer.removeMoney(itemCount)
			targetXPlayer.addMoney(itemCount)

			local sendToDiscord = '' .. targetXPlayer.name .. ' ยึด เงินสด จาก ' .. sourceXPlayer.name .. ' จำนวน $' .. ESX.Math.GroupDigits(itemCount) .. ''
			TriggerEvent('azael_discordlogs:sendToDiscord', 'SeizeMoney', sendToDiscord, targetXPlayer.source, '^3')

			Citizen.Wait(100)
								
			local sendToDiscord2 = '' .. sourceXPlayer.name .. ' ถูกยึด เงินสด โดย ' .. targetXPlayer.name .. ' จำนวน $' .. ESX.Math.GroupDigits(itemCount) .. ''
			TriggerEvent('azael_discordlogs:sendToDiscord', 'SeizeMoney', sendToDiscord2, sourceXPlayer.source, '^2')
		end
	elseif type == "item_account" then
		if itemCount > 0 and sourceXPlayer.getAccount(itemName).money >= itemCount then
			sourceXPlayer.removeAccountMoney(itemName, itemCount)
			targetXPlayer.addAccountMoney(itemName, itemCount)

			local sendToDiscord = '' .. targetXPlayer.name .. ' ยึด ' .. itemName .. ' จาก ' .. sourceXPlayer.name .. ' จำนวน $' .. ESX.Math.GroupDigits(itemCount) .. ''
			TriggerEvent('azael_discordlogs:sendToDiscord', 'SeizeDirtyMoney', sendToDiscord, targetXPlayer.source, '^3')

			Citizen.Wait(100)
								
			local sendToDiscord2 = '' .. sourceXPlayer.name .. ' ถูกยึด ' .. itemName .. ' โดย ' .. targetXPlayer.name .. ' จำนวน $' .. ESX.Math.GroupDigits(itemCount) .. ''
			TriggerEvent('azael_discordlogs:sendToDiscord', 'SeizeDirtyMoney', sendToDiscord2, sourceXPlayer.source, '^2')
		end
	elseif type == "item_weapon" then
		if not targetXPlayer.hasWeapon(itemName) then
			sourceXPlayer.removeWeapon(itemName)
			targetXPlayer.addWeapon(itemName, itemCount)

			local weaponLabel = ESX.GetWeaponLabel(itemName)
			
			if itemCount > 0 then
				local sendToDiscord = '' .. targetXPlayer.name .. ' ยึด ' .. weaponLabel .. ' จาก ' .. sourceXPlayer.name .. ' และ กระสุน จำนวน ' .. ESX.Math.GroupDigits(itemCount) .. ''
				TriggerEvent('azael_discordlogs:sendToDiscord', 'SeizeWeapon', sendToDiscord, targetXPlayer.source, '^3')
			
				Citizen.Wait(100)
							
				local sendToDiscord2 = '' .. sourceXPlayer.name .. ' ถูกยึด ' .. weaponLabel .. ' โดย ' .. targetXPlayer.name .. ' และ กระสุน จำนวน ' .. ESX.Math.GroupDigits(itemCount) .. ''
				TriggerEvent('azael_discordlogs:sendToDiscord', 'SeizeWeapon', sendToDiscord2, sourceXPlayer.source, '^2')
			else
				local sendToDiscord = '' .. targetXPlayer.name .. ' ยึด ' .. weaponLabel .. ' จาก ' .. sourceXPlayer.name .. '  จำนวน 1'
				TriggerEvent('azael_discordlogs:sendToDiscord', 'SeizeWeapon', sendToDiscord, targetXPlayer.source, '^3')
			
				Citizen.Wait(100)
							
				local sendToDiscord2 = '' .. sourceXPlayer.name .. ' ถูกยึด ' .. weaponLabel .. ' โดย ' .. targetXPlayer.name .. ' จำนวน 1'
				TriggerEvent('azael_discordlogs:sendToDiscord', 'SeizeWeapon', sendToDiscord2, sourceXPlayer.source, '^2')
			end
		end
	end
end)
RegisterCommand("openinventory",function(source, args, rawCommand)
	if IsPlayerAceAllowed(source, "inventory.openinventory") then
		local target = tonumber(args[1])
		local targetXPlayer = ESX.GetPlayerFromId(target)
		if targetXPlayer ~= nil then
			TriggerClientEvent("esx_inventoryhud:openPlayerInventory", source, target, targetXPlayer.name)
		else
			TriggerClientEvent("chatMessage", source, "^1" .. _U("no_player"))
		end
	else
		TriggerClientEvent("chatMessage", source, "^1" .. _U("no_permissions"))
	end
end)
