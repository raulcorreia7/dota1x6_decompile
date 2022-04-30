LinkLuaModifier("modifier_troll_warlord_berserkers_rage_custom", "abilities/troll_warlord/troll_warlord_berserkers_rage_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_troll_warlord_berserkers_rage_custom_ensnare", "abilities/troll_warlord/troll_warlord_berserkers_rage_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_troll_warlord_berserkers_rage_tracker", "abilities/troll_warlord/troll_warlord_berserkers_rage_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_troll_warlord_berserkers_rage_noattack", "abilities/troll_warlord/troll_warlord_berserkers_rage_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_troll_warlord_berserkers_rage_charge_stack", "abilities/troll_warlord/troll_warlord_berserkers_rage_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_troll_warlord_berserkers_rage_charge", "abilities/troll_warlord/troll_warlord_berserkers_rage_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_troll_warlord_berserkers_rage_charge_cd", "abilities/troll_warlord/troll_warlord_berserkers_rage_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_troll_warlord_berserkers_rage_ranged", "abilities/troll_warlord/troll_warlord_berserkers_rage_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_troll_warlord_berserkers_rage_slow", "abilities/troll_warlord/troll_warlord_berserkers_rage_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_troll_warlord_berserkers_rage_bloodrage", "abilities/troll_warlord/troll_warlord_berserkers_rage_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_troll_warlord_berserkers_rage_last_meele", "abilities/troll_warlord/troll_warlord_berserkers_rage_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_troll_warlord_berserkers_rage_last_range", "abilities/troll_warlord/troll_warlord_berserkers_rage_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_troll_warlord_berserkers_rage_lowhp_tracker", "abilities/troll_warlord/troll_warlord_berserkers_rage_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_troll_warlord_berserkers_rage_cd", "abilities/troll_warlord/troll_warlord_berserkers_rage_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_troll_warlord_berserkers_rage_charge_ready", "abilities/troll_warlord/troll_warlord_berserkers_rage_custom", LUA_MODIFIER_MOTION_NONE)



troll_warlord_berserkers_rage_custom = class({})

troll_warlord_berserkers_rage_custom.armor_init = 0
troll_warlord_berserkers_rage_custom.armor_inc = 2
troll_warlord_berserkers_rage_custom.move_init = 0
troll_warlord_berserkers_rage_custom.move_inc = 10

troll_warlord_berserkers_rage_custom.aoe_radius = 250
troll_warlord_berserkers_rage_custom.aoe_max = 1
troll_warlord_berserkers_rage_custom.aoe_damage_init = -90
troll_warlord_berserkers_rage_custom.aoe_damage_inc = 10

troll_warlord_berserkers_rage_custom.charge_stack_duration = 10
troll_warlord_berserkers_rage_custom.charge_max = 6
troll_warlord_berserkers_rage_custom.charge_max_range = 1200
troll_warlord_berserkers_rage_custom.charge_min_range = 300
troll_warlord_berserkers_rage_custom.charge_speed = 800
troll_warlord_berserkers_rage_custom.charge_charge_duration = 3
troll_warlord_berserkers_rage_custom.charge_stun = 1.2
troll_warlord_berserkers_rage_custom.charge_cd = 10
troll_warlord_berserkers_rage_custom.charge_ready = 5

troll_warlord_berserkers_rage_custom.legendary_slow = 1.2
troll_warlord_berserkers_rage_custom.legendary_range = 100
troll_warlord_berserkers_rage_custom.legendary_slow_move = -100

troll_warlord_berserkers_rage_custom.proc_damage_init = 0.004
troll_warlord_berserkers_rage_custom.proc_damage_inc = 0.004
troll_warlord_berserkers_rage_custom.proc_max = 6

troll_warlord_berserkers_rage_custom.stats_agi = {6,9,12}
troll_warlord_berserkers_rage_custom.stats_str = {6,9,12}

troll_warlord_berserkers_rage_custom.root_turn = -70
troll_warlord_berserkers_rage_custom.root_speed = -100
troll_warlord_berserkers_rage_custom.root_chance = 15	


function troll_warlord_berserkers_rage_custom:ProcsMagicStick()
	return false
end

function troll_warlord_berserkers_rage_custom:GetIntrinsicModifierName()
return "modifier_troll_warlord_berserkers_rage_tracker"
end

function troll_warlord_berserkers_rage_custom:ResetToggleOnRespawn()
	return false
end

