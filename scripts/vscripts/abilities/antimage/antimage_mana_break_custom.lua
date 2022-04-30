LinkLuaModifier( "modifier_antimage_mana_break_custom", "abilities/antimage/antimage_mana_break_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_antimage_mana_break_custom_slow", "abilities/antimage/antimage_mana_break_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_antimage_mana_break_custom_silence", "abilities/antimage/antimage_mana_break_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_antimage_mana_break_custom_anim", "abilities/antimage/antimage_mana_break_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_antimage_mana_break_custom_legendary", "abilities/antimage/antimage_mana_break_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_antimage_mana_break_custom_cost", "abilities/antimage/antimage_mana_break_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_antimage_mana_break_custom_damage", "abilities/antimage/antimage_mana_break_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_antimage_mana_break_custom_damage_cd", "abilities/antimage/antimage_mana_break_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_antimage_mana_break_custom_anim_normal", "abilities/antimage/antimage_mana_break_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_antimage_mana_break_custom_rooted", "abilities/antimage/antimage_mana_break_custom", LUA_MODIFIER_MOTION_NONE )



antimage_mana_break_custom = class({})

antimage_mana_break_custom.burn_damage = {0.4,0.8,1.2}

antimage_mana_break_custom.heal = {10,15,20}
antimage_mana_break_custom.heal_k = 2

antimage_mana_break_custom.no_mana_damage = {10, 15}
antimage_mana_break_custom.no_mana_stun = {1.0, 1.5}
antimage_mana_break_custom.no_mana_damage_duration = 5
antimage_mana_break_custom.no_mana_cd = 15
antimage_mana_break_custom.no_mana_pct = 0.5

antimage_mana_break_custom.silence_mana = 80
antimage_mana_break_custom.silence_duration = 1

antimage_mana_break_custom.slow_reduction = -30
antimage_mana_break_custom.slow_mana = 50

antimage_mana_break_custom.legenday_duration = 10
antimage_mana_break_custom.legenday_damage = 1.2
antimage_mana_break_custom.legenday_slow_k = 2
antimage_mana_break_custom.legenday_cd = 25

antimage_mana_break_custom.mana_cost = {-10,-15,-20}
antimage_mana_break_custom.mana_cost_duration = 2



function antimage_mana_break_custom:GetCooldown(iLevel)

if self:GetCaster():HasModifier("modifier_antimage_break_7") then 
	return self.legenday_cd
end

return
end


function antimage_mana_break_custom:GetBehavior()
  if self:GetCaster():HasModifier("modifier_antimage_break_7") then
    return  DOTA_ABILITY_BEHAVIOR_NO_TARGET
  end
 return DOTA_ABILITY_BEHAVIOR_PASSIVE
end

function antimage_mana_break_custom:OnAbilityPhaseStart()
if not IsServer() then return end
self:GetCaster():StartGestureWithPlaybackRate(ACT_DOTA_CAST_ABILITY_2, 1.2)

return true
end


function antimage_mana_break_custom:OnAbilityPhaseInterrupted()
if not IsServer() then return end
self:GetCaster():FadeGesture(ACT_DOTA_CAST_ABILITY_2)
end


function antimage_mana_break_custom:OnSpellStart()
if not IsServer() then return end

self:GetCaster():EmitSound("Antimage.Break_legendary")
self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_antimage_mana_break_custom_legendary", {duration = self.legenday_duration})
end









function antimage_mana_break_custom:GetIntrinsicModifierName()
	return "modifier_antimage_mana_break_custom"
end

modifier_antimage_mana_break_custom = class({})

function modifier_antimage_mana_break_custom:IsHidden()
	return true
end

function modifier_antimage_mana_break_custom:IsPurgable()
	return false
end

function modifier_antimage_mana_break_custom:OnCreated( kv )
	self.mana_break = self:GetAbility():GetSpecialValueFor( "mana_per_hit" ) -- special value
	self.mana_damage_pct = self:GetAbility():GetSpecialValueFor( "damage_per_burn" ) -- special value
end

function modifier_antimage_mana_break_custom:OnRefresh( kv )
	self.mana_break = self:GetAbility():GetSpecialValueFor( "mana_per_hit" )
	self.mana_damage_pct = self:GetAbility():GetSpecialValueFor( "damage_per_burn" )
