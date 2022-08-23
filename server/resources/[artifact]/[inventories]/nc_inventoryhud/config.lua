Config                      = {}
Config.Locale               = "en"
Config.IncludeCash          = true -- แสดงเงินในกระเป๋า
Config.IncludeAccounts      = true -- แสดง เงินแดง ในกระเป๋า
Config.IncludeWeapons       = true -- แสดง Weapons ในกระเป๋า
Config.ExcludeAccountsList  = {'bank'}   -- List of accounts names to exclude from inventory
Config.OpenControl          = 289  -- Key ในการเปิดกระเป๋า
Config.EnableVehicleKey     = true -- คุณแจรถในกระเป๋า
Config.EnableHouseKey       = true -- คุณแจบ้านในกระเป๋า
Config.Items                = true

Config.Category = {
    ["inventory_food"] = {
        "water",    -- ใส่ชื่อไอเทม
        "bread",
    },
}
Config.Options = { -- อนิเมชั่นใส่ถอดเสือผ้า
    enabled = true, -- true = เปิดใช้งานอนิเมชั่นใส่เสือผ้า
    dicton = "clothingtie",
    animon = "try_tie_positive_a",

    enabledoff = true, -- true = เปิดใช้งานอนิเมชั่นถอดเสือผ้า
    dictoff = "clothingtie",
    animoff = "try_tie_positive_a"

}

Config.CloseUiItems = { -- เวลาใช้ของปิดกระเป๋าเอง
	'gacha_01',
	'gacha_02',
	'gacha_03',
	'fixkit',
	'7K_RESKIN',
	'radio',
	'lettucecut',
	'bread',
	'water',
	'seller',
	'mining_lease',
	'bottle_oil',
	'tool_iron',
	'hatchet_lj',
	'beer',
	'scuba_gear',
	'scuba_oxygen_tank',
	'snorkelling_gear',
	'blue'
}

Config.disableDrop          = -- ปิดกระดอป Item
{
    -- Weapons
    WEAPON_BAT 			= true,
    WEAPON_GOLFCLUB 	= true,
	WEAPON_KNUCKLE 		= true,
    WEAPON_FLASHLIGHT 	= true,
    WEAPON_NIGHTSTICK 	= true,
	WEAPON_HAMMER 		= true,
	WEAPON_MACHETE 		= true,
	WEAPON_BOTTLE 		= true,
	WEAPON_STUNGUN 		= true,
	WEAPON_SWITCHBLADE 	= true,
    WEAPON_POOLCUE 		= true,
    
    -- Item
	marijuana 				= true,
	cement 				= true,
	coin_gang 				= true,
	coin_ganglv2 				= true,
	card_back 				= true,
}

Config.disableGive          = -- ปิดการ Give Item
{
    -- Weapons
    WEAPON_BAT 			= true,
    WEAPON_GOLFCLUB 	= true,
	WEAPON_KNUCKLE 		= true,
    WEAPON_FLASHLIGHT 	= true,
    WEAPON_NIGHTSTICK 	= true,
	WEAPON_HAMMER 		= true,
	WEAPON_MACHETE 		= true,
	WEAPON_BOTTLE 		= true,
	WEAPON_STUNGUN 		= true,
	WEAPON_SWITCHBLADE 	= true,
    WEAPON_POOLCUE 		= true,
	coin_gang 		     = true,
	coin_ganglv2 		 = true,
	card_back 			 = true,
	sad                  = true,

}

Config.disablePutTrunk       = -- ห้ามเอาของเข้ารถ Item
{
    -- Weapons
    WEAPON_BAT 			= true,
    WEAPON_GOLFCLUB 	= true,
	WEAPON_KNUCKLE 		= true,
    WEAPON_FLASHLIGHT 	= true,
    WEAPON_NIGHTSTICK 	= true,
	WEAPON_HAMMER 		= true,
	WEAPON_MACHETE 		= true,
	WEAPON_BOTTLE 		= true,
	WEAPON_STUNGUN 		= true,
	WEAPON_SWITCHBLADE 	= true,
    WEAPON_POOLCUE 		= true,
    
    -- Item
	coin_gang 		= true,
	coin_ganglv2 				= true,
	card_back 				= true,
}

Config.disablePutIntoHouse       = -- ห้ามเอาของเข้ารถ House
{
    -- Weapons
    WEAPON_BAT 			= true,
    WEAPON_GOLFCLUB 	= true,
	WEAPON_KNUCKLE 		= true,
    WEAPON_FLASHLIGHT 	= true,
    WEAPON_NIGHTSTICK 	= true,
	WEAPON_HAMMER 		= true,
	WEAPON_MACHETE 		= true,
	WEAPON_BOTTLE 		= true,
	WEAPON_STUNGUN 		= true,
	WEAPON_SWITCHBLADE 	= true,
    WEAPON_POOLCUE 		= true,
    
    -- Item
	cement 				= true,
}

Config.disablePutIntoVault       = -- ห้ามเอาของเข้ารถ Vault
{
    -- Weapons
    WEAPON_BAT 			= true,
    WEAPON_GOLFCLUB 	= true,
	WEAPON_KNUCKLE 		= true,
    WEAPON_FLASHLIGHT 	= true,
    WEAPON_NIGHTSTICK 	= true,
	WEAPON_HAMMER 		= true,
	WEAPON_MACHETE 		= true,
	WEAPON_BOTTLE 		= true,
	WEAPON_STUNGUN 		= true,
	WEAPON_SWITCHBLADE 	= true,
    WEAPON_POOLCUE 		= true,
    
    -- Item
	cement 				= true,
}

Config.BlacklistVault = { --บล็อกของตู้เซฟ
    "card_back",


}