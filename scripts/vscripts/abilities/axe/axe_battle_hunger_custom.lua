LinkLuaModifier( "modifier_axe_battle_hunger_custom_buff", "abilities/axe/axe_battle_hunger_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_axe_battle_hunger_custom_creep", "abilities/axe/axe_battle_hunger_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_axe_battle_hunger_custom_hero", "abilities/axe/axe_battle_hunger_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_axe_battle_hunger_custom_debuff", "abilities/axe/axe_battle_hunger_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_axe_battle_hunger_custom_str_buff", "abilities/axe/axe_battle_hunger_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_axe_battle_hunger_custom_str_buff_counter", "abilities/axe/axe_battle_hunger_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_axe_battle_hunger_custom_str_silence", "abilities/axe/axe_battle_hunger_custom", LUA_MODIFIER_MOTION_NONE )

axe_battle_hunger_custom = class({})

axe_battle_hunger_custom.scepter_armor = 7

axe_battle_hunger_custom.damage_init = 0
axe_battle_hunger_custom.damage_inc = 20

axe_battle_hunger_custom.reduce_init = -2
axe_battle_hunger_custom.reduce_inc = -2

axe_battle_hunger_custom.armor_reduce = 1
axe_battle_hunger_custom.armor_duration = {8,12}

axe_battle_hunger_custom.silence_timer = 5
axe_battle_hunger_custom.silence_duration = 2

axe_battle_hunger_custom.legendary_health = 0.3
axe_battle_hunger_custom.legendary_multi = 1
axe_battle_hunger_custom.legendary_timer = 3

axe_battle_hunger_custom.slow = {5,10,15}
axe_battle_hunger_custom.movespeed_bonus = {10,15,20}

function axe_battle_hunger_custom:CastFilterResultTarget(target)
	if target:GetTeamNumber() == self:GetCaster():GetTeamNumber() and self:GetCaster() ~= target and self:GetCaster():HasModifier("modifier_axe_hunger_5") then
		return UF_FAIL_FRIENDLY 
	end

	if target ~= nil and target:IsMagicImmune() then
		return UF_FAIL_MAGIC_IMMUNE_ENEMY
	end

	if not self:GetCaster():HasModifier("modifier_axe_hunger_5") then 
		return UnitFilter(target, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 0, self:GetCaster():GetTeamNumber())
	else 	
		return UnitFilter(target, DOTA_UNIT_TARGET_TEAM_BOTH, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 0, self:GetCaster():GetTeamNumber())
	end
end







function axe_battle_hunger_custom:OnSpellStart(new_target)
if not IsServer() then return end
	local target = self:GetCursorTarget()

	if new_target ~= nil then 
		target = new_target
	end

	if target == self:GetCaster() then 
		self:GetCaster():Purge(false, true, false, false, false)
	end

	local duration = self:GetSpecialValueFor("duration")
	if target:TriggerSpellAbsorb( self ) then return end
	target:AddNewModifier( self:GetCaster(), self, "modifier_axe_battle_hunger_custom_debuff", { duration = duration } )
	local mod = self:GetCaster():AddNewModifier( self:GetCaster(), self, "modifier_axe_battle_hunger_custom_buff", {target = target:entindex(),  duration = duration } )


	target:EmitSound("Hero_Axe.Battle_Hunger")
end





modifier_axe_battle_hunger_custom_buff = class({})

function modifier_axe_battle_hunger_custom_buff:IsPurgable()
	return false
end

function modifier_axe_battle_hunger_custom_buff:IsHidden()
return not self:GetCaster():HasModifier("modifier_axe_hunger_3")
end




function modifier_axe_battle_hunger_custom_buff:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS
	}

	return funcs
end

function modifier_axe_battle_hunger_custom_buff:GetModifierMoveSpeedBonus_Percentage()
	return self:GetAbility().movespeed_bonus[self:GetCaster():GetUpgradeStack("modifier_axe_hunger_3")]
end


function modifier_axe_battle_hunger_custom_buff:GetModifierPhysicalArmorBonus()
if self:GetCaster():HasScepter() then 
	return (self:GetAbility().scepter_armor/2)*self:GetCaster():GetUpgradeStack("modifier_axe_battle_hunger_custom_creep") + self:GetAbility().scepter_armor*self:GetCaster():GetUpgradeStack("modifier_axe_battle_hunger_custom_hero")