end

function modifier_antimage_mana_break_custom:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_PROCATTACK_BONUS_DAMAGE_PHYSICAL,
		MODIFIER_EVENT_ON_ATTACK_LANDED
	}

	return funcs
end



function modifier_antimage_mana_break_custom:OnAttackLanded(params)
if not IsServer() then return end
if not self:GetParent():HasModifier("modifier_antimage_break_3") then return end
if self:GetParent() ~= params.attacker then return end
if not params.target then return end
if params.target:IsBuilding() or params.target:IsMagicImmune() then return end

params.target:AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_antimage_mana_break_custom_cost", {duration = self:GetAbility().mana_cost_duration})

end





function modifier_antimage_mana_break_custom:GetModifierProcAttack_BonusDamage_Physical( params )
if not IsServer() then return end




if self:GetParent():PassivesDisabled() then return end
	local target = params.target

if not target then return end
if target:GetMaxMana() == 0 then return end
if target:IsMagicImmune() then return end

	local percent_damage_per_burn = self:GetAbility():GetSpecialValueFor("percent_damage_per_burn")
	local mana_per_hit_pct = self:GetAbility():GetSpecialValueFor("mana_per_hit_pct")
	local mana_per_hit = self:GetAbility():GetSpecialValueFor("mana_per_hit")
	local illusion_burn = self:GetAbility():GetSpecialValueFor("illusion_burn")
	local slow_duration = self:GetAbility():GetSpecialValueFor("slow_duration")

	if self:GetParent():HasModifier("modifier_antimage_break_1") then 
		percent_damage_per_burn = percent_damage_per_burn + self:GetAbility().burn_damage[self:GetParent():GetUpgradeStack("modifier_antimage_break_1")]
	end


	local reduce_mana_full = mana_per_hit + (target:GetMaxMana() / 100 * mana_per_hit_pct)

	if self:GetParent():IsIllusion() then
		reduce_mana_full = illusion_burn
	end

	local mana_k = target:GetMana()/target:GetMaxMana()

	if self:GetParent():HasModifier("modifier_antimage_break_5") and target:GetManaPercent() >= self:GetAbility().silence_mana then 
		target:EmitSound("Antimage.Break_silence")
		target:AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_antimage_mana_break_custom_silence", {duration = self:GetAbility().silence_duration})
	end


	local mana_burn =  math.min( target:GetMana(), reduce_mana_full )

	if self:GetParent():HasModifier("modifier_antimage_break_2") then 
		local heal = self:GetAbility().heal[self:GetParent():GetUpgradeStack("modifier_antimage_break_2")]


		heal = heal * (self:GetAbility().heal_k - mana_k)


		self:GetCaster():Heal(heal, self:GetAbility())

		SendOverheadEventMessage(self:GetCaster(), 10, self:GetCaster(), heal, nil)

		local trail_pfx = ParticleManager:CreateParticle("particles/am_heal_mana.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster())
	 	ParticleManager:ReleaseParticleIndex(trail_pfx)

	end

	if self:GetParent():HasShard() and mana_burn > 2 and self:GetParent():IsRealHero() and not self:GetParent():HasModifier("modifier_tidehunter_anchor_smash_caster") then 

		local units = FindUnitsInRadius( self:GetCaster():GetTeamNumber(),  target:GetAbsOrigin(), nil, 300, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 0, FIND_ANY_ORDER, false )


		local particle = ParticleManager:CreateParticle("particles/ogre_hit.vpcf", PATTACH_WORLDORIGIN, nil)	
			ParticleManager:SetParticleControl(particle, 0, target:GetAbsOrigin())

		for _,unit in pairs(units) do 
			if unit ~= target then 
				ApplyDamage( { victim = unit, attacker = self:GetParent(), damage = mana_burn, damage_type = DAMAGE_TYPE_MAGICAL, ability = self:GetAbility()} )
			end
		end

	end

	target:ReduceMana(mana_burn) 


	local particle = ParticleManager:CreateParticle( "particles/generic_gameplay/generic_manaburn.vpcf", PATTACH_ABSORIGIN, target )
	ParticleManager:ReleaseParticleIndex( particle )
	target:EmitSound("Hero_Antimage.ManaBreak")


	if target:GetMana()/target:GetMaxMana() <= self:GetAbility().no_mana_pct then

		if self:GetParent():HasModifier("modifier_antimage_break_4") and not target:HasModifier("modifier_antimage_mana_break_custom_damage_cd") then 
			local duration = self:GetAbility().no_mana_stun[self:GetCaster():GetUpgradeStack("modifier_antimage_break_4")]*(1 - target:GetStatusResistance())
			target:AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_antimage_mana_break_custom_rooted", {duration = duration})
			target:AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_antimage_mana_break_custom_damage", {duration = self:GetAbility().no_mana_damage_duration})
			target:AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_antimage_mana_break_custom_damage_cd", {duration = self:GetAbility().no_mana_cd})
		
			target:EmitSound("Antimage.Break_stun")

			local effect_cast = ParticleManager:CreateParticle( "particles/am_no_mana.vpcf", PATTACH_OVERHEAD_FOLLOW, target )
			ParticleManager:SetParticleControl( effect_cast, 0,  target:GetOrigin() )
			ParticleManager:SetParticleControl( effect_cast, 1, target:GetOrigin() )

		end

		

	end

	local bonus_damage = 0

	if self:GetParent():HasModifier("modifier_antimage_mana_break_custom_legendary") then 

		target:EmitSound("Antimage.Break_legendary_hit")

		bonus_damage = (self:GetAbility().legenday_damage - mana_k)*params.damage

		local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_antimage/antimage_manabreak_slow.vpcf", PATTACH_ABSORIGIN_FOLLOW, target)
		ParticleManager:SetParticleControl(particle, 0, target:GetAbsOrigin())
		ParticleManager:SetParticleControl(particle, 1, target:GetAbsOrigin())
	end


	if target:GetMana() <= 1 or (target:GetManaPercent() <= self:GetAbility().slow_mana and self:GetParent():HasModifier("modifier_antimage_break_6")) then
		target:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_antimage_mana_break_custom_slow", {duration = slow_duration*(1 - target:GetStatusResistance())})
	end	




	return mana_burn * percent_damage_per_burn + bonus_damage
end

modifier_antimage_mana_break_custom_slow = class({})

function modifier_antimage_mana_break_custom_slow:IsPurgable() return false end

function modifier_antimage_mana_break_custom_slow:OnCreated()
	self.movespeed_slow = self:GetAbility():GetSpecialValueFor("move_slow") * -1
	local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_antimage/antimage_manabreak_slow.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
	ParticleManager:SetParticleControl(particle, 0, self:GetParent():GetAbsOrigin())
	ParticleManager:SetParticleControl(particle, 1, self:GetParent():GetAbsOrigin())
end

function modifier_antimage_mana_break_custom_slow:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
 		MODIFIER_PROPERTY_HEAL_AMPLIFY_PERCENTAGE_TARGET,
   		MODIFIER_PROPERTY_HP_REGEN_AMPLIFY_PERCENTAGE,
  		MODIFIER_PROPERTY_LIFESTEAL_AMPLIFY_PERCENTAGE
	}
