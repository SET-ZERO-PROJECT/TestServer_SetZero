local Keys = {
    ["ESC"] = 322, ["F1"] = 288, ["F2"] = 289, ["F3"] = 170, ["F5"] = 166, ["F6"] = 167, ["F7"] = 168, ["F8"] = 169, ["F9"] = 56, ["F10"] = 57,["~"] = 243, 
    ["1"] = 157, ["2"] = 158, ["3"] = 160, ["4"] = 164, ["5"] = 165, ["6"] = 159, ["7"] = 161, ["8"] = 162, ["9"] = 163, ["-"] = 84, ["="] = 83, ["BACKSPACE"] = 177,
	["TAB"] = 37, ["Q"] = 44, ["W"] = 32, ["E"] = 38, ["R"] = 45, ["T"] = 245, ["Y"] = 246, ["U"] = 303, ["P"] = 199, ["["] = 39, ["]"] = 40, ["ENTER"] = 18,
    ["CAPS"] = 137, ["A"] = 34, ["S"] = 8, ["D"] = 9, ["F"] = 23, ["G"] = 47, ["H"] = 74, ["K"] = 311, ["L"] = 182,["LEFTSHIFT"] = 21, ["Z"] = 20, ["X"] = 73, ["C"] = 26, 
    ["V"] = 0, ["B"] = 29, ["N"] = 249, ["M"] = 244, [","] = 82, ["."] = 81,["LEFTCTRL"] = 36, ["LEFTALT"] = 19, ["SPACE"] = 22, ["RIGHTCTRL"] = 70,["HOME"] = 213, 
    ["PAGEUP"] = 10, ["PAGEDOWN"] = 11, ["DELETE"] = 178,["LEFT"] = 174, ["RIGHT"] = 175, ["TOP"] = 27, ["DOWN"] = 173,["NENTER"] = 201, ["N4"] = 108, ["N5"] = 60, 
    ["N6"] = 107, ["N+"] = 96, ["N-"] = 97, ["N7"] = 117, ["N8"] = 61, ["N9"] = 118
}

isInInventory       = false
ESX                 = nil
local blur = "MenuMGIn"

Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent("esx:getSharedObject",function(obj)ESX = obj end)
        Citizen.Wait(0)
    end
    SetNuiFocus(false,false)
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        if IsControlJustReleased(0, Config["OpenControl"]) and IsInputDisabled(0) then
            openInventory()
        end
    end
end)

function closeInventory()
    StopScreenEffect(blur)
    isInInventory = false
    SendNUIMessage(
        {
            action = "hide"
        }
    )
    SetNuiFocus(false, false)
    -- TriggerEvent('meeta_carinventory:setOpenMenu', false)
end

RegisterNUICallback("NUIFocusOff",function()
    closeInventory()
end)

RegisterNUICallback("GetNearPlayers",function(data, cb)
    local playerPed = PlayerPedId()
    local players, nearbyPlayer = ESX.Game.GetPlayersInArea(GetEntityCoords(playerPed), 3.0)
    local foundPlayers = false
    local elements = {}

    for i = 1, #players, 1 do
        if players[i] ~= PlayerId() then
            foundPlayers = true
            table.insert(
                elements,
                {
                    player = GetPlayerServerId(players[i])
                }
            )
        end
    end

    if not foundPlayers then
        exports.pNotify:SendNotification(
            {
                text = '<strong class="red-text">ผู้เล่นอยู่ไกลเกินไป</strong>',
                type = "error",
                timeout = 3000,
                layout = "bottomCenter",
                queue = "inventoryhud"
            }
        )
    else
        SendNUIMessage(
            {
                action = "nearPlayers",
                foundAny = foundPlayers,
                players = elements,
                item = data.item
            }
        )
    end
    cb("ok")
end)

RegisterNUICallback("GetNearPlayersPolice", function(data, cb)
    local playerPed = PlayerPedId()
    local players, nearbyPlayer = ESX.Game.GetPlayersInArea(GetEntityCoords(playerPed), 1.0)
    local foundPlayers = false
    local elements = {}
    for i = 1, #players, 1 do
        if players[i] ~= PlayerId() then
            foundPlayers = true
			table.insert(
				elements,
			    {
				label = GetPlayerName(players[i]),
				player = GetPlayerServerId(players[i])
			    }
		    )
        end
    end

    if not foundPlayers then
        exports.pNotify:SendNotification(
            {
                text = '<strong class="red-text">ผู้เล่นอยู่ไกลเกินไป</strong>',
                type = "error",
                timeout = 3000,
                layout = "bottomCenter",
                queue = "inventoryhud"
            }
        )
    else
        SendNUIMessage(
            {
                action = "nearPlayers",
                foundAny = foundPlayers,
                players = elements,
                item = data.item
            }
        )
    end
    cb("ok")
end)

