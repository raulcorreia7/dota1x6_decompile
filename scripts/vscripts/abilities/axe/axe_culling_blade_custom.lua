LinkLuaModifier( "modifier_axe_culling_blade_custom", "abilities/axe/axe_culling_blade_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_axe_culling_blade_custom_tracker", "abilities/axe/axe_culling_blade_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_axe_culling_blade_custom_attack_kill", "abilities/axe/axe_culling_blade_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_axe_culling_blade_custom_execute", "abilities/axe/axe_culling_blade_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_axe_culling_blade_custom_kills", "abilities/axe/axe_culling_blade_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_axe_culling_blade_custom_aegis", "abilities/axe/axe_culling_blade_custom", LUA_MODIFIER_MOTION_NONE )

axe_culling_blade_custom = class({})

axe_culling_blade_custom.kill_speed = {20,40,60}
axe_culling_blade_custom.kill_duration = {1,1.5,2}

axe_culling_blade_custom.attack_kill_damage = {30,50}
axe_culling_blade_custom.attack_kill_duration = 10
axe_culling_blade_custom.attack_kill_max = 9

axe_culling_blade_custom.execute_chance = 15
axe_culling_blade_custom.execute_duration = 6

axe_culling_blade_custom.kills_spell_damage = 3

axe_culling_blade_custom.heal = {0.1,0.2,0.3}
axe_culling_blade_custom.heal_amp = 2

axe_culling_blade_custom.threshold = {100,150,200}

axe_culling_blade_custom_legendary = class({})





function axe_culling_blade_custom:GetManaCost(level)
if self:GetCaster():HasModifier("modifier_axe_culling_blade_custom_execute") then 
return 0
end

return self.BaseClass.GetManaCost(self,level) 
end


function axe_culling_blade_custom:GetIntrinsicModifierName()
return "modifier_axe_culling_blade_custom_tracker"
end