function troll_warlord_berserkers_rage_custom:OnToggle()
	if not IsServer() then return end
	self:GetCaster():CalculateStatBonus(true)
	self:GetCaster():StartGesture(ACT_DOTA_CAST_ABILITY_1)
	if self:GetToggleState() then
		self.modifier = self:GetCaster():AddNewModifier( self:GetCaster(), self, "modifier_troll_warlord_berserkers_rage_custom", {} )

		if self:GetCaster():HasModifier("modifier_troll_warlord_berserkers_rage_ranged") then 
			self:GetCaster():RemoveModifierByName("modifier_troll_warlord_berserkers_rage_ranged")
		end

		if not self:GetCaster():HasModifier("modifier_troll_axes_legendary") then 
			self:GetCaster():FindAbilityByName("troll_warlord_whirling_axes_melee_custom"):SetActivated(true)
			self:GetCaster():FindAbilityByName("troll_warlord_whirling_axes_ranged_custom"):SetActivated(false)
		end

	else
		if self.modifier then
			self.modifier:Destroy()
			self.modifier = nil

			if self:GetCaster():HasModifier("modifier_troll_rage_legendary") then 
				self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_troll_warlord_berserkers_rage_ranged", {})
			end

			if not self:GetCaster():HasModifier("modifier_troll_axes_legendary") then 
				self:GetCaster():FindAbilityByName("troll_warlord_whirling_axes_melee_custom"):SetActivated(false)
				self:GetCaster():FindAbilityByName("troll_warlord_whirling_axes_ranged_custom"):SetActivated(true)
			end

		end
	end
	if self:GetCaster():HasModifier("modifier_troll_rage_4") and not self:GetCaster():HasModifier("modifier_troll_warlord_berserkers_rage_bloodrage") then 

		self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_troll_warlord_berserkers_rage_bloodrage", {})
		 	
		self:GetCaster():EmitSound("Troll.Bloodrage")
		local particle_peffect = ParticleManager:CreateParticle("particles/troll_heal_buf.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster())
		ParticleManager:SetParticleControl(particle_peffect, 0, self:GetCaster():GetAbsOrigin())
		ParticleManager:SetParticleControl(particle_peffect, 2, self:GetCaster():GetAbsOrigin())
		ParticleManager:ReleaseParticleIndex(particle_peffect)

	end
	self:GetCaster():EmitSound("Hero_TrollWarlord.BerserkersRage.Toggle")
end

function troll_warlord_berserkers_rage_custom:GetAbilityTextureName()
	if self:GetCaster():HasModifier("modifier_troll_warlord_berserkers_rage_custom") then
		return "troll_warlord_berserkers_rage_active"
	else
		return "troll_warlord_berserkers_rage"
	end
end

function troll_warlord_berserkers_rage_custom:OnUpgrade()
	if self.modifier then
		self.modifier:ForceRefresh()
	end
end

function troll_warlord_berserkers_rage_custom:OnProjectileHit(hTarget, vLocation)
	if not IsServer() then return end

	local ensnare_duration	= self:GetSpecialValueFor("ensnare_duration")

	if hTarget then
		hTarget:EmitSound("n_creep_TrollWarlord.Ensnare")
		if hTarget:IsAlive() then
			hTarget:AddNewModifier(self:GetCaster(), self, "modifier_troll_warlord_berserkers_rage_custom_ensnare", {duration = ensnare_duration * (1 - hTarget:GetStatusResistance())})
		end
	end
end

modifier_troll_warlord_berserkers_rage_custom_ensnare = class({})

function modifier_troll_warlord_berserkers_rage_custom_ensnare:GetEffectName()
	return "particles/units/heroes/hero_troll_warlord/troll_warlord_bersekers_net.vpcf"
end

function modifier_troll_warlord_berserkers_rage_custom_ensnare:CheckState()
	return {[MODIFIER_STATE_ROOTED] = true}
end


function modifier_troll_warlord_berserkers_rage_custom_ensnare:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_TURN_RATE_PERCENTAGE,
	MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT
}
end



function modifier_troll_warlord_berserkers_rage_custom_ensnare:GetModifierTurnRate_Percentage()
local bonus = 0

if self:GetCaster():HasModifier("modifier_troll_rage_6") then 
	bonus = self:GetAbility().root_turn
end

return bonus
end

function modifier_troll_warlord_berserkers_rage_custom_ensnare:GetModifierAttackSpeedBonus_Constant()
local bonus = 0

if self:GetCaster():HasModifier("modifier_troll_rage_6") then 
	bonus = self:GetAbility().root_speed
end

return bonus
end



modifier_troll_warlord_berserkers_rage_custom = class({})
function modifier_troll_warlord_berserkers_rage_custom:IsHidden() return true end

function modifier_troll_warlord_berserkers_rage_custom:IsPurgable() return false end
function modifier_troll_warlord_berserkers_rage_custom:RemoveOnDeath() return false end
function modifier_troll_warlord_berserkers_rage_custom:AllowIllusionDuplicate() return true end
function modifier_troll_warlord_berserkers_rage_custom:IsPurgeException() return false end

function modifier_troll_warlord_berserkers_rage_custom:OnCreated( kv )
	self.base_attack_time = self:GetAbility():GetSpecialValueFor( "base_attack_time" )
	self.bonus_move_speed = self:GetAbility():GetSpecialValueFor( "bonus_move_speed" )
	self.bonus_armor = self:GetAbility():GetSpecialValueFor( "bonus_armor" )
	self.melee_range = 150

	self.ensnare_chance = self:GetAbility():GetSpecialValueFor( "ensnare_chance" )

	self.delta_attack_range = self.melee_range - self:GetParent():Script_GetAttackRange()

	if not IsServer() then return end
	self.pre_attack_capability = self:GetParent():GetAttackCapability()
	self:GetParent():SetAttackCapability( DOTA_UNIT_CAP_MELEE_ATTACK )
	self:GetParent():FadeGesture(ACT_DOTA_RUN)
	self.attack_melee = false