end

return
end

modifier_axe_battle_hunger_custom_debuff = class({})

function modifier_axe_battle_hunger_custom_debuff:IsPurgable()
	return not self:GetCaster():HasModifier("modifier_axe_hunger_legendary")
end

function modifier_axe_battle_hunger_custom_debuff:OnCreated( kv )
	self.slow = self:GetAbility():GetSpecialValueFor( "slow" )
	self.damage = self:GetAbility():GetSpecialValueFor( "damage_per_second" )

	local caster = self:GetCaster()

	if caster:HasModifier("modifier_axe_hunger_1") then 
 		self.damage = self.damage + self:GetAbility().damage_init + self:GetAbility().damage_inc*self:GetCaster():GetUpgradeStack("modifier_axe_hunger_1")
	end

	self.armor_multi = self:GetAbility():GetSpecialValueFor("armor_multiplier")

	self.stone_angle = 85
	self.facing = false

	local caster = self:GetCaster()
	if self:GetCaster().owner ~= nil then 
		caster = self:GetCaster().owner
	end

	if caster:HasModifier("modifier_axe_hunger_3") then 
		self.slow = self.slow - self:GetAbility().slow[self:GetCaster():GetUpgradeStack("modifier_axe_hunger_3")]
	end



	self.armor = -1*self:GetAbility().scepter_armor
	if not IsServer() then return end

	local name = "modifier_axe_battle_hunger_custom_creep"
	if self:GetParent():IsHero() then 
		name = "modifier_axe_battle_hunger_custom_hero"
	end

	if self:GetCaster():HasModifier("modifier_axe_hunger_legendary") and self:GetCaster() ~= self:GetParent() then 
		self:SetStackCount(self:GetCaster():GetMaxHealth()*self:GetAbility().legendary_health)
	end


	self.count = -1
	self.legendary_count = -1
	self.legendary_damage = 0

	self:GetCaster():AddNewModifier(self:GetCaster(), self:GetAbility(), name, {})

	self:StartIntervalThink( 1 )
	self:OnIntervalThink()
end



function modifier_axe_battle_hunger_custom_debuff:OnRefresh()
if not IsServer() then return end

	if self:GetCaster():HasModifier("modifier_axe_hunger_legendary") and self:GetCaster() ~= self:GetParent() then 
		self:SetStackCount(self:GetCaster():GetMaxHealth()*self:GetAbility().legendary_health)
	end
end

function modifier_axe_battle_hunger_custom_debuff:OnDestroy( kv )
if not IsServer() then return end
if self:GetCaster() == nil then return end

local name = "modifier_axe_battle_hunger_custom_creep"
if self:GetParent():IsHero() then 
	name = "modifier_axe_battle_hunger_custom_hero"
end

local mod = self:GetCaster():FindModifierByName(name)
if mod then 
	mod:DecrementStackCount()
	if mod:GetStackCount() == 0 then
		mod:Destroy()
	end
end


if not self:GetCaster():HasModifier("modifier_axe_battle_hunger_custom_hero") and not self:GetCaster():HasModifier("modifier_axe_battle_hunger_custom_creep") then 
	if self:GetCaster():HasModifier("modifier_axe_battle_hunger_custom_buff") then 
		self:GetCaster():RemoveModifierByName("modifier_axe_battle_hunger_custom_buff")
	end
end

end

function modifier_axe_battle_hunger_custom_debuff:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_DEATH,
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
		MODIFIER_PROPERTY_TOOLTIP,
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
		MODIFIER_EVENT_ON_TAKEDAMAGE,
		MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE
	}

	return funcs
end


function modifier_axe_battle_hunger_custom_debuff:OnTakeDamage(params)
if not IsServer() then return end
if self:GetCaster() == self:GetParent() then return end
if not self:GetCaster():HasModifier("modifier_axe_hunger_legendary") then return end
if self:GetParent() ~= params.attacker then return end

self:SetStackCount(self:GetStackCount() - params.damage)
if self:GetStackCount() <= 0 then 
	self:Destroy()
end

end

function modifier_axe_battle_hunger_custom_debuff:GetModifierTotalDamageOutgoing_Percentage()
if self:GetCaster() == self:GetParent() then return end

