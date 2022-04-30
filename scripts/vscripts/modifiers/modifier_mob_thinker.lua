

modifier_mob_thinker = class({})


function modifier_mob_thinker:IsHidden() return false end
function modifier_mob_thinker:IsPurgable() return false end



function modifier_mob_thinker:CheckState()
    return {
        [MODIFIER_STATE_UNSELECTABLE] = true,
        [MODIFIER_STATE_NO_UNIT_COLLISION] = true,
        [MODIFIER_STATE_OUT_OF_GAME] = true,
        [MODIFIER_STATE_INVULNERABLE] = true,
        [MODIFIER_STATE_NO_HEALTH_BAR] = true,
        [MODIFIER_STATE_NOT_ON_MINIMAP_FOR_ENEMIES] = true,
    }
end

function modifier_mob_thinker:RemoveOnDeath() return false end

function modifier_mob_thinker:DeclareFunctions()
return
{
	MODIFIER_EVENT_ON_ATTACK_LANDED,
	MODIFIER_EVENT_ON_TAKEDAMAGE,
	MODIFIER_EVENT_ON_DEATH
}

end


function modifier_mob_thinker:OnDeath(params)
if not IsServer() then return end
local killer = params.attacker

if killer == nil then return end
if killer.owner == nil and not killer:IsHero() then return end

if players[killer:GetTeamNumber()] == nil then return end


if params.unit:GetUnitName() == "patrol_range_bad" or
	params.unit:GetUnitName() == "patrol_melee_bad" or
	params.unit:GetUnitName() == "patrol_range_good" or 
	params.unit:GetUnitName() == "patrol_melee_good" then
	players[killer:GetTeamNumber()].patrol_kills = players[killer:GetTeamNumber()].patrol_kills + 1
end


if params.unit:GetUnitName() == "npc_dota_observer_wards" and params.unit:GetTeamNumber() ~= killer:GetTeamNumber() then 
	players[killer:GetTeamNumber()].obs_kills = players[killer:GetTeamNumber()].obs_kills + 1
end


if params.unit:GetUnitName() == "npc_dota_sentry_wards" and params.unit:GetTeamNumber() ~= killer:GetTeamNumber()  then 
	players[killer:GetTeamNumber()].sentry_kills = players[killer:GetTeamNumber()].sentry_kills + 1
end


end

function modifier_mob_thinker:OnAttackLanded(params)
if not IsServer() then return end
local attacker = params.attacker
local target = params.target
if attacker == nil or target == nil then return end
if target:GetTeamNumber() ~= DOTA_TEAM_CUSTOM_5 and attacker:GetTeamNumber() ~= DOTA_TEAM_CUSTOM_5 then return end






if attacker:HasModifier("modifier_troll_heal") then 
	local mod = attacker:FindModifierByName("modifier_troll_heal")
	mod:DoScript()
end

if attacker:HasModifier("modifier_abbadon_silence_self") then 
	local mod = attacker:FindModifierByName("modifier_abbadon_silence_self")
	mod:DoScript(target)
end



if target:HasModifier("modifier_abbadon_silence") then 
	local mod = target:FindModifierByName("modifier_abbadon_silence")
	mod:DoScript(attacker)
end


if attacker:HasModifier("modifier_siege_attack") then 
	local mod = attacker:FindModifierByName("modifier_siege_attack")
	mod:DoScript(target)
end

if attacker:HasModifier("modifier_siege_melting") then 
	local mod = attacker:FindModifierByName("modifier_siege_melting")
	mod:DoScript(target)
end

if attacker:HasModifier("modifier_werewolf_bloodrage") then 
	local mod = attacker:FindModifierByName("modifier_werewolf_bloodrage")
	mod:DoScript()
end



if attacker:HasModifier("modifier_satyr_root_passive") then 
	local mod = attacker:FindModifierByName("modifier_satyr_root_passive")
	mod:DoScript(target)
end


end




