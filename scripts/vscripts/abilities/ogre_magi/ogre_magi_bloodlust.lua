LinkLuaModifier( "modifier_ogre_magi_bloodlust_custom_buff", "abilities/ogre_magi/ogre_magi_bloodlust", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_ogre_magi_bloodlust_custom_buff_count", "abilities/ogre_magi/ogre_magi_bloodlust", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_ogre_magi_bloodlust_custom_damage", "abilities/ogre_magi/ogre_magi_bloodlust", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_ogre_magi_bloodlust_custom_tracker", "abilities/ogre_magi/ogre_magi_bloodlust", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_ogre_magi_bloodlust_custom_legendary_1", "abilities/ogre_magi/ogre_magi_bloodlust", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_ogre_magi_bloodlust_custom_legendary_2", "abilities/ogre_magi/ogre_magi_bloodlust", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_ogre_magi_bloodlust_custom_legendary_3", "abilities/ogre_magi/ogre_magi_bloodlust", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_ogre_magi_bloodlust_custom_legendary_4", "abilities/ogre_magi/ogre_magi_bloodlust", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_ogre_magi_bloodlust_custom_legendary_5", "abilities/ogre_magi/ogre_magi_bloodlust", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_ogre_magi_bloodlust_custom_legendary_6", "abilities/ogre_magi/ogre_magi_bloodlust", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_ogre_magi_bloodlust_custom_legendary_attack", "abilities/ogre_magi/ogre_magi_bloodlust", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_ogre_magi_bloodlust_custom_legendary_attack_no", "abilities/ogre_magi/ogre_magi_bloodlust", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_ogre_magi_bloodlust_custom_legendary_resist", "abilities/ogre_magi/ogre_magi_bloodlust", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_ogre_magi_bloodlust_custom_legendary_slow", "abilities/ogre_magi/ogre_magi_bloodlust", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_ogre_magi_bloodlust_custom_heal_cd", "abilities/ogre_magi/ogre_magi_bloodlust", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_ogre_magi_bloodlust_custom_attack_count", "abilities/ogre_magi/ogre_magi_bloodlust", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_ogre_magi_bloodlust_custom_incoming", "abilities/ogre_magi/ogre_magi_bloodlust", LUA_MODIFIER_MOTION_NONE )

ogre_magi_bloodlust_custom = class({})

ogre_magi_bloodlust_custom.speed_attack = {5, 10, 15}
ogre_magi_bloodlust_custom.speed_move = {1, 2, 3}

ogre_magi_bloodlust_custom.damage_max_stack = 10
ogre_magi_bloodlust_custom.damage_duration = 3
ogre_magi_bloodlust_custom.damage_per_stack = {3,5,7}

ogre_magi_bloodlust_custom.proc_chance = {15,25}
ogre_magi_bloodlust_custom.proc_delay = 0.15

ogre_magi_bloodlust_custom.heal = 0.1
ogre_magi_bloodlust_custom.heal_damage = -40
ogre_magi_bloodlust_custom.heal_duration = 3

ogre_magi_bloodlust_custom.attack_max = 10
ogre_magi_bloodlust_custom.attack_stack = 1


ogre_magi_bloodlust_custom.armor = {3,4,5}

ogre_magi_bloodlust_custom.legendary_buffs = 
{
	"modifier_ogre_magi_bloodlust_custom_legendary_1",
	"modifier_ogre_magi_bloodlust_custom_legendary_2",
	"modifier_ogre_magi_bloodlust_custom_legendary_3",
	"modifier_ogre_magi_bloodlust_custom_legendary_4",
	"modifier_ogre_magi_bloodlust_custom_legendary_5",
	"modifier_ogre_magi_bloodlust_custom_legendary_6",
}
ogre_magi_bloodlust_custom.legendary_duration = 25
ogre_magi_bloodlust_custom.legendary_heal = 0.20
ogre_magi_bloodlust_custom.legendary_cdr = 20
ogre_magi_bloodlust_custom.legendary_cast = 50
ogre_magi_bloodlust_custom.legendary_chance = 15
ogre_magi_bloodlust_custom.legendary_bash = 0.2
ogre_magi_bloodlust_custom.legendary_str = 15
ogre_magi_bloodlust_custom.legendary_str_damage = 0.01
ogre_magi_bloodlust_custom.legendary_resist_duration = 5
ogre_magi_bloodlust_custom.legendary_resist_speed = 20
ogre_magi_bloodlust_custom.legendary_resist_effects = 40
ogre_magi_bloodlust_custom.legendary_proc_chance = 25
ogre_magi_bloodlust_custom.legendary_proc_aoe = 700
ogre_magi_bloodlust_custom.legendary_proc_number = 5
ogre_magi_bloodlust_custom.legendary_proc_damage = 0.25
ogre_magi_bloodlust_custom.legendary_proc_slow = -100
ogre_magi_bloodlust_custom.legendary_proc_slow_duration = 1