local bonus = 0
if self:GetCaster():HasModifier("modifier_axe_hunger_2") then 
	bonus = self:GetAbility().reduce_init + self:GetAbility().reduce_inc*self:GetCaster():GetUpgradeStack("modifier_axe_hunger_2")
end

return bonus
end


function modifier_axe_battle_hunger_custom_debuff:GetModifierPhysicalArmorBonus()
if self:GetCaster() == self:GetParent() then return end
if self:GetCaster():HasScepter() then 
	return self.armor
end

return
end

function modifier_axe_battle_hunger_custom_debuff:OnDeath( params )
if not IsServer() then return end
if self:GetCaster():HasModifier("modifier_axe_hunger_legendary") then return end
if params.attacker~=self:GetParent() then return end
if self:GetCaster() == self:GetParent() then return end
	self:Destroy()
end

function modifier_axe_battle_hunger_custom_debuff:GetModifierMoveSpeedBonus_Percentage()
if not IsServer() then return end
if self:GetCaster() == self:GetParent() then return end
	local vector = (self:GetCaster():GetAbsOrigin()-self:GetParent():GetAbsOrigin()):Normalized()

	local center_angle = VectorToAngles( vector ).y
	local facing_angle = VectorToAngles( self:GetParent():GetForwardVector() ).y


	local facing = ( math.abs( AngleDiff(center_angle,facing_angle) ) > self.stone_angle ) 

	if facing then
		return self.slow
	end
end



