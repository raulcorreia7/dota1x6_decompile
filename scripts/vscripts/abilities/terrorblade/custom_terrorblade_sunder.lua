LinkLuaModifier("modifier_custom_terrorblade_sunder_legendary", "abilities/terrorblade/custom_terrorblade_sunder", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_custom_terrorblade_sunder_incoming", "abilities/terrorblade/custom_terrorblade_sunder", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_custom_terrorblade_sunder_tracker", "abilities/terrorblade/custom_terrorblade_sunder", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_custom_terrorblade_sunder_stats", "abilities/terrorblade/custom_terrorblade_sunder", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_custom_terrorblade_sunder_stats_self", "abilities/terrorblade/custom_terrorblade_sunder", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_custom_terrorblade_sunder_lifesteal", "abilities/terrorblade/custom_terrorblade_sunder", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_custom_terrorblade_sunder_rooted", "abilities/terrorblade/custom_terrorblade_sunder", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_custom_terrorblade_sunder_bkb", "abilities/terrorblade/custom_terrorblade_sunder", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_custom_terrorblade_sunder_damage", "abilities/terrorblade/custom_terrorblade_sunder", LUA_MODIFIER_MOTION_NONE)

custom_terrorblade_sunder = class({})

custom_terrorblade_sunder.lifesteal_init = 0.2
custom_terrorblade_sunder.lifesteal_inc = 0.1
custom_terrorblade_sunder.lifesteal_duration = 6

custom_terrorblade_sunder.creep_init = 0.1
custom_terrorblade_sunder.creep_inc = 0.1
custom_terrorblade_sunder.creep_cd = 0.5

custom_terrorblade_sunder.amplify_init = 0
custom_terrorblade_sunder.amplify_inc = -10
custom_terrorblade_sunder.amplify_duration = 6

custom_terrorblade_sunder.stun_range = 250
custom_terrorblade_sunder.stun_stun = 3 	

custom_terrorblade_sunder.bkb_duration = 3

custom_terrorblade_sunder.legendary_interval = 1
custom_terrorblade_sunder.legendary_heal = 0.25
custom_terrorblade_sunder.legendary_duration = 3.1
custom_terrorblade_sunder.legendary_cd = 15

custom_terrorblade_sunder.stats_duration = 10
custom_terrorblade_sunder.stats_init = 0
custom_terrorblade_sunder.stats_inc = 0.1

custom_terrorblade_sunder.damage_duration = 5
custom_terrorblade_sunder.damage_total = {0.1, 0.15, 0.2}
custom_terrorblade_sunder.damage_interval = 1
custom_terrorblade_sunder.damage_creeps = 1


function custom_terrorblade_sunder:GetIntrinsicModifierName()
return "modifier_custom_terrorblade_sunder_tracker"
end


function custom_terrorblade_sunder:GetCastRange(vLocation, hTarget)
local upgrade = self.stun_range*self:GetCaster():GetUpgradeStack("modifier_terror_sunder_swap")
 return self.BaseClass.GetCastRange(self , vLocation , hTarget) + upgrade 
end


function custom_terrorblade_sunder:GetCooldown(iLevel)
if self:GetCaster():HasModifier("modifier_terror_sunder_legendary") then 
	return self.legendary_cd
end

return self.BaseClass.GetCooldown(self, iLevel)
end


function custom_terrorblade_sunder:CastFilterResultTarget(target)
	if target == self:GetCaster() then
		return UF_FAIL_CUSTOM
	end

	if target ~= nil and target:IsMagicImmune()  then
		return UF_FAIL_MAGIC_IMMUNE_ENEMY
	end

	if self:GetCaster():HasModifier("modifier_terror_sunder_legendary") then 
		return UnitFilter(target, DOTA_UNIT_TARGET_TEAM_BOTH, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_CHECK_DISABLE_HELP, self:GetCaster():GetTeamNumber())
	else
		return UnitFilter(target, DOTA_UNIT_TARGET_TEAM_BOTH, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NOT_CREEP_HERO + DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_CHECK_DISABLE_HELP, self:GetCaster():GetTeamNumber())
	end