end

function modifier_troll_warlord_berserkers_rage_custom:OnRefresh( kv )
	self.base_attack_time = self:GetAbility():GetSpecialValueFor( "base_attack_time" )
	self.bonus_move_speed = self:GetAbility():GetSpecialValueFor( "bonus_move_speed" )
	self.bonus_armor = self:GetAbility():GetSpecialValueFor( "bonus_armor" )
	self.ensnare_chance = self:GetAbility():GetSpecialValueFor( "ensnare_chance" )

end

function modifier_troll_warlord_berserkers_rage_custom:OnDestroy( kv )
	if not IsServer() then return end
	self:GetParent():SetAttackCapability(self.pre_attack_capability )
	self:GetParent():FadeGesture(ACT_DOTA_RUN)
end

function modifier_troll_warlord_berserkers_rage_custom:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_BASE_ATTACK_TIME_CONSTANT,
		MODIFIER_PROPERTY_ATTACK_RANGE_BONUS,
		MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
		MODIFIER_PROPERTY_TRANSLATE_ACTIVITY_MODIFIERS,
		MODIFIER_PROPERTY_TRANSLATE_ATTACK_SOUND,
		MODIFIER_EVENT_ON_ATTACK_LANDED,
		MODIFIER_EVENT_ON_ORDER
	}

	return funcs
end




function modifier_troll_warlord_berserkers_rage_custom:OnOrder( ord )
if not IsServer() then return end


if ord.order_type ~= DOTA_UNIT_ORDER_ATTACK_TARGET and ord.order_type ~= DOTA_UNIT_ORDER_MOVE_TO_TARGET then return end

if not ord.target:HasModifier("modifier_troll_warlord_berserkers_rage_charge_ready") then return end

if (self:GetParent():GetAbsOrigin() - ord.target:GetAbsOrigin()):Length2D() < self:GetAbility().charge_min_range then return end
if (self:GetParent():GetAbsOrigin() - ord.target:GetAbsOrigin()):Length2D() > self:GetAbility().charge_max_range then return end
if self:GetCaster() ~= ord.unit then return end

ord.unit:EmitSound("Troll.Charge")

ord.target:RemoveModifierByName("modifier_troll_warlord_berserkers_rage_charge_ready")

self:GetCaster():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_troll_warlord_berserkers_rage_charge_cd", {duration = self:GetAbility().charge_cd})

self:GetCaster():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_troll_warlord_berserkers_rage_charge", {target = ord.target:entindex(), duration = self:GetAbility().legendary_charge_duration})


end


function modifier_troll_warlord_berserkers_rage_custom:GetModifierBaseAttackTimeConstant()
local ability = self:GetParent():FindAbilityByName("troll_warlord_fervor_custom")
if self:GetParent():HasModifier("modifier_troll_warlord_fervor_custom_max") then return ability.max_bva end
    return self.base_attack_time
end

function modifier_troll_warlord_berserkers_rage_custom:GetModifierAttackRangeBonus()
	return -350  --self.delta_attack_range
end

function modifier_troll_warlord_berserkers_rage_custom:GetModifierMoveSpeedBonus_Constant()
local bonus = 0
if self:GetCaster():HasModifier("modifier_troll_rage_1") then 
	bonus = self:GetAbility().move_init + self:GetAbility().move_inc*self:GetCaster():GetUpgradeStack("modifier_troll_rage_1")
end

	return self.bonus_move_speed + bonus
end

function modifier_troll_warlord_berserkers_rage_custom:GetModifierPhysicalArmorBonus()
local bonus = 0
if self:GetCaster():HasModifier("modifier_troll_rage_1") then 
	bonus = self:GetAbility().armor_init + self:GetAbility().armor_inc*self:GetCaster():GetUpgradeStack("modifier_troll_rage_1")
end

	return self.bonus_armor + bonus
end

function modifier_troll_warlord_berserkers_rage_custom:GetAttackSound()
	return "Hero_TrollWarlord.ProjectileImpact"
end

