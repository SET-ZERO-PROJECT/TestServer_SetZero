--[[

  ESX RP Chat

--]]

ESX = nil
local holfz_ooc_playerlist = {}

TriggerEvent(
  "esx:getSharedObject",
  function(obj)
    ESX = obj
  end
)

function getIdentity(source)
	local identifier = GetPlayerIdentifiers(source)[1]
	local result = MySQL.Sync.fetchAll("SELECT * FROM users WHERE identifier = @identifier", {['@identifier'] = identifier})
	if result[1] ~= nil then
		local identity = result[1]

		return {
			identifier = identity['identifier'],
			firstname = identity['firstname'],
			lastname = identity['lastname'],
			dateofbirth = identity['dateofbirth'],
			sex = identity['sex'],
			height = identity['height']
			
		}
	else
		return nil
	end
end
  
-- TriggerEvent('es:addCommand', 'me', function(source, args, user)
--    local name = getIdentity(source)
--    TriggerClientEvent("sendProximityMessageMe", -1, source, name.firstname, table.concat(args, " "))
-- end) 



  --- TriggerEvent('es:addCommand', 'me', function(source, args, user)
  ---    local name = getIdentity(source)
  ---    TriggerClientEvent("sendProximityMessageMe", -1, source, name.firstname, table.concat(args, " "))
  -- end) 
  TriggerEvent('es:addCommand', 'me', function(source, args, user)
    local name = getIdentity(source)
    table.remove(args, 2)
    TriggerClientEvent('esx-qalle-chat:me', -1, source, name.firstname, table.concat(args, " "))
end)

--[[
 RegisterCommand('tweet', function(source, args, rawCommand)
    local playerName = GetPlayerName(source)
    local msg = rawCommand:sub(6)
    local name = getIdentity(source)
    fal = name.firstname .. " " .. name.lastname
    TriggerClientEvent('chat:addMessage', -1, {
        template = '<div style="padding: 0.5vw; margin: 0.5vw; background-color: rgba(28, 160, 242, 0.6); border-radius: 3px;"><i class="fab fa-twitter"></i> @{0} ได้ทวีต:<br> {1}</div>',
        args = { fal, msg }
    })
end, false)

 RegisterCommand('anontweet', function(source, args, rawCommand)
    local playerName = GetPlayerName(source)
    local msg = rawCommand:sub(11)
    local name = getIdentity(source)
    fal = name.firstname .. " " .. name.lastname
    TriggerClientEvent('chat:addMessage', -1, {
        template = '<div style="padding: 0.5vw; margin: 0.5vw; background-color: rgba(28, 160, 242, 0.6); border-radius: 3px;"><i class="fab fa-twitter"></i> @Anonymous:<br> {1}</div>',
        args = { fal, msg }
    })
end, false)
]]
RegisterCommand('ad', function(source, args, rawCommand)
    local playerName = GetPlayerName(source)
    local msg = rawCommand:sub(4)
    local name = getIdentity(source)
    TriggerClientEvent('chat:addMessage', -1, {
        template = '<div style="padding: 0.5vw; margin: 0.5vw; background-color: rgba(0, 0, 0, 1); border-radius: 3px;"><i class="fas fa-ad"></i>ประกาศจากนายก:<br> {1}<br></div>',
        args = { fal, msg }
    })
end, false)

RegisterCommand('pd', function(source, args, rawCommand)
    local playerName = GetPlayerName(source)
    local msg = rawCommand:sub(4)
    local name = getIdentity(source)
    TriggerClientEvent('chat:addMessage', -1, {
        template = '<div style="padding: 0.5vw; margin: 0.5vw; background-color: rgba(0, 0, 255, 1); border-radius: 3px;"><i class="fas fa-ad"></i>ประกาศจากสำนักงานตำรวจ Asgard:<br> {1}<br></div>',
        args = { fal, msg }
    })
end, false)

RegisterCommand('md', function(source, args, rawCommand)
    local playerName = GetPlayerName(source)
    local msg = rawCommand:sub(4)
    local name = getIdentity(source)
    TriggerClientEvent('chat:addMessage', -1, {
        template = '<div style="padding: 0.5vw; margin: 0.5vw; background-color: rgba(238, 130, 238, 1); border-radius: 3px;"><i class="fas fa-ad"></i>ประกาศจากหมอ:<br> {1}<br></div>',
        args = { fal, msg }
    })
end, false)