function modifier_axe_battle_hunger_custom_debuff:OnIntervalThink()
if not IsServer() then return end

	if self:GetCaster():HasModifier("modifier_axe_hunger_6") and self:GetCaster() ~= self:GetParent() then 
		self.count = self.count + 1
	end

	if self.count >= self:GetAbility().silence_timer then 
		self.count = 0
		self:GetParent():EmitSound("Sf.Raze_Silence")
		self:GetParent():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_axe_battle_hunger_custom_str_silence", {duration = (1 - self:GetParent():GetStatusResistance())*self:GetAbility().silence_duration})
	end

	if self:GetCaster():HasModifier("modifier_axe_hunger_legendary") and self:GetCaster() ~= self:GetParent() then 
		self.legendary_count = self.legendary_count + 1
	end

	if self.legendary_count >= self:GetAbility().legendary_timer then 


    	local effect_target = ParticleManager:CreateParticle( "particles/units/heroes/hero_doom_bringer/doom_infernal_blade_impact.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
    	ParticleManager:SetParticleControl( effect_target, 0, self:GetParent():GetAbsOrigin() )
    	ParticleManager:ReleaseParticleIndex( effect_target )
		self:GetParent():EmitSound("Axe.Hunger_damage")

		self.legendary_count = 0
		
		self.armor_multi = self.armor_multi + self:GetAbility().legendary_multi
		SendOverheadEventMessage(self:GetParent(), 2, self:GetParent(), self.armor_multi, nil)
	end


	if self:GetCaster():HasModifier("modifier_axe_hunger_4") and self:GetParent() ~= self:GetCaster() then 

		local duration = self:GetAbility().armor_duration[self:GetCaster():GetUpgradeStack("modifier_axe_hunger_4")]
		self:GetCaster():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_axe_battle_hunger_custom_str_buff", {duration = duration})
		self:GetCaster():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_axe_battle_hunger_custom_str_buff_counter", {duration = duration})
 
		self:GetParent():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_axe_battle_hunger_custom_str_buff", {duration = duration})
		self:GetParent():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_axe_battle_hunger_custom_str_buff_counter", {duration = duration})
		

	end

	if self:GetCaster() == self:GetParent() then 

		local heal = self.damage + self:GetCaster():GetPhysicalArmorValue(false)*self.armor_multi
		self:GetCaster():Heal(heal, self:GetCaster())
		SendOverheadEventMessage(self:GetCaster(), 10, self:GetCaster(), heal, nil)

		local particle = ParticleManager:CreateParticle( "particles/generic_gameplay/generic_lifesteal.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster() )
		ParticleManager:ReleaseParticleIndex( particle )
	else 

		local damage = self.damage + self:GetCaster():GetPhysicalArmorValue(false)*self.armor_multi
		local damageTable = { victim = self:GetParent(), attacker = self:GetCaster(), damage = damage, damage_type = DAMAGE_TYPE_PHYSICAL, ability = self:GetAbility(), damage_flags = DOTA_DAMAGE_FLAG_NONE, }

		ApplyDamage( damageTable )
	end

	
end

function modifier_axe_battle_hunger_custom_debuff:GetEffectName()
	return "particles/units/heroes/hero_axe/axe_battle_hunger.vpcf"
end

function modifier_axe_battle_hunger_custom_debuff:GetEffectAttachType()
	return PATTACH_OVERHEAD_FOLLOW
end



modifier_axe_battle_hunger_custom_creep = class({})
function modifier_axe_battle_hunger_custom_creep:IsHidden() return true end
function modifier_axe_battle_hunger_custom_creep:IsPurgable() return false end

function modifier_axe_battle_hunger_custom_creep:OnCreated(table)
if not IsServer() then return end
self:SetStackCount(1)
end


function modifier_axe_battle_hunger_custom_creep:OnRefresh(table)
if not IsServer() then return end
self:IncrementStackCount()
end

modifier_axe_battle_hunger_custom_hero = class({})
function modifier_axe_battle_hunger_custom_hero:IsHidden() return true end
function modifier_axe_battle_hunger_custom_hero:IsPurgable() return false end
function modifier_axe_battle_hunger_custom_hero:OnCreated(table)
if not IsServer() then return end
self:SetStackCount(1)
end


function modifier_axe_battle_hunger_custom_hero:OnRefresh(table)
if not IsServer() then return end
self:IncrementStackCount()
end



modifier_axe_battle_hunger_custom_str_buff = class({})
function modifier_axe_battle_hunger_custom_str_buff:IsHidden() return true end
function modifier_axe_battle_hunger_custom_str_buff:IsPurgable() return false end
function modifier_axe_battle_hunger_custom_str_buff:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end
function modifier_axe_battle_hunger_custom_str_buff:OnDestroy()
if not IsServer() then return end
local mod = self:GetParent():FindModifierByName("modifier_axe_battle_hunger_custom_str_buff_counter")
if mod then 
	mod:DecrementStackCount()
	if mod:GetStackCount() == 0 then 
		mod:Destroy()
	end
end

end

function modifier_axe_battle_hunger_custom_str_buff:OnCreated(table)
self.RemoveForDuel = true 
end


modifier_axe_battle_hunger_custom_str_buff_counter = class({})

function modifier_axe_battle_hunger_custom_str_buff_counter:IsHidden() return false end
function modifier_axe_battle_hunger_custom_str_buff_counter:GetTexture() return "buffs/hunger_str" end
function modifier_axe_battle_hunger_custom_str_buff_counter:IsPurgable() return false end

function modifier_axe_battle_hunger_custom_str_buff_counter:DeclareFunctions()
return
 { MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS } 
end

function modifier_axe_battle_hunger_custom_str_buff_counter:OnCreated(table)
if not IsServer() then return end
  self:SetStackCount(1) 
end


function modifier_axe_battle_hunger_custom_str_buff_counter:OnRefresh(table)
if not IsServer() then return end
  self:SetStackCount(self:GetStackCount()+1)
end

function modifier_axe_battle_hunger_custom_str_buff_counter:GetModifierPhysicalArmorBonus()
local bonus = self:GetAbility().armor_reduce

if self:GetCaster() ~= self:GetParent() then 
	bonus = -1*bonus
end

return bonus*self:GetStackCount()
end


modifier_axe_battle_hunger_custom_str_silence = class({})

function modifier_axe_battle_hunger_custom_str_silence:IsHidden() return false end

function modifier_axe_battle_hunger_custom_str_silence:IsPurgable() return true end

function modifier_axe_battle_hunger_custom_str_silence:CheckState() return {[MODIFIER_STATE_SILENCED] = true} end


function modifier_axe_battle_hunger_custom_str_silence:GetEffectName() return "particles/generic_gameplay/generic_silenced.vpcf" end
 
function modifier_axe_battle_hunger_custom_str_silence:GetEffectAttachType() return PATTACH_OVERHEAD_FOLLOW end