modifier_mob_thinker.Teams_Neutrals_Camps = {
	-- Easy
	["neutralcamp_good_2"] = "Easy",
	["neutralcamp_good_3"] = "Easy",
	["neutralcamp_good_5"] = "Easy",
	["neutralcamp_evil_5"] =  "Easy",
	["neutralcamp_evil_1"] =  "Easy",
	["neutralcamp_good_6"] = "Easy",
	["neutralcamp_evil_3"] =  "Easy",
	["neutralcamp_good_4"] = "Easy",
	["neutralcamp_evil_4"] =  "Easy",
	["neutralcamp_evil_2"] =  "Easy",
	["neutralcamp_evil_6"] =  "Easy",
	["neutralcamp_good_1"] = "Easy",

	-- Medium
	["neutralcamp_evil_12"] = "Medium",
	["neutralcamp_good_9"] = "Medium",
	["neutralcamp_good_8"] = "Medium",
	["neutralcamp_good_7"] = "Medium",
	["neutralcamp_good_12"] = "Medium",
	["neutralcamp_evil_8"] =  "Medium",
	["neutralcamp_evil_9"] =  "Medium",
	["neutralcamp_evil_7"] =  "Medium",
	["neutralcamp_good_10"] = "Medium",
	["neutralcamp_evil_10"] = "Medium",

	--hard
	["neutralcamp_evil_13"] = "Hard",
	["neutralcamp_evil_16"] = "Hard",
	["neutralcamp_evil_14"] = "Hard",
	["neutralcamp_evil_15"] = "Hard",
	["neutralcamp_good_15"] = "Hard",
	["neutralcamp_good_16"] = "Hard",
	["neutralcamp_good_13"] = "Hard",
	["neutralcamp_good_14"] = "Hard",

	-- Ancient
	["neutralcamp_good_17"] = "Ancient",
	["neutralcamp_good_18"] = "Ancient",
}

function ModifyDamageData(data, params, received)
	local pre_reduction = nil
	local post_reduction = nil
	if received then
		pre_reduction = data.received_pre_reduction
		post_reduction = data.received_post_reduction
	else
		pre_reduction = data.dealt_pre_reduction
		post_reduction = data.dealt_post_reduction
	end
	local i = 1
	if params.damage_type == DAMAGE_TYPE_PHYSICAL then
		i = 1
	elseif params.damage_type == DAMAGE_TYPE_MAGICAL then
		i = 2
	elseif params.damage_type == DAMAGE_TYPE_PURE then
		i = 3
	elseif params.damage_type == DAMAGE_TYPE_HP_REMOVAL then
		i = 4
	end
	pre_reduction[i] = pre_reduction[i] + params.original_damage
	post_reduction[i] = post_reduction[i] + params.damage
end

function modifier_mob_thinker:OnTakeDamage(params)
if not IsServer() then return end
local attacker = params.attacker
local unit = params.unit

if attacker == nil or unit == nil then return end

if attacker:IsHero() or attacker.onwer ~= nil then 
	local attacker_player = players[attacker:GetTeamNumber()]
	if attacker_player ~= nil then 

		local damage_name = "auto"
		if params.inflictor ~= nil then 
			damage_name = params.inflictor:GetName()
		end

		local ability_data = nil
		for j,ability in pairs(attacker_player.abilities) do 
			if ability.name ~= nil and ability.name == damage_name then 
				ability_data = ability
				break
			end
		end


		if ability_data == nil then 
			ability_data = {
				name = damage_name,
				damage_pre_reduction = 0,
				damage_post_reduction = 0
			}
			table.insert(attacker_player.abilities, ability_data)
		end
		ability_data.damage_pre_reduction = ability_data.damage_pre_reduction + params.original_damage
		ability_data.damage_post_reduction = ability_data.damage_post_reduction + params.damage

		if params.unit:IsBuilding() then
			ModifyDamageData(attacker_player.tower_damage, params, false)
		end

		if params.unit:IsRealHero() then
			ModifyDamageData(attacker_player.hero_damage, params, false)
		end

		
		if params.unit:IsCreep() then
			ModifyDamageData(attacker_player.creep_damage, params, false)
		end
	end
end


local receiver_player = players[params.unit:GetTeamNumber()]
if params.unit:IsRealHero() and receiver_player ~= nil then 

	if params.attacker:IsBuilding() then
		ModifyDamageData(receiver_player.tower_damage, params, true)
	end

	if params.attacker:IsHero() then
		ModifyDamageData(receiver_player.hero_damage, params, true)
	end

	if params.attacker:IsCreep() then
		ModifyDamageData(receiver_player.creep_damage, params, true)
	end

end



