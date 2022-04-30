LinkLuaModifier( "modifier_alchemist_chemical_rage_custom", "abilities/alchemist/alchemist_chemical_rage_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_alchemist_chemical_rage_custom_legendary_rotate", "abilities/alchemist/alchemist_chemical_rage_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_alchemist_chemical_rage_transformation", "abilities/alchemist/alchemist_chemical_rage_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_alchemist_chemical_rage_slow", "abilities/alchemist/alchemist_chemical_rage_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_alchemist_chemical_rage_buff", "abilities/alchemist/alchemist_chemical_rage_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_alchemist_chemical_rage_incoming", "abilities/alchemist/alchemist_chemical_rage_custom", LUA_MODIFIER_MOTION_NONE )


alchemist_chemical_rage_custom = class({})

alchemist_chemical_rage_custom.cd = {-5,-10,-15}

alchemist_chemical_rage_custom.bonus_speed = {20,40,60}
alchemist_chemical_rage_custom.bonus_regen = {20,30,40}

alchemist_chemical_rage_custom.attack_max = 3
alchemist_chemical_rage_custom.attack_slow = {-9,-12,-15}
alchemist_chemical_rage_custom.attack_damage = {4,6,8}
alchemist_chemical_rage_custom.attack_duration = 4
alchemist_chemical_rage_custom.attack_chance = 20

alchemist_chemical_rage_custom.damage_reduction_max = 7
alchemist_chemical_rage_custom.damage_reduction = -10

alchemist_chemical_rage_custom.range_attack = 100
alchemist_chemical_rage_custom.cleave_attack = 0.40

alchemist_chemical_rage_custom.legendary_bva = 0.1

alchemist_enrage_potion = class({})

alchemist_enrage_potion.cd = {7,5}

function alchemist_enrage_potion:GetCooldown(iLevel)

	if self:GetCaster():HasModifier("modifier_alchemist_rage_4") then
		return self.cd[self:GetCaster():GetUpgradeStack("modifier_alchemist_rage_4")]
	end
	return self.BaseClass.GetCooldown(self, iLevel)
end


function alchemist_chemical_rage_custom:GetCooldown(iLevel)
	local cooldown_reduction = 0
	if self:GetCaster():HasModifier("modifier_alchemist_rage_1") then
		cooldown_reduction = self.cd[self:GetCaster():GetUpgradeStack("modifier_alchemist_rage_1")]
	end
	return self.BaseClass.GetCooldown(self, iLevel) + cooldown_reduction
end

function alchemist_chemical_rage_custom:OnSpellStart()
	if not IsServer() then return end
	local duration = self:GetSpecialValueFor( "transformation_time" )
	self:GetCaster():AddNewModifier( self:GetCaster(),  self, "modifier_alchemist_chemical_rage_transformation", { duration = duration } )
	self:GetCaster():EmitSound("Hero_Alchemist.ChemicalRage.Cast")
	ProjectileManager:ProjectileDodge( self:GetCaster() )
	self:GetCaster():Purge( false, true, false, false, false )
end

modifier_alchemist_chemical_rage_transformation = class({})

function modifier_alchemist_chemical_rage_transformation:IsHidden() return true end
function modifier_alchemist_chemical_rage_transformation:IsPurgable() return false end

function modifier_alchemist_chemical_rage_transformation:OnCreated()
	if not IsServer() then return end
	self:GetCaster():StartGesture(ACT_DOTA_ALCHEMIST_CHEMICAL_RAGE_START)
end

function modifier_alchemist_chemical_rage_transformation:OnDestroy()
	if not IsServer() then return end
	local buff_duration = self:GetAbility():GetSpecialValueFor("duration")
	self:GetCaster():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_alchemist_chemical_rage_custom", {duration = buff_duration})
end

modifier_alchemist_chemical_rage_custom = class({})

function modifier_alchemist_chemical_rage_custom:IsPurgable()
	return false
end

function modifier_alchemist_chemical_rage_custom:AllowIllusionDuplicate()
	return true
end