end

function custom_terrorblade_sunder:GetCustomCastErrorTarget(target)
	if target == self:GetCaster() then
		return "#dota_hud_error_cant_cast_on_self"
	end
end

function custom_terrorblade_sunder:PlayEffect(target)
if not IsServer() then return end
self:GetCaster():EmitSound("Hero_Terrorblade.Sunder.Cast")
target:EmitSound("Hero_Terrorblade.Sunder.Target")


local effect_name = "particles/units/heroes/hero_terrorblade/terrorblade_sunder.vpcf"

if self:GetCaster() ~= nil and self:GetCaster():IsHero() then
local children = self:GetCaster():GetChildren()
	for k,child in pairs(children) do

	    if child:GetClassname() == "dota_item_wearable" then
	        if child:GetModelName() == "models/items/terrorblade/terrorblade_ti8_immortal_back/terrorblade_ti8_immortal_back.vmdl" then
	            effect_name = "particles/econ/items/terrorblade/terrorblade_back_ti8/terrorblade_sunder_ti8.vpcf"
	            break
	        end
	    end
	end
end 


local sunder_particle_1 = ParticleManager:CreateParticle(effect_name, PATTACH_ABSORIGIN_FOLLOW, target)
ParticleManager:SetParticleControlEnt(sunder_particle_1, 0, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), true)
ParticleManager:SetParticleControlEnt(sunder_particle_1, 1, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetCaster():GetAbsOrigin(), true)
ParticleManager:SetParticleControl(sunder_particle_1, 2, target:GetAbsOrigin())
ParticleManager:SetParticleControl(sunder_particle_1, 15, Vector(0,152,255))
ParticleManager:SetParticleControl(sunder_particle_1, 16, Vector(1,0,0))
ParticleManager:ReleaseParticleIndex(sunder_particle_1)

local sunder_particle_2 = ParticleManager:CreateParticle(effect_name, PATTACH_ABSORIGIN_FOLLOW, self:GetCaster())
ParticleManager:SetParticleControlEnt(sunder_particle_2, 0, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetCaster():GetAbsOrigin(), true)
ParticleManager:SetParticleControlEnt(sunder_particle_2, 1, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), true)
ParticleManager:SetParticleControl(sunder_particle_2, 2, self:GetCaster():GetAbsOrigin())
ParticleManager:SetParticleControl(sunder_particle_2, 15, Vector(0,152,255))
ParticleManager:SetParticleControl(sunder_particle_2, 16, Vector(1,0,0))
ParticleManager:ReleaseParticleIndex(sunder_particle_2)

end

function custom_terrorblade_sunder:OnSpellStart(new_target)
if not IsServer() then return end

local target = self:GetCursorTarget()
if new_target then 
	target = new_target
end

