LinkLuaModifier( "modifier_item_bloodthorn_custom_passive", "abilities/items/item_bloodthorn_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_item_bloodthorn_custom_active", "abilities/items/item_bloodthorn_custom", LUA_MODIFIER_MOTION_NONE )

item_bloodthorn_custom = class({})


function item_bloodthorn_custom:GetIntrinsicModifierName()
	return "modifier_item_bloodthorn_custom_passive"
end



function item_bloodthorn_custom:OnSpellStart()
	if not IsServer() then return end

	local duration = self:GetSpecialValueFor("duration")
	local caster = self:GetCaster()
	local target = self:GetCursorTarget()

	if target:IsMagicImmune() then return end
	if target:TriggerSpellAbsorb(self) then return end

	target:AddNewModifier(caster, self, "modifier_item_bloodthorn_custom_active", {duration = duration*(1 - target:GetStatusResistance()) })
	target:EmitSound("DOTA_Item.Bloodthorn.Activate")

end





modifier_item_bloodthorn_custom_passive = class({})


function modifier_item_bloodthorn_custom_passive:IsPurgable()		return false end
function modifier_item_bloodthorn_custom_passive:IsHidden()
		return true end
function modifier_item_bloodthorn_custom_passive:RemoveOnDeath() return false end
function modifier_item_bloodthorn_custom_passive:RemoveOnDeath()	return false end

function modifier_item_bloodthorn_custom_passive:DestroyOnExpire()
    return false
end

function modifier_item_bloodthorn_custom_passive:OnCreated()
	if IsServer() then
        if not self:GetAbility() then self:Destroy() end
    end
	self.item = self:GetAbility()
	self.parent = self:GetParent()
	self.damage = self.item:GetSpecialValueFor("bonus_damage")
	self.speed = self.item:GetSpecialValueFor("bonus_speed")
	self.mana = self.item:GetSpecialValueFor("bonus_mana")
end


function modifier_item_bloodthorn_custom_passive:DeclareFunctions()
	local decFuns =
		{
			MODIFIER_PROPERTY_MANA_REGEN_CONSTANT,
			MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
			MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
		}
	return decFuns
end

function modifier_item_bloodthorn_custom_passive:GetModifierPreAttack_BonusDamage()
	return self.damage
end

function modifier_item_bloodthorn_custom_passive:GetModifierAttackSpeedBonus_Constant()
	return self.speed
end

function modifier_item_bloodthorn_custom_passive:GetModifierConstantManaRegen()
	return self.mana
end









modifier_item_bloodthorn_custom_active = class({})

function modifier_item_bloodthorn_custom_active:IsDebuff() return true end
function modifier_item_bloodthorn_custom_active:IsHidden() return false end
function modifier_item_bloodthorn_custom_active:IsPurgable() return true end

function modifier_item_bloodthorn_custom_active:GetEffectName()
	return "particles/items2_fx/orchid.vpcf"
end

function modifier_item_bloodthorn_custom_active:GetEffectAttachType()
	return PATTACH_OVERHEAD_FOLLOW
end

function modifier_item_bloodthorn_custom_active:OnCreated( params )
if IsServer() then
	if not self:GetAbility() then self:Destroy() return end
end

self.count = 0
self.damage_count = self:GetAbility():GetSpecialValueFor("silence_damage_percent")/100
self.crit = self:GetAbility():GetSpecialValueFor("target_crit_multiplier")
end

function modifier_item_bloodthorn_custom_active:CheckState()
return
{
	[MODIFIER_STATE_SILENCED] = true,
	[MODIFIER_STATE_EVADE_DISABLED] = true
}
end

function modifier_item_bloodthorn_custom_active:DeclareFunctions()
return
{
	MODIFIER_EVENT_ON_TAKEDAMAGE,
	MODIFIER_PROPERTY_PREATTACK_TARGET_CRITICALSTRIKE
}
end

function modifier_item_bloodthorn_custom_active:OnTakeDamage(params)
if not IsServer() then return end
if self:GetParent() ~= params.unit then return end

self.count = self.count + params.damage*self.damage_count
ParticleManager:SetParticleControl(ParticleManager:CreateParticle("particles/items2_fx/orchid_pop.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent()), 1, Vector(params.damage))

end

function modifier_item_bloodthorn_custom_active:OnDestroy()
if not IsServer() then return end
if self:GetRemainingTime() > 0.2 then return end
if self.count == 0 then return end
if not self:GetAbility() then return end
if not self:GetCaster() then return end

ApplyDamage({ victim = self:GetParent(), attacker = self:GetCaster(), damage = self.count, damage_type = DAMAGE_TYPE_MAGICAL, ability = self:GetAbility()})


ParticleManager:SetParticleControl(ParticleManager:CreateParticle("particles/items2_fx/orchid_pop.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent()), 1, Vector(self.count))
		
end

function modifier_item_bloodthorn_custom_active:GetCritDamage()
	return self.crit
end

function modifier_item_bloodthorn_custom_active:GetModifierPreAttack_Target_CriticalStrike(params)
if not IsServer() then return end
if params.target ~= self:GetParent() then return end
return self.crit
end