function modifier_alchemist_chemical_rage_custom:OnStackCountChanged(iStackCount)
if self:GetStackCount() == 0 then return end
if not self.effect_cast then 

  local particle_cast = "particles/alch_rage_stack.vpcf"

  self.effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_OVERHEAD_FOLLOW, self:GetParent() )
  ParticleManager:SetParticleControl( self.effect_cast, 1, Vector( 0, self:GetStackCount(), 0 ) )

  self:AddParticle(self.effect_cast,false, false, -1, false, false)
else 

  ParticleManager:SetParticleControl( self.effect_cast, 1, Vector( 0, self:GetStackCount(), 0 ) )

end

end





function modifier_alchemist_chemical_rage_custom:OnCreated( kv )
	self.bat = self:GetAbility():GetSpecialValueFor( "base_attack_time" )


	if self:GetParent():HasModifier("modifier_alchemist_rage_legendary") then 
		self.bat = self.bat - self:GetAbility().legendary_bva
	end

	self.health_regen = self:GetAbility():GetSpecialValueFor( "bonus_health_regen" )
	self.movespeed = self:GetAbility():GetSpecialValueFor( "bonus_movespeed" )

	if self:GetParent():HasModifier("modifier_alchemist_rage_4") and self:GetParent() then 
		self:GetParent():SwapAbilities("alchemist_chemical_rage_custom", "alchemist_enrage_potion", false, true)

	end


	--local effect_cast_1 = ParticleManager:CreateParticle("particles/alch_run.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
	--self:AddParticle( effect_cast_1, false, false, -1, false, false  )


	if self:GetParent():HasModifier("modifier_alchemist_rage_6") then 
		self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_alchemist_chemical_rage_incoming", {})
	end

	self.RemoveForDuel = true


	if not IsServer() then return end
	local effect_cast = ParticleManager:CreateParticle("particles/units/heroes/hero_alchemist/alchemist_chemical_rage.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
	self:AddParticle( effect_cast, false, false, -1, false, false  )
	self:GetParent():EmitSound("Hero_Alchemist.ChemicalRage")

	if self:GetCaster():HasModifier("modifier_alchemist_rage_legendary") then
		self:GetCaster():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_alchemist_chemical_rage_custom_legendary_rotate", {duration = self:GetRemainingTime()})
		local apm = self:GetCaster():GetAttacksPerSecond()
		self:StartIntervalThink(1/apm)
	end
end

function modifier_alchemist_chemical_rage_custom:OnIntervalThink()
if not IsServer() then return end

	local apm = self:GetCaster():GetAttacksPerSecond()
	self:StartIntervalThink(1/apm)

	local enemies = FindUnitsInRadius( self:GetParent():GetTeamNumber(), self:GetParent():GetAbsOrigin(), nil, self:GetParent():Script_GetAttackRange(), DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE, FIND_CLOSEST, false )
	
	for id, enemy in pairs(enemies) do
		if enemy:IsAttackImmune() or enemy:GetUnitName() == "npc_teleport" then
			table.remove(enemies, id)
		end
	end

	if #enemies <= 0 then return end

	if self:GetParent():IsStunned() or self:GetParent():IsHexed() or (my_game:CheckDisarm(self:GetParent()) == true) or self:GetParent():IsChanneling()
	 then return end

	local random_attack = RandomInt(1, 2)
	self:GetParent():FadeGesture(ACT_DOTA_ATTACK)
	self:GetParent():FadeGesture(ACT_DOTA_ATTACK2)
	self:GetParent():StartGestureWithPlaybackRate(ACT_DOTA_ATTACK, self:GetParent():GetDisplayAttackSpeed() / 100)
	self:GetParent():PerformAttack(enemies[1], false, true, true, false, false, false, false)
end

function modifier_alchemist_chemical_rage_custom:CheckState()
	if not self:GetCaster():HasModifier("modifier_alchemist_rage_legendary") then return {} end
	return {
		[MODIFIER_STATE_DISARMED] = true,
	}
end

function modifier_alchemist_chemical_rage_custom:OnRefresh( kv )
if not IsServer() then return end
self:OnCreated(table)
end

function modifier_alchemist_chemical_rage_custom:OnDestroy()
if not IsServer() then return end
if not self:GetParent() then return end
	self:GetParent():StopSound("Hero_Alchemist.ChemicalRage")

	local ability = self:GetParent():FindAbilityByName("alchemist_enrage_potion")

	if self:GetParent():HasModifier("modifier_alchemist_rage_4") and not ability:IsHidden() then 
		self:GetParent():SwapAbilities("alchemist_chemical_rage_custom", "alchemist_enrage_potion", true, false)
	end
end

function modifier_alchemist_chemical_rage_custom:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_BASE_ATTACK_TIME_CONSTANT,
		MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,
		MODIFIER_PROPERTY_HEALTH_BONUS,
		MODIFIER_PROPERTY_MANA_REGEN_CONSTANT,
		MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_TRANSLATE_ACTIVITY_MODIFIERS,
    	MODIFIER_PROPERTY_TRANSLATE_ATTACK_SOUND,
    	MODIFIER_PROPERTY_ATTACK_RANGE_BONUS,
    	MODIFIER_EVENT_ON_ATTACK_LANDED,
    	MODIFIER_PROPERTY_IGNORE_CAST_ANGLE,
    	MODIFIER_PROPERTY_CASTTIME_PERCENTAGE,
    	MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
    	MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
    	MODIFIER_PROPERTY_DISABLE_AUTOATTACK,
        MODIFIER_PROPERTY_ALWAYS_AUTOATTACK_WHILE_HOLD_POSITION
	}

	return funcs
end



function modifier_alchemist_chemical_rage_custom:GetModifierIncomingDamage_Percentage()
if self:GetStackCount() == 0 then return end
local ability = self:GetParent():FindAbilityByName("alchemist_enrage_potion")
return ability:GetSpecialValueFor("damage")*self:GetStackCount()
end

function modifier_alchemist_chemical_rage_custom:GetModifierAttackSpeedBonus_Constant()
if self:GetStackCount() == 0 then return end
local ability = self:GetParent():FindAbilityByName("alchemist_enrage_potion")
return ability:GetSpecialValueFor("speed")*self:GetStackCount()
end


function modifier_alchemist_chemical_rage_custom:OnAttackLanded(params)
if params.attacker ~= self:GetParent() then return end
if params.attacker:IsIllusion() then return end

if self:GetParent():HasModifier("modifier_alchemist_rage_5") then 


	local k = self:GetAbility().cleave_attack

	DoCleaveAttack(self:GetParent(), params.target, nil, params.damage * k  , 150, 360, 650, "particles/alch_cleave.vpcf")
end




if not self:GetParent():HasModifier("modifier_alchemist_rage_2") then return end
	
local random = RollPseudoRandomPercentage(self:GetAbility().attack_chance,101,self:GetParent())

if not random then return end

self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_alchemist_chemical_rage_buff", {duration = self:GetAbility().attack_duration})
params.target:AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_alchemist_chemical_rage_slow", {duration = self:GetAbility().attack_duration*(1 - params.target:GetStatusResistance())})
params.target:EmitSound("DOTA_Item.Maim")
end

function modifier_alchemist_chemical_rage_custom:GetModifierIgnoreCastAngle()
	if self:GetCaster():HasModifier("modifier_alchemist_rage_legendary") then
		return 1
	end
	return 0
end

function modifier_alchemist_chemical_rage_custom:GetModifierPercentageCasttime()
	if self:GetCaster():HasModifier("modifier_alchemist_rage_legendary") then
		return 100
	end
    return 0
end





function modifier_alchemist_chemical_rage_custom:GetModifierBaseAttackTimeConstant()
	return self.bat
end


function modifier_alchemist_chemical_rage_custom:GetModifierConstantHealthRegen()

local bonus = 0

if self:GetParent():HasModifier("modifier_alchemist_rage_3") then
	bonus = self:GetAbility().bonus_regen[self:GetCaster():GetUpgradeStack("modifier_alchemist_rage_3")]
end
	return self.health_regen + bonus
end

function modifier_alchemist_chemical_rage_custom:GetModifierMoveSpeedBonus_Constant()

local bonus = 0

if self:GetParent():HasModifier("modifier_alchemist_rage_3") then
	bonus = self:GetAbility().bonus_speed[self:GetCaster():GetUpgradeStack("modifier_alchemist_rage_3")]
end
	return self.movespeed + bonus
end

function modifier_alchemist_chemical_rage_custom:GetHeroEffectName()
	return "particles/units/heroes/hero_alchemist/alchemist_chemical_rage_hero_effect.vpcf"
end

function modifier_alchemist_chemical_rage_custom:GetActivityTranslationModifiers()
    return "chemical_rage"
end

function modifier_alchemist_chemical_rage_custom:GetAttackSound()
    return "Hero_Alchemist.ChemicalRage.Attack"
end

function modifier_alchemist_chemical_rage_custom:GetModifierAttackRangeBonus()
	if self:GetCaster():HasModifier("modifier_alchemist_rage_5") then
		return self:GetAbility().range_attack
	end
	return 0
end














modifier_alchemist_chemical_rage_custom_legendary_rotate = class({})

function modifier_alchemist_chemical_rage_custom_legendary_rotate:IsPurgable()
	return false
end

function modifier_alchemist_chemical_rage_custom_legendary_rotate:IsHidden()
	return true
end

function modifier_alchemist_chemical_rage_custom_legendary_rotate:AllowIllusionDuplicate()
	return true
end

function modifier_alchemist_chemical_rage_custom_legendary_rotate:OnCreated( kv )
	if not IsServer() then return end
	self.rotate = 0
	self:StartIntervalThink(FrameTime())
end

function modifier_alchemist_chemical_rage_custom_legendary_rotate:OnIntervalThink()
	if not IsServer() then return end
	local enemies = FindUnitsInRadius( self:GetParent():GetTeamNumber(), self:GetParent():GetAbsOrigin(), nil, self:GetParent():Script_GetAttackRange(), DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE, FIND_CLOSEST, false )
	if #enemies <= 0 then self.rotate = 0 return end
	self.rotate = 1
	local direction = enemies[1]:GetAbsOrigin() - self:GetParent():GetAbsOrigin()
	direction.z = 0
	direction = direction:Normalized()
	self:GetParent():SetForwardVector(direction)
	self:GetParent():FaceTowards(enemies[1]:GetAbsOrigin())
end
function modifier_alchemist_chemical_rage_custom_legendary_rotate:DeclareFunctions()
	local funcs = {
    	MODIFIER_PROPERTY_DISABLE_TURNING,
	}

	return funcs
end

function modifier_alchemist_chemical_rage_custom_legendary_rotate:GetModifierDisableTurning()
	return self.rotate
end




modifier_alchemist_chemical_rage_slow = class({})
function modifier_alchemist_chemical_rage_slow:IsHidden() return false end
function modifier_alchemist_chemical_rage_slow:IsPurgable() return false end
function modifier_alchemist_chemical_rage_slow:GetTexture() return "buffs/mortal_bash" end
function modifier_alchemist_chemical_rage_slow:GetEffectName()
return "particles/items2_fx/sange_maim.vpcf"
end


function modifier_alchemist_chemical_rage_slow:OnCreated(table)
if not IsServer() then return end
self:SetStackCount(1)
end

function modifier_alchemist_chemical_rage_slow:OnRefresh(table)
if not IsServer() then return end
if self:GetStackCount() >= self:GetAbility().attack_max then return end
self:IncrementStackCount()
end


function modifier_alchemist_chemical_rage_slow:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE
}
end

