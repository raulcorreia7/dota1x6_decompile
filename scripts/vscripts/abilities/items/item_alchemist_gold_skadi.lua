LinkLuaModifier("modifier_item_alchemist_gold_skadi", "abilities/items/item_alchemist_gold_skadi", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_alchemist_gold_skadi_debuff", "abilities/items/item_alchemist_gold_skadi", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_alchemist_gold_skadi_debuff_active", "abilities/items/item_alchemist_gold_skadi", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_alchemist_gold_skadi_root", "abilities/items/item_alchemist_gold_skadi", LUA_MODIFIER_MOTION_NONE)

item_alchemist_gold_skadi = class({})

function item_alchemist_gold_skadi:GetIntrinsicModifierName()
	return "modifier_item_alchemist_gold_skadi"
end

function item_alchemist_gold_skadi:OnSpellStart()
	if not IsServer() then return end

	local duration = self:GetSpecialValueFor("purge_slow_duration")
	local target = self:GetCursorTarget()


	local particle_target_fx = ParticleManager:CreateParticle("particles/generic_gameplay/generic_manaburn.vpcf", PATTACH_ABSORIGIN_FOLLOW, target)
	ParticleManager:ReleaseParticleIndex(particle_target_fx)
	self:GetCaster():EmitSound("DOTA_Item.DiffusalBlade.Activate")
	target:EmitSound("DOTA_Item.DiffusalBlade.Target")
	target:AddNewModifier(self:GetCaster(), self, "modifier_item_alchemist_gold_skadi_debuff_active", {duration = duration})

	
end

modifier_item_alchemist_gold_skadi	= class({})

function modifier_item_alchemist_gold_skadi:IsPurgable()		return false end
function modifier_item_alchemist_gold_skadi:RemoveOnDeath()	return false end
function modifier_item_alchemist_gold_skadi:IsHidden()	return true end

function modifier_item_alchemist_gold_skadi:OnCreated()
	self.bonus_strength = self:GetAbility():GetSpecialValueFor("bonus_strength")
	self.bonus_agility = self:GetAbility():GetSpecialValueFor("bonus_agility")
	self.bonus_intellect =  self:GetAbility():GetSpecialValueFor("bonus_intellect")
	self.bonus_health = self:GetAbility():GetSpecialValueFor("bonus_health")
	self.bonus_mana = self:GetAbility():GetSpecialValueFor("bonus_mana")
	self.cold_duration = self:GetAbility():GetSpecialValueFor("cold_duration")
end

function modifier_item_alchemist_gold_skadi:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
		MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
		MODIFIER_PROPERTY_HEALTH_BONUS,
		MODIFIER_PROPERTY_MANA_BONUS,
        MODIFIER_EVENT_ON_ATTACK_LANDED,
        MODIFIER_PROPERTY_PROCATTACK_FEEDBACK
	}
end

function modifier_item_alchemist_gold_skadi:GetModifierBonusStats_Strength()
    return self.bonus_strength
end

function modifier_item_alchemist_gold_skadi:GetModifierBonusStats_Agility()
    return self.bonus_agility
end

function modifier_item_alchemist_gold_skadi:GetModifierBonusStats_Intellect()
    return self.bonus_intellect
end

function modifier_item_alchemist_gold_skadi:GetModifierHealthBonus()
    return self.bonus_health
end

function modifier_item_alchemist_gold_skadi:GetModifierManaBonus()
    return self.bonus_mana
end




function modifier_item_alchemist_gold_skadi:GetModifierProcAttack_Feedback(params)
if not IsServer() then return end
if params.attacker:FindAllModifiersByName(self:GetName())[1] ~= self then return end 
if not params.target:IsHero() and not params.target:IsCreep() then return end
if params.attacker ~= self:GetParent() then return end
if params.target:IsMagicImmune() then return end
if self:GetParent():HasModifier("modifier_item_diffusal_blade") then return end
if self:GetParent():HasModifier("modifier_item_cleansing_blade") then return end

local mana = self:GetAbility():GetSpecialValueFor("feedback_mana_burn") 

if self:GetParent():IsIllusion() then 
    mana = self:GetAbility():GetSpecialValueFor("feedback_mana_burn_illusion_melee")
end

if params.target:GetMana() < mana then 
    mana = params.target:GetMana()
end

local effect = ParticleManager:CreateParticle( "particles/generic_gameplay/generic_manaburn.vpcf", PATTACH_ABSORIGIN_FOLLOW, params.target)

params.target:ReduceMana(mana)

return mana

end




function modifier_item_alchemist_gold_skadi:OnAttackLanded(keys)
if keys.attacker ~= self:GetParent() then return end
local target = keys.target

if not self:GetParent():IsIllusion() then
    local duration = self:GetAbility():GetSpecialValueFor("cold_duration")
    target:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_item_alchemist_gold_skadi_debuff", {duration = duration})
end

end





modifier_item_alchemist_gold_skadi_debuff = class({})

function modifier_item_alchemist_gold_skadi_debuff:IsPurgable() return false end

