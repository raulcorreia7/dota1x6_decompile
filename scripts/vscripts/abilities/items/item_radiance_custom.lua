LinkLuaModifier( "modifier_radiance_custom_stats", "abilities/items/item_radiance_custom.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_radiance_custom_aura", "abilities/items/item_radiance_custom.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_radiance_custom_burn", "abilities/items/item_radiance_custom.lua", LUA_MODIFIER_MOTION_NONE )

item_radiance_custom = class({})

function item_radiance_custom:GetIntrinsicModifierName()
	return "modifier_radiance_custom_stats" end

function item_radiance_custom:OnSpellStart()
	if IsServer() then
		if self:GetCaster():HasModifier("modifier_radiance_custom_aura") then
			self:GetCaster():RemoveModifierByName("modifier_radiance_custom_aura")
		else
			self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_radiance_custom_aura", {})
		end
	end
end

function item_radiance_custom:GetAbilityTextureName()
	if self:GetCaster():HasModifier("modifier_radiance_custom_aura") then
		return "item_radiance"
	else
		return "item_radiance_inactive"
	end
end

modifier_radiance_custom_stats = class({})

function modifier_radiance_custom_stats:IsHidden() return true end
function modifier_radiance_custom_stats:IsDebuff() return false end
function modifier_radiance_custom_stats:IsPurgable() return false end
function modifier_radiance_custom_stats:IsPermanent() return true end
function modifier_radiance_custom_stats:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end

function modifier_radiance_custom_stats:OnCreated(keys)
	if IsServer() then
		if not self:GetParent():HasModifier("modifier_radiance_custom_aura") then
			self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_radiance_custom_aura", {})
		end
	end

end


function modifier_radiance_custom_stats:OnDestroy(keys)
	if IsServer() then
		if not self:GetParent():HasModifier("modifier_radiance_custom_stats") then
			self:GetParent():RemoveModifierByName("modifier_radiance_custom_aura")
		end
	end
end

function modifier_radiance_custom_stats:DeclareFunctions()
	return { 
				MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
				MODIFIER_PROPERTY_EVASION_CONSTANT
			 }
end

function modifier_radiance_custom_stats:GetModifierPreAttack_BonusDamage()
	return self:GetAbility():GetSpecialValueFor("bonus_damage")
end

function modifier_radiance_custom_stats:GetModifierEvasion_Constant()
	return self:GetAbility():GetSpecialValueFor("evasion")
end

modifier_radiance_custom_aura = class({})
function modifier_radiance_custom_aura:IsAura() return true end
function modifier_radiance_custom_aura:IsHidden() return true end
function modifier_radiance_custom_aura:IsDebuff() return false end
function modifier_radiance_custom_aura:IsPurgable() return false end

function modifier_radiance_custom_aura:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_ENEMY end

function modifier_radiance_custom_aura:GetAuraSearchType()
	return DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO
end

function modifier_radiance_custom_aura:GetModifierAura()
	return "modifier_radiance_custom_burn"
end

function modifier_radiance_custom_aura:GetAuraRadius()
	return self:GetAbility():GetSpecialValueFor("aura_radius")
end

function modifier_radiance_custom_aura:OnCreated()
	if IsServer() then
		self.particle = ParticleManager:CreateParticle("particles/items2_fx/radiance_owner.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
	end
end

function modifier_radiance_custom_aura:OnDestroy()
	if IsServer() then
		ParticleManager:DestroyParticle(self.particle, false)
		ParticleManager:ReleaseParticleIndex(self.particle)
	end
end

modifier_radiance_custom_burn = class({})
function modifier_radiance_custom_burn:IsHidden() return false end
function modifier_radiance_custom_burn:IsDebuff() return true end
function modifier_radiance_custom_burn:IsPurgable() return false end
function modifier_radiance_custom_burn:GetTexture() return "item_radiance" end


function modifier_radiance_custom_burn:DeclareFunctions()
return 
	{ 
		MODIFIER_PROPERTY_MISS_PERCENTAGE,
		MODIFIER_PROPERTY_TOOLTIP
	} 
end

function modifier_radiance_custom_burn:OnCreated()
if not IsServer() then return end
	self.particle = ParticleManager:CreateParticle("particles/items2_fx/radiance.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
	ParticleManager:SetParticleControl(self.particle, 1, self:GetCaster():GetAbsOrigin())

	self:StartIntervalThink(self:GetAbility():GetSpecialValueFor("think_interval"))

	local ability = self:GetAbility()
	self.base_damage = ability:GetSpecialValueFor("aura_damage")
	self.aura_radius = ability:GetSpecialValueFor("aura_radius")
	self.miss_chance = ability:GetSpecialValueFor("blind_pct")

	 EmitSoundOnEntityForPlayer("DOTA_Item.Radiance.Target.Loop", self:GetParent(), self:GetParent():GetPlayerOwnerID())
end

function modifier_radiance_custom_burn:OnDestroy()
if IsServer() then

	StopSoundOn("DOTA_Item.Radiance.Target.Loop", self:GetParent())

	if self.particle then
		ParticleManager:DestroyParticle(self.particle, false)
		ParticleManager:ReleaseParticleIndex(self.particle)
	end
end

end

function modifier_radiance_custom_burn:OnIntervalThink()
if not IsServer() then return end

	ParticleManager:SetParticleControl(self.particle, 1, self:GetCaster():GetAbsOrigin())

	local ability = self:GetAbility()
	local caster = self:GetCaster()
	local damage = self.base_damage + self:GetAbility():GetSpecialValueFor("health_damage")*self:GetCaster():GetMaxHealth()
	if self:GetCaster():IsIllusion() then 
		damage = self:GetAbility():GetSpecialValueFor("aura_damage_illusions")
	end

	ApplyDamage({victim = self:GetParent(), attacker = caster, ability = ability, damage = damage, damage_type = DAMAGE_TYPE_MAGICAL})

end

function modifier_radiance_custom_burn:GetModifierMiss_Percentage()
	return self:GetAbility():GetSpecialValueFor("blind_pct")
end

function modifier_radiance_custom_burn:OnTooltip()
return self:GetAbility():GetSpecialValueFor("aura_damage") + self:GetAbility():GetSpecialValueFor("health_damage")*self:GetCaster():GetMaxHealth()
end
