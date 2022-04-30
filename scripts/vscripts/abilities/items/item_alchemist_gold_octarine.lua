LinkLuaModifier("modifier_item_alchemist_gold_octarine", "abilities/items/item_alchemist_gold_octarine", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_alchemist_gold_octarine_active", "abilities/items/item_alchemist_gold_octarine", LUA_MODIFIER_MOTION_NONE)

item_alchemist_gold_octarine = class({})

function item_alchemist_gold_octarine:GetIntrinsicModifierName()
	return "modifier_item_alchemist_gold_octarine"
end





function item_alchemist_gold_octarine:OnSpellStart()
if not IsServer() then return end
    local duration = self:GetSpecialValueFor("duration")
    self:GetCaster():EmitSound("DOTA_Item.BlackKingBar.Activate")
    self:GetCaster():Purge(false, true, false, false, false)
    self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_item_alchemist_gold_octarine_active", {duration = duration})
end





modifier_item_alchemist_gold_octarine_active = class({})

function modifier_item_alchemist_gold_octarine_active:IsPurgable() return false end

function modifier_item_alchemist_gold_octarine_active:OnCreated()
    if not IsServer() then return end
    if not self:GetAbility() then 
        self:Destroy() 
    end
self:GetParent():EmitSound("BB.Quill_cdr")
self.particle = ParticleManager:CreateParticle("particles/bristle_cdr.vpcf", PATTACH_CUSTOMORIGIN, self:GetParent())
ParticleManager:SetParticleControlEnt(self.particle, 0, self:GetParent(), PATTACH_OVERHEAD_FOLLOW, "attach_hitloc", self:GetParent():GetAbsOrigin(), true)
ParticleManager:SetParticleControlEnt(self.particle, 1, self:GetParent(), PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", self:GetParent():GetAbsOrigin(), true)
ParticleManager:SetParticleControlEnt(self.particle, 5, self:GetParent(), PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", self:GetParent():GetAbsOrigin(), true)
self:AddParticle(self.particle, false, false, -1, false, false)


end

function modifier_item_alchemist_gold_octarine_active:OnRefresh()
    if not IsServer() then return end
    self:OnCreated()
end

function modifier_item_alchemist_gold_octarine_active:GetEffectName()
    return "particles/items_fx/black_king_bar_avatar.vpcf"
end

function modifier_item_alchemist_gold_octarine_active:GetEffectAttachType()
    return PATTACH_ABSORIGIN_FOLLOW
end

function modifier_item_alchemist_gold_octarine_active:CheckState()
    return {
        [MODIFIER_STATE_MAGIC_IMMUNE] = true
    }
end

function modifier_item_alchemist_gold_octarine_active:DeclareFunctions()
    return {
        MODIFIER_PROPERTY_MODEL_SCALE
    }
end

function modifier_item_alchemist_gold_octarine_active:GetModifierModelScale()
    if self:GetAbility() then 
        return 30
    end
end

function modifier_item_alchemist_gold_octarine_active:GetStatusEffectName()
    return "particles/status_fx/status_effect_avatar.vpcf"
end

function modifier_item_alchemist_gold_octarine_active:StatusEffectPriority()
    return 99999
end








modifier_item_alchemist_gold_octarine	= class({})

function modifier_item_alchemist_gold_octarine:IsPurgable()		return false end
function modifier_item_alchemist_gold_octarine:RemoveOnDeath()	return false end
function modifier_item_alchemist_gold_octarine:IsHidden()	return true end

function modifier_item_alchemist_gold_octarine:OnCreated()
	self.bonus_cooldown = self:GetAbility():GetSpecialValueFor("bonus_cooldown")
	self.cast_range_bonus = self:GetAbility():GetSpecialValueFor("cast_range_bonus")
	self.bonus_health = self:GetAbility():GetSpecialValueFor("bonus_health")
	self.bonus_mana = self:GetAbility():GetSpecialValueFor("bonus_mana")
	self.bonus_mana_regen = self:GetAbility():GetSpecialValueFor("bonus_mana_regen")
	self.bonus_damage = self:GetAbility():GetSpecialValueFor("bonus_damage")
	self.bonus_str = self:GetAbility():GetSpecialValueFor("bonus_strength")
end

function modifier_item_alchemist_gold_octarine:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_COOLDOWN_PERCENTAGE,
		MODIFIER_PROPERTY_CAST_RANGE_BONUS_STACKING,
		MODIFIER_PROPERTY_HEALTH_BONUS,
		MODIFIER_PROPERTY_MANA_BONUS,
		MODIFIER_PROPERTY_MANA_REGEN_CONSTANT,
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE
	}

	return funcs
end

function modifier_item_alchemist_gold_octarine:GetModifierBonusStats_Strength()
	return self.bonus_str
end

function modifier_item_alchemist_gold_octarine:GetModifierPreAttack_BonusDamage()
	return self.bonus_damage
end

function modifier_item_alchemist_gold_octarine:GetModifierPercentageCooldown()
if self:GetParent():HasModifier("modifier_item_alchemist_gold_octarine_active") then 
	return self:GetAbility():GetSpecialValueFor("active_cooldown")
end
	return self.bonus_cooldown
end

function modifier_item_alchemist_gold_octarine:GetModifierCastRangeBonusStacking()
	return self.cast_range_bonus
end

function modifier_item_alchemist_gold_octarine:GetModifierHealthBonus()
	return self.bonus_health
end

function modifier_item_alchemist_gold_octarine:GetModifierManaBonus()
	return self.bonus_mana
end

function modifier_item_alchemist_gold_octarine:GetModifierConstantManaRegen()
	return self.bonus_mana_regen
end