function modifier_alchemist_chemical_rage_slow:GetModifierMoveSpeedBonus_Percentage()
if not self:GetCaster() or not self:GetAbility() then return end
return self:GetAbility().attack_slow[self:GetCaster():GetUpgradeStack("modifier_alchemist_rage_2")]*self:GetStackCount()
end




modifier_alchemist_chemical_rage_buff = class({})
function modifier_alchemist_chemical_rage_buff:IsHidden() return false end
function modifier_alchemist_chemical_rage_buff:IsPurgable() return false end
function modifier_alchemist_chemical_rage_buff:GetTexture() return "buffs/mortal_bash" end
function modifier_alchemist_chemical_rage_buff:OnCreated(table)
if not IsServer() then return end
self:SetStackCount(1)
end

function modifier_alchemist_chemical_rage_buff:OnRefresh(table)
if not IsServer() then return end
if self:GetStackCount() >= self:GetAbility().attack_max then return end
self:IncrementStackCount()
end


function modifier_alchemist_chemical_rage_buff:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_DAMAGEOUTGOING_PERCENTAGE
}
end

function modifier_alchemist_chemical_rage_buff:GetModifierDamageOutgoing_Percentage()
return self:GetAbility().attack_damage[self:GetCaster():GetUpgradeStack("modifier_alchemist_rage_2")]*self:GetStackCount()
end




