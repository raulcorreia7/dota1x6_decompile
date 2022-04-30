
LinkLuaModifier("modifier_up_toweraoe_buff", "upgrade/tower/modifier_up_toweraoe", LUA_MODIFIER_MOTION_NONE)




modifier_up_toweraoe = class({})

function modifier_up_toweraoe:IsHidden() return true end
function modifier_up_toweraoe:IsPurgable() return true end

function modifier_up_toweraoe:DeclareFunctions()
return
{
	MODIFIER_EVENT_ON_ATTACK
  
    }

 end

function modifier_up_toweraoe:OnCreated(table)
if not IsServer() then return end
  self:SetStackCount(1)
end


function modifier_up_toweraoe:OnRefresh(table)
if not IsServer() then return end
  self:SetStackCount(self:GetStackCount()+1)
end


function modifier_up_toweraoe:OnAttack( params )
if not IsServer() then return end
if self:GetParent() == params.attacker and not self:GetParent():HasModifier("modifier_up_toweraoe_buff") then

	self:GetParent():AddNewModifier(self:GetParent(), nil, "modifier_up_toweraoe_buff", {})
	local n = 0
	local max = self:GetStackCount()*2
	 local targets = FindUnitsInRadius(self:GetParent():GetTeamNumber(), self:GetParent():GetAbsOrigin(), nil, 700 , DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_INVULNERABLE, FIND_ANY_ORDER, false)
     for _,target in ipairs(targets) do
     	if n < max and target ~= params.target then 
     		n = n + 1
     		self:GetParent():PerformAttack(target, true, true, true, false, true, false, false)
     	end
     end
     self:GetParent():RemoveModifierByName("modifier_up_toweraoe_buff")
end

end

modifier_up_toweraoe_buff = class({})

function modifier_up_toweraoe_buff:IsHidden() return true end
function modifier_up_toweraoe_buff:IsPurgable() return false end