end

function modifier_antimage_mana_break_custom_slow:GetModifierMoveSpeedBonus_Percentage()
local k = 1
if self:GetCaster():HasModifier("modifier_antimage_mana_break_custom_legendary") then 
	k = self:GetAbility().legenday_slow_k
end

	return self.movespeed_slow*k
end



function modifier_antimage_mana_break_custom_slow:GetModifierLifestealRegenAmplify_Percentage() 
local k = 0
if self:GetCaster():HasModifier("modifier_antimage_break_6") then 
  k = self:GetAbility().slow_reduction
end 
    return k
end

function modifier_antimage_mana_break_custom_slow:GetModifierHealAmplify_PercentageTarget() 
local k = 0
if self:GetCaster():HasModifier("modifier_antimage_break_6") then 
  k = self:GetAbility().slow_reduction
end 
    return k
end

function modifier_antimage_mana_break_custom_slow:GetModifierHPRegenAmplify_Percentage() 
local k = 0
if self:GetCaster():HasModifier("modifier_antimage_break_6") then 
  k = self:GetAbility().slow_reduction
end 
    return k
end




modifier_antimage_mana_break_custom_silence = class({})

function modifier_antimage_mana_break_custom_silence:IsHidden() return false end

function modifier_antimage_mana_break_custom_silence:IsPurgable() return true end

