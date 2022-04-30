LinkLuaModifier("modifier_bird_slow", "abilities/neutral_bird_slow", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_bird_slow_buff", "abilities/neutral_bird_slow", LUA_MODIFIER_MOTION_NONE)



neutral_bird_slow = class({})

function neutral_bird_slow:GetIntrinsicModifierName() return "modifier_bird_slow" end 


modifier_bird_slow = class({})

function modifier_bird_slow:IsPurgable() return false end

function modifier_bird_slow:IsHidden() return true end

function modifier_bird_slow:IsAura() return true end

function modifier_bird_slow:GetAuraDuration() return 0.1 end

function modifier_bird_slow:GetAuraRadius() return self:GetAbility():GetSpecialValueFor("radius") end

function modifier_bird_slow:GetAuraSearchTeam() return DOTA_UNIT_TARGET_TEAM_ENEMY end

function modifier_bird_slow:GetAuraSearchType() return DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO end



function modifier_bird_slow:GetAuraEntityReject(target)
	if not target:CanEntityBeSeenByMyTeam(self:GetParent()) then
		return true 
	end

	return false
end

function modifier_bird_slow:GetModifierAura() return "modifier_bird_slow_buff" end

modifier_bird_slow_buff = class({})
function modifier_bird_slow_buff:IsPurgable() return false end
function modifier_bird_slow_buff:IsHidden() return false end



function modifier_bird_slow_buff:OnCreated(table)
if not IsServer() then return end
 self:SetHasCustomTransmitterData(true)
self.move =  -self:GetAbility():GetSpecialValueFor("move")
self.speed = -self:GetAbility():GetSpecialValueFor("speed")
end

function modifier_bird_slow_buff:DeclareFunctions()

  return 
{

         
         MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
  MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
  MODIFIER_PROPERTY_TOOLTIP,
MODIFIER_PROPERTY_TOOLTIP2
   
}

end

function modifier_bird_slow_buff:OnTooltip() return self:GetAbility():GetSpecialValueFor("move") end
function modifier_bird_slow_buff:OnTooltip2() return self:GetAbility():GetSpecialValueFor("speed") end



function modifier_bird_slow_buff:AddCustomTransmitterData() return {
speed = self.speed,
move = self.move

} end

function modifier_bird_slow_buff:HandleCustomTransmitterData(data)
self.speed = data.speed
self.move = data.move
end

function modifier_bird_slow_buff:GetAttributes()
 return  MODIFIER_ATTRIBUTE_MULTIPLE end 

function modifier_bird_slow_buff:GetModifierAttackSpeedBonus_Constant() return self.speed end

function modifier_bird_slow_buff:GetModifierMoveSpeedBonus_Percentage() return self.move end