if (unit:IsNeutralUnitType()) then
	if attacker:IsHero() and (attacker.tip_ready == nil or attacker.tip_ready == true) then
		local attacker_level = attacker:GetLevel()
		local current_camp = nil
		local range_trigger_last = 10000
		local camps_ping = {}
		local table_tips = CustomNetTables:GetTableValue("TipsType", tostring(attacker:GetPlayerID()))

		for trigger_name, camp_name in pairs(self.Teams_Neutrals_Camps) do
			local trigger = Entities:FindByName(nil, trigger_name)
			local length = (trigger:GetAbsOrigin() - attacker:GetAbsOrigin()):Length2D()
			if length <= range_trigger_last then
				range_trigger_last = length
				current_camp = camp_name
			end
		end

		if attacker_level < 5 then
			if current_camp ~= nil and current_camp ~= "Easy" then
				for trigger_name, camp_name in pairs(self.Teams_Neutrals_Camps) do
					if camp_name == "Easy" then
						table.insert(camps_ping, trigger_name)
					end
				end	


				table.sort( camps_ping, function(x,y) return (Entities:FindByName(nil, y):GetAbsOrigin()-towers[attacker:GetTeamNumber()]:GetAbsOrigin()):Length2D() > (Entities:FindByName(nil, x):GetAbsOrigin()-towers[attacker:GetTeamNumber()]:GetAbsOrigin()):Length2D() end )
				if table_tips.type == 3 then
					if camps_ping and camps_ping[1] then
						local unit_camp = Entities:FindByName(nil, camps_ping[1])
						local abs = unit_camp:GetAbsOrigin()
						GameRules:ExecuteTeamPing( attacker:GetTeamNumber(), abs.x, abs.y, attacker, 0 )
					end
					if camps_ping and camps_ping[2] then
						local unit_camp = Entities:FindByName(nil, camps_ping[2])
						local abs = unit_camp:GetAbsOrigin()
						Timers:CreateTimer(1.5, function()
							GameRules:ExecuteTeamPing( attacker:GetTeamNumber(), abs.x, abs.y, attacker, 0 )
						end)
					end
					attacker.tip_ready = false
					if table_tips.type == 3 then
					CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(attacker:GetPlayerID()), "TipForPlayer", {duration = 7, text = "#Tip_EasyCamp"})
					end
					Timers:CreateTimer(10, function ()
						attacker.tip_ready = true
					end)
				end
			end
		elseif attacker_level >= 5 and attacker_level <= 9 then

			if current_camp ~= nil and (current_camp ~= "Easy" and current_camp ~= "Medium") then

					for trigger_name, camp_name in pairs(self.Teams_Neutrals_Camps) do
						if camp_name == "Medium" then
							table.insert(camps_ping, trigger_name)
						end
					end	

				table.sort( camps_ping, function(x,y) return (Entities:FindByName(nil, y):GetAbsOrigin()-towers[attacker:GetTeamNumber()]:GetAbsOrigin()):Length2D() > (Entities:FindByName(nil, x):GetAbsOrigin()-towers[attacker:GetTeamNumber()]:GetAbsOrigin()):Length2D() end )
				if table_tips.type == 3 then
					if camps_ping and camps_ping[1] then
						local unit_camp = Entities:FindByName(nil, camps_ping[1])
						local abs = unit_camp:GetAbsOrigin()
						GameRules:ExecuteTeamPing( attacker:GetTeamNumber(), abs.x, abs.y, attacker, 0 )
					end
					if camps_ping and camps_ping[2] then
						local unit_camp = Entities:FindByName(nil, camps_ping[2])
						local abs = unit_camp:GetAbsOrigin()
						Timers:CreateTimer(1.5, function()
							GameRules:ExecuteTeamPing( attacker:GetTeamNumber(), abs.x, abs.y, attacker, 0 )
						end)
					end
					attacker.tip_ready = false

					if table_tips.type == 3 then
						CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(attacker:GetPlayerID()), "TipForPlayer", {duration = 7, text = "#Tip_MediumCamp"})
					end

					Timers:CreateTimer(10, function ()
						attacker.tip_ready = true
					end)
				end
			end
		end
	end
end







if (unit:GetUnitName() == "npc_towerdire" or unit:GetUnitName() == "npc_towerradiant") and unit:GetHealthPercent() < 0.001 and attacker:IsHero() then 

	unit.killer = attacker

end



if attacker:GetTeamNumber() ~= DOTA_TEAM_CUSTOM_5 and unit:GetTeamNumber() ~= DOTA_TEAM_CUSTOM_5 then return end


if unit:HasModifier("modifier_abbadon_passive") then 
	local mod = unit:FindModifierByName("modifier_abbadon_passive")
	mod:DoScript()
end


end

