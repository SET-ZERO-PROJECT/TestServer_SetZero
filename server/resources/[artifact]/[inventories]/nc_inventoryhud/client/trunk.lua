local trunkData = nil
local blur = "MenuMGIn"

RegisterNetEvent("esx_inventoryhud:openTrunkInventory")
AddEventHandler("esx_inventoryhud:openTrunkInventory", function(data, cash, blackMoney, inventory, weapons)
    setTrunkInventoryData(data, cash, blackMoney, inventory, weapons)
    openTrunkInventory()
end)

RegisterNetEvent("esx_inventoryhud:refreshTrunkInventory")
AddEventHandler("esx_inventoryhud:refreshTrunkInventory", function(data, cash, blackMoney, inventory, weapons)
    setTrunkInventoryData(data, cash, blackMoney, inventory, weapons)
end)

local PutIntoTrunk = false
RegisterNUICallback("PutIntoTrunk", function(data, cb)
    if IsPedSittingInAnyVehicle(playerPed) then
        return
    end
	if not PutIntoTrunk then
        PutIntoTrunk = true
        local rdm = math.random(0,1000)            --ดึงของพร้อมกัน
        Wait(rdm)
        if Config.disablePutTrunk and Config.disablePutTrunk[data.item.name] then
            exports.PorNotify:SendNotification(
                {
                    text = "ไม่สามารถใส่ของชิ้นนี้ได้",
                    type = "error",
                    timeout = 3000,
                    layout = "centerLeft",
                    queue = "inventoryhud"
                }
            )
            closeInventory()
        elseif type(data.number) == "number" and math.floor(data.number) == data.number then
            local count = tonumber(data.number)
            if data.item.type == "item_weapon" then
                count = GetAmmoInPedWeapon(PlayerPedId(), GetHashKey(data.item.name))
            end
            TriggerServerEvent("meeta_carinventory:putItem", trunkData.plate, data.item.type, data.item.name, count, data.item.label, trunkData.max)
        end
        local player = GetPlayerPed(-1)
        local dict = "mp_am_hold_up"
        RequestAnimDict(dict)
        while (not HasAnimDictLoaded(dict)) do Citizen.Wait(0) end
        TaskPlayAnim(player, dict, "purchase_beerbox_shopkeeper", 8.0, 2.0, -1, 48, 2, 0, 0, 0 )
        Wait(500)
        loadPlayerInventory()
        cb("ok")
        PutIntoTrunk = false
    else
        --closeInventory()
    end
end)

local TakeFromTrunk = false
RegisterNUICallback("TakeFromTrunk", function(data, cb)
    if IsPedSittingInAnyVehicle(playerPed) then
        return
    end
    if not TakeFromTrunk then
        TakeFromTrunk = true
        local rdm = math.random(0,1000)            --ดึงของพร้อมกัน
        Wait(rdm)
        if type(data.number) == "number" and math.floor(data.number) == data.number then
            TriggerServerEvent("meeta_carinventory:getItem", data.item.id, trunkData.plate, data.item.type, data.item.name, tonumber(data.number), data.item.label, trunkData.max)
        end
        local player = GetPlayerPed(-1)
        local dict = "mp_am_hold_up"
        RequestAnimDict(dict)
        while (not HasAnimDictLoaded(dict)) do Citizen.Wait(0) end
        TaskPlayAnim(player, dict, "purchase_beerbox_shopkeeper", 8.0, 2.0, -1, 48, 2, 0, 0, 0 )
        Wait(500)
        loadPlayerInventory()
        cb("ok")
        TakeFromTrunk = false
    else
        --closeInventory()
    end
end)

function setTrunkInventoryData(data, cash, blackMoney, inventory, weapons)
    trunkData = data

    SendNUIMessage(
		{
			action = "setInfoText",
			text = data.text,
			weight = data.weight,
			max = data.max,
			plate = data.plate
		}
	)

    items = {}

    if blackMoney > 0 then
        accountData = {
            label = _U("black_money"),
            count = blackMoney,
            type = "item_account",
            name = "black_money",
            usable = false,
            rare = false,
            limit = -1,
            canRemove = false
        }
        table.insert(items, accountData)
    end

    if inventory ~= nil then
        for key, value in pairs(inventory) do
            if inventory[key].count <= 0 then
                inventory[key] = nil
            else
                inventory[key].type = "item_standard"
                inventory[key].usable = false
                inventory[key].rare = false
                inventory[key].limit = -1
                inventory[key].canRemove = false
                table.insert(items, inventory[key])
            end
        end
    end

    if Config.IncludeWeapons and weapons ~= nil then
        for key, value in pairs(weapons) do
            local weaponHash = GetHashKey(weapons[key].name)
            if weapons[key].name ~= "WEAPON_UNARMED" then
                table.insert(
                    items,
                    {
                        label = weapons[key].label,
                        count = weapons[key].ammo,
                        limit = -1,
                        type = "item_weapon",
                        name = weapons[key].name,
                        usable = false,
                        rare = false,
                        canRemove = false
                    }
                )
            end
        end
    end

    SendNUIMessage(
        {
            action = "setSecondInventoryItems",
            itemList = items
        }
    )
end

function openTrunkInventory()
    StartScreenEffect(blur, 1, true)
    loadPlayerInventory()
    isInInventory = true
    SendNUIMessage(
        {
            action = "display",
            type = "trunk"
        }
    )
    SetNuiFocus(true, true)
end