RegisterNUICallback("SetCurrentMenu", function(type, cb)
    local Value = type.type or 'inventory_all'
    Current_Menu = Value
    cb("ok")
end)

RegisterNUICallback(
    "UseItem",
    function(data, cb)
	
	    if data.item.type == "item_key" then
			TriggerEvent("shiba-invenkeys:usekey", data.item.label)
			TriggerEvent("meeta_remote:usekey", data.item.label)

            closeInventory()
			
        elseif data.item.type == "item_accessories" then
            local player = GetPlayerPed(-1)
            closeInventory()
            --หมวก
            if data.item.name == "helmet" then
                TriggerEvent('skinchanger:getSkin', function(skin)
                    if skin["helmet_1"] == -1 then
                        local dict = "veh@bicycle@roadfront@base"
                        local anim = "put_on_helmet"
            
                        RequestAnimDict(dict)
                        while (not HasAnimDictLoaded(dict)) do Citizen.Wait(0) end
                        
                        TaskPlayAnim(player, dict, anim, 8.0, 2.0, -1, 48, 2, 0, 0, 0 )
            
                        Wait(1000)
    
                        local accessorySkin = {}
                        accessorySkin['helmet_1'] = data.item.itemnum
                        accessorySkin['helmet_2'] = data.item.itemskin
    
                        TriggerEvent('skinchanger:loadClothes', skin, accessorySkin)
                        ClearPedTasks(player)
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
                        ClearPedTasks(player)
                    end
                    
                end)
            --หน้ากาก
            elseif data.item.name == "mask" then
                TriggerEvent('skinchanger:getSkin', function(skin)
                    if skin["mask_1"] == -1 then
    
                        local dict = "veh@bicycle@roadfront@base"
                        local anim = "put_on_helmet"
            
                        RequestAnimDict(dict)
                        while (not HasAnimDictLoaded(dict)) do Citizen.Wait(0) end
                        
                        TaskPlayAnim(player, dict, anim, 8.0, 2.0, -1, 48, 2, 0, 0, 0 )
            
                        Wait(1000)
    
                        local accessorySkin = {}
                        accessorySkin['mask_1'] = data.item.itemnum
                        accessorySkin['mask_2'] = data.item.itemskin
                        TriggerEvent('skinchanger:loadClothes', skin, accessorySkin)
                        ClearPedTasks(player)
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
                        ClearPedTasks(player)
                    end
                    
                end)
            --แวนตา
            elseif data.item.name == "glasses" then
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
                        accessorySkin['glasses_1'] = data.item.itemnum
                        accessorySkin['glasses_2'] = data.item.itemskin
                        TriggerEvent('skinchanger:loadClothes', skin, accessorySkin)
                        ClearPedTasks(player)
    
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
                        ClearPedTasks(player)
                    end
                    
                end)
            
            --ตางหู		  
            elseif data.item.name == "earring" then
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
                        accessorySkin['ears_1'] = data.item.itemnum
                        accessorySkin['ears_2'] = data.item.itemskin
                        TriggerEvent('skinchanger:loadClothes', skin, accessorySkin)
                        ClearPedTasks(player)
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
                        ClearPedTasks(player)
                    end
                end)
 
            elseif data.item.name == "tshirt" then
                TriggerEvent('skinchanger:getSkin', function(skin)
    
                    if skin["tshirt_1"] == -1 then
    
                    if Config.Options.enabled and IsPedInAnyVehicle(PlayerPedId(), true) == false then
                        RequestAnimDict(Config.Options.dicton)
                        while (not HasAnimDictLoaded(Config.Options.dicton)) do Citizen.Wait(0) end
                        TaskPlayAnim(player, Config.Options.dicton, Config.Options.animon, 8.0, 1.0, -1, 0, 0.5, 0, 0)
                        Wait(2000)
                    end
    
                    local accessorySkin = {}
                    accessorySkin['tshirt_1']  = data.item.itemnum
                    accessorySkin['tshirt_2']  = data.item.itemskin
                    TriggerEvent('skinchanger:loadClothes', skin, accessorySkin)
                    TriggerEvent("pNotify:SendNotification", {
                        text = Config.Text.pantson,
                        type = "success",
                        timeout = 2000,
                        layout = "bottomCenter",
                        queue = "global"
                    })
           
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
                    TriggerEvent("pNotify:SendNotification", {
                        text = Config.Text.pantson,
                        type = "success",
                        timeout = 2000,
                        layout = "bottomCenter",
                        queue = "global"
                    })

                end
                
            end)
            -- Torso
            elseif data.item.name == "torso" then
                TriggerEvent('skinchanger:getSkin', function(skin)
    
                    if skin["torso_1"] == -1 then
    
                    if Config.Options.enabled and IsPedInAnyVehicle(PlayerPedId(), true) == false then
                        RequestAnimDict(Config.Options.dicton)
                        while (not HasAnimDictLoaded(Config.Options.dicton)) do Citizen.Wait(0) end
                        TaskPlayAnim(player, Config.Options.dicton, Config.Options.animon, 8.0, 1.0, -1, 0, 0.5, 0, 0)
                        Wait(2000)
                    end
    
                    local accessorySkin = {}
                    accessorySkin['torso_1']   = data.item.itemnum
                    accessorySkin['torso_2']   = data.item.itemskin
                    TriggerEvent('skinchanger:loadClothes', skin, accessorySkin) 
                    TriggerEvent("pNotify:SendNotification", {
                        text = Config.Text.pantson,
                        type = "success",
                        timeout = 2000,
                        layout = "bottomCenter",
                        queue = "global"
                    })            
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
                     TriggerEvent("pNotify:SendNotification", {
                            text = Config.Text.pantson,
                            type = "success",
                            timeout = 2000,
                            layout = "bottomCenter",
                            queue = "global"
                        })
         
                end
                
            end)
            -- arms
        elseif data.item.name == "arms" then
            TriggerEvent('skinchanger:getSkin', function(skin)
    
                if skin["arms"] == 15 then
    
                if Config.Options.enabled and IsPedInAnyVehicle(PlayerPedId(), true) == false then
                    RequestAnimDict(Config.Options.dicton)
                    while (not HasAnimDictLoaded(Config.Options.dicton)) do Citizen.Wait(0) end
                    TaskPlayAnim(player, Config.Options.dicton, Config.Options.animon, 8.0, 1.0, -1, 0, 0.5, 0, 0)
                    Wait(2000)
                end
    
                local accessorySkin = {}
                accessorySkin['arms']   = data.item.itemnum
                accessorySkin['arms_2']   = data.item.itemskin
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
                 TriggerEvent("pNotify:SendNotification", {
                            text = Config.Text.pantson,
                            type = "success",
                            timeout = 2000,
                            layout = "bottomCenter",
                            queue = "global"
                        })
     
            end       
        end)
            --กางเกง
            elseif data.item.name == "pants" then
                TriggerEvent('skinchanger:getSkin', function(skin)
                    if skin["pants_1"] == 21 then
    
                        if Config.Options.enabled and IsPedInAnyVehicle(PlayerPedId(), true) == false then
                            RequestAnimDict(Config.Options.dicton)
                            while (not HasAnimDictLoaded(Config.Options.dicton)) do Citizen.Wait(0) end
                            TaskPlayAnim(player, Config.Options.dicton, Config.Options.animon, 8.0, 1.0, -1, 0, 0.5, 0, 0)
                            Wait(2000)
                        end
    
                        local accessorySkin = {}
                        accessorySkin['pants_1'] = data.item.itemnum
                        accessorySkin['pants_2'] = data.item.itemskin
                        skin['pants_1'] = data.item.itemnum
                        skin['pants_2'] = data.item.itemskin
                        TriggerEvent('skinchanger:loadClothes', skin, accessorySkin)
                        TriggerServerEvent('esx_skin:save', skin)
                        ClearPedTasks(player)
                        TriggerEvent("pNotify:SendNotification", {
                            text = Config.Text.pantson,
                            type = "success",
                            timeout = 2000,
                            layout = "bottomCenter",
                            queue = "global"
                        })
    
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
                        TriggerServerEvent('esx_skin:save', skin)
                        ClearPedTasks(player)
                        TriggerEvent("pNotify:SendNotification", {
                            text = Config.Text.pantsoff,
                            type = "error",
                            timeout = 2000,
                            layout = "bottomCenter",
                            queue = "global"
                        })
                    end
                    
                end)
            --รองเท้า
            elseif data.item.name == "shoes" then
                TriggerEvent('skinchanger:getSkin', function(skin)
                    if skin["shoes_1"] == 34 then
    
                        if Config.Options.enabled and IsPedInAnyVehicle(PlayerPedId(), true) == false then
                            RequestAnimDict(Config.Options.dicton)
                            while (not HasAnimDictLoaded(Config.Options.dicton)) do Citizen.Wait(0) end
                            TaskPlayAnim(player, Config.Options.dicton, Config.Options.animon, 8.0, 1.0, -1, 0, 0.5, 0, 0)
                            Wait(2000)
                        end
    
                        local accessorySkin = {}
                        accessorySkin['shoes_1'] = data.item.itemnum
                        accessorySkin['shoes_2'] = data.item.itemskin
                        skin['shoes_1'] = data.item.itemnum
                        skin['shoes_2'] = data.item.itemskin
                        TriggerEvent('skinchanger:loadClothes', skin, accessorySkin)
                        TriggerServerEvent('esx_skin:save', skin)
                        ClearPedTasks(player)
                        TriggerEvent("pNotify:SendNotification", {
                            text = Config.Text.shoeson,
                            type = "success",
                            timeout = 2000,
                            layout = "bottomCenter",
                            queue = "global"
                        })
    
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
                        TriggerServerEvent('esx_skin:save', skin)
                        ClearPedTasks(player)
                        TriggerEvent("pNotify:SendNotification", {
                            text = Config.Text.shoesoff,
                            type = "error",
                            timeout = 2000,
                            layout = "bottomCenter",
                            queue = "global"
                        })
                    end
                end)
            --กระเป๋า
            elseif data.item.name == "bags" then
                TriggerEvent('skinchanger:getSkin', function(skin)
                    if skin["bags_1"] == -1 then
    
                        if IsPedInAnyVehicle(PlayerPedId(), true) == false then
                            local dict = "mp_safehouseshower@male@"
                            local anim = "male_shower_undress_&_turn_on_water"
                
                            RequestAnimDict(dict)
                            while (not HasAnimDictLoaded(dict)) do Citizen.Wait(0) end
                            
                            TaskPlayAnim(player, dict, anim, 8.0, 1.0, -1, 0, 0.3, 0, 0 )
                
                            Wait(800)
                        end
    
                        local accessorySkin = {}
                        accessorySkin['bags_1'] = data.item.itemnum
                        accessorySkin['bags_2'] = data.item.itemskin
                        TriggerEvent('skinchanger:loadClothes', skin, accessorySkin)
                        ClearPedTasks(player)
                    else
    
                        if IsPedInAnyVehicle(PlayerPedId(), true) == false then
                            local dict = "mp_safehouseshower@male@"
                            local anim = "male_shower_undress_&_turn_on_water"
                
                            RequestAnimDict(dict)
                            while (not HasAnimDictLoaded(dict)) do Citizen.Wait(0) end
                            
                            TaskPlayAnim(player, dict, anim, 8.0, 1.0, -1, 0, 0.3, 0, 0 )
                
                            Wait(800)
                        end
    
                        local accessorySkin = {}
                        accessorySkin['bags_1'] = -1
                        accessorySkin['bags_2'] = 0
                        TriggerEvent('skinchanger:loadClothes', skin, accessorySkin)
                        ClearPedTasks(player)
                    end
              end)
			elseif data.item.name == "bproof" then
                TriggerEvent('skinchanger:getSkin', function(skin)
                    if skin["bproof_1"] == -1 then
                        if Config.Options.enabled and IsPedInAnyVehicle(PlayerPedId(), true) == false then
                            RequestAnimDict(Config.Options.dicton)
                            while (not HasAnimDictLoaded(Config.Options.dicton)) do Citizen.Wait(0) end
                            TaskPlayAnim(player, Config.Options.dicton, Config.Options.animon, 8.0, 1.0, -1, 0, 0.5, 0, 0)
                            Wait(2000)
                        end
    
                        local accessorySkin = {}
                        accessorySkin['bproof_1']   = data.item.itemnum
                        accessorySkin['bproof_2']   = data.item.itemskin
                        skin['bproof_1']            = data.item.itemnum
                        skin['bproof_2']            = data.item.itemskin
    
                        TriggerEvent('skinchanger:loadClothes', skin, accessorySkin)
                        TriggerServerEvent('esx_skin:save', skin)              
                        TriggerEvent("pNotify:SendNotification", {
                            text = Config.Text.torsoon,
                            type = "success",
                            timeout = 2000,
                            layout = "bottomCenter",
                            queue = "global"
                        })
    
                        ClearPedTasks(player)
                    else
    
                        if Config.Options.enabledoff and IsPedInAnyVehicle(PlayerPedId(), true) == false then
                            RequestAnimDict(Config.Options.dictoff)
                            while (not HasAnimDictLoaded(Config.Options.dictoff)) do Citizen.Wait(0) end
                            TaskPlayAnim(player, Config.Options.dictoff, Config.Options.animoff, 8.0, 1.0, -1, 0, 0.3, 0, 0)
                            Wait(2000)
                        end
    
                        local accessorySkin = {}
                        accessorySkin['bproof_1'] = -1
                        accessorySkin['bproof_2'] = 0
    
                        TriggerEvent('skinchanger:loadClothes', skin, accessorySkin)
                        TriggerServerEvent('esx_skin:save', skin)
                        TriggerEvent("pNotify:SendNotification", {
                            text = Config.Text.torsooff,
                            type = "error",
                            timeout = 2000,
                            layout = "bottomCenter",
                            queue = "global"
                        })
                        ClearPedTasks(player)
                    end
                end)
            -- สร้อยคอ
            elseif data.item.name == "chain" then
                TriggerEvent('skinchanger:getSkin', function(skin)
                    if skin["chain_1"] == -1 then
                        if Config.Options.enabled and IsPedInAnyVehicle(PlayerPedId(), true) == false then
                            RequestAnimDict(Config.Options.dicton)
                            while (not HasAnimDictLoaded(Config.Options.dicton)) do Citizen.Wait(0) end
                            TaskPlayAnim(player, Config.Options.dicton, Config.Options.animon, 8.0, 1.0, -1, 0, 0.5, 0, 0)
                            Wait(2000)
                        end
    
                        local accessorySkin = {}
                        accessorySkin['chain_1']   = data.item.itemnum
                        accessorySkin['chain_2']   = data.item.itemskin
                        skin['chain_1']            = data.item.itemnum
                        skin['chain_2']            = data.item.itemskin
    
                        TriggerEvent('skinchanger:loadClothes', skin, accessorySkin)
                        TriggerServerEvent('esx_skin:save', skin)              
                        TriggerEvent("pNotify:SendNotification", {
                            text = Config.Text.torsoon,
                            type = "success",
                            timeout = 2000,
                            layout = "bottomCenter",
                            queue = "global"
                        })
    
                        ClearPedTasks(player)
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
                        TriggerServerEvent('esx_skin:save', skin)
                        TriggerEvent("pNotify:SendNotification", {
                            text = Config.Text.torsooff,
                            type = "error",
                            timeout = 2000,
                            layout = "bottomCenter",
                            queue = "global"
                        })
                        ClearPedTasks(player)
                    end
                end)
            -- นาฬิกาข้อมือ
            elseif data.item.name == "watches" then
                TriggerEvent('skinchanger:getSkin', function(skin)
                    if skin["watches_1"] == -1 then
                        if Config.Options.enabled and IsPedInAnyVehicle(PlayerPedId(), true) == false then
                            RequestAnimDict(Config.Options.dicton)
                            while (not HasAnimDictLoaded(Config.Options.dicton)) do Citizen.Wait(0) end
                            TaskPlayAnim(player, Config.Options.dicton, Config.Options.animon, 8.0, 1.0, -1, 0, 0.5, 0, 0)
                            Wait(2000)
                        end
    
                        local accessorySkin = {}
                        accessorySkin['watches_1']   = data.item.itemnum
                        accessorySkin['watches_2']   = data.item.itemskin
                        skin['watches_1']            = data.item.itemnum
                        skin['watches_2']            = data.item.itemskin
    
                        TriggerEvent('skinchanger:loadClothes', skin, accessorySkin)
                        TriggerServerEvent('esx_skin:save', skin)              
                        TriggerEvent("pNotify:SendNotification", {
                            text = Config.Text.torsoon,
                            type = "success",
                            timeout = 2000,
                            layout = "bottomCenter",
                            queue = "global"
                        })
    
                        ClearPedTasks(player)
                    else
    
                        if Config.Options.enabledoff and IsPedInAnyVehicle(PlayerPedId(), true) == false then
                            RequestAnimDict(Config.Options.dictoff)
                            while (not HasAnimDictLoaded(Config.Options.dictoff)) do Citizen.Wait(0) end
                            TaskPlayAnim(player, Config.Options.dictoff, Config.Options.animoff, 8.0, 1.0, -1, 0, 0.3, 0, 0)
                            Wait(2000)
                        end
    
                        local accessorySkin = {}
                        accessorySkin['watches_1'] = -1
                        accessorySkin['watches_2'] = 0
    
                        TriggerEvent('skinchanger:loadClothes', skin, accessorySkin)
                        TriggerServerEvent('esx_skin:save', skin)
                        TriggerEvent("pNotify:SendNotification", {
                            text = Config.Text.torsooff,
                            type = "error",
                            timeout = 2000,
                            layout = "bottomCenter",
                            queue = "global"
                        })
                        ClearPedTasks(player)
                    end
                end)
            -- สร้อยข้อมือ
            elseif data.item.name == "bracelets" then
                TriggerEvent('skinchanger:getSkin', function(skin)
                    if skin["bracelets_1"] == -1 then
                        if Config.Options.enabled and IsPedInAnyVehicle(PlayerPedId(), true) == false then
                            RequestAnimDict(Config.Options.dicton)
                            while (not HasAnimDictLoaded(Config.Options.dicton)) do Citizen.Wait(0) end
                            TaskPlayAnim(player, Config.Options.dicton, Config.Options.animon, 8.0, 1.0, -1, 0, 0.5, 0, 0)
                            Wait(2000)
                        end
    
                        local accessorySkin = {}
                        accessorySkin['bracelets_1']   = data.item.itemnum
                        accessorySkin['bracelets_2']   = data.item.itemskin
                        skin['bracelets_1']            = data.item.itemnum
                        skin['bracelets_2']            = data.item.itemskin
    
                        TriggerEvent('skinchanger:loadClothes', skin, accessorySkin)
                        TriggerServerEvent('esx_skin:save', skin)              
                        TriggerEvent("pNotify:SendNotification", {
                            text = Config.Text.torsoon,
                            type = "success",
                            timeout = 2000,
                            layout = "bottomCenter",
                            queue = "global"
                        })
    
                        ClearPedTasks(player)
                    else
                        if Config.Options.enabledoff and IsPedInAnyVehicle(PlayerPedId(), true) == false then
                            RequestAnimDict(Config.Options.dictoff)
                            while (not HasAnimDictLoaded(Config.Options.dictoff)) do Citizen.Wait(0) end
                            TaskPlayAnim(player, Config.Options.dictoff, Config.Options.animoff, 8.0, 1.0, -1, 0, 0.3, 0, 0)
                            Wait(2000)
                        end
    
                        local accessorySkin = {}
                        accessorySkin['bracelets_1'] = -1
                        accessorySkin['bracelets_2'] = 0
    
                        TriggerEvent('skinchanger:loadClothes', skin, accessorySkin)
                        TriggerServerEvent('esx_skin:save', skin)
                        TriggerEvent("pNotify:SendNotification", {
                            text = Config.Text.torsooff,
                            type = "error",
                            timeout = 2000,
                            layout = "bottomCenter",
                            queue = "global"
                        })
                        ClearPedTasks(player)
                    end
                end)
            end
        elseif data.item.name == 'id_card' then
            TriggerEvent('jsfour-idcard:id_card', source)
            closeInventory()
        elseif data.item.name == 'driver_license' then
            TriggerEvent('jsfour-idcard:dv_license', source)
            closeInventory()
        else
            TriggerServerEvent("esx:useItem", data.item.name)
            if ItemCloseInventory(data.item.name) then
                closeInventory()
            else	
                Citizen.Wait(500)
                loadPlayerInventory()
            end
        end
    cb("ok")