function modifier_item_alchemist_gold_skadi_debuff:OnCreated()
	self.speed_reduction = 0
	self.cold_slow_ranged = self:GetAbility():GetSpecialValueFor("cold_slow_ranged")
	self.heal_reduction = self:GetAbility():GetSpecialValueFor("heal_reduction")

	self.speed_reduction = self.cold_slow_ranged
end

function modifier_item_alchemist_gold_skadi_debuff:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_HEAL_AMPLIFY_PERCENTAGE_TARGET,
		MODIFIER_PROPERTY_HP_REGEN_AMPLIFY_PERCENTAGE,
		MODIFIER_PROPERTY_LIFESTEAL_AMPLIFY_PERCENTAGE,

	}
end

function modifier_item_alchemist_gold_skadi_debuff:GetModifierMoveSpeedBonus_Percentage()
	return self.speed_reduction
end

function modifier_item_alchemist_gold_skadi_debuff:GetModifierAttackSpeedBonus_Constant()
	return self.speed_reduction
end

function modifier_item_alchemist_gold_skadi_debuff:GetModifierLifestealRegenAmplify_Percentage()
	return self.heal_reduction
end

function modifier_item_alchemist_gold_skadi_debuff:GetModifierHealAmplify_PercentageTarget()
	return self.heal_reduction
end

function modifier_item_alchemist_gold_skadi_debuff:GetModifierHPRegenAmplify_Percentage()
	return self.heal_reduction
end

function modifier_item_alchemist_gold_skadi_debuff:GetStatusEffectName()
	return "particles/status_fx/status_effect_frost_lich.vpcf"
end

function modifier_item_alchemist_gold_skadi_debuff:StatusEffectPriority()
	return 10
end









modifier_item_alchemist_gold_skadi_debuff_active = class({})
function modifier_item_alchemist_gold_skadi_debuff_active:IsHidden() return false end
function modifier_item_alchemist_gold_skadi_debuff_active:IsPurgable() return true end
function modifier_item_alchemist_gold_skadi_debuff_active:GetEffectName() return "particles/items_fx/diffusal_slow.vpcf" end


function modifier_item_alchemist_gold_skadi_debuff_active:OnCreated(table)
self.slow = -100
self.tick = 20
self.heal_reduction = self:GetAbility():GetSpecialValueFor("heal_reduction")
self.interval = self:GetRemainingTime()/self:GetAbility():GetSpecialValueFor("purge_rate")
self.max = self:GetAbility():GetSpecialValueFor("root_hits")
self.root_duration = self:GetAbility():GetSpecialValueFor("root_duration")
self:StartIntervalThink(self.interval)
end

function modifier_item_alchemist_gold_skadi_debuff_active:OnRefresh(table)
self:OnCreated(table)
end

function modifier_item_alchemist_gold_skadi_debuff_active:OnIntervalThink()
self.slow = self.slow + self.tick
end

function modifier_item_alchemist_gold_skadi_debuff_active:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
		MODIFIER_EVENT_ON_ATTACK_LANDED
	}
end

function modifier_item_alchemist_gold_skadi_debuff_active:GetModifierMoveSpeedBonus_Percentage()
    return self.slow
end

function modifier_item_alchemist_gold_skadi_debuff_active:OnAttackLanded(params)
if not IsServer() then return end
if self:GetParent() ~= params.target then return end
if self:GetCaster() ~= params.attacker then return end
if self:GetParent():HasModifier("modifier_item_alchemist_gold_skadi_root") then return end

self:IncrementStackCount()

if self:GetStackCount() == 1 then 

	local particle_cast = "particles/units/heroes/hero_drow/drow_hypothermia_counter_stack.vpcf"
	self.effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_OVERHEAD_FOLLOW, self:GetParent() )
	ParticleManager:SetParticleControl( self.effect_cast, 1, Vector( 0, self:GetStackCount(), 0 ) )
	self:AddParticle(self.effect_cast,false, false, -1, false, false)
else 
	ParticleManager:SetParticleControl( self.effect_cast, 1, Vector( 0, self:GetStackCount(), 0 ) )
end



if self:GetStackCount() == self.max then 
	self:SetStackCount(0)

	ParticleManager:DestroyParticle(self.effect_cast, false)
	ParticleManager:ReleaseParticleIndex(self.effect_cast)

    self:GetParent():EmitSound("Hero_Crystal.frostbite")
	self:GetParent():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_item_alchemist_gold_skadi_root", {duration = self.root_duration*(1 - self:GetParent():GetStatusResistance())})
end


end


modifier_item_alchemist_gold_skadi_root = class({})
function modifier_item_alchemist_gold_skadi_root:IsHidden() return false end
function modifier_item_alchemist_gold_skadi_root:IsPurgable() return true end
function modifier_item_alchemist_gold_skadi_root:CheckState()
return
{
	[MODIFIER_STATE_ROOTED] = true
}
end


function modifier_item_alchemist_gold_skadi_root:GetEffectName() return "particles/units/heroes/hero_crystalmaiden/maiden_frostbite_buff.vpcf" end

function modifier_item_alchemist_gold_skadi_root:GetEffectAttachType() return PATTACH_ABSORIGIN_FOLLOW end