function ogre_magi_bloodlust_custom:GetIntrinsicModifierName()
	return "modifier_ogre_magi_bloodlust_custom_tracker"
end





function ogre_magi_bloodlust_custom:AddStack()
if not IsServer() then return end

local duration = self:GetSpecialValueFor( "duration" )
local target = self:GetCaster()

target:AddNewModifier( self:GetCaster(), self, "modifier_ogre_magi_bloodlust_custom_buff", { duration = duration } )

local mod = target:FindModifierByName("modifier_ogre_magi_bloodlust_custom_buff")

local max = self:GetSpecialValueFor("max")
if self:GetCaster():HasModifier("modifier_ogremagi_bloodlust_6") then 
	max = max + self.attack_stack
end

if mod and mod:GetStackCount() > max then 

	for _,all_counts in ipairs(self:GetCaster():FindAllModifiersByName("modifier_ogre_magi_bloodlust_custom_buff_count")) do 
     	 all_counts:Destroy()
      	break
    end
end


target:AddNewModifier( self:GetCaster(), self, "modifier_ogre_magi_bloodlust_custom_buff_count", { duration = duration } )

local particle = ParticleManager:CreateParticle( "particles/units/heroes/hero_ogre_magi/ogre_magi_bloodlust_cast.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster() )
ParticleManager:SetParticleControlEnt( particle, 0, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_attack1", Vector(0,0,0), true)
ParticleManager:SetParticleControlEnt( particle, 2, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_attack1", Vector(0,0,0), true )
ParticleManager:SetParticleControlEnt( particle, 3, target, PATTACH_POINT_FOLLOW, "attach_hitloc", Vector(0,0,0), true )
ParticleManager:ReleaseParticleIndex( particle )

self:GetCaster():EmitSound("Hero_OgreMagi.Bloodlust.Cast")

end


function ogre_magi_bloodlust_custom:LegendaryProc()
if not IsServer() then return end

local buff_table = {}

for _,name in pairs(self.legendary_buffs) do
	if not self:GetCaster():HasModifier(name) then 
		buff_table[#buff_table + 1] = name
	end
end


if #buff_table == 0 then 
 	buff_table = self.legendary_buffs
end

local name = buff_table[RandomInt(1, #buff_table)]

self:GetCaster():AddNewModifier(self:GetCaster(), self, name, {duration = self.legendary_duration})
end


function ogre_magi_bloodlust_custom:OnSpellStart(multi)
if not IsServer() then return end
	

if self:GetCaster():HasModifier("modifier_ogre_magi_bloodlust_custom_legendary_5") then 
	local ability = self:GetCaster():FindAbilityByName("ogre_magi_bloodlust_custom")
	self:GetCaster():AddNewModifier(self:GetCaster(), ability, "modifier_ogre_magi_bloodlust_custom_legendary_resist", {duration = ability.legendary_resist_duration})
end

if self:GetCaster():HasModifier("modifier_ogremagi_multi_2") then 
	local ability = self:GetCaster():FindAbilityByName("ogre_magi_multicast_custom")
	self:GetCaster():AddNewModifier(self:GetCaster(), ability, "modifier_ogre_magi_multicast_custom_spell", {duration = ability.spell_duration[self:GetCaster():GetUpgradeStack("modifier_ogremagi_multi_2")]})
	self:GetCaster():AddNewModifier(self:GetCaster(), ability, "modifier_ogre_magi_multicast_custom_spell_count", {duration = ability.spell_duration[self:GetCaster():GetUpgradeStack("modifier_ogremagi_multi_2")]})
end

if self:GetCaster():HasModifier("modifier_ogremagi_bloodlust_5") then 

	self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_ogre_magi_bloodlust_custom_incoming", {duration = self.heal_duration})
end


if self:GetCaster():HasModifier("modifier_ogre_magi_multicast_custom_proc") and multi == nil then 
	local ability = self:GetCaster():FindAbilityByName("ogre_magi_multicast_custom")
	self:GetCaster():RemoveModifierByName("modifier_ogre_magi_multicast_custom_proc")

	self:GetCaster():AddNewModifier(self:GetCaster(), ability, "modifier_ogre_magi_multicast_custom_proc_bkb", {duration = ability.proc_bkb})
end

self:AddStack()


end






modifier_ogre_magi_bloodlust_custom_buff = class({})

function modifier_ogre_magi_bloodlust_custom_buff:IsPurgable()
	return false
end

function modifier_ogre_magi_bloodlust_custom_buff:OnCreated( kv )
	self.model_scale = self:GetAbility():GetSpecialValueFor( "modelscale" )
	self.bonus_movement_speed = self:GetAbility():GetSpecialValueFor( "bonus_movement_speed" )

	self.bonus_attack_speed = self:GetAbility():GetSpecialValueFor( "self_bonus" )

	self.RemoveForDuel = true
	if not IsServer() then return end


	if self:GetParent():HasModifier("modifier_ogremagi_bloodlust_7") then 
		self:GetAbility():LegendaryProc()
	end




	if self:GetParent():HasModifier("modifier_ogremagi_bloodlust_5") then 

	

		local heal = self:GetAbility().heal*(self:GetCaster():GetMaxHealth() - self:GetCaster():GetHealth())
		self:GetCaster():Heal(heal, self:GetAbility())

		SendOverheadEventMessage(self:GetCaster(), 10, self:GetCaster(), heal, nil)

		local particle = ParticleManager:CreateParticle( "particles/generic_gameplay/generic_lifesteal.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster() )
		ParticleManager:ReleaseParticleIndex( particle )
	end




	self:IncrementStackCount()
	self:GetParent():EmitSound("Hero_OgreMagi.Bloodlust.Target")
	EmitSoundOnClient( "Hero_OgreMagi.Bloodlust.Target.FP", self:GetParent():GetPlayerOwner() )
end

function modifier_ogre_magi_bloodlust_custom_buff:OnRefresh( kv )
	self:OnCreated( kv )
end

function modifier_ogre_magi_bloodlust_custom_buff:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_MODEL_SCALE,
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS
	}

	return funcs
end

function modifier_ogre_magi_bloodlust_custom_buff:GetModifierMoveSpeedBonus_Percentage()
local bonus = 0

if self:GetCaster():HasModifier("modifier_ogremagi_bloodlust_1") then 
	bonus = self:GetAbility().speed_move[self:GetCaster():GetUpgradeStack("modifier_ogremagi_bloodlust_1")]
end

	return (self.bonus_movement_speed + bonus)*self:GetStackCount()
end


function modifier_ogre_magi_bloodlust_custom_buff:GetModifierPhysicalArmorBonus()
local bonus = 0

if self:GetCaster():HasModifier("modifier_ogremagi_bloodlust_3") then 
	bonus = self:GetAbility().armor[self:GetCaster():GetUpgradeStack("modifier_ogremagi_bloodlust_3")]
end

	return (bonus)*self:GetStackCount()
end




function modifier_ogre_magi_bloodlust_custom_buff:GetModifierAttackSpeedBonus_Constant()
local bonus = 0

if self:GetCaster():HasModifier("modifier_ogremagi_bloodlust_1") then 
	bonus = self:GetAbility().speed_attack[self:GetCaster():GetUpgradeStack("modifier_ogremagi_bloodlust_1")]
end

return (self.bonus_attack_speed + bonus)*self:GetStackCount()
end

function modifier_ogre_magi_bloodlust_custom_buff:GetModifierModelScale()
	return self.model_scale
end








modifier_ogre_magi_bloodlust_custom_buff_count = class({})
function modifier_ogre_magi_bloodlust_custom_buff_count:IsHidden() return true end
function modifier_ogre_magi_bloodlust_custom_buff_count:IsPurgable() return false end
function modifier_ogre_magi_bloodlust_custom_buff_count:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end

function modifier_ogre_magi_bloodlust_custom_buff_count:OnCreated(table)
self.RemoveForDuel = true
end

function modifier_ogre_magi_bloodlust_custom_buff_count:OnDestroy()
if not IsServer() then return end
local mod = self:GetParent():FindModifierByName("modifier_ogre_magi_bloodlust_custom_buff")
if mod then 
	mod:DecrementStackCount()
	if mod:GetStackCount() == 0 then 
		mod:Destroy()
	end
end

end
function modifier_ogre_magi_bloodlust_custom_buff_count:GetEffectName()
	return "particles/units/heroes/hero_ogre_magi/ogre_magi_bloodlust_buff.vpcf"
end

function modifier_ogre_magi_bloodlust_custom_buff_count:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end


modifier_ogre_magi_bloodlust_custom_damage = class({})
function modifier_ogre_magi_bloodlust_custom_damage:IsHidden() return false end
function modifier_ogre_magi_bloodlust_custom_damage:IsPurgable() return false end
function modifier_ogre_magi_bloodlust_custom_damage:GetTexture() return "buffs/bloodlust_damage" end

function modifier_ogre_magi_bloodlust_custom_damage:OnCreated(table)
if not self:GetAbility() then return end

if not IsServer() then return end

self:SetStackCount(1)
end

function modifier_ogre_magi_bloodlust_custom_damage:OnRefresh(table)
if not IsServer() then return end
if self:GetStackCount() >= self:GetAbility().damage_max_stack then return end
self:IncrementStackCount()
end

function modifier_ogre_magi_bloodlust_custom_damage:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE
}
end


function modifier_ogre_magi_bloodlust_custom_damage:GetModifierPreAttack_BonusDamage()
return self:GetStackCount()*self:GetAbility().damage_per_stack[self:GetCaster():GetUpgradeStack("modifier_ogremagi_bloodlust_2")]
end




modifier_ogre_magi_bloodlust_custom_tracker = class({})
function modifier_ogre_magi_bloodlust_custom_tracker:IsHidden() return true end
function modifier_ogre_magi_bloodlust_custom_tracker:IsPurgable() return false end
function modifier_ogre_magi_bloodlust_custom_tracker:DeclareFunctions()
return
{
	MODIFIER_EVENT_ON_ATTACK_LANDED,
}
end





function modifier_ogre_magi_bloodlust_custom_tracker:OnAttackLanded(params)
if not IsServer() then return end
if self:GetParent() ~= params.attacker then return end

if self:GetParent():HasModifier("modifier_ogremagi_bloodlust_6") and not params.target:IsBuilding() then 
	self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_ogre_magi_bloodlust_custom_attack_count", {target = params.target:entindex()})
end


if self:GetParent():HasModifier("modifier_ogremagi_bloodlust_2") then 
	self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_ogre_magi_bloodlust_custom_damage", {duration = self:GetAbility().damage_duration})
end


if self:GetParent():HasModifier("modifier_ogremagi_bloodlust_4") then 
	if params.target:IsAlive()  and (params.target:IsCreep() or params.target:IsHero()) and 
		RollPseudoRandomPercentage(self:GetAbility().proc_chance[self:GetCaster():GetUpgradeStack("modifier_ogremagi_bloodlust_4")], 546, self:GetParent()) then 

		params.target:AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_ogre_magi_bloodlust_custom_legendary_attack", {duration = self:GetAbility().proc_delay})
	end
end


if self:GetParent():HasModifier("modifier_ogre_magi_bloodlust_custom_legendary_6") then 
	if params.target and RollPseudoRandomPercentage(self:GetAbility().legendary_proc_chance, 548, self:GetParent()) then 


		self:GetParent():EmitSound("Item.Maelstrom.Chain_Lightning.Jump")

		local units = FindUnitsInRadius( self:GetParent():GetTeamNumber(), params.target:GetAbsOrigin(), nil, self:GetAbility().legendary_proc_aoe, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO+DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_CLOSEST, false )
		for _, unit in pairs(units) do

			local damage = params.damage*self:GetAbility().legendary_proc_damage
				
			ApplyDamage({victim = unit, attacker = self:GetParent(), damage = damage, damage_type = DAMAGE_TYPE_MAGICAL})

			SendOverheadEventMessage(unit, 4, unit, damage, nil)

			--unit:AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_ogre_magi_bloodlust_custom_legendary_slow", {duration = self:GetAbility().legendary_proc_slow_duration*(1 - unit:GetStatusResistance())})

			local source = self:GetParent()
			if unit ~= params.target then 
				source = params.target
			end

			unit:EmitSound("Item.Maelstrom.Chain_Lightning")

			local particle = ParticleManager:CreateParticle( "particles/orge_lightning.vpcf", PATTACH_POINT_FOLLOW, unit )
			ParticleManager:SetParticleControlEnt( particle, 0, unit, PATTACH_POINT_FOLLOW, "attach_hitloc", unit:GetAbsOrigin(), true )
			ParticleManager:SetParticleControlEnt( particle, 1, source, PATTACH_POINT_FOLLOW, "attach_hitloc", source:GetAbsOrigin(), true )
			ParticleManager:ReleaseParticleIndex( particle )



		end
	end
end


if self:GetParent():HasModifier("modifier_ogre_magi_bloodlust_custom_legendary_3") then 
	local chance = self:GetAbility().legendary_chance

	if RollPseudoRandomPercentage(chance, 542, self:GetParent()) then 
		params.target:EmitSound("BB.Goo_stun")
		params.target:AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_bashed", {duration = (1 - params.target:GetStatusResistance())*self:GetAbility().legendary_bash})
	end
end

end




modifier_ogre_magi_bloodlust_custom_legendary_1 = class({})
function modifier_ogre_magi_bloodlust_custom_legendary_1:IsHidden() return true end
function modifier_ogre_magi_bloodlust_custom_legendary_1:IsPurgable() return false end
function modifier_ogre_magi_bloodlust_custom_legendary_1:DeclareFunctions()
return
{
	MODIFIER_EVENT_ON_TAKEDAMAGE
}
end

function modifier_ogre_magi_bloodlust_custom_legendary_1:OnTakeDamage(params)
if not IsServer() then return end
if self:GetCaster() ~= params.attacker then return end

local heal = self:GetAbility().legendary_heal*params.damage

self:GetCaster():Heal(heal, self)

SendOverheadEventMessage(self:GetCaster(), 10, self:GetCaster(), heal, nil)

local particle = ParticleManager:CreateParticle( "particles/generic_gameplay/generic_lifesteal.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster() )
ParticleManager:ReleaseParticleIndex( particle )

end

function modifier_ogre_magi_bloodlust_custom_legendary_1:OnCreated(table)
if not IsServer() then return end
self.RemoveForDuel = true 
end




modifier_ogre_magi_bloodlust_custom_legendary_2 = class({})
function modifier_ogre_magi_bloodlust_custom_legendary_2:IsHidden() return true end
function modifier_ogre_magi_bloodlust_custom_legendary_2:IsPurgable() return false end
function modifier_ogre_magi_bloodlust_custom_legendary_2:GetEffectName()
return "particles/generic_gameplay/rune_arcane_owner.vpcf"
end

function modifier_ogre_magi_bloodlust_custom_legendary_2:OnCreated(table)
if not IsServer() then return end
self.RemoveForDuel = true 
end

function modifier_ogre_magi_bloodlust_custom_legendary_2:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_CASTTIME_PERCENTAGE,
MODIFIER_PROPERTY_COOLDOWN_PERCENTAGE
}
end

function modifier_ogre_magi_bloodlust_custom_legendary_2:GetModifierPercentageCasttime()
return self:GetAbility().legendary_cast
end


function modifier_ogre_magi_bloodlust_custom_legendary_2:GetModifierPercentageCooldown() 
	return self:GetAbility().legendary_cdr
end
   





modifier_ogre_magi_bloodlust_custom_legendary_3 = class({})
function modifier_ogre_magi_bloodlust_custom_legendary_3:IsHidden() return true end
function modifier_ogre_magi_bloodlust_custom_legendary_3:IsPurgable() return false end

function modifier_ogre_magi_bloodlust_custom_legendary_3:OnCreated(table)
if not IsServer() then return end
self.RemoveForDuel = true 
end




modifier_ogre_magi_bloodlust_custom_legendary_4 = class({})
function modifier_ogre_magi_bloodlust_custom_legendary_4:IsHidden() return true end
function modifier_ogre_magi_bloodlust_custom_legendary_4:IsPurgable() return false end
function modifier_ogre_magi_bloodlust_custom_legendary_4:GetEffectName()
 return "particles/ogre_shield.vpcf" end
 
function modifier_ogre_magi_bloodlust_custom_legendary_4:GetEffectAttachType() return PATTACH_OVERHEAD_FOLLOW end


function modifier_ogre_magi_bloodlust_custom_legendary_4:OnCreated(table)
if not IsServer() then return end
	self.RemoveForDuel = true
	self.str_percentage = self:GetAbility().legendary_str
	self:StartIntervalThink(0.2)
end

function modifier_ogre_magi_bloodlust_custom_legendary_4:OnIntervalThink()
if not IsServer() then return end
self.str  = 0

self.str   = self:GetParent():GetStrength() * self.str_percentage * 0.01

self:GetParent():CalculateStatBonus(true)


end

function modifier_ogre_magi_bloodlust_custom_legendary_4:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
	MODIFIER_EVENT_ON_ATTACK_LANDED
}
end


function modifier_ogre_magi_bloodlust_custom_legendary_4:GetModifierBonusStats_Strength()
  return self.str
end


function modifier_ogre_magi_bloodlust_custom_legendary_4:OnAttackLanded(params)
if not IsServer() then return end 
if self:GetParent() ~= params.target then return end

local damage = self:GetParent():GetMaxHealth()*(self:GetAbility().legendary_str_damage)

ApplyDamage({victim = params.attacker, attacker = self:GetParent(), damage = damage, damage_type = DAMAGE_TYPE_MAGICAL})
SendOverheadEventMessage(params.attacker, 4, params.attacker, damage, nil)
end
			




modifier_ogre_magi_bloodlust_custom_legendary_5 = class({})
function modifier_ogre_magi_bloodlust_custom_legendary_5:IsHidden() return true end
function modifier_ogre_magi_bloodlust_custom_legendary_5:IsPurgable() return false end


function modifier_ogre_magi_bloodlust_custom_legendary_5:OnCreated(table)
if not IsServer() then return end
self.RemoveForDuel = true 
end


modifier_ogre_magi_bloodlust_custom_legendary_resist = class({})
function modifier_ogre_magi_bloodlust_custom_legendary_resist:IsHidden() return false end
function modifier_ogre_magi_bloodlust_custom_legendary_resist:IsPurgable() return true end
function modifier_ogre_magi_bloodlust_custom_legendary_resist:GetTexture() return "buffs/bloodlust_resist" end
function modifier_ogre_magi_bloodlust_custom_legendary_resist:GetEffectName() return "particles/items4_fx/ascetic_cap.vpcf" end

function modifier_ogre_magi_bloodlust_custom_legendary_resist:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
	MODIFIER_PROPERTY_STATUS_RESISTANCE_STACKING
}

end
function modifier_ogre_magi_bloodlust_custom_legendary_resist:GetModifierMoveSpeedBonus_Percentage()
	return self:GetAbility().legendary_resist_speed
end
function modifier_ogre_magi_bloodlust_custom_legendary_resist:GetModifierStatusResistanceStacking() 
	return self:GetAbility().legendary_resist_effects
end



modifier_ogre_magi_bloodlust_custom_legendary_6 = class({})
function modifier_ogre_magi_bloodlust_custom_legendary_6:IsHidden() return true end
function modifier_ogre_magi_bloodlust_custom_legendary_6:IsPurgable() return false end
function modifier_ogre_magi_bloodlust_custom_legendary_6:GetEffectName()
return "particles/ogre_dd.vpcf"
end


function modifier_ogre_magi_bloodlust_custom_legendary_6:OnCreated(table)
if not IsServer() then return end
self.RemoveForDuel = true 
end








modifier_ogre_magi_bloodlust_custom_legendary_attack = class({})
function modifier_ogre_magi_bloodlust_custom_legendary_attack:IsHidden() return true end
function modifier_ogre_magi_bloodlust_custom_legendary_attack:IsPurgable() return false end
function modifier_ogre_magi_bloodlust_custom_legendary_attack:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end
function modifier_ogre_magi_bloodlust_custom_legendary_attack:OnDestroy()
if not IsServer() then return end
if not self:GetParent():IsAlive() then return end
if not self:GetCaster() then return end
if self:GetCaster():IsNull() then return end

self:GetCaster():PerformAttack(self:GetParent(), true, true, true, true, false, false, false)
self:GetParent():EmitSound("Ogre.Bloodlust_hit")

end



modifier_ogre_magi_bloodlust_custom_legendary_slow = class({})
function modifier_ogre_magi_bloodlust_custom_legendary_slow:IsHidden() return false end
function modifier_ogre_magi_bloodlust_custom_legendary_slow:IsPurgable() return false end
function modifier_ogre_magi_bloodlust_custom_legendary_slow:GetTexture() return "buffs/bloodlust_slow" end
function modifier_ogre_magi_bloodlust_custom_legendary_slow:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE
}
end

function modifier_ogre_magi_bloodlust_custom_legendary_slow:GetModifierMoveSpeedBonus_Percentage()
	return self:GetAbility().legendary_proc_slow
end



modifier_ogre_magi_bloodlust_custom_heal_cd = class({})

function modifier_ogre_magi_bloodlust_custom_heal_cd:IsPurgable() return false end
function modifier_ogre_magi_bloodlust_custom_heal_cd:IsHidden() return false end
function modifier_ogre_magi_bloodlust_custom_heal_cd:IsDebuff() return true end
function modifier_ogre_magi_bloodlust_custom_heal_cd:RemoveOnDeath() return false end
function modifier_ogre_magi_bloodlust_custom_heal_cd:GetTexture()
  return "buffs/inner_heal" end
function modifier_ogre_magi_bloodlust_custom_heal_cd:OnCreated(table)
  self.RemoveForDuel = true
end




modifier_ogre_magi_bloodlust_custom_attack_count = class({})
function modifier_ogre_magi_bloodlust_custom_attack_count:IsHidden() return false end
function modifier_ogre_magi_bloodlust_custom_attack_count:IsPurgable() return false end
function modifier_ogre_magi_bloodlust_custom_attack_count:GetTexture() return "buffs/bloodlust_count" end

function modifier_ogre_magi_bloodlust_custom_attack_count:OnCreated(table)
if not IsServer() then return end
self.RemoveForDuel = true 
self:SetStackCount(1)
self.target = EntIndexToHScript(table.target)

self.particle = ParticleManager:CreateParticle("particles/troll_char.vpcf", PATTACH_OVERHEAD_FOLLOW, self:GetParent())
self:AddParticle(self.particle, false, false, -1, false, false)


end


function modifier_ogre_magi_bloodlust_custom_attack_count:OnRefresh(table)
if not IsServer() then return end

local new_target = EntIndexToHScript(table.target)
if not new_target then return end 

if new_target == self.target then 
	self:IncrementStackCount()
	if self:GetStackCount() >= self:GetAbility().attack_max then 
		self:Destroy()
		self:GetAbility():AddStack()
	end
else 
	self.target = new_target
	self:SetStackCount(1)
end

end


function modifier_ogre_magi_bloodlust_custom_attack_count:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_TOOLTIP
}
end

function modifier_ogre_magi_bloodlust_custom_attack_count:OnTooltip()
	return self:GetAbility().attack_max
end



function modifier_ogre_magi_bloodlust_custom_attack_count:OnStackCountChanged(iStackCount)
if self:GetStackCount() == 0 then return end
if not self.particle then return end

local max = self:GetAbility().attack_max/2
local stack = math.min(math.floor(self:GetStackCount()/2), max)


for i = 1,max do 
	
	if i <= stack then 
		ParticleManager:SetParticleControl(self.particle, i, Vector(1, 0, 0))	
	else 
		ParticleManager:SetParticleControl(self.particle, i, Vector(0, 0, 0))	
	end
end

end





modifier_ogre_magi_bloodlust_custom_incoming = class({})
function modifier_ogre_magi_bloodlust_custom_incoming:IsHidden() return false end
function modifier_ogre_magi_bloodlust_custom_incoming:IsPurgable() return false end
function modifier_ogre_magi_bloodlust_custom_incoming:GetTexture() return "buffs/chemical_incoming" end
function modifier_ogre_magi_bloodlust_custom_incoming:OnCreated(table)
if not IsServer() then return end

 
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



function modifier_ogre_magi_bloodlust_custom_incoming:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE
}
end

function modifier_ogre_magi_bloodlust_custom_incoming:GetModifierIncomingDamage_Percentage()
return self:GetAbility().heal_damage
end