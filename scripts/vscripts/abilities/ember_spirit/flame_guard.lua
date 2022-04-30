LinkLuaModifier("modifier_ember_spirit_flame_guard_custom", "abilities/ember_spirit/flame_guard", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_ember_spirit_flame_guard_custom_stack", "abilities/ember_spirit/flame_guard", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_ember_spirit_flame_guard_stack_aura", "abilities/ember_spirit/flame_guard", LUA_MODIFIER_MOTION_NONE)

ember_spirit_flame_guard_custom = class({})

ember_spirit_flame_guard_custom.base_init = 0.05
ember_spirit_flame_guard_custom.base_inc = 0.05

ember_spirit_flame_guard_custom.armor_init = 3
ember_spirit_flame_guard_custom.armor_inc = 3

ember_spirit_flame_guard_custom.damage_init = 0
ember_spirit_flame_guard_custom.damage_inc = 25

ember_spirit_flame_guard_custom.stack_interval = 1
ember_spirit_flame_guard_custom.stack_max = 6
ember_spirit_flame_guard_custom.stack_init = 0.05
ember_spirit_flame_guard_custom.stack_inc = 0.05

ember_spirit_flame_guard_custom.purge_stun = 1.5 
ember_spirit_flame_guard_custom.purge_cd = 10

ember_spirit_flame_guard_custom.legendary_damage = 0.6
ember_spirit_flame_guard_custom.legendary_regen = 6

function ember_spirit_flame_guard_custom:OnSpellStart()
if not IsServer() then return end
	local caster = self:GetCaster()
	local duration = self:GetSpecialValueFor("duration")
		
	caster:EmitSound("Hero_EmberSpirit.FlameGuard.Cast")

	if caster:FindModifierByName("modifier_ember_spirit_flame_guard_custom") then
		caster:FindModifierByName("modifier_ember_spirit_flame_guard_custom"):Destroy()
	end
	caster:AddNewModifier(caster, self, "modifier_ember_spirit_flame_guard_custom", {duration = duration})

end

modifier_ember_spirit_flame_guard_custom = class({})

function modifier_ember_spirit_flame_guard_custom:IsDebuff() return false end
function modifier_ember_spirit_flame_guard_custom:IsHidden() return false end
function modifier_ember_spirit_flame_guard_custom:IsPurgable() 
return not self:GetParent():HasModifier("modifier_ember_guard_legendary")
end



function modifier_ember_spirit_flame_guard_custom:OnCreated(keys)
if not IsServer() then return end

self.RemoveForDuel = true

self.block_amount = self:GetAbility():GetSpecialValueFor("damage_block")/100

self.effect_radius = self:GetAbility():GetSpecialValueFor("radius")

if self:GetParent():HasModifier("modifier_ember_guard_4") then 
	self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_ember_spirit_flame_guard_stack_aura", {})
end
	
self.destroyed = true
self.destroy_count = 0