function axe_culling_blade_custom:OnSpellStart(new_target)
	if not IsServer() then return end
	local target = self:GetCursorTarget()

	if new_target then 
		target = new_target
	end

	local damage = self:GetSpecialValueFor("damage")

	local k = 1

	local threshold = self:GetSpecialValueFor("kill_threshold")
	local radius = self:GetSpecialValueFor("speed_aoe")
	local duration = self:GetSpecialValueFor("speed_duration")

	if self:GetCaster():HasModifier("modifier_axe_culling_1") then 
		duration = duration + self.kill_duration[self:GetCaster():GetUpgradeStack("modifier_axe_culling_1")]
	end

	local mod = target:FindModifierByName("modifier_axe_culling_blade_custom_attack_kill")

	if mod then 
		threshold = threshold + self.attack_kill_damage[self:GetCaster():GetUpgradeStack("modifier_axe_culling_4")]*mod:GetStackCount()
	end

	if self:GetCaster():HasModifier("modifier_axe_culling_3") then 
		threshold = threshold + self.threshold[self:GetCaster():GetUpgradeStack("modifier_axe_culling_3")]
	end

	local success = false
	local direction = (target:GetOrigin()-self:GetCaster():GetOrigin()):Normalized()

	if target:GetHealth()<=threshold then 
		success = true 
	end

	local particle_cast = ""
	local sound_cast = ""

	if success then
		particle_cast = "particles/units/heroes/hero_axe/axe_culling_blade_kill.vpcf"
		sound_cast = "Hero_Axe.Culling_Blade_Success"
	else
		particle_cast = "particles/units/heroes/hero_axe/axe_culling_blade.vpcf"
		sound_cast = "Hero_Axe.Culling_Blade_Fail"
	end

	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, target )
	ParticleManager:SetParticleControl( effect_cast, 4, target:GetOrigin() )
	ParticleManager:SetParticleControlForward( effect_cast, 3, direction )
	ParticleManager:SetParticleControlForward( effect_cast, 4, direction )
	ParticleManager:ReleaseParticleIndex( effect_cast )
	target:EmitSound(sound_cast)
	
	if success then

		local kill_mod = target:AddNewModifier(target, nil, "modifier_death", {})

		local kill_mod_2 = target:AddNewModifier(target, nil, "modifier_axe_culling_blade_custom_aegis", {})

		ApplyDamage({ victim = target, attacker = self:GetCaster(), damage = threshold, damage_type = DAMAGE_TYPE_PURE, ability = self, damage_flags = DOTA_DAMAGE_FLAG_HPLOSS, })
		
		if kill_mod then 
			kill_mod:Destroy()
		end

		if kill_mod_2 then 
			kill_mod_2:Destroy()
		end
		self:EndCooldown()

		if target:IsRealHero() and not target:IsAlive() then 
			k = self.heal_amp
			self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_axe_culling_blade_custom_kills", {})

		end




		local heroes = FindUnitsInRadius( self:GetCaster():GetTeamNumber(), self:GetCaster():GetOrigin(), nil, radius, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 0, 0, false )
		for _,hero in pairs(heroes) do
			hero:AddNewModifier( self:GetCaster(), self, "modifier_axe_culling_blade_custom", { duration = duration } )
		end
	else
		ApplyDamage({ victim = target, attacker = self:GetCaster(), damage = damage, damage_type = DAMAGE_TYPE_PURE, ability = self, })	
		
	end

	local mod_ex = self:GetCaster():FindModifierByName("modifier_axe_culling_blade_custom_execute")

	if mod_ex  then 
		mod_ex:Destroy()
		self:EndCooldown()
	end	
	if self:GetCaster():HasModifier("modifier_axe_culling_2") then 
		local heal = k*self.heal[self:GetCaster():GetUpgradeStack("modifier_axe_culling_2")]*(self:GetCaster():GetMaxHealth() - self:GetCaster():GetHealth())
		


		self:GetCaster():Heal(heal, self:GetCaster())
		SendOverheadEventMessage(self:GetCaster(), 10, self:GetCaster(), heal, nil)

		local particle = ParticleManager:CreateParticle( "particles/generic_gameplay/generic_lifesteal.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster() )
		ParticleManager:ReleaseParticleIndex( particle )
	end
end

modifier_axe_culling_blade_custom = class({})

function modifier_axe_culling_blade_custom:IsPurgable()
	return true
end

function modifier_axe_culling_blade_custom:OnCreated( kv )
	self.as_bonus = self:GetAbility():GetSpecialValueFor( "atk_speed_bonus" )
	self.ms_bonus = self:GetAbility():GetSpecialValueFor( "speed_bonus" )
end

function modifier_axe_culling_blade_custom:OnRefresh( kv )
	self.as_bonus = self:GetAbility():GetSpecialValueFor( "atk_speed_bonus" )
	self.ms_bonus = self:GetAbility():GetSpecialValueFor( "speed_bonus" )
end

function modifier_axe_culling_blade_custom:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
	}

	return funcs
end

function modifier_axe_culling_blade_custom:GetModifierMoveSpeedBonus_Percentage()
	return self.ms_bonus
end

function modifier_axe_culling_blade_custom:GetModifierAttackSpeedBonus_Constant()
local bonus = 0

if self:GetCaster():HasModifier("modifier_axe_culling_1") then 
	bonus = self:GetAbility().kill_speed[self:GetCaster():GetUpgradeStack("modifier_axe_culling_1")]
end

	return self.as_bonus + bonus
end

function modifier_axe_culling_blade_custom:GetEffectName()
	return "particles/units/heroes/hero_axe/axe_cullingblade_sprint.vpcf"
end

function modifier_axe_culling_blade_custom:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end


modifier_axe_culling_blade_custom_tracker = class({})
function modifier_axe_culling_blade_custom_tracker:IsHidden() return true end
function modifier_axe_culling_blade_custom_tracker:IsPurgable() return false end
function modifier_axe_culling_blade_custom_tracker:DeclareFunctions()
return
{
	MODIFIER_EVENT_ON_ATTACK_LANDED
}
end

function modifier_axe_culling_blade_custom_tracker:OnAttackLanded(params)
if not IsServer() then return end
if self:GetParent() ~= params.attacker then return end
if not params.target:IsHero() and not params.target:IsCreep() then return end