function modifier_troll_warlord_berserkers_rage_custom:OnAttackLanded( params )
	if not IsServer() then return end
	if params.attacker:PassivesDisabled() then return end
	if params.attacker ~= self:GetParent() then return end
	if params.attacker == params.target then return end
	if params.target:IsOther() then return end
	if params.attacker:IsIllusion() then return end
	if params.target:IsBuilding() then return end
	if params.target:IsMagicImmune() then return end
	if self:GetParent():HasModifier("modifier_troll_warlord_berserkers_rage_cd") then return end
	if params.ranged_attack then return end


	local chance = self.ensnare_chance
	if self:GetParent():HasModifier("modifier_troll_rage_6") then 
		chance = chance + self:GetAbility().root_chance
	end

	if RollPseudoRandomPercentage(chance, self:GetParent():entindex(), self:GetParent()) then
		
		self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_troll_warlord_berserkers_rage_cd", {duration = self:GetAbility():GetSpecialValueFor("ensnare_cooldown")})
		local net =
		{
			Target = params.target,
			Source = self:GetParent(),
			Ability = self:GetAbility(),
			bDodgeable = false,
			EffectName = "particles/units/heroes/hero_troll_warlord/troll_warlord_bersekers_net_projectile.vpcf",
			iMoveSpeed = 1500,
			flExpireTime = GameRules:GetGameTime() + 10
		}
		ProjectileManager:CreateTrackingProjectile(net)
	end
end

function modifier_troll_warlord_berserkers_rage_custom:GetActivityTranslationModifiers()
	return "melee"
end

function modifier_troll_warlord_berserkers_rage_custom:GetPriority()
	return 1
end

function modifier_troll_warlord_berserkers_rage_custom:GetEffectName()
	return "particles/units/heroes/hero_troll_warlord/troll_warlord_berserk_buff.vpcf"
end

function modifier_troll_warlord_berserkers_rage_custom:GetEffectAttachType()
	return PATTACH_POINT_FOLLOW
end


modifier_troll_warlord_berserkers_rage_tracker = class({})
function modifier_troll_warlord_berserkers_rage_tracker:IsHidden() return true end
function modifier_troll_warlord_berserkers_rage_tracker:IsPurgable() return false end
function modifier_troll_warlord_berserkers_rage_tracker:OnCreated(table)
self.last_proc = nil


  self.agi_percentage = 0



  self:OnIntervalThink()
  self:StartIntervalThink(0.2)
end

function modifier_troll_warlord_berserkers_rage_tracker:DeclareFunctions()
return
{
	MODIFIER_EVENT_ON_ATTACK,
	MODIFIER_EVENT_ON_ATTACK_LANDED,
	MODIFIER_PROPERTY_ATTACK_RANGE_BONUS,
	MODIFIER_PROPERTY_HEALTH_BONUS,
	MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
	MODIFIER_PROPERTY_STATS_STRENGTH_BONUS
}
end

function modifier_troll_warlord_berserkers_rage_tracker:GetModifierAttackRangeBonus()
local bonus = 0
if self:GetCaster():HasModifier("modifier_troll_rage_legendary") and not self:GetCaster():HasModifier("modifier_troll_warlord_berserkers_rage_custom") then 
	bonus = self:GetAbility().legendary_range
end
	return bonus
end




function modifier_troll_warlord_berserkers_rage_tracker:GetModifierBonusStats_Agility()
if self:GetParent():HasModifier("modifier_troll_warlord_berserkers_rage_custom") then return end
  return self.agility
end




function modifier_troll_warlord_berserkers_rage_tracker:GetModifierBonusStats_Strength()
if not self:GetParent():HasModifier("modifier_troll_warlord_berserkers_rage_custom") then return end
  return self.str
end



function modifier_troll_warlord_berserkers_rage_tracker:OnIntervalThink()
if not IsServer() then return end
if not self:GetParent():HasModifier("modifier_troll_rage_3") then return end


   self.agi_percentage = self:GetAbility().stats_agi[self:GetParent():GetUpgradeStack("modifier_troll_rage_3")]
   self.str_percentage = self:GetAbility().stats_str[self:GetParent():GetUpgradeStack("modifier_troll_rage_3")]


  self.agility  = 0
  self.str  = 0
  self.agility   = self:GetParent():GetAgility() * self.agi_percentage * 0.01
  self.str   = self:GetParent():GetStrength() * self.str_percentage * 0.01

  self:GetParent():CalculateStatBonus(true)

end





function modifier_troll_warlord_berserkers_rage_tracker:OnAttack(params)
if not IsServer() then return end
if self:GetParent() ~= params.attacker then return end
if not self:GetParent():HasModifier("modifier_troll_rage_2") then return end
if self:GetParent():HasModifier("modifier_troll_warlord_berserkers_rage_noattack") then return end

local units = FindUnitsInRadius(self:GetCaster():GetTeamNumber(), params.target:GetAbsOrigin(), nil, self:GetAbility().aoe_radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO+DOTA_UNIT_TARGET_BASIC, 0, FIND_CLOSEST, false)
local n = 0

local mod = self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_troll_warlord_berserkers_rage_noattack", {})
local no_cleave = self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_tidehunter_anchor_smash_caster", {})

for _,unit in pairs(units) do 
	if unit ~= params.target then 
		if n < self:GetAbility().aoe_max then 
			n = n + 1
			self:GetParent():PerformAttack(unit, true, false, true, false, true, false, false)
		end
	end

end

if mod then 
	mod:Destroy()
end

if no_cleave then 
	no_cleave:Destroy()
end


end