function modifier_antimage_mana_break_custom_silence:GetTexture() return "silencer_last_word" end

function modifier_antimage_mana_break_custom_silence:CheckState() return {[MODIFIER_STATE_SILENCED] = true} end


function modifier_antimage_mana_break_custom_silence:GetEffectName() return "particles/econ/items/death_prophet/death_prophet_ti9/death_prophet_silence_custom_ti9_overhead_model.vpcf" end
 
function modifier_antimage_mana_break_custom_silence:GetEffectAttachType() return PATTACH_OVERHEAD_FOLLOW end



modifier_antimage_mana_break_custom_anim = class({}) 
function modifier_antimage_mana_break_custom_anim:IsHidden() return true end
function modifier_antimage_mana_break_custom_anim:IsPurgable() return false end
function modifier_antimage_mana_break_custom_anim:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_TRANSLATE_ACTIVITY_MODIFIERS
}
end

function modifier_antimage_mana_break_custom_anim:GetActivityTranslationModifiers()
	return "basher"
end





modifier_antimage_mana_break_custom_legendary = class({})
function modifier_antimage_mana_break_custom_legendary:IsHidden() return false end
function modifier_antimage_mana_break_custom_legendary:IsPurgable() return false end
function modifier_antimage_mana_break_custom_legendary:OnCreated(table)
if not IsServer() then return end



self.particle_peffect = ParticleManager:CreateParticle("particles/am_break_2.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())	
ParticleManager:SetParticleControl(self.particle_peffect, 0, self:GetParent():GetAbsOrigin())
self:AddParticle(self.particle_peffect, false, false, -1, false, true)

end


function modifier_antimage_mana_break_custom_legendary:GetEffectName() return "particles/am_break_legendary.vpcf" end




modifier_antimage_mana_break_custom_cost = class({})
function modifier_antimage_mana_break_custom_cost:IsHidden() return false end
function modifier_antimage_mana_break_custom_cost:IsPurgable() return false end
function modifier_antimage_mana_break_custom_cost:GetTexture() return "buffs/remnant_lowhp" end
function modifier_antimage_mana_break_custom_cost:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_MANACOST_PERCENTAGE
}
end

function modifier_antimage_mana_break_custom_cost:GetModifierPercentageManacost()
return self:GetAbility().mana_cost[self:GetCaster():GetUpgradeStack("modifier_antimage_break_3")]
end





modifier_antimage_mana_break_custom_damage_cd = class({})
function modifier_antimage_mana_break_custom_damage_cd:IsHidden() return true end
function modifier_antimage_mana_break_custom_damage_cd:IsPurgable() return false end

modifier_antimage_mana_break_custom_damage = class({})
function modifier_antimage_mana_break_custom_damage:IsHidden() return false end
function modifier_antimage_mana_break_custom_damage:IsPurgable() return true end
function modifier_antimage_mana_break_custom_damage:GetTexture() return "buffs/manabreak_damage" end
function modifier_antimage_mana_break_custom_damage:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE
}
end

function modifier_antimage_mana_break_custom_damage:GetModifierIncomingDamage_Percentage()
	return self:GetAbility().no_mana_damage[self:GetCaster():GetUpgradeStack("modifier_antimage_break_4")]
end


function modifier_antimage_mana_break_custom_damage:OnCreated(table)
if not IsServer() then return end
self.particle_peffect = ParticleManager:CreateParticle("particles/am_damage.vpcf", PATTACH_OVERHEAD_FOLLOW, self:GetParent())	
ParticleManager:SetParticleControl(self.particle_peffect, 0, self:GetParent():GetAbsOrigin())
self:AddParticle(self.particle_peffect, false, false, -1, false, true)
end



modifier_antimage_mana_break_custom_rooted = class({})
function modifier_antimage_mana_break_custom_rooted:IsHidden() return true end
function modifier_antimage_mana_break_custom_rooted:IsPurgable() return true end
function modifier_antimage_mana_break_custom_rooted:CheckState()
return
{
	[MODIFIER_STATE_ROOTED] = true
}
end
function modifier_antimage_mana_break_custom_rooted:GetEffectName() return "particles/items3_fx/gleipnir_root.vpcf" end

