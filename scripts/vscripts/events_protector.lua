local allow_keys_reload = IsInToolsMode()
local client_keys = {}
local server_keys = {}
local load_listeners = {}
CustomGameEventManager.RegisterListener_old = CustomGameEventManager.RegisterListener
CustomGameEventManager.Send_ServerToPlayer_old = CustomGameEventManager.Send_ServerToPlayer

ListenToGameEvent("player_disconnect", function(data)
	local playerID = data.PlayerID
	if playerID == nil then
		return
	end
	client_keys[playerID] = nil
	server_keys[playerID] = nil
end, nil)

function RegisterLoadListener(listener)
	table.insert(load_listeners, listener)
	for playerID, _ in pairs(server_keys) do
		local player = PlayerResource:GetPlayer(tonumber(playerID))
		if player ~= nil then
			listener(player, playerID)
		end
	end
end

CustomGameEventManager:RegisterListener("ok", function(_, data)
	local playerID = data.PlayerID
	if playerID == nil or type(data.n) ~= "number" then
		return
	end
	local player = PlayerResource:GetPlayer(playerID)
	if player == nil then
		return
	end

	local server_key = server_keys[playerID]
	local trigger_load = false
	if server_key ~= nil then
		if not allow_keys_reload then
			return
		end
	else
		server_key = RandomInt(0, math.pow(2, 30))
		server_keys[playerID] = server_key
		trigger_load = true
	end

	client_keys[playerID] = data.n
	CustomGameEventManager:Send_ServerToPlayer_old(player, "ok", {
		n = data.n,
		k = server_key
	})
	if trigger_load then
		for _, listener in ipairs(load_listeners) do
			listener(player, playerID)
		end
	end
end)

CustomGameEventManager.RegisterListener = function(self, name, listener)
	return self:RegisterListener_old(name, function(player, data)
		if data.PlayerID == nil or data.n ~= client_keys[data.PlayerID] then
			return
		end
		return listener(player, data)
	end)
end

CustomGameEventManager.Send_ServerToPlayer = function(self, player, name, data)
	if player == nil then
		return
	end
	local server_key = server_keys[player:GetPlayerID()]
	if server_key ~= nil then
		data.n = server_key
		self:Send_ServerToPlayer_old(player, name, data)
	end
	data.n = nil
end

CustomGameEventManager.Send_ServerToAllClients = function(self, name, data)
	for playerID, server_key in pairs(server_keys) do
		local player = PlayerResource:GetPlayer(tonumber(playerID))
		if player ~= nil then
			data.n = server_key
			self:Send_ServerToPlayer_old(player, name, data)
		end
	end
	data.n = nil
end

CustomGameEventManager.Send_ServerToTeam = function(self, team, name, data)
	for playerID, server_key in pairs(server_keys) do
		local player = PlayerResource:GetPlayer(tonumber(playerID))
		if player ~= nil and player:GetTeam() == team then
			data.n = server_key
			self:Send_ServerToPlayer_old(player, name, data)
		end
	end
	data.n = nil
end