function modifier_troll_warlord_berserkers_rage_tracker:OnAttackLanded(params)
if not IsServer() then return end
if self:GetParent() ~= params.attacker then return end
if not self:GetParent():HasModifier("modifier_troll_rage_5") then return end

if not params.ranged_attack then return end
if self:GetParent():HasModifier("modifier_troll_warlord_berserkers_rage_charge_cd") then return end
if params.target:HasModifier("modifier_troll_warlord_berserkers_rage_charge_ready") then return end

params.target:AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_troll_warlord_berserkers_rage_charge_stack", {duration = self:GetAbility().charge_stack_duration})
end



modifier_troll_warlord_berserkers_rage_noattack = class({})
function modifier_troll_warlord_berserkers_rage_noattack:IsHidden() return true end
function modifier_troll_warlord_berserkers_rage_noattack:IsPurgable() return false end
function modifier_troll_warlord_berserkers_rage_noattack:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_DAMAGEOUTGOING_PERCENTAGE
}
end
function modifier_troll_warlord_berserkers_rage_noattack:GetModifierDamageOutgoing_Percentage()
return (self:GetAbility().aoe_damage_init + self:GetAbility().aoe_damage_inc*self:GetParent():GetUpgradeStack("modifier_troll_rage_2"))
end


modifier_troll_warlord_berserkers_rage_charge_stack = class({})
function modifier_troll_warlord_berserkers_rage_charge_stack:IsHidden() return true end
function modifier_troll_warlord_berserkers_rage_charge_stack:IsPurgable() return false end
function modifier_troll_warlord_berserkers_rage_charge_stack:OnCreated(table)
if not IsServer() then return end

self:SetStackCount(1)
end

function modifier_troll_warlord_berserkers_rage_charge_stack:OnRefresh(table)
if not IsServer() then return end
self:IncrementStackCount()

if self:GetStackCount() >= self:GetAbility().charge_max then 
	self:GetParent():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_troll_warlord_berserkers_rage_charge_ready", {duration = self:GetAbility().charge_ready})
	self:Destroy()
end

end



function modifier_troll_warlord_berserkers_rage_charge_stack:OnStackCountChanged(iStackCount)
if self:GetStackCount() == 1 then

  local particle_cast = "particles/units/heroes/hero_drow/fist_count.vpcf"
  self.effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_OVERHEAD_FOLLOW, self:GetParent() )
  ParticleManager:SetParticleControl( self.effect_cast, 1, Vector( 0, self:GetStackCount(), 0 ) )
  self:AddParticle(self.effect_cast,false, false, -1, false, false)
else 

  if self.effect_cast then 
  	ParticleManager:SetParticleControl( self.effect_cast, 1, Vector( 0, self:GetStackCount(), 0 ) )
  end

end


end



modifier_troll_warlord_berserkers_rage_charge_ready = class({})
function modifier_troll_warlord_berserkers_rage_charge_ready:IsHidden() return false end
function modifier_troll_warlord_berserkers_rage_charge_ready:IsPurgable() return false end
function modifier_troll_warlord_berserkers_rage_charge_ready:GetEffectName() return "particles/lc_odd_charge_mark.vpcf" end
function modifier_troll_warlord_berserkers_rage_charge_ready:GetEffectAttachType() return PATTACH_OVERHEAD_FOLLOW end








modifier_troll_warlord_berserkers_rage_charge = class({})
function modifier_troll_warlord_berserkers_rage_charge:IsHidden() return true end
function modifier_troll_warlord_berserkers_rage_charge:IsPurgable() return true end
function modifier_troll_warlord_berserkers_rage_charge:GetTexture() return "buffs/odds_mark" end

function modifier_troll_warlord_berserkers_rage_charge:OnCreated(table)
if not IsServer() then return end
self.target = EntIndexToHScript(table.target)
self.stun = false 
self:GetParent():SetForceAttackTarget(self.target)
self:StartIntervalThink(FrameTime())
end

function modifier_troll_warlord_berserkers_rage_charge:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_MOVESPEED_ABSOLUTE,
	MODIFIER_PROPERTY_TRANSLATE_ACTIVITY_MODIFIERS,
	MODIFIER_EVENT_ON_ATTACK_START
}

end


function modifier_troll_warlord_berserkers_rage_charge:OnAttackStart(params)
if not IsServer() then return end
if self:GetParent() ~= params.attacker then return end

self.stun = true 
self:Destroy()

end


function modifier_troll_warlord_berserkers_rage_charge:OnIntervalThink()
if not IsServer() then return end

if (self:GetParent():GetAbsOrigin() - self.target:GetAbsOrigin()):Length2D() <= 200 then 
	self.stun = true 
end


if self.stun
or not self.target:IsAlive()  
or self.target:IsInvulnerable() 
or self.target:IsInvisible() 
or self.target:IsAttackImmune()
or self:GetParent():IsStunned()
or self:GetParent():IsRooted() then 
 	self:Destroy()
end

end

