LinkLuaModifier("modifier_press_the_attack_buff", "abilities/legion_commander/custom_legion_commander_press_the_attack", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_press_the_attack_tracker", "abilities/legion_commander/custom_legion_commander_press_the_attack", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_press_the_attack_lowhp_cd", "abilities/legion_commander/custom_legion_commander_press_the_attack", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_press_the_attack_count", "abilities/legion_commander/custom_legion_commander_press_the_attack", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_press_the_attack_legendary_effect", "abilities/legion_commander/custom_legion_commander_press_the_attack", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_press_the_attack_bkb", "abilities/legion_commander/custom_legion_commander_press_the_attack", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_press_the_attack_root", "abilities/legion_commander/custom_legion_commander_press_the_attack", LUA_MODIFIER_MOTION_NONE)



custom_legion_commander_press_the_attack = class({})


custom_legion_commander_press_the_attack.resist_init = 0
custom_legion_commander_press_the_attack.resist_inc = 10

custom_legion_commander_press_the_attack.regen_init = 1
custom_legion_commander_press_the_attack.regen_inc = 1

custom_legion_commander_press_the_attack.root_radius = 400
custom_legion_commander_press_the_attack.root_duration = 2

custom_legion_commander_press_the_attack.lowhp_cd = 25
custom_legion_commander_press_the_attack.lowhp_duration = 3
custom_legion_commander_press_the_attack.lowph_health = 30

custom_legion_commander_press_the_attack.legendary_reduce = 0.5
custom_legion_commander_press_the_attack.legendary_damage = 0.7


custom_legion_commander_press_the_attack.duration_init = 0
custom_legion_commander_press_the_attack.duration_inc = 1

custom_legion_commander_press_the_attack.incoming_max = 500
custom_legion_commander_press_the_attack.incoming_max_stack = 10
custom_legion_commander_press_the_attack.incoming_speed_init = 5
custom_legion_commander_press_the_attack.incoming_speed_inc = 10
custom_legion_commander_press_the_attack.incoming_heal_init = 0.02
custom_legion_commander_press_the_attack.incoming_heal_inc = 0.03



function custom_legion_commander_press_the_attack:GetIntrinsicModifierName()
return "modifier_press_the_attack_tracker"
end


function custom_legion_commander_press_the_attack:GetCooldown(iLevel)

local upgrade_cooldown = 0
if self:GetCaster():HasShard() then 
	upgrade_cooldown = -2
end

 return self.BaseClass.GetCooldown(self, iLevel) + upgrade_cooldown

end



function custom_legion_commander_press_the_attack:OnSpellStart( target , duration )
if not IsServer() then return end
self.duration = self:GetSpecialValueFor("duration")

self:GetCaster():EmitSound("Hero_LegionCommander.PressTheAttack")



if self:GetCaster():HasModifier("modifier_legion_press_speed") then 
	self.duration = self.duration + self.duration_init + self.duration_inc*self:GetCaster():GetUpgradeStack("modifier_legion_press_speed")
end

if target == nil then 
	self.target = self:GetCursorTarget()
else 
	self.target = target
end
self.target:Purge(false , true, false , true, false)


if duration == nil then 
	self.target:AddNewModifier(self:GetCaster(), self, "modifier_press_the_attack_buff", {duration = self.duration})

else 

	local mod = self.target:FindModifierByName("modifier_press_the_attack_buff")
	if mod then 
		mod:SetDuration(mod:GetRemainingTime() + duration, true)
	else 
		self.target:AddNewModifier(self:GetCaster(), self, "modifier_press_the_attack_buff", {duration = duration})
	end

end


if self:GetCaster():HasShard() then 
	self.target:AddNewModifier(self:GetCaster(), self, "modifier_press_the_attack_bkb", {duration = 1.75})
end