function alchemist_enrage_potion:OnSpellStart()
if not IsServer() then return end

local mod = self:GetCaster():FindModifierByName("modifier_alchemist_chemical_rage_custom")
if not mod then return end

self:GetCaster():EmitSound("Hero_Alchemist.BerserkPotion.Cast")
self:GetCaster():EmitSound("Hero_Alchemist.BerserkPotion.Target")

self:GetCaster():StartGesture(ACT_DOTA_CAST_ABILITY_4)
local effect_cast = ParticleManager:CreateParticle("particles/units/heroes/hero_alchemist/alchemist_berserk_buff.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster() )
mod:AddParticle( effect_cast, false, false, -1, false, false  )

mod:SetStackCount(mod:GetStackCount() + 1)


end





modifier_alchemist_chemical_rage_incoming = class({})
function modifier_alchemist_chemical_rage_incoming:IsHidden() return false end
function modifier_alchemist_chemical_rage_incoming:IsPurgable() return false end
function modifier_alchemist_chemical_rage_incoming:GetTexture() return "buffs/chemical_incoming" end
function modifier_alchemist_chemical_rage_incoming:OnCreated(table)
if not IsServer() then return end
self:SetStackCount(self:GetAbility().damage_reduction_max)
self:StartIntervalThink(1)

 
  self.particle_1 = "particles/units/heroes/hero_pangolier/pangolier_tailthump_buff.vpcf"
  self.particle_2 = "particles/units/heroes/hero_pangolier/pangolier_tailthump_buff_egg.vpcf"
  self.particle_3 = "particles/units/heroes/hero_pangolier/pangolier_tailthump_buff_streaks.vpcf"
  self.sound = "Hero_Pangolier.TailThump.Shield"
  self.buff_particles = {}

  self:GetCaster():EmitSound( self.sound)


  self.buff_particles[1] = ParticleManager:CreateParticle(self.particle_1, PATTACH_ABSORIGIN_FOLLOW, self:GetCaster())
  ParticleManager:SetParticleControlEnt(self.buff_particles[1], 1, self:GetCaster(), PATTACH_ABSORIGIN_FOLLOW, nil, Vector(0,0,0), false) 
  self:AddParticle(self.buff_particles[1], false, false, -1, true, false)
  ParticleManager:SetParticleControl( self.buff_particles[1], 3, Vector( 255, 255, 255 ) )

  self.buff_particles[2] = ParticleManager:CreateParticle(self.particle_2, PATTACH_ABSORIGIN_FOLLOW, self:GetCaster())
  ParticleManager:SetParticleControlEnt(self.buff_particles[2], 1, self:GetCaster(), PATTACH_ABSORIGIN_FOLLOW, nil, Vector(0,0,0), false) 
  self:AddParticle(self.buff_particles[2], false, false, -1, true, false)

  self.buff_particles[3] = ParticleManager:CreateParticle(self.particle_3, PATTACH_ABSORIGIN_FOLLOW, self:GetCaster())
  ParticleManager:SetParticleControlEnt(self.buff_particles[3], 1, self:GetCaster(), PATTACH_ABSORIGIN_FOLLOW, nil, Vector(0,0,0), false) 
  self:AddParticle(self.buff_particles[3], false, false, -1, true, false)

end

function modifier_alchemist_chemical_rage_incoming:OnIntervalThink()
self:DecrementStackCount()
if self:GetStackCount() == 0 then 
	self:Destroy()
end

end

function modifier_alchemist_chemical_rage_incoming:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE
}
end

function modifier_alchemist_chemical_rage_incoming:GetModifierIncomingDamage_Percentage()
return self:GetAbility().damage_reduction*self:GetStackCount()
end