function modifier_troll_warlord_berserkers_rage_charge:OnDestroy()
if not IsServer() then return end
local stun = self:GetAbility().charge_stun

	if self.stun then 

		local anim = self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_overwhelming_odds_mark_anim", {})
		self:GetParent():EmitSound("Troll.ChargeHit")
		--self:GetParent():StartGestureWithPlaybackRate(ACT_DOTA_ATTACK_STATUE, 1.5)
		if anim then 
			anim:Destroy()
		end

		
		local effect_cast = ParticleManager:CreateParticle( "particles/econ/items/troll_warlord/troll_warlord_ti7_axe/troll_ti7_axe_bash_explosion.vpcf", PATTACH_OVERHEAD_FOLLOW, self.target )
		ParticleManager:SetParticleControl( effect_cast, 0,  self.target:GetOrigin() )
		ParticleManager:SetParticleControl( effect_cast, 1, self:GetParent():GetOrigin() )

		self.target:AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_stunned", {duration = (1 - self.target:GetStatusResistance())*stun})
	
	end


self:GetParent():SetForceAttackTarget(nil)
end
function modifier_troll_warlord_berserkers_rage_charge:GetEffectName() return "particles/troll_haste.vpcf" end

function modifier_troll_warlord_berserkers_rage_charge:GetModifierMoveSpeed_Absolute() return self:GetAbility().charge_speed
 end



modifier_troll_warlord_berserkers_rage_ranged = class({})
function modifier_troll_warlord_berserkers_rage_ranged:IsHidden() return true end
function modifier_troll_warlord_berserkers_rage_ranged:IsPurgable() return false end
function modifier_troll_warlord_berserkers_rage_ranged:RemoveOnDeath() return false end
function modifier_troll_warlord_berserkers_rage_ranged:AllowIllusionDuplicate() return true end
function modifier_troll_warlord_berserkers_rage_ranged:IsPurgeException() return false end

function modifier_troll_warlord_berserkers_rage_ranged:OnCreated( kv )
	self.base_attack_time = self:GetAbility():GetSpecialValueFor( "base_attack_time" )
	self.bonus_move_speed = self:GetAbility():GetSpecialValueFor( "bonus_move_speed" )
	self.bonus_armor = self:GetAbility():GetSpecialValueFor( "bonus_armor" )
	self.ensnare_chance = self:GetAbility():GetSpecialValueFor( "ensnare_chance" )
end




function modifier_troll_warlord_berserkers_rage_ranged:OnRefresh( kv )
	self.base_attack_time = self:GetAbility():GetSpecialValueFor( "base_attack_time" )
	self.bonus_move_speed = self:GetAbility():GetSpecialValueFor( "bonus_move_speed" )
	self.bonus_armor = self:GetAbility():GetSpecialValueFor( "bonus_armor" )
	self.ensnare_chance = self:GetAbility():GetSpecialValueFor( "ensnare_chance" )

end


function modifier_troll_warlord_berserkers_rage_ranged:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_BASE_ATTACK_TIME_CONSTANT,
		MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
		MODIFIER_EVENT_ON_ATTACK_LANDED,
	}

	return funcs
end


 
function modifier_troll_warlord_berserkers_rage_ranged:GetModifierBaseAttackTimeConstant()
local ability = self:GetParent():FindAbilityByName("troll_warlord_fervor_custom")
if self:GetParent():HasModifier("modifier_troll_warlord_fervor_custom_max") then return ability.max_bva end
    return self.base_attack_time
end


function modifier_troll_warlord_berserkers_rage_ranged:GetModifierMoveSpeedBonus_Constant()
local bonus = 0
if self:GetCaster():HasModifier("modifier_troll_rage_1") then 
	bonus = self:GetAbility().move_init + self:GetAbility().move_inc*self:GetCaster():GetUpgradeStack("modifier_troll_rage_1")
end

	return self.bonus_move_speed + bonus
end

function modifier_troll_warlord_berserkers_rage_ranged:GetModifierPhysicalArmorBonus()
local bonus = 0
if self:GetCaster():HasModifier("modifier_troll_rage_1") then 
	bonus = self:GetAbility().armor_init + self:GetAbility().armor_inc*self:GetCaster():GetUpgradeStack("modifier_troll_rage_1")
end

	return self.bonus_armor + bonus
end

function modifier_troll_warlord_berserkers_rage_ranged:OnAttackLanded( params )
	if not IsServer() then return end
	if params.attacker:PassivesDisabled() then return end
	if params.attacker ~= self:GetParent() then return end
	if params.attacker == params.target then return end
	if params.target:IsOther() then return end
	if params.attacker:IsIllusion() then return end
	if params.target:IsBuilding() then return end
	if params.target:IsMagicImmune() then return end
	if not params.ranged_attack then return end
	if self:GetParent():HasModifier("modifier_troll_warlord_berserkers_rage_cd") then return end


	local chance = self.ensnare_chance
	if self:GetParent():HasModifier("modifier_troll_rage_6") then 
		chance = chance + self:GetAbility().root_chance
	end

	if RollPseudoRandomPercentage(chance, self:GetParent():entindex(), self:GetParent()) then
  		params.target:EmitSound("DOTA_Item.Maim")

		self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_troll_warlord_berserkers_rage_cd", {duration = self:GetAbility():GetSpecialValueFor("ensnare_cooldown")})
		
		params.target:AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_troll_warlord_berserkers_rage_slow", {duration = self:GetAbility().legendary_slow*(1 - params.target:GetStatusResistance())})
	end