end)

RegisterNUICallback("DropItem",function(data, cb)
    if IsPedSittingInAnyVehicle(playerPed) then
        return
    end
    if Config.disableDrop and Config.disableDrop[data.item.name] then
        exports.pNotify:SendNotification(
            {
                text = "ไม่สามารถทิ้งของชิ้นนี้ได้",
                type = "error",
                timeout = 3000,
                layout = "centerLeft",
                queue = "inventoryhud"
            }
        )
        closeInventory()
    elseif type(data.number) == "number" and math.floor(data.number) == data.number then
        TriggerServerEvent("esx:removeInventoryItem", data.item.type, data.item.name, data.number)
        closeInventory()
    end
    cb("ok")
end)

RegisterNUICallback("GiveItem",function(data, cb)		
    local playerPed = PlayerPedId()
    local players, nearbyPlayer = ESX.Game.GetPlayersInArea(GetEntityCoords(playerPed), 3.0)
    local foundPlayer = false
    
    if Config.disableGive and Config.disableGive[data.item.name] then
        exports.pNotify:SendNotification(
            {
                text = "ไม่สามารถให้ของชิ้นนี้ได้",
                type = "error",
                timeout = 3000,
                layout = "centerLeft",
                queue = "inventoryhud"
            }
        )
        closeInventory()
        return
    end
    
    for i = 1, #players, 1 do
        if players[i] ~= PlayerId() then
            if GetPlayerServerId(players[i]) == data.player then
                foundPlayer = true
            end
        end
    end

    if foundPlayer then
        
        local count = tonumber(data.number)
        local health = GetEntityHealth(playerPed)
        if health >= 101 then
            if data.item.type == "item_weapon" then
                count = GetAmmoInPedWeapon(PlayerPedId(), GetHashKey(data.item.name))
            end
            
            if data.item.type == "item_key" then
                
                TriggerServerEvent("shiba-invenkeys:giveKey", data.player, data.item.type, data.item.label)
                TriggerServerEvent("esx_inventoryhud:updateKey", data.player, data.item.type, data.item.label)

                
            elseif data.item.type == "item_keyhouse" then
                TriggerServerEvent("esx_inventoryhud:updateKey", data.player, data.item.type, data.item.house_id)
            else
                TriggerEvent('xzero_giveui:client:On_GiveItem', data)
                TriggerServerEvent("esx:giveInventoryItem", data.player, data.item.type, data.item.name, count)
            end
            Wait(250)
            loadPlayerInventory()
        else
            exports.pNotify:SendNotification(
                {
                    text = '<strong class="red-text">ไม่สามารถเทรดของตอนตายได้นะจ๊ะ หนู หนู</strong>',
                    type = "error",
                    timeout = 3000,
                    layout = "bottomCenter",
                    queue = "inventoryhud"
                }
            )
        end
    else
        exports.pNotify:SendNotification(
            {
                text = '<strong class="red-text">ผู้เล่นอยู่ไกลเกินไป</strong>',
                type = "error",
                timeout = 3000,
                layout = "bottomCenter",
                queue = "inventoryhud"
            }
        )
    end
    cb("ok")
end)