if self:GetCaster():HasModifier("modifier_legion_press_after") then 

	local wave_particle = ParticleManager:CreateParticle( "particles/lc_wave.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster() )
	ParticleManager:SetParticleControl( wave_particle, 1, self:GetCaster():GetAbsOrigin() )
	ParticleManager:ReleaseParticleIndex(wave_particle)

	local enemies = FindUnitsInRadius(
		self:GetCaster():GetTeamNumber(),
		self:GetCaster():GetAbsOrigin(),
		nil,
		self.root_radius,
		DOTA_UNIT_TARGET_TEAM_ENEMY,
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
		DOTA_UNIT_TARGET_FLAG_NONE,
		FIND_ANY_ORDER,
		false
	)
	for _,target in ipairs(enemies) do 
		if target:GetUnitName() ~= "npc_teleport" then 
			target:AddNewModifier(self:GetCaster(), self, "modifier_press_the_attack_root", {duration = (1 - target:GetStatusResistance())*self.root_duration})
			target:EmitSound("Lc.Press_Root")
		end
	end

end

end




modifier_press_the_attack_buff = class({})

function modifier_press_the_attack_buff:IsHidden() return false end
function modifier_press_the_attack_buff:IsPurgable() 
	return not self:GetParent():HasModifier("modifier_legion_press_legendary")
 end


function modifier_press_the_attack_buff:OnCreated(table)

self.RemoveForDuel = true

self.particle = ParticleManager:CreateParticle( "particles/units/heroes/hero_legion_commander/legion_commander_press.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
ParticleManager:SetParticleControl( self.particle, 1, self:GetParent():GetAbsOrigin() )

self.cast = ParticleManager:CreateParticle("particles/units/heroes/hero_legion_commander/legion_commander_press_hands.vpcf", PATTACH_CUSTOMORIGIN, self:GetParent())
ParticleManager:SetParticleControlEnt( self.cast, 0, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_attack1", self:GetParent():GetAbsOrigin(), true )
ParticleManager:SetParticleControlEnt( self.cast, 1, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_attack1", self:GetParent():GetAbsOrigin(), true )
ParticleManager:SetParticleControlEnt( self.cast, 2, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_attack1", self:GetParent():GetAbsOrigin(), true )

if self:GetParent():HasModifier("modifier_legion_press_legendary") then 
	self.legen = ParticleManager:CreateParticle("particles/lc_press_legendary.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
	ParticleManager:SetParticleControl( self.legen, 1, self:GetParent():GetAbsOrigin() )
end

self.speed = self:GetAbility():GetSpecialValueFor("attack_speed")

self.damage_count = 0

self.regen = self:GetAbility():GetSpecialValueFor("hp_regen")

if not IsServer() then return end


end







function modifier_press_the_attack_buff:OnDestroy()

ParticleManager:DestroyParticle(self.particle, false)
ParticleManager:ReleaseParticleIndex(self.particle)
ParticleManager:DestroyParticle(self.cast, false)
ParticleManager:ReleaseParticleIndex(self.cast)

if self.effect_target then 
	ParticleManager:DestroyParticle(self.effect_target, false)
    ParticleManager:ReleaseParticleIndex(self.effect_target)
end

if self:GetParent():HasModifier("modifier_legion_press_legendary") and self.legen ~= nil then 
	ParticleManager:DestroyParticle(self.legen, false)
	ParticleManager:ReleaseParticleIndex(self.legen)
end

if not IsServer() then return end







if self:GetParent():HasModifier("modifier_legion_press_legendary") then 

	local mod = self:GetParent():FindModifierByName("modifier_press_the_attack_count")
	if mod then 

		local damage = mod:GetStackCount()

		self:GetParent():SetHealth(math.max(self:GetParent():GetHealth() - damage, 1))
		mod:Destroy()
		self:GetParent():EmitSound("Lc.Press_legendary") 
	end
end


end


function modifier_press_the_attack_buff:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
	MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,
	MODIFIER_PROPERTY_TOTAL_CONSTANT_BLOCK,
	MODIFIER_EVENT_ON_TAKEDAMAGE,
	MODIFIER_PROPERTY_STATUS_RESISTANCE_STACKING
}

end


function modifier_press_the_attack_buff:GetModifierStatusResistanceStacking()
local bonus = 0
if self:GetCaster():HasModifier("modifier_legion_press_cd") then 
	bonus = self:GetAbility().resist_init + self:GetAbility().resist_inc*self:GetCaster():GetUpgradeStack("modifier_legion_press_cd")
end
return bonus
end

function modifier_press_the_attack_buff:OnTakeDamage(params)
if not IsServer() then return end
if params.unit ~= self:GetParent() then return end
if not self:GetCaster():HasModifier("modifier_legion_press_duration") then return end
if self:GetStackCount() >= self:GetAbility().incoming_max_stack then return end


self.damage_count = self.damage_count + params.original_damage
local max = self:GetAbility().incoming_max


if self.damage_count < max then return end

self.damage_count = 0
self:IncrementStackCount()


self:GetParent():EmitSound("Lc.Press_Heal")
local effect_target = ParticleManager:CreateParticle( "particles/lc_press_heal.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
ParticleManager:SetParticleControl( effect_target, 1, Vector( 200, 100, 100 ) )
ParticleManager:ReleaseParticleIndex( effect_target )



end





function modifier_press_the_attack_buff:GetModifierTotal_ConstantBlock(params)
if not IsServer() then return end
if not self:GetParent():HasModifier("modifier_legion_press_legendary") then return end

if self:GetParent() == params.attacker then return end

if params.damage_type == DAMAGE_TYPE_MAGICAL then 
  local mod = self:GetParent():FindModifierByName("modifier_magic_shield")
  if mod and mod:GetStackCount() > 0 then 
    return
  end
end

if params.damage_type == DAMAGE_TYPE_PHYSICAL then 
  local mod = self:GetParent():FindModifierByName("modifier_attack_shield")
  if mod and mod:GetStackCount() > 0 then 
    return
  end
end

local mod = self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_press_the_attack_count", {})
if mod then 
	mod:SetStackCount(mod:GetStackCount() + params.damage * self:GetAbility().legendary_damage * self:GetAbility().legendary_reduce)
end

return params.damage * self:GetAbility().legendary_reduce

end





function modifier_press_the_attack_buff:GetModifierConstantHealthRegen()

local bonus = 0
if self:GetCaster():HasModifier("modifier_legion_press_regen") then 
	bonus = (self:GetAbility().regen_init + self:GetAbility().regen_inc*self:GetCaster():GetUpgradeStack("modifier_legion_press_regen"))*self:GetParent():GetMaxHealth()/100
end

local k = 1
if self:GetStackCount() > 0 then 
	k = k + self:GetStackCount()*(self:GetAbility().incoming_heal_init + self:GetAbility().incoming_heal_inc*self:GetCaster():GetUpgradeStack("modifier_legion_press_duration"))
end

return (self.regen + bonus)*k

end


function modifier_press_the_attack_buff:GetModifierAttackSpeedBonus_Constant() 
local bonus = 0
if self:GetStackCount() > 0 then 
	bonus = self:GetStackCount()*(self:GetAbility().incoming_speed_init + self:GetAbility().incoming_speed_inc*self:GetCaster():GetUpgradeStack("modifier_legion_press_duration"))
end

return self.speed + bonus 
end






modifier_press_the_attack_tracker = class({})
function modifier_press_the_attack_tracker:IsHidden() return true end
function modifier_press_the_attack_tracker:IsPurgable() return false  end
function modifier_press_the_attack_tracker:DeclareFunctions()
return
{
	MODIFIER_EVENT_ON_TAKEDAMAGE
}
end
function modifier_press_the_attack_tracker:OnTakeDamage(params)
if not IsServer() then return end
if params.unit ~= self:GetParent() then return end
if self:GetParent():PassivesDisabled() then return end
if self:GetParent():HasModifier("modifier_death") then return end
if not self:GetParent():HasModifier("modifier_legion_press_lowhp") then return end

if self:GetParent():GetHealthPercent() < self:GetAbility().lowph_health then 

	if not self:GetParent():HasModifier("modifier_press_the_attack_lowhp_cd") then 
		self:GetAbility():OnSpellStart(self:GetParent(), self:GetAbility().lowhp_duration)
		self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_press_the_attack_lowhp_cd", {duration = self:GetAbility().lowhp_cd})
	end
end 

end


modifier_press_the_attack_lowhp_cd = class({})
function modifier_press_the_attack_lowhp_cd:IsHidden() return false end
function modifier_press_the_attack_lowhp_cd:IsPurgable() return false end
function modifier_press_the_attack_lowhp_cd:RemoveOnDeath() return false end
function modifier_press_the_attack_lowhp_cd:IsDebuff() return true end
function modifier_press_the_attack_lowhp_cd:GetTexture() return "buffs/lowhp_cd" end
function modifier_press_the_attack_lowhp_cd:OnCreated(table)
	self.RemoveForDuel = true
end



modifier_press_the_attack_count = class({})
function modifier_press_the_attack_count:IsHidden() return false end
function modifier_press_the_attack_count:IsPurgable() return false end
function modifier_press_the_attack_count:GetTexture() return "buffs/press_legendary" end

function modifier_press_the_attack_count:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_TOOLTIP
}
end
function modifier_press_the_attack_count:OnTooltip() return self:GetStackCount() end


modifier_press_the_attack_bkb = class({})
function modifier_press_the_attack_bkb:IsHidden() return true end
function modifier_press_the_attack_bkb:IsPurgable() return false end 
function modifier_press_the_attack_bkb:GetEffectName() return "particles/items_fx/black_king_bar_avatar.vpcf" end
function modifier_press_the_attack_bkb:CheckState() return {[MODIFIER_STATE_MAGIC_IMMUNE] = true} end

modifier_press_the_attack_root = class({})
function modifier_press_the_attack_root:IsHidden() return false end
function modifier_press_the_attack_root:IsPurgable() return true end
function modifier_press_the_attack_root:GetTexture() return "buffs/press_root" end
function modifier_press_the_attack_root:CheckState() return {[MODIFIER_STATE_ROOTED] = true} end
function modifier_press_the_attack_root:GetEffectName() return "particles/lc_root.vpcf" end