self.particle_index = ParticleManager:CreateParticle("particles/units/heroes/hero_ember_spirit/ember_spirit_flameguard.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
ParticleManager:SetParticleControlEnt(self.particle_index, 0, self:GetParent(), PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", self:GetParent():GetAbsOrigin(), true)
ParticleManager:SetParticleControlEnt(self.particle_index, 1, self:GetParent(), PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", self:GetParent():GetAbsOrigin(), true)
ParticleManager:SetParticleControl(self.particle_index, 2, Vector(self.effect_radius,0,0))
ParticleManager:SetParticleControl(self.particle_index, 3, Vector(125,0,0))
self:AddParticle(self.particle_index, false, false, -1, false, false ) 



self.tick_interval = self:GetAbility():GetSpecialValueFor("tick_interval")
self.damage = self:GetAbility():GetSpecialValueFor("damage_per_second") 


if self:GetParent():HasModifier("modifier_ember_guard_3") then 
	self.damage = self.damage + self:GetAbility().damage_init + self:GetAbility().damage_inc*self:GetParent():GetUpgradeStack("modifier_ember_guard_3")
end

self.damage = self.damage*self.tick_interval

self.remaining_health = self:GetAbility():GetSpecialValueFor("absorb_amount")


if self:GetParent():HasModifier("modifier_ember_guard_1") then 
	self.remaining_health = self.remaining_health + self:GetParent():GetMaxHealth()*(self:GetAbility().base_init + self:GetAbility().base_inc*self:GetParent():GetUpgradeStack("modifier_ember_guard_1"))
end


self:SetStackCount(self.remaining_health)
self:StartIntervalThink(self.tick_interval)
self:GetParent():EmitSound("Hero_EmberSpirit.FlameGuard.Loop")

end

function modifier_ember_spirit_flame_guard_custom:OnDestroy()
if not IsServer() then return end
self:GetParent():StopSound("Hero_EmberSpirit.FlameGuard.Loop")

if self:GetParent():HasModifier("modifier_ember_spirit_flame_guard_stack_aura") then 
	self:GetParent():RemoveModifierByName("modifier_ember_spirit_flame_guard_stack_aura")
end



if self:GetParent():HasModifier("modifier_ember_guard_6") and self.destroyed == true then 
	local cd = self:GetAbility():GetCooldownTimeRemaining()
	
	self:GetAbility():EndCooldown()

	if cd > self:GetAbility().purge_cd then 
		self:GetAbility():StartCooldown(cd - self:GetAbility().purge_cd)
	end

	local nearby_enemies = FindUnitsInRadius(self:GetParent():GetTeamNumber(), self:GetParent():GetAbsOrigin(), nil, self.effect_radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
	for _, enemy in pairs(nearby_enemies) do
		enemy:AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_stunned", {duration = self:GetAbility().purge_stun*(1 - enemy:GetStatusResistance())})
		
		local particle_index = ParticleManager:CreateParticle("particles/units/heroes/hero_ogre_magi/ogre_magi_fireblast.vpcf", PATTACH_ABSORIGIN_FOLLOW, enemy)
		ParticleManager:SetParticleControl(particle_index, 0, enemy:GetAbsOrigin())
		ParticleManager:SetParticleControl(particle_index, 1, enemy:GetAbsOrigin())
		enemy:EmitSound("Hero_OgreMagi.Fireblast.Target")

	end

end

end

function modifier_ember_spirit_flame_guard_custom:OnIntervalThink()
if not IsServer() then return end


	self.destroy_count = self.destroy_count + self.tick_interval
	if self.destroy_count >= self:GetAbility():GetSpecialValueFor("duration") - self.tick_interval then
		self.destroyed = false
	end


	if self.remaining_health <= 0 then
		self:Destroy()
	else
		local nearby_enemies = FindUnitsInRadius(self:GetParent():GetTeamNumber(), self:GetParent():GetAbsOrigin(), nil, self.effect_radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_BUILDING, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
		for _, enemy in pairs(nearby_enemies) do

			local damage = self.damage

			if self:GetParent():HasModifier("modifier_ember_guard_legendary") then 
				damage = damage*(1 + self:GetAbility().legendary_damage*(1 - self:GetParent():GetHealthPercent()/100))
			end

			if enemy:HasModifier("modifier_ember_spirit_flame_guard_custom_stack") then 
 				local stack = enemy:FindModifierByName("modifier_ember_spirit_flame_guard_custom_stack"):GetStackCount()
 				damage = damage + damage*stack*(self:GetAbility().stack_init + self:GetAbility().stack_inc*self:GetCaster():GetUpgradeStack("modifier_ember_guard_4"))
			end

			if enemy:IsBuilding() then 
				damage = damage*self:GetAbility():GetSpecialValueFor("building_damage")/100
			end

			ApplyDamage({victim = enemy, attacker = self:GetCaster(), ability = self:GetAbility(), damage = damage, damage_type = DAMAGE_TYPE_MAGICAL})
		end
	end

end

function modifier_ember_spirit_flame_guard_custom:DeclareFunctions()
return 
{
	MODIFIER_PROPERTY_TOTAL_CONSTANT_BLOCK,
	MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
	MODIFIER_PROPERTY_MIN_HEALTH,
	MODIFIER_EVENT_ON_TAKEDAMAGE,
	MODIFIER_PROPERTY_HEALTH_REGEN_PERCENTAGE
}
end


function modifier_ember_spirit_flame_guard_custom:GetModifierHealthRegenPercentage()
local regen = 0

if self:GetParent():HasModifier("modifier_ember_guard_legendary") then 
	regen = self:GetAbility().legendary_regen*(100 - self:GetParent():GetHealthPercent())/100
end

return regen
end



function modifier_ember_spirit_flame_guard_custom:GetMinHealth()
if not self:GetParent():HasModifier("modifier_ember_guard_5") then return end
if self:GetParent():HasModifier("modifier_death") then return end
return 1
end


function modifier_ember_spirit_flame_guard_custom:OnTakeDamage(params)
if not IsServer() then return end
if not self:GetParent():HasModifier("modifier_ember_guard_5") then return end
if self:GetParent():GetHealth() > 1 then return end
if self:GetParent():HasModifier("modifier_death") then return end


local heal = self.remaining_health
self:GetParent():Heal(heal, self:GetAbility())

self:GetParent():EmitSound("Ember.Guard_Lowhp")

local effect_target = ParticleManager:CreateParticle( "particles/econ/items/omniknight/hammer_ti6_immortal/ember_shield_heal.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
ParticleManager:SetParticleControl( effect_target, 1, Vector( 200, 100, 100 ) )
ParticleManager:ReleaseParticleIndex( effect_target )

self:GetParent():Purge(false, true, false, true, false)
local particle = ParticleManager:CreateParticle( "particles/generic_gameplay/generic_lifesteal.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
ParticleManager:ReleaseParticleIndex( particle )

SendOverheadEventMessage(self:GetParent(), 10, self:GetParent(), heal, nil)
self:Destroy()
end


function modifier_ember_spirit_flame_guard_custom:GetModifierPhysicalArmorBonus()
if not self:GetParent():HasModifier("modifier_ember_guard_2") then return end
return self:GetAbility().armor_init + self:GetAbility().armor_inc*self:GetParent():GetUpgradeStack("modifier_ember_guard_2")
end


function modifier_ember_spirit_flame_guard_custom:GetModifierTotal_ConstantBlock(params)
    if not IsServer() then return end

    if self:GetParent() == params.attacker then return end

    if self.remaining_health == 0 then return end
    
    if params.damage_type ~= DAMAGE_TYPE_MAGICAL then return end

    local mod = self:GetParent():FindModifierByName("modifier_magic_shield")

    if mod and mod:GetStackCount() > 0 then
        return
    end
    
    local blocked_damage = params.damage*self.block_amount

    if self.remaining_health > blocked_damage then
        self.remaining_health = self.remaining_health - blocked_damage
        self:SetStackCount(self.remaining_health)
        local i = blocked_damage
        return i
    else
        local i = self.remaining_health
        self:Destroy()
        return i
    end
end


modifier_ember_spirit_flame_guard_custom_stack = class({})
function modifier_ember_spirit_flame_guard_custom_stack:IsHidden() return false end
function modifier_ember_spirit_flame_guard_custom_stack:IsPurgable() return false end
function modifier_ember_spirit_flame_guard_custom_stack:OnCreated(table)
if not IsServer() then return end
self:SetStackCount(0)
self:StartIntervalThink(self:GetAbility().stack_interval)
end

function modifier_ember_spirit_flame_guard_custom_stack:OnIntervalThink()
if not IsServer() then return end
if self:GetStackCount() >= self:GetAbility().stack_max then return end
self:IncrementStackCount()
end


function modifier_ember_spirit_flame_guard_custom_stack:DeclareFunctions()
return
{
  MODIFIER_PROPERTY_TOOLTIP
}
end
function modifier_ember_spirit_flame_guard_custom_stack:OnTooltip()
return 100*self:GetStackCount()*(self:GetAbility().stack_init + self:GetAbility().stack_inc*self:GetCaster():GetUpgradeStack("modifier_ember_guard_4"))
end

function modifier_ember_spirit_flame_guard_custom_stack:OnStackCountChanged(iStackCount)
if self:GetStackCount() == 0 then return end
if not self.effect_cast then 

	local particle_cast = "particles/units/heroes/hero_marci/marci_unleash_stack.vpcf"

	self.effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_OVERHEAD_FOLLOW, self:GetParent() )
	ParticleManager:SetParticleControl( self.effect_cast, 1, Vector( 0, self:GetStackCount(), 0 ) )

	self:AddParticle(self.effect_cast,false, false, -1, false, false)
else 

  ParticleManager:SetParticleControl( self.effect_cast, 1, Vector( 0, self:GetStackCount(), 0 ) )

end

end




modifier_ember_spirit_flame_guard_stack_aura = class({})

function modifier_ember_spirit_flame_guard_stack_aura:IsDebuff() return false end
function modifier_ember_spirit_flame_guard_stack_aura:IsHidden() return true end
function modifier_ember_spirit_flame_guard_stack_aura:IsPurgable() return false end

function modifier_ember_spirit_flame_guard_stack_aura:GetAuraRadius()
	return self:GetAbility():GetSpecialValueFor("radius")
end

function modifier_ember_spirit_flame_guard_stack_aura:GetAuraSearchFlags()
	return DOTA_UNIT_TARGET_FLAG_NONE
end

function modifier_ember_spirit_flame_guard_stack_aura:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_ENEMY
end

function modifier_ember_spirit_flame_guard_stack_aura:GetAuraSearchType()
	return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
end

function modifier_ember_spirit_flame_guard_stack_aura:GetModifierAura()
	return "modifier_ember_spirit_flame_guard_custom_stack"

end

function modifier_ember_spirit_flame_guard_stack_aura:IsAura()

return true
end