if self:GetCaster():HasModifier("modifier_axe_culling_5") then 

    local random = RollPseudoRandomPercentage(self:GetAbility().execute_chance,79,self:GetCaster())

    if random then 
    	self:GetCaster():EmitSound("Axe.Culling_execute")
    	self:GetCaster():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_axe_culling_blade_custom_execute", {duration = self:GetAbility().execute_duration})

    end

end


if not self:GetParent():HasModifier("modifier_axe_culling_4") then return end


params.target:AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_axe_culling_blade_custom_attack_kill", {duration = self:GetAbility().attack_kill_duration})

end

modifier_axe_culling_blade_custom_attack_kill = class({})
function modifier_axe_culling_blade_custom_attack_kill:IsHidden() return false end
function modifier_axe_culling_blade_custom_attack_kill:IsPurgable() return false end
function modifier_axe_culling_blade_custom_attack_kill:GetTexture() return "buffs/culling_attack" end
function modifier_axe_culling_blade_custom_attack_kill:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_TOOLTIP
}
end

function modifier_axe_culling_blade_custom_attack_kill:OnTooltip()
return self:GetAbility().attack_kill_damage[self:GetCaster():GetUpgradeStack("modifier_axe_culling_4")]*self:GetStackCount()
end

function modifier_axe_culling_blade_custom_attack_kill:OnCreated(table)
if not IsServer() then return end
self.RemoveForDuel = true
self:SetStackCount(1)
end

function modifier_axe_culling_blade_custom_attack_kill:OnRefresh(table)
if not IsServer() then return end
if self:GetStackCount() >= self:GetAbility().attack_kill_max then return end
self:IncrementStackCount()
end



function modifier_axe_culling_blade_custom_attack_kill:OnStackCountChanged(iStackCount)
if self:GetStackCount() == 0 then return end
if not self.effect_cast then 

    local particle_cast = "particles/axe_culling_stack.vpcf"

    self.effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_OVERHEAD_FOLLOW, self:GetParent() )
    ParticleManager:SetParticleControl( self.effect_cast, 1, Vector( 0, self:GetStackCount(), 0 ) )

    self:AddParticle(self.effect_cast,false, false, -1, false, false)
else 

  ParticleManager:SetParticleControl( self.effect_cast, 1, Vector( 0, self:GetStackCount(), 0 ) )

end

end





function axe_culling_blade_custom_legendary:OnAbilityPhaseStart()
if not IsServer() then return end

if self:GetCursorTarget():GetHealthPercent() < self:GetSpecialValueFor("health") then 
CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(self:GetCaster():GetPlayerID()), "CreateIngameErrorMessage", {message = "culling_health"})

return false
end

return true
end

function axe_culling_blade_custom_legendary:OnSpellStart()
if not IsServer() then return end

if self:GetCursorTarget():TriggerSpellAbsorb(self) then return end

local ability = self:GetCaster():FindAbilityByName("axe_culling_blade_custom")

if ability then 

	local duration = ability:GetSpecialValueFor("speed_duration")

	if self:GetCaster():HasModifier("modifier_axe_culling_1") then 
		duration = duration + ability.kill_duration[self:GetCaster():GetUpgradeStack("modifier_axe_culling_1")]
	end

	self:GetCaster():AddNewModifier( self:GetCaster(), ability, "modifier_axe_culling_blade_custom", { duration = duration } )

end