RegisterNUICallback("UseMask",function(data, cb)
    if data.item.type == "item_accessories" then
        local player = GetPlayerPed(-1)

        closeInventory()
       
        if data.item.name == "helmet" then
            TriggerEvent('skinchanger:getSkin', function(skin)
                if skin["helmet_1"] == -1 then

                    local dict = "veh@bicycle@roadfront@base"
                    local anim = "put_on_helmet"
        
                    RequestAnimDict(dict)
                    while (not HasAnimDictLoaded(dict)) do Citizen.Wait(0) end
                    
                    TaskPlayAnim(player, dict, anim, 8.0, 2.0, -1, 48, 2, 0, 0, 0 )
        
                    Wait(1000)

                    local accessorySkin = {}
                    accessorySkin['helmet_1'] = data.item.itemnum
                    accessorySkin['helmet_2'] = data.item.itemskin

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
        elseif data.item.name == "mask" then
            TriggerEvent('skinchanger:getSkin', function(skin)
                if skin["mask_1"] == -1 then

                    local dict = "veh@bicycle@roadfront@base"
                    local anim = "put_on_helmet"
        
                    RequestAnimDict(dict)
                    while (not HasAnimDictLoaded(dict)) do Citizen.Wait(0) end
                    
                    TaskPlayAnim(player, dict, anim, 8.0, 2.0, -1, 48, 2, 0, 0, 0 )
        
                    Wait(1000)

                    local accessorySkin = {}
                    accessorySkin['mask_1'] = data.item.itemnum
                    accessorySkin['mask_2'] = data.item.itemskin
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
        elseif data.item.name == "glasses" then
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
                    accessorySkin['glasses_1'] = data.item.itemnum
                    accessorySkin['glasses_2'] = data.item.itemskin
                    TriggerEvent('skinchanger:loadClothes', skin, accessorySkin)

                    ClearPedTasks(player)
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
        elseif data.item.name == "earring" then
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
                    accessorySkin['ears_1'] = data.item.itemnum
                    accessorySkin['ears_2'] = data.item.itemskin
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
        end
    end
end)

function shouldSkipAccount(accountName)
    for index, value in ipairs(Config.ExcludeAccountsList) do
        if value == accountName then
            return true
        end
    end
    return false
end

RegisterNetEvent("esx_inventoryhud:closeHud")
AddEventHandler("esx_inventoryhud:closeHud",function()
    closeInventory()
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1)
        if isInInventory then
            local playerPed = PlayerPedId()
            DisableControlAction(0, 1, true) -- Disable pan
            DisableControlAction(0, 2, true) -- Disable tilt
            DisableControlAction(0, 24, true) -- Attack
            DisableControlAction(0, 257, true) -- Attack 2
            DisableControlAction(0, 25, true) -- Aim
            DisableControlAction(0, 263, true) -- Melee Attack 1
            DisableControlAction(0, Keys["W"], true) -- W
            DisableControlAction(0, Keys["A"], true) -- A
            DisableControlAction(0, 31, true) -- S (fault in Keys table!)
            DisableControlAction(0, 30, true) -- D (fault in Keys table!)
            DisableControlAction(0, Keys["R"], true) -- Reload
            DisableControlAction(0, Keys["SPACE"], true) -- Jump
            DisableControlAction(0, Keys["Q"], true) -- Cover
            DisableControlAction(0, Keys["TAB"], true) -- Select Weapon
            DisableControlAction(0, Keys["F"], true) -- Also 'enter'?
            DisableControlAction(0, Keys["F1"], true) -- Disable phone
            DisableControlAction(0, Keys["F2"], true) -- Inventory
            DisableControlAction(0, Keys["F3"], true) -- Animations
            DisableControlAction(0, Keys["F6"], true) -- Job
            DisableControlAction(0, Keys["V"], true) -- Disable changing view
            DisableControlAction(0, Keys["C"], true) -- Disable looking behind
            DisableControlAction(0, Keys["X"], true) -- Disable clearing animation
            DisableControlAction(2, Keys["P"], true) -- Disable pause screen
            DisableControlAction(0, 59, true) -- Disable steering in vehicle
            DisableControlAction(0, 71, true) -- Disable driving forward in vehicle
            DisableControlAction(0, 72, true) -- Disable reversing in vehicle
            DisableControlAction(2, Keys["LEFTCTRL"], true) -- Disable going stealth
            DisableControlAction(0, 47, true) -- Disable weapon
            DisableControlAction(0, 264, true) -- Disable melee
            DisableControlAction(0, 257, true) -- Disable melee
            DisableControlAction(0, 140, true) -- Disable melee
            DisableControlAction(0, 141, true) -- Disable melee
            DisableControlAction(0, 142, true) -- Disable melee
            DisableControlAction(0, 143, true) -- Disable melee
            DisableControlAction(0, 75, true) -- Disable exit vehicle
            DisableControlAction(27, 75, true) -- Disable exit vehicle
            DisableControlAction(0, 288, true) -- Disable exit vehicle
        end
    end
end)

AddEventHandler("esx_inventoryhud:closeInventory", function()
    closeInventory()
end) 

RegisterCommand('bags', function()
    TriggerEvent('esx_inventoryhud:closeInventory')
    exports.pNotify:SendNotification(
        {
            text = "You Close Inventory!!!!!",
            type = "success",
            timeout = 3000,
            layout = "bottomCenter"
        }
    )
end)

function ItemCloseInventory(itemName)
    for index, value in ipairs(Config.CloseUiItems) do
        if value == itemName then
            return true
        end
    end

    return false
end

RegisterNetEvent('esx_inventoryhud:closeInventory2')
AddEventHandler('esx_inventoryhud:closeInventory2', function()
    closeInventory()
end)