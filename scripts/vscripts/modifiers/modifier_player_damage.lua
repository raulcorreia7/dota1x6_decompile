

modifier_player_damage = class({})


function modifier_player_damage:IsHidden() return false end
function modifier_player_damage:IsPurgable() return false end
function modifier_player_damage:RemoveOnDeath() return false end


function modifier_player_damage:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE
}
end

function modifier_player_damage:GetModifierIncomingDamage_Percentage(params)
if not IsServer() then return end


local self_id = self:GetParent():GetPlayerID()
local player_array = players[self:GetParent():GetTeamNumber()]

if player_array == nil then return end

local attacker = params.attacker
if not attacker or not attacker:IsHero() then return end 
if attacker == self:GetParent() then return end

local attacker_id = attacker:GetPlayerID()
local attacker_array = players[attacker:GetTeamNumber()]

if not attacker_array then return end

for i,damage in pairs(attacker_array.damages) do
	if i == self_id then 
		if damage < 0  then 

			local tower = towers[attacker:GetTeamNumber()] 
			if tower and (tower:GetAbsOrigin() - self:GetParent():GetAbsOrigin()):Length2D() <= 900 then 
				return 0
			end

			return damage
		end
	end
end

end