RegisterCommand('me', function(source, args, rawCommand)
    local playerName = GetPlayerName(source)
    local msg = rawCommand:sub(4)
    local name = getIdentity(source)
    TriggerClientEvent('chat:addMessage', -1, {
        template = '<div style="padding: 0.5vw; margin: 0.5vw; background-color: rgba(255, 0, 0, 1); border-radius: 3px;"><i class="fas fa-tools"></i>ประกาศจากช่าง :<br> {1}<br></div>',
        args = { fal, msg }
    })
end, false)

RegisterCommand('ooc', function(source, args, rawCommand)
    local playerName = GetPlayerName(source)
    local msg = rawCommand:sub(5)
    local name = getIdentity(source)
	
	local isFound = false
	local _source = source
	if playerName ~= " " or playerName ~= nil or playerName ~= "" then
		for _,v in pairs(holfz_ooc_playerlist) do
			if(name["identifier"] == v.steam) then
				isFound = true
				break
			end	
		end
	else
		isFound = true
	end

	if(isFound == false) then
		--add
		TriggerClientEvent("chatMessage", source, "[OOC]", {0, 255, 0}, " OOC Chat Enabled")
		local nameisfound = false
		for _,v in pairs(holfz_ooc_playerlist) do
			if(name["identifier"] == v.steam) then
				if(source == v.id) then
					nameisfound = true
					break
				else
					for i=1, #holfz_ooc_playerlist, 1 do
						if holfz_ooc_playerlist[i].steam == name["identifier"] then
							if holfz_ooc_playerlist[i].steam ~= " " or name["identifier"] ~= " " or holfz_ooc_playerlist[i].steam ~= nil or name["identifier"] ~= nil or holfz_ooc_playerlist[i].steam ~= "" or name["identifier"] ~= "" then
								table.remove(holfz_ooc_playerlist, i)
								break
							end
						end
					end
					nameisfound = false
					break
				end
			end		
		end
		if not nameisfound then
			table.insert(holfz_ooc_playerlist, {steam = name["identifier"], id = source})
		end
	elseif(isFound == true) then
		--remove
		TriggerClientEvent("chatMessage", source, "[OOC]", {255, 0, 0}, " OOC Chat Disable")
		for i=1, #holfz_ooc_playerlist, 1 do
			if holfz_ooc_playerlist[i].steam == name["identifier"] then
				if holfz_ooc_playerlist[i].steam ~= " " or name["identifier"] ~= " " or holfz_ooc_playerlist[i].steam ~= nil or name["identifier"] ~= nil or holfz_ooc_playerlist[i].steam ~= "" or name["identifier"] ~= "" then
					table.remove(holfz_ooc_playerlist, i)
					break
				end
			end
		end
	end
end, false)

AddEventHandler('chatMessage', function(source, playername, message)
	local isFound = false
	local _source = source
	local name = getIdentity(source)
	
	if name["identifier"] ~= " " or name["identifier"] ~= nil or name["identifier"] ~= "" then
		for _,v in pairs(holfz_ooc_playerlist) do
			if(name["identifier"] == v.steam) then
				isFound = true
				break
			end
		end
	else
		isFound = true
	end
	
	if(isFound == true) then
		if(string.sub(message, 1, 1) ~= "/") then
			local fal = name.firstname .. " " .. name.lastname
			for _,v in pairs(holfz_ooc_playerlist) do
				TriggerClientEvent('chat:addMessage', v.id, {
					template = '<div style="padding: 0.5vw; margin: 0.5vw; background-color: rgba(41, 41, 41, 0.6); border-radius: 3px;"><i class="fas fa-globe"></i> {0}:<br> {1}</div>',
					args = { fal, message }
				})
			end
		end
	end
end)

function dump(o)
   if type(o) == 'table' then
      local s = '{ '
      for k,v in pairs(o) do
         if type(k) ~= 'number' then k = '"'..k..'"' end
         s = s .. '['..k..'] = ' .. dump(v) .. ','
      end
      return s .. '} '
   else
      return tostring(o)
   end
end

function stringsplit(inputstr, sep)
	if sep == nil then
		sep = "%s"
	end
	local t={} ; i=1
	for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
		t[i] = str
		i = i + 1
	end
	return t
end