if target:TriggerSpellAbsorb(self) then return end

	local illusion_kill = false

	if (target:IsIllusion() and self:GetCaster():GetTeamNumber() == target:GetTeamNumber()) and self:GetCaster():HasModifier("modifier_terror_sunder_heal") then
		illusion_kill = true
	else


		if self:GetCaster():HasModifier("modifier_terror_sunder_legendary") and target ~= nil then 
			self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_custom_terrorblade_sunder_legendary", {duration = self.legendary_duration, target = target:entindex()})
		else 
			local caster_health_percent	= self:GetCaster():GetHealthPercent()
			local target_health_percent	= target:GetHealthPercent()

			local current_health = self:GetCaster():GetHealth()

			self:PlayEffect(target)

			self:GetCaster():SetHealth(self:GetCaster():GetMaxHealth() * math.max(target_health_percent, self:GetSpecialValueFor("hit_point_minimum_pct")) * 0.01)
			target:SetHealth(target:GetMaxHealth() * math.max(caster_health_percent, self:GetSpecialValueFor("hit_point_minimum_pct")) * 0.01)

		end

	end

	if self:GetCaster():HasModifier("modifier_terror_sunder_amplify") then
		self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_custom_terrorblade_sunder_incoming", {duration = self.amplify_duration})
	end


	if  self:GetCaster():HasModifier("modifier_terror_sunder_damage") then 
		target:AddNewModifier(self:GetCaster(), self, "modifier_custom_terrorblade_sunder_lifesteal", {duration = self.lifesteal_duration})
	end




	mod = self:GetCaster():FindModifierByName("modifier_custom_terrorblade_sunder_stats_self")
	if mod then 
		mod:Destroy()
	end

	mod = target:FindModifierByName("modifier_custom_terrorblade_sunder_stats")
	if mod then 
		mod:Destroy()
	end

	if self:GetCaster():HasModifier("modifier_terror_sunder_stats") then 
		target:AddNewModifier(self:GetCaster(), self, "modifier_custom_terrorblade_sunder_stats", {duration = self.stats_duration})  
	end



	if self:GetCaster():HasModifier("modifier_terror_sunder_swap") and target:GetTeamNumber() ~= self:GetCaster():GetTeamNumber() then 
		target:AddNewModifier(self:GetCaster(), self, "modifier_custom_terrorblade_sunder_rooted", {duration = (1 - target:GetStatusResistance())*self.stun_stun})
	end

	if self:GetCaster():HasModifier("modifier_terror_sunder_cd") then 
		target:AddNewModifier(self:GetCaster(), self, "modifier_custom_terrorblade_sunder_damage", {duration = self.damage_duration})
	end


	if illusion_kill == true then 
		self:PlayEffect(target)
		target:ForceKill(false)
		self:EndCooldown()
		self:GetCaster():Purge(false, true, false, false, false)
		self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_custom_terrorblade_sunder_bkb", {duration = self.bkb_duration})
	end
		


end





modifier_custom_terrorblade_sunder_legendary = class({})
function modifier_custom_terrorblade_sunder_legendary:IsHidden() return true end
function modifier_custom_terrorblade_sunder_legendary:IsPurgable() return false end
function modifier_custom_terrorblade_sunder_legendary:OnCreated(table)
self.target = EntIndexToHScript(table.target)

if not IsServer() then return end
self:OnIntervalThink()
self:StartIntervalThink(self:GetAbility().legendary_interval)

end

function modifier_custom_terrorblade_sunder_legendary:OnIntervalThink()
if not IsServer() then return end
if not self.target:IsAlive() then 
	self:Destroy()
	return
end

local heal = (self:GetCaster():GetMaxHealth() - self:GetCaster():GetHealth())*self:GetAbility().legendary_heal

self:GetCaster():SetHealth(self:GetCaster():GetHealth() + heal)

SendOverheadEventMessage(self:GetCaster(), 10, self:GetCaster(), heal, nil)
local damageTable = {
    victim      = self.target,
    damage      = heal,
    damage_type   = DAMAGE_TYPE_PURE,
    damage_flags  = DOTA_DAMAGE_FLAG_NONE,
    attacker    = self:GetCaster(),
    ability     = self:GetAbility()
 }
    
ApplyDamage(damageTable)


self:GetAbility():PlayEffect(self.target)
end





modifier_custom_terrorblade_sunder_incoming = class({})
function modifier_custom_terrorblade_sunder_incoming:IsHidden() return false end
function modifier_custom_terrorblade_sunder_incoming:IsPurgable() return false end
function modifier_custom_terrorblade_sunder_incoming:GetTexture() return "buffs/sunder_amplify" end
function modifier_custom_terrorblade_sunder_incoming:DeclareFunctions()
return
{
MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE
}

end

function modifier_custom_terrorblade_sunder_incoming:GetModifierIncomingDamage_Percentage() return 
self:GetAbility().amplify_init + self:GetAbility().amplify_inc*self:GetCaster():GetUpgradeStack("modifier_terror_sunder_amplify")
end




