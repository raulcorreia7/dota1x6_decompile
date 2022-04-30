item_spirit_vessel_custom = class({})

LinkLuaModifier( "modifier_item_spirit_vessel_custom_passive", "abilities/items/item_spirit_vessel_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_item_spirit_vessel_custom_active_ally", "abilities/items/item_spirit_vessel_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_item_spirit_vessel_custom_active_enemy", "abilities/items/item_spirit_vessel_custom", LUA_MODIFIER_MOTION_NONE )

function item_spirit_vessel_custom:GetIntrinsicModifierName()
	return "modifier_item_spirit_vessel_custom_passive"
end

function item_spirit_vessel_custom:CastFilterResultTarget(target)
	if IsServer() then
		local caster = self:GetCaster()
		if caster:GetTeam() ~= target:GetTeam() and target:IsMagicImmune() then
			return UF_FAIL_MAGIC_IMMUNE_ENEMY
		end

		if target:GetUnitName() == "npc_lich" or target:GetUnitName() == "npc_roshan_custom" then 
			return UF_FAIL_OTHER
		end


		return UnitFilter( target, self:GetAbilityTargetTeam(), self:GetAbilityTargetType(), self:GetAbilityTargetFlags(), self:GetCaster():GetTeamNumber() )
	end
end

function item_spirit_vessel_custom:OnSpellStart()
	if not IsServer() then return end

	local duration = self:GetSpecialValueFor("duration")
	local caster = self:GetCaster()
	local target = self:GetCursorTarget()

	target:EmitSound("DOTA_Item.UrnOfShadows.Activate")

	local particle_fx = ParticleManager:CreateParticle("particles/items4_fx/spirit_vessel_cast.vpcf", PATTACH_ABSORIGIN_FOLLOW, caster)
	ParticleManager:SetParticleControl(particle_fx, 0, caster:GetAbsOrigin())
	ParticleManager:SetParticleControl(particle_fx, 1, target:GetAbsOrigin())
	ParticleManager:ReleaseParticleIndex(particle_fx)

	if target:GetTeam() == caster:GetTeam() then
		target:AddNewModifier(caster, self, "modifier_item_spirit_vessel_custom_active_ally", {duration = duration })
	else
		target:AddNewModifier(caster, self, "modifier_item_spirit_vessel_custom_active_enemy", {duration = duration })
	end

	self:SetCurrentCharges(self:GetCurrentCharges() - 1)
end

modifier_item_spirit_vessel_custom_passive = class({})

function modifier_item_spirit_vessel_custom_passive:IsHidden()	return
 self:GetParent():HasModifier("modifier_item_soul_keeper_custom_passive")
end


function modifier_item_spirit_vessel_custom_passive:IsPurgable()		return false end
function modifier_item_spirit_vessel_custom_passive:RemoveOnDeath()	return false end

function modifier_item_spirit_vessel_custom_passive:DestroyOnExpire()
    return false
end

function modifier_item_spirit_vessel_custom_passive:OnCreated()
	if IsServer() then
        if not self:GetAbility() then self:Destroy() end
    end
	self.item = self:GetAbility()
	self.parent = self:GetParent()
	self.soul_cooldown = self.item:GetSpecialValueFor("soul_cooldown")
	self.bonus_armor = self.item:GetSpecialValueFor("bonus_armor")
	self.bonus_mana_regen = self.item:GetSpecialValueFor("mana_regen")
	self.bonus_agility = self.item:GetSpecialValueFor("bonus_all_stats")
	self.bonus_strength = self.item:GetSpecialValueFor("bonus_all_stats")
	self.bonus_intelligence = self.item:GetSpecialValueFor("bonus_all_stats")
	self.health_bonus = self.item:GetSpecialValueFor("bonus_health")
	self.radius = self.item:GetSpecialValueFor("soul_radius")
	self.duration = self.soul_cooldown
	self:SetDuration(self.soul_cooldown, true)
	self:StartIntervalThink(0.1)
end

function modifier_item_spirit_vessel_custom_passive:OnIntervalThink()
	if not IsServer() then return end


	if self:GetParent():HasModifier("modifier_item_soul_keeper_custom_passive") then
		self:SetDuration(self.soul_cooldown, true)
		return
	end


	if self.duration <= 0 then
		self.item:SetCurrentCharges(self.item:GetCurrentCharges() + 1)
		self:SetDuration(self.soul_cooldown, true)
		self.duration = self:GetRemainingTime()
		return
	end
	self.duration = self:GetRemainingTime()
end

function modifier_item_spirit_vessel_custom_passive:DeclareFunctions()
	local decFuns =
		{
			MODIFIER_PROPERTY_MANA_REGEN_CONSTANT,
			MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
			MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
			MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
			MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
			MODIFIER_PROPERTY_HEALTH_BONUS,
			MODIFIER_EVENT_ON_DEATH

		}
	return decFuns
end

function modifier_item_spirit_vessel_custom_passive:GetModifierConstantManaRegen()
	return self.bonus_mana_regen
end

function modifier_item_spirit_vessel_custom_passive:GetModifierPhysicalArmorBonus()
	return self.bonus_armor
end

function modifier_item_spirit_vessel_custom_passive:GetModifierBonusStats_Agility()
	return self.bonus_agility
end

function modifier_item_spirit_vessel_custom_passive:GetModifierBonusStats_Intellect()
	return self.bonus_intelligence
end

function modifier_item_spirit_vessel_custom_passive:GetModifierBonusStats_Strength()
	return self.bonus_strength