end

modifier_troll_warlord_berserkers_rage_slow = class({})
function modifier_troll_warlord_berserkers_rage_slow:IsHidden() return false end
function modifier_troll_warlord_berserkers_rage_slow:IsPurgable() return true end

function modifier_troll_warlord_berserkers_rage_slow:GetEffectName()
return "particles/units/heroes/hero_sniper/sniper_headshot_slow.vpcf"
end


function modifier_troll_warlord_berserkers_rage_slow:GetEffectAttachType()
return PATTACH_OVERHEAD_FOLLOW
end

function modifier_troll_warlord_berserkers_rage_slow:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
	MODIFIER_PROPERTY_TURN_RATE_PERCENTAGE,
	MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT
}
end



function modifier_troll_warlord_berserkers_rage_slow:GetModifierTurnRate_Percentage()
local bonus = 0

if self:GetCaster():HasModifier("modifier_troll_rage_6") then 
	bonus = self:GetAbility().root_turn
end

return bonus
end

function modifier_troll_warlord_berserkers_rage_slow:GetModifierAttackSpeedBonus_Constant()
local bonus = 0

if self:GetCaster():HasModifier("modifier_troll_rage_6") then 
	bonus = self:GetAbility().root_speed
end

return bonus
end



function modifier_troll_warlord_berserkers_rage_slow:GetModifierMoveSpeedBonus_Percentage()
return self:GetAbility().legendary_slow_move
end


modifier_troll_warlord_berserkers_rage_bloodrage = class({})
function modifier_troll_warlord_berserkers_rage_bloodrage:IsHidden() return false end
function modifier_troll_warlord_berserkers_rage_bloodrage:IsPurgable() return false end
function modifier_troll_warlord_berserkers_rage_bloodrage:GetTexture() return "buffs/rage_bloodrage" end

function modifier_troll_warlord_berserkers_rage_bloodrage:GetStatusEffectName()
  return "particles/status_fx/status_effect_beserkers_call.vpcf"
end
function modifier_troll_warlord_berserkers_rage_bloodrage:StatusEffectPriority()
    return 12
end


function modifier_troll_warlord_berserkers_rage_bloodrage:OnCreated(table)

self.ranged = self:GetParent():IsRangedAttacker()

if not IsServer() then return end

local name = "particles/troll_char.vpcf"
if self.ranged then 
	name = "particles/troll_char_active.vpcf"
end

self.particle = ParticleManager:CreateParticle(name, PATTACH_OVERHEAD_FOLLOW, self:GetParent())
self:AddParticle(self.particle, false, false, -1, false, false)


self:SetStackCount(self:GetAbility().proc_max)

end


function modifier_troll_warlord_berserkers_rage_bloodrage:OnStackCountChanged(iStackCount)
if self:GetStackCount() == 0 then return end
if not self.particle then return end

for i = 1,self:GetAbility().proc_max do 
	
	if i <= self:GetStackCount() then 
		ParticleManager:SetParticleControl(self.particle, i, Vector(1, 0, 0))	
	else 
		ParticleManager:SetParticleControl(self.particle, i, Vector(0, 0, 0))	
	end
end

end








function modifier_troll_warlord_berserkers_rage_bloodrage:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_PROCATTACK_BONUS_DAMAGE_PHYSICAL,
	MODIFIER_PROPERTY_TOOLTIP
}
end



function modifier_troll_warlord_berserkers_rage_bloodrage:GetModifierProcAttack_BonusDamage_Physical( params )
if not IsServer() then return end


if self:GetParent():IsRangedAttacker() ~= self.ranged then return end 
if params.ranged_attack ~= self.ranged then return end 


local heal = self:GetParent():GetMaxHealth()*(self:GetAbility().proc_damage_init + self:GetAbility().proc_damage_inc*self:GetCaster():GetUpgradeStack("modifier_troll_rage_4"))

self:GetCaster():Heal(heal, self:GetCaster())
SendOverheadEventMessage(self:GetCaster(), 10, self:GetCaster(), heal, nil)