modifier_custom_terrorblade_sunder_tracker = class({})
function modifier_custom_terrorblade_sunder_tracker:IsHidden() return true end
function modifier_custom_terrorblade_sunder_tracker:IsPurgable() return false end
function modifier_custom_terrorblade_sunder_tracker:RemoveOnDeath() return false end
function modifier_custom_terrorblade_sunder_tracker:DeclareFunctions()
return
{
}
end








modifier_custom_terrorblade_sunder_stats = class({})
function modifier_custom_terrorblade_sunder_stats:IsHidden() return false end
function modifier_custom_terrorblade_sunder_stats:IsPurgable() return false end
function modifier_custom_terrorblade_sunder_stats:IsDebuff() return true end
function modifier_custom_terrorblade_sunder_stats:GetTexture() return "buffs/sunder_stats" end


function modifier_custom_terrorblade_sunder_stats:OnCreated(table)
if not IsServer() then return end

self.RemoveForDuel = true
self:SetHasCustomTransmitterData(true)

local k = self:GetAbility().stats_init + self:GetAbility().stats_inc*self:GetCaster():GetUpgradeStack("modifier_terror_sunder_stats")
k = k * -1
self.armor = self:GetParent():GetPhysicalArmorValue(false)*k
self.speed = self:GetParent():GetMoveSpeedModifier(self:GetParent():GetBaseMoveSpeed(), false)*k
self.damage = self:GetParent():GetAverageTrueAttackDamage(nil)*k

if self:GetParent():GetPhysicalArmorValue(false) <= 0 then 
self.armor = 0
end

if self:GetParent():GetAverageTrueAttackDamage(nil) <= 0 then 
self.damage = 0
end


self:GetCaster():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_custom_terrorblade_sunder_stats_self", {duration = self:GetRemainingTime(), armor = self.armor*-1, damage = self.damage*-1, speed = self.speed*-1})

end



function modifier_custom_terrorblade_sunder_stats:AddCustomTransmitterData() return {
speed = self.speed,
armor = self.armor,
damage = self.damage

} end

function modifier_custom_terrorblade_sunder_stats:HandleCustomTransmitterData(data)
self.speed = data.speed
self.armor = data.armor
self.damage = data.damage
end




function modifier_custom_terrorblade_sunder_stats:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
	MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
	MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT
}
end

function modifier_custom_terrorblade_sunder_stats:GetModifierMoveSpeedBonus_Constant() return self.speed end
function modifier_custom_terrorblade_sunder_stats:GetModifierPhysicalArmorBonus() return self.armor end
function modifier_custom_terrorblade_sunder_stats:GetModifierPreAttack_BonusDamage() return self.damage end





modifier_custom_terrorblade_sunder_stats_self = class({})
function modifier_custom_terrorblade_sunder_stats_self:IsHidden() return false end
function modifier_custom_terrorblade_sunder_stats_self:IsPurgable() return false end
function modifier_custom_terrorblade_sunder_stats_self:GetTexture() return "buffs/sunder_stats" end


function modifier_custom_terrorblade_sunder_stats_self:OnCreated(table)
if not IsServer() then return end
self.RemoveForDuel = true
self:SetHasCustomTransmitterData(true)

self.armor = table.armor
self.speed = table.speed
self.damage = table.damage


end



function modifier_custom_terrorblade_sunder_stats_self:AddCustomTransmitterData() return {
speed = self.speed,
armor = self.armor,
damage = self.damage

} end

function modifier_custom_terrorblade_sunder_stats_self:HandleCustomTransmitterData(data)
self.speed = data.speed
self.armor = data.armor
self.damage = data.damage
end




function modifier_custom_terrorblade_sunder_stats_self:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
	MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
	MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT
}
end

function modifier_custom_terrorblade_sunder_stats_self:GetModifierMoveSpeedBonus_Constant() return self.speed end
function modifier_custom_terrorblade_sunder_stats_self:GetModifierPhysicalArmorBonus() return self.armor end
function modifier_custom_terrorblade_sunder_stats_self:GetModifierPreAttack_BonusDamage() return self.damage end