end

function modifier_item_spirit_vessel_custom_passive:GetModifierHealthBonus()
	return self.health_bonus
end

function modifier_item_spirit_vessel_custom_passive:OnDeath(params)
	local target = params.unit
		
	if not self:GetCaster():IsRealHero() then return end
	if not target:IsRealHero() then return end
	if self:GetCaster():GetTeamNumber() == target:GetTeamNumber() then return end
	if target:IsReincarnating() then return end
	if self:GetParent():HasModifier("modifier_item_soul_keeper_custom_passive") then return end

	if (self:GetCaster():GetAbsOrigin() - target:GetAbsOrigin()):Length2D() <= self.radius or params.attacker and params.attacker == self:GetCaster() then
		self.item:SetCurrentCharges(self.item:GetCurrentCharges() + 1)
	end
end

function modifier_item_spirit_vessel_custom_passive:OnDestroy()
    if not IsServer() then return end
    local charges    = self.item:GetCurrentCharges()
    local parent     = self:GetParent()
    Timers:CreateTimer(0.1, function()
        if not parent:IsNull() and self.item:IsNull() then
            local item_vessel = parent:FindItemInInventory("item_soul_keeper_custom")
            if item_vessel then
                item_vessel:SetCurrentCharges(math.max(charges, item_vessel:GetCurrentCharges()))
            end
        end
    end)
end



modifier_item_spirit_vessel_custom_active_ally = class({})

function modifier_item_spirit_vessel_custom_active_ally:IsDebuff() return false end
function modifier_item_spirit_vessel_custom_active_ally:IsHidden() return false end
function modifier_item_spirit_vessel_custom_active_ally:IsPurgable() return true end

function modifier_item_spirit_vessel_custom_active_ally:OnCreated( params )
self.health_regen = self:GetAbility():GetSpecialValueFor("soul_heal_amount")
	if not IsServer() then return end
	if not self:GetAbility() then self:Destroy() return end
end

function modifier_item_spirit_vessel_custom_active_ally:DeclareFunctions()
	local decFuns =
		{
			MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,
			MODIFIER_EVENT_ON_TAKEDAMAGE
		}
	return decFuns
end

function modifier_item_spirit_vessel_custom_active_ally:GetEffectName()
	return "particles/items2_fx/urn_of_shadows_heal.vpcf"
end

function modifier_item_spirit_vessel_custom_active_ally:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end

function modifier_item_spirit_vessel_custom_active_ally:GetModifierConstantHealthRegen()
	return self.health_regen
end

function modifier_item_spirit_vessel_custom_active_ally:OnTakeDamage(keys)
if not keys.attacker or not keys.attacker:IsHero() then return end


local unit = keys.unit
local parent = self:GetParent()

    if  unit == parent then
        self:Destroy()
    end
end


modifier_item_spirit_vessel_custom_active_enemy = class({})

function modifier_item_spirit_vessel_custom_active_enemy:IsDebuff() return true end
function modifier_item_spirit_vessel_custom_active_enemy:IsHidden() return false end
function modifier_item_spirit_vessel_custom_active_enemy:IsPurgable() return true end
function modifier_item_spirit_vessel_custom_active_enemy:IsStunDebuff() return false end
function modifier_item_spirit_vessel_custom_active_enemy:RemoveOnDeath() return true end

function modifier_item_spirit_vessel_custom_active_enemy:GetEffectName()
	return "particles/items4_fx/spirit_vessel_damage.vpcf"
end

function modifier_item_spirit_vessel_custom_active_enemy:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end

function modifier_item_spirit_vessel_custom_active_enemy:OnCreated( params )
	if IsServer() then
		if not self:GetAbility() then self:Destroy() return end
	end
	self.damage_per_second = self:GetAbility():GetSpecialValueFor("soul_damage_amount")
	self.enemy_hp_drain = self:GetAbility():GetSpecialValueFor("enemy_hp_drain") / 100
	self.hp_reduction_heal = -1 * self:GetAbility():GetSpecialValueFor("hp_regen_reduction_enemy")
	self:StartIntervalThink(1)
end

function modifier_item_spirit_vessel_custom_active_enemy:OnIntervalThink()
	if not IsServer() then return end
	local damageTable = {
		victim = self:GetParent(),
		attacker = self:GetCaster(),
		damage = self.damage_per_second + (self:GetParent():GetHealth()*self.enemy_hp_drain),
		damage_type = DAMAGE_TYPE_MAGICAL,
		ability = self:GetAbility()
	}
	ApplyDamage(damageTable)
end

function modifier_item_spirit_vessel_custom_active_enemy:DeclareFunctions()
return 
    {
        MODIFIER_PROPERTY_HP_REGEN_AMPLIFY_PERCENTAGE,
        MODIFIER_PROPERTY_LIFESTEAL_AMPLIFY_PERCENTAGE,
        MODIFIER_PROPERTY_HEAL_AMPLIFY_PERCENTAGE_TARGET,
    }
end

function modifier_item_spirit_vessel_custom_active_enemy:GetModifierLifestealRegenAmplify_Percentage()
    return self.hp_reduction_heal
end

function modifier_item_spirit_vessel_custom_active_enemy:GetModifierHealAmplify_PercentageTarget()
    return self.hp_reduction_heal
end

function modifier_item_spirit_vessel_custom_active_enemy:GetModifierHPRegenAmplify_Percentage()
    return self.hp_reduction_heal
end