if self:GetCaster():HasModifier("modifier_axe_culling_2") then 

	local heal = ability.heal[self:GetCaster():GetUpgradeStack("modifier_axe_culling_2")]*(self:GetCaster():GetMaxHealth() - self:GetCaster():GetHealth())
		
	self:GetCaster():Heal(heal, self:GetCaster())
	SendOverheadEventMessage(self:GetCaster(), 10, self:GetCaster(), heal, nil)

	local particle = ParticleManager:CreateParticle( "particles/generic_gameplay/generic_lifesteal.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster() )
	ParticleManager:ReleaseParticleIndex( particle )
end



local target =  self:GetCursorTarget()
local direction = (target:GetOrigin()-self:GetCaster():GetOrigin()):Normalized()

local old_pos = self:GetCaster():GetAbsOrigin()
    

local effect = ParticleManager:CreateParticle("particles/items3_fx/blink_overwhelming_start.vpcf", PATTACH_WORLDORIGIN, nil)
ParticleManager:SetParticleControl(effect, 0, old_pos)

FindClearSpaceForUnit(self:GetCaster(), self:GetCursorTarget():GetAbsOrigin(), true)
ProjectileManager:ProjectileDodge(self:GetCaster())

effect = ParticleManager:CreateParticle("particles/items3_fx/blink_overwhelming_end.vpcf", PATTACH_WORLDORIGIN, nil)
ParticleManager:SetParticleControl(effect, 0, self:GetCaster():GetAbsOrigin())

local damage = self:GetCursorTarget():GetMaxHealth()*self:GetSpecialValueFor("damage")/100

ApplyDamage({ victim = self:GetCursorTarget(), attacker = self:GetCaster(), damage = damage, damage_type = DAMAGE_TYPE_PURE, ability = self, })

if not target:IsMagicImmune() then 
	target:AddNewModifier(self:GetCaster(), self, "modifier_stunned", {duration = 0.3})
end


local effect_cast = ParticleManager:CreateParticle( "particles/units/heroes/hero_axe/axe_culling_blade_kill.vpcf", PATTACH_ABSORIGIN_FOLLOW, target )
ParticleManager:SetParticleControl( effect_cast, 4, target:GetOrigin() )
ParticleManager:SetParticleControlForward( effect_cast, 3, direction )
ParticleManager:SetParticleControlForward( effect_cast, 4, direction )
ParticleManager:ReleaseParticleIndex( effect_cast )
target:EmitSound("Hero_Axe.Culling_Blade_Success")



end



modifier_axe_culling_blade_custom_execute = class({})
function modifier_axe_culling_blade_custom_execute:IsHidden() return false end
function modifier_axe_culling_blade_custom_execute:IsPurgable() return false end
function modifier_axe_culling_blade_custom_execute:GetTexture() return "buffs/culling_execute" end

function modifier_axe_culling_blade_custom_execute:GetEffectName()  
return "particles/axe_execute.vpcf"
end

function modifier_axe_culling_blade_custom_execute:OnCreated()
if not IsServer() then return end
self.particle_peffect = ParticleManager:CreateParticle("particles/axe_exe.vpcf", PATTACH_OVERHEAD_FOLLOW, self:GetParent())	
ParticleManager:SetParticleControl(self.particle_peffect, 0, self:GetParent():GetAbsOrigin())
end

function modifier_axe_culling_blade_custom_execute:OnDestroy()
if not IsServer() then return end
if not self.particle_peffect then return end

ParticleManager:DestroyParticle(self.particle_peffect, false)
   ParticleManager:ReleaseParticleIndex(self.particle_peffect)
end







modifier_axe_culling_blade_custom_kills = class({})
function modifier_axe_culling_blade_custom_kills:IsHidden() return false end
function modifier_axe_culling_blade_custom_kills:IsPurgable() return false end
function modifier_axe_culling_blade_custom_kills:GetTexture() return "buffs/culling_kills" end
function modifier_axe_culling_blade_custom_kills:RemoveOnDeath() return false end
function modifier_axe_culling_blade_custom_kills:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE,
	MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
	MODIFIER_PROPERTY_TOOLTIP
}
end

function modifier_axe_culling_blade_custom_kills:GetModifierSpellAmplify_Percentage()
if not self:GetCaster():HasModifier("modifier_axe_culling_6") then
	return 0
end

return self:GetStackCount()*self:GetAbility().kills_spell_damage
end

function modifier_axe_culling_blade_custom_kills:OnCreated(table)
if not IsServer() then return end
self:SetStackCount(1)
end

function modifier_axe_culling_blade_custom_kills:GetModifierPhysicalArmorBonus()
return self:GetAbility():GetSpecialValueFor("armor_bonus")*self:GetStackCount()
end


function modifier_axe_culling_blade_custom_kills:OnRefresh(table)
if not IsServer() then return end
self:IncrementStackCount()
end
function modifier_axe_culling_blade_custom_kills:OnTooltip()
return self:GetStackCount()
end

modifier_axe_culling_blade_custom_aegis = class({})
function modifier_axe_culling_blade_custom_aegis:IsHidden() return true end
function modifier_axe_culling_blade_custom_aegis:IsPurgable() return false end