modifier_custom_terrorblade_sunder_lifesteal = class({})
function modifier_custom_terrorblade_sunder_lifesteal:IsHidden() return false end
function modifier_custom_terrorblade_sunder_lifesteal:IsPurgable() return true end
function modifier_custom_terrorblade_sunder_lifesteal:GetTexture() return "buffs/sunder_speed" end


function modifier_custom_terrorblade_sunder_lifesteal:DeclareFunctions()
return
{
	MODIFIER_EVENT_ON_TAKEDAMAGE,
	MODIFIER_PROPERTY_TOOLTIP
}
end
function modifier_custom_terrorblade_sunder_lifesteal:OnTakeDamage(params)
if not IsServer() then return end
if self:GetParent() ~= params.unit then return end

local heal = (self:GetAbility().lifesteal_init + self:GetAbility().lifesteal_inc*self:GetCaster():GetUpgradeStack("modifier_terror_sunder_damage"))*params.damage


self:GetCaster():Heal(heal, self:GetAbility())

SendOverheadEventMessage(self:GetCaster(), 10, self:GetCaster(), heal, nil)

local particle = ParticleManager:CreateParticle( "particles/generic_gameplay/generic_lifesteal.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster() )
ParticleManager:ReleaseParticleIndex( particle )
end



function modifier_custom_terrorblade_sunder_lifesteal:OnTooltip()
return (self:GetAbility().lifesteal_init + self:GetAbility().lifesteal_inc*self:GetCaster():GetUpgradeStack("modifier_terror_sunder_damage"))*100
end

modifier_custom_terrorblade_sunder_rooted = class({})
function modifier_custom_terrorblade_sunder_rooted:IsHidden() return true end
function modifier_custom_terrorblade_sunder_rooted:IsPurgable() return true end
function modifier_custom_terrorblade_sunder_rooted:CheckState()
return
{
	[MODIFIER_STATE_ROOTED] = true
}
end
function modifier_custom_terrorblade_sunder_rooted:GetEffectName() return "particles/items3_fx/gleipnir_root.vpcf" end




modifier_custom_terrorblade_sunder_bkb = class({})
function modifier_custom_terrorblade_sunder_bkb:IsHidden() return false end
function modifier_custom_terrorblade_sunder_bkb:IsPurgable() return false end
function modifier_custom_terrorblade_sunder_bkb:GetTexture() return "buffs/sunder_heal" end
function modifier_custom_terrorblade_sunder_bkb:CheckState()
return
{
	[MODIFIER_STATE_MAGIC_IMMUNE] = true
}
end 
function modifier_custom_terrorblade_sunder_bkb:GetEffectName()
    return "particles/items_fx/black_king_bar_avatar.vpcf"
end

function modifier_custom_terrorblade_sunder_bkb:GetEffectAttachType()
    return PATTACH_ABSORIGIN_FOLLOW
end

modifier_custom_terrorblade_sunder_damage = class({})
function modifier_custom_terrorblade_sunder_damage:IsHidden() return false end
function modifier_custom_terrorblade_sunder_damage:IsPurgable() return false end
function modifier_custom_terrorblade_sunder_damage:GetTexture() return "buffs/sunder_damage" end

function modifier_custom_terrorblade_sunder_damage:OnCreated(table)
if not IsServer() then return end

self.tick = (self:GetAbility().damage_total[self:GetCaster():GetUpgradeStack("modifier_terror_sunder_cd")]/self:GetAbility().damage_duration)*self:GetParent():GetMaxHealth()
if self:GetParent():IsCreep() then 
	self.tick = self.tick*self:GetAbility().damage_creeps
end

self:StartIntervalThink(self:GetAbility().damage_interval)
end

function modifier_custom_terrorblade_sunder_damage:OnIntervalThink()
if not IsServer() then return end

local heal = self.tick


local damageTable = {
    victim      = self:GetParent(),
    damage      = heal,
    damage_type   = DAMAGE_TYPE_PURE,
    damage_flags  = DOTA_DAMAGE_FLAG_NONE,
    attacker    = self:GetCaster(),
    ability     = self:GetAbility()
 }
    
ApplyDamage(damageTable)

end