local particle = ParticleManager:CreateParticle( "particles/units/heroes/hero_meepo/meepo_ransack.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
ParticleManager:ReleaseParticleIndex( particle )

self:DecrementStackCount()
if self:GetStackCount() == 0 then 
	self:Destroy()
end

return heal

end




function modifier_troll_warlord_berserkers_rage_bloodrage:OnTooltip()
return self:GetParent():GetMaxHealth()*(self:GetAbility().proc_damage_init + self:GetAbility().proc_damage_inc*self:GetCaster():GetUpgradeStack("modifier_troll_rage_4"))
end


modifier_troll_warlord_berserkers_rage_last_meele = class({})
function modifier_troll_warlord_berserkers_rage_last_meele:IsHidden() return false end
function modifier_troll_warlord_berserkers_rage_last_meele:IsPurgable() return false end
function modifier_troll_warlord_berserkers_rage_last_meele:RemoveOnDeath() return false end
function modifier_troll_warlord_berserkers_rage_last_meele:IsDebuff() return true end
function modifier_troll_warlord_berserkers_rage_last_meele:GetTexture()
	return "troll_warlord_berserkers_rage_active"
end

modifier_troll_warlord_berserkers_rage_last_range = class({})
function modifier_troll_warlord_berserkers_rage_last_range:IsHidden() return false end
function modifier_troll_warlord_berserkers_rage_last_range:IsPurgable() return false end
function modifier_troll_warlord_berserkers_rage_last_range:RemoveOnDeath() return false end
function modifier_troll_warlord_berserkers_rage_last_range:IsDebuff() return true end
function modifier_troll_warlord_berserkers_rage_last_range:GetTexture() 
	return "troll_warlord_berserkers_rage"
end



modifier_troll_warlord_berserkers_rage_lowhp_tracker = class({})
function modifier_troll_warlord_berserkers_rage_lowhp_tracker:IsHidden()
return self:GetParent():GetHealthPercent() >= self:GetAbility().lowhp_health
end

function modifier_troll_warlord_berserkers_rage_lowhp_tracker:IsPurgable() return end
function modifier_troll_warlord_berserkers_rage_lowhp_tracker:RemoveOnDeath() return false end
function modifier_troll_warlord_berserkers_rage_lowhp_tracker:GetTexture() return "buffs/rage_lowhp" end


function modifier_troll_warlord_berserkers_rage_lowhp_tracker:OnCreated(table)
if not IsServer() then return end
self.ground_particle = nil 

self:StartIntervalThink(0.15)
end

function modifier_troll_warlord_berserkers_rage_lowhp_tracker:OnIntervalThink()
if not IsServer() then return end

if self:GetParent():GetHealthPercent() >= self:GetAbility().lowhp_health and self.ground_particle ~= nil  then 
    ParticleManager:DestroyParticle(self.ground_particle, false)
    ParticleManager:ReleaseParticleIndex(self.ground_particle)
    self.ground_particle = nil
end

if self:GetParent():GetHealthPercent() < self:GetAbility().lowhp_health and self.ground_particle == nil  then 
	self.ground_particle = ParticleManager:CreateParticle("particles/troll_lowhp.vpcf", PATTACH_CUSTOMORIGIN, self:GetParent())
	ParticleManager:SetParticleControlEnt(self.ground_particle, 0, self:GetParent(), PATTACH_OVERHEAD_FOLLOW, "attach_hitloc", self:GetParent():GetAbsOrigin(), true)
	ParticleManager:SetParticleControlEnt(self.ground_particle, 1, self:GetParent(), PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", self:GetParent():GetAbsOrigin(), true)
	ParticleManager:SetParticleControlEnt(self.ground_particle, 5, self:GetParent(), PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", self:GetParent():GetAbsOrigin(), true)
	
end


end








function modifier_troll_warlord_berserkers_rage_lowhp_tracker:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
	MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE
}
end

function modifier_troll_warlord_berserkers_rage_lowhp_tracker:GetModifierMoveSpeedBonus_Percentage()
local bonus = 0
if not self:GetParent():HasModifier("modifier_troll_warlord_berserkers_rage_custom") and self:GetParent():GetHealthPercent() < self:GetAbility().lowhp_health then 
	bonus = self:GetAbility().lowhp_speed
end
return bonus
end


function modifier_troll_warlord_berserkers_rage_lowhp_tracker:GetModifierIncomingDamage_Percentage()
local bonus = 0
if self:GetParent():HasModifier("modifier_troll_warlord_berserkers_rage_custom") and self:GetParent():GetHealthPercent() < self:GetAbility().lowhp_health then 
	bonus = self:GetAbility().lowhp_resist
end
return bonus
end


modifier_troll_warlord_berserkers_rage_cd = class({})
function modifier_troll_warlord_berserkers_rage_cd:IsHidden() return true end
function modifier_troll_warlord_berserkers_rage_cd:IsPurgable() return false end
function modifier_troll_warlord_berserkers_rage_cd:IsDebuff() return true end


modifier_troll_warlord_berserkers_rage_charge_cd = class({})
function modifier_troll_warlord_berserkers_rage_charge_cd:IsHidden() return false  end
function modifier_troll_warlord_berserkers_rage_charge_cd:IsPurgable() return false end
function modifier_troll_warlord_berserkers_rage_charge_cd:IsDebuff() return true end
function modifier_troll_warlord_berserkers_rage_charge_cd:RemoveOnDeath() return false end
function modifier_troll_warlord_berserkers_rage_charge_cd:GetTexture() return "buffs/rage_charge" end
function modifier_troll_warlord_berserkers_rage_charge_cd:OnCreated(table)
self.RemoveForDuel = true 

end





