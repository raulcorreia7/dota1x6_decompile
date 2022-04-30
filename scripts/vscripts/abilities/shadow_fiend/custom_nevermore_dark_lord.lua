LinkLuaModifier("modifier_custom_dark_lord_aura","abilities/shadow_fiend/custom_nevermore_dark_lord", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_custom_dark_lord_debuff", "abilities/shadow_fiend/custom_nevermore_dark_lord", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_custom_dark_lord_slow_aura", "abilities/shadow_fiend/custom_nevermore_dark_lord", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_custom_dark_lord_slow", "abilities/shadow_fiend/custom_nevermore_dark_lord", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_custom_dark_lord_damage_aura", "abilities/shadow_fiend/custom_nevermore_dark_lord", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_custom_dark_lord_damage", "abilities/shadow_fiend/custom_nevermore_dark_lord", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_custom_dark_lord_nil", "abilities/shadow_fiend/custom_nevermore_dark_lord", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_custom_dark_lord_legendary", "abilities/shadow_fiend/custom_nevermore_dark_lord", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_custom_dark_lord_self_armor", "abilities/shadow_fiend/custom_nevermore_dark_lord", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_custom_dark_lord_self_speed", "abilities/shadow_fiend/custom_nevermore_dark_lord", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_custom_dark_lord_self_armor_count", "abilities/shadow_fiend/custom_nevermore_dark_lord", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_custom_dark_lord_self_speed_count", "abilities/shadow_fiend/custom_nevermore_dark_lord", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_custom_dark_lord_self_damage", "abilities/shadow_fiend/custom_nevermore_dark_lord", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_custom_dark_lord_self_damage_count", "abilities/shadow_fiend/custom_nevermore_dark_lord", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_custom_dark_lord_silence_aura", "abilities/shadow_fiend/custom_nevermore_dark_lord", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_custom_dark_lord_silence", "abilities/shadow_fiend/custom_nevermore_dark_lord", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_custom_dark_lord_silence_timer", "abilities/shadow_fiend/custom_nevermore_dark_lord", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier( "modifier_generic_ring_lua_sf", "abilities/generic/modifier_generic_ring_lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier("modifier_custom_dark_lord_self_attackspeed", "abilities/shadow_fiend/custom_nevermore_dark_lord", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_custom_dark_lord_self_attackspeed_count", "abilities/shadow_fiend/custom_nevermore_dark_lord", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_custom_dark_lord_healing_aura", "abilities/shadow_fiend/custom_nevermore_dark_lord", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_custom_dark_lord_healing", "abilities/shadow_fiend/custom_nevermore_dark_lord", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_custom_dark_lord_self_healing", "abilities/shadow_fiend/custom_nevermore_dark_lord", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_custom_dark_lord_self_healing_count", "abilities/shadow_fiend/custom_nevermore_dark_lord", LUA_MODIFIER_MOTION_NONE)





custom_nevermore_dark_lord = class({})


custom_nevermore_dark_lord.armor_init = 1
custom_nevermore_dark_lord.armor_inc = 1

custom_nevermore_dark_lord.magic_inc = -5
custom_nevermore_dark_lord.magic_init = -5

custom_nevermore_dark_lord.slow_init = -5
custom_nevermore_dark_lord.slow_inc = -5
custom_nevermore_dark_lord.speed_init = 0
custom_nevermore_dark_lord.speed_inc = -20

custom_nevermore_dark_lord.lowhealth_init = 0
custom_nevermore_dark_lord.lowhealth_inc = 0.3

custom_nevermore_dark_lord.legendary_cd = 60
custom_nevermore_dark_lord.legendary_duration = 10
custom_nevermore_dark_lord.legendary_radius = 1200
custom_nevermore_dark_lord.legendary_speed = 1200
custom_nevermore_dark_lord.legendary_fear = 1.5
custom_nevermore_dark_lord.legendary_creep = 4

custom_nevermore_dark_lord.healing_health = 40
custom_nevermore_dark_lord.healing_reduce = -30
custom_nevermore_dark_lord.healing_lifesteal = 0.2

custom_nevermore_dark_lord.silence_timer = 4
custom_nevermore_dark_lord.silence_duration = 3
custom_nevermore_dark_lord.silence_radius = 250



function custom_nevermore_dark_lord:GetCooldown(iLevel)
if self:GetCaster():HasModifier("modifier_nevermore_darklord_legendary") then return self.legendary_cd end  
end




function custom_nevermore_dark_lord:GetBehavior()
  if self:GetCaster():HasModifier("modifier_nevermore_darklord_legendary") then
    return DOTA_ABILITY_BEHAVIOR_NO_TARGET end
 return DOTA_ABILITY_BEHAVIOR_PASSIVE 
end

function custom_nevermore_dark_lord:OnSpellStart()
if not IsServer() then return end
self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_custom_dark_lord_legendary", {duration = self.legendary_duration})


	local caster = self:GetCaster()
	local radius = self.legendary_radius
	local speed = 900

	local particle_cast = "particles/sf_fear.vpcf"

	local sound_cast = "Sf.Aura_Ring"

	
	self.effect_cast = ParticleManager:CreateParticle( particle_cast,  PATTACH_WORLDORIGIN, nil )
	ParticleManager:SetParticleControl( self.effect_cast, 0, self:GetCaster():GetAbsOrigin())
	ParticleManager:SetParticleControl( self.effect_cast, 1, Vector(  900, 1000, 1000 ) )

	caster:EmitSound(sound_cast)
	self.wings_particle = ParticleManager:CreateParticle("particles/sf_wings.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster())
	caster:EmitSound("Sf.Aura_Legendary")




	Timers:CreateTimer(4,function()
		ParticleManager:DestroyParticle(self.wings_particle, false)
		ParticleManager:ReleaseParticleIndex(self.wings_particle)
        
	end)

	local pulse = caster:AddNewModifier(
		caster, -- player source
		self, -- ability source
		"modifier_generic_ring_lua_sf", -- modifier name
		{
			end_radius = radius,
			speed = speed,
			target_team = DOTA_UNIT_TARGET_TEAM_ENEMY,
			target_type = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
		} -- kv
	)
	pulse:SetCallback()

  Timers:CreateTimer(radius/speed,function()
     
		ParticleManager:DestroyParticle(self.effect_cast, false)
		ParticleManager:ReleaseParticleIndex(self.effect_cast)
        
        end)

end





function custom_nevermore_dark_lord:GetAbilityTextureName()
   return "nevermore_dark_lord"
end

function custom_nevermore_dark_lord:GetIntrinsicModifierName()
	return "modifier_custom_dark_lord_aura"
end

modifier_custom_dark_lord_aura = class({})

function modifier_custom_dark_lord_aura:OnCreated()
	self.caster = self:GetCaster()
	self.ability = self:GetAbility()
	self.aura_radius = self.ability:GetSpecialValueFor("presence_radius")
end


function modifier_custom_dark_lord_aura:IsHidden() return true end
function modifier_custom_dark_lord_aura:IsPurgable() return false end
function modifier_custom_dark_lord_aura:IsDebuff() return false end

function modifier_custom_dark_lord_aura:OnRefresh()
	self:OnCreated()
end

function modifier_custom_dark_lord_aura:AllowIllusionDuplicate()
	return true
end

function modifier_custom_dark_lord_aura:GetAuraEntityReject(target)
	if not target:CanEntityBeSeenByMyTeam(self.caster) then
		return true 
	end

	return false
end

function modifier_custom_dark_lord_aura:GetAuraRadius()
	return self.aura_radius
end

function modifier_custom_dark_lord_aura:GetAuraSearchFlags()
	return DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE
end

function modifier_custom_dark_lord_aura:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_ENEMY
end

function modifier_custom_dark_lord_aura:GetAuraSearchType() 
	return DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO
end


function modifier_custom_dark_lord_aura:GetModifierAura()
	return "modifier_custom_dark_lord_debuff"
end

function modifier_custom_dark_lord_aura:IsAura()
	if self.caster:PassivesDisabled() then
		return false
	end

	return true
end



modifier_custom_dark_lord_debuff =  class({})



function modifier_custom_dark_lord_debuff:IsHidden() return false end
function modifier_custom_dark_lord_debuff:IsPurgable() return false end
function modifier_custom_dark_lord_debuff:IsDebuff() return true end
function modifier_custom_dark_lord_debuff:OnCreated(table)
self.range_buf = 0
self.range = 0
self.armor_bonus = 0

if self:GetCaster():HasModifier("modifier_nevermore_darklord_armor") then 
	self.armor_bonus = self:GetAbility().armor_init + self:GetAbility().armor_inc*self:GetCaster():GetUpgradeStack("modifier_nevermore_darklord_armor")
end

	
self.armor_reduction = self:GetAbility():GetSpecialValueFor("presence_armor_reduction") + self.armor_bonus

self.armor_reduction = -1*self.armor_reduction*(1 + self.range_buf)

self:StartIntervalThink(0.2)




end



function modifier_custom_dark_lord_debuff:OnIntervalThink()

if self:GetCaster():HasModifier("modifier_nevermore_darklord_health") then 
	self.range = 1 - self:GetParent():GetHealthPercent()/100
	self.range_buf =  self.range*(self:GetAbility().lowhealth_init + self:GetAbility().lowhealth_inc*self:GetCaster():GetUpgradeStack("modifier_nevermore_darklord_health"))

end

self.armor_reduction = self:GetAbility():GetSpecialValueFor("presence_armor_reduction") + self.armor_bonus

 
self.armor_reduction = -1*self.armor_reduction*(1 + self.range_buf)

if not IsServer() then return end

if self:GetCaster():HasModifier("modifier_custom_dark_lord_legendary") and (not self.caster_buf or self.caster_buf:IsNull())
	and not self:GetParent():IsIllusion() then 

	self.caster_buf_count = self:GetCaster():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_custom_dark_lord_self_armor_count", {})
	self.caster_buf = self:GetCaster():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_custom_dark_lord_self_armor", {})
	self.creep = 1
	if not self:GetParent():IsHero() then 
		self.creep = self:GetAbility().legendary_creep
	end

end

if self.caster_buf and not self.caster_buf:IsNull() then
	self.caster_buf:SetStackCount(-10*self.armor_reduction/self.creep )
end

end


function modifier_custom_dark_lord_debuff:DeclareFunctions()
return 
{
	MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS
}
end

function modifier_custom_dark_lord_debuff:GetModifierPhysicalArmorBonus()
	return self.armor_reduction 
end




function modifier_custom_dark_lord_debuff:OnDestroy() 
if not IsServer() then return end

	if self.caster_buf and not self.caster_buf:IsNull() then self.caster_buf:Destroy() end
	if not self:GetCaster():HasModifier("modifier_custom_dark_lord_self_armor") and self.caster_buf_count and not self.caster_buf_count:IsNull()
	 then self.caster_buf_count:Destroy() end
end




modifier_custom_dark_lord_slow_aura = class({})


function modifier_custom_dark_lord_slow_aura:IsHidden() return true end
function modifier_custom_dark_lord_slow_aura:IsPurgable() return false end
function modifier_custom_dark_lord_slow_aura:IsDebuff() return false end



function modifier_custom_dark_lord_slow_aura:GetAuraEntityReject(target)
	if not target:CanEntityBeSeenByMyTeam(self:GetCaster()) then
		return true 
	end

	return false
end

function modifier_custom_dark_lord_slow_aura:GetAuraRadius()
	return 1200
end

function modifier_custom_dark_lord_slow_aura:GetAuraSearchFlags()
	return DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE end

function modifier_custom_dark_lord_slow_aura:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_ENEMY
end

function modifier_custom_dark_lord_slow_aura:GetAuraSearchType()
	return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
end

function modifier_custom_dark_lord_slow_aura:GetModifierAura()
	return "modifier_custom_dark_lord_slow"
end
function modifier_custom_dark_lord_slow_aura:IsAura()
	if self:GetCaster():PassivesDisabled() then
		return false
	end

	return true
end

modifier_custom_dark_lord_slow = class({})
function modifier_custom_dark_lord_slow:IsHidden() return false end
function modifier_custom_dark_lord_slow:IsPurgable() return true end
function modifier_custom_dark_lord_slow:GetTexture() return "buffs/darklord_slow" end
 

function modifier_custom_dark_lord_slow:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
	MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT
}
end


function modifier_custom_dark_lord_slow:OnCreated(table)
self.range_buf = 0
self.range = 0

self.attack_speed = self:GetAbility().speed_init + self:GetAbility().speed_inc*self:GetCaster():GetUpgradeStack("modifier_nevermore_darklord_slow")
self.move_speed = self:GetAbility().slow_init + self:GetAbility().slow_inc*self:GetCaster():GetUpgradeStack("modifier_nevermore_darklord_slow")


self:StartIntervalThink(0.2)

if not IsServer() then return end


end


function modifier_custom_dark_lord_slow:OnIntervalThink()


if self:GetCaster():HasModifier("modifier_nevermore_darklord_health") then 
	self.range = 1 - self:GetParent():GetHealthPercent()/100
	self.range_buf =  self.range*(self:GetAbility().lowhealth_init + self:GetAbility().lowhealth_inc*self:GetCaster():GetUpgradeStack("modifier_nevermore_darklord_health"))
end

self.attack_speed = self:GetAbility().speed_init + self:GetAbility().speed_inc*self:GetCaster():GetUpgradeStack("modifier_nevermore_darklord_slow")
self.move_speed = self:GetAbility().slow_init + self:GetAbility().slow_inc*self:GetCaster():GetUpgradeStack("modifier_nevermore_darklord_slow")

self.attack_speed = self.attack_speed*(self.range_buf + 1)
self.move_speed = self.move_speed*(self.range_buf + 1)


if not IsServer() then return end
if self:GetCaster():HasModifier("modifier_custom_dark_lord_legendary") and (not self.caster_buf or self.caster_buf:IsNull())
	and not self:GetParent():IsIllusion() then 

	self.caster_buf_count = self:GetCaster():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_custom_dark_lord_self_speed_count", {})
	self.caster_buf = self:GetCaster():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_custom_dark_lord_self_speed", {})

	self.caster_buf_speed_count = self:GetCaster():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_custom_dark_lord_self_attackspeed_count", {})
	self.caster_buf_speed = self:GetCaster():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_custom_dark_lord_self_attackspeed", {})

	self.creep = 1
	if not self:GetParent():IsHero() then 
		self.creep = self:GetAbility().legendary_creep
	end

end

if self.caster_buf and not self.caster_buf:IsNull() then
	self.caster_buf:SetStackCount(-10*self.move_speed/self.creep)
end

if self.caster_buf_speed and not self.caster_buf_speed:IsNull() then
	self.caster_buf_speed:SetStackCount(-10*self.attack_speed/self.creep)
end



end




function modifier_custom_dark_lord_slow:GetModifierMoveSpeedBonus_Percentage()
	return self.move_speed
end


function modifier_custom_dark_lord_slow:GetModifierAttackSpeedBonus_Constant()
	return self.attack_speed
end





function modifier_custom_dark_lord_slow:OnDestroy() 
if not IsServer() then return end
if self.caster_buf and not self.caster_buf:IsNull() then self.caster_buf:Destroy() end

if self.caster_buf_speed and not self.caster_buf_speed:IsNull() then self.caster_buf_speed:Destroy() end

if not self:GetCaster():HasModifier("modifier_custom_dark_lord_self_speed") and self.caster_buf_count and not self.caster_buf_count:IsNull() then
	self.caster_buf_count:Destroy()
end

if not self:GetCaster():HasModifier("modifier_custom_dark_lord_self_attackspeed") and self.caster_buf_speed_count and not self.caster_buf_speed_count:IsNull() then
	self.caster_buf_speed_count:Destroy()
end

end











modifier_custom_dark_lord_damage_aura = class({})


function modifier_custom_dark_lord_damage_aura:IsHidden() return true end
function modifier_custom_dark_lord_damage_aura:IsPurgable() return false end
function modifier_custom_dark_lord_damage_aura:IsDebuff() return false end




function modifier_custom_dark_lord_damage_aura:GetAuraEntityReject(target)
	if not target:CanEntityBeSeenByMyTeam(self:GetCaster()) then
		return true 
	end

	return false
end

function modifier_custom_dark_lord_damage_aura:GetAuraRadius()
	return 1200
end

function modifier_custom_dark_lord_damage_aura:GetAuraSearchFlags()
	return DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE
	 end

function modifier_custom_dark_lord_damage_aura:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_ENEMY
end

function modifier_custom_dark_lord_damage_aura:GetAuraSearchType()
	return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
end

function modifier_custom_dark_lord_damage_aura:GetModifierAura()
	return "modifier_custom_dark_lord_damage"
end

function modifier_custom_dark_lord_damage_aura:IsAura()
	if self:GetCaster():PassivesDisabled() then
		return false
	end

	return true
end




modifier_custom_dark_lord_damage = class({})
function modifier_custom_dark_lord_damage:IsHidden() return false end
function modifier_custom_dark_lord_damage:IsPurgable() return true end
function modifier_custom_dark_lord_damage:GetTexture() return "buffs/darklord_damage" end
function modifier_custom_dark_lord_damage:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS
}
end


function modifier_custom_dark_lord_damage:OnCreated(table)

self.range_buf = 0
self.range = 0

self.magic = self:GetAbility().magic_init + self:GetAbility().magic_inc*self:GetCaster():GetUpgradeStack("modifier_nevermore_darklord_damage")

self:StartIntervalThink(0.2)


end



function modifier_custom_dark_lord_damage:OnIntervalThink()

if self:GetCaster():HasModifier("modifier_nevermore_darklord_health") then 
	self.range = 1 - self:GetParent():GetHealthPercent()/100
	self.range_buf =  self.range*(self:GetAbility().lowhealth_init + self:GetAbility().lowhealth_inc*self:GetCaster():GetUpgradeStack("modifier_nevermore_darklord_health"))
end


self.magic = self:GetAbility().magic_init + self:GetAbility().magic_inc*self:GetCaster():GetUpgradeStack("modifier_nevermore_darklord_damage")

self.magic = (self.range_buf + 1)*self.magic

if not IsServer() then return end

if self:GetCaster():HasModifier("modifier_custom_dark_lord_legendary") and (not self.caster_buf or self.caster_buf:IsNull())
	and not self:GetParent():IsIllusion() then 

	self.caster_buf_count = self:GetCaster():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_custom_dark_lord_self_damage_count", {})
	self.caster_buf = self:GetCaster():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_custom_dark_lord_self_damage", {})
	self.creep = 1
	if not self:GetParent():IsHero() then 
		self.creep = self:GetAbility().legendary_creep
	end

end

if self.caster_buf and not self.caster_buf:IsNull() then
	self.caster_buf:SetStackCount(-10*self.magic/self.creep)
end

end




function modifier_custom_dark_lord_damage:GetModifierMagicalResistanceBonus()
	return self.magic
end


function modifier_custom_dark_lord_damage:OnDestroy() 
if not IsServer() then return end

if self.caster_buf and not self.caster_buf:IsNull() then self.caster_buf:Destroy() end

if not self:GetCaster():HasModifier("modifier_custom_dark_lord_self_damage") and self.caster_buf_count and not self.caster_buf_count:IsNull()
	then self.caster_buf_count:Destroy() end
end






modifier_custom_dark_lord_silence_aura = class({})


function modifier_custom_dark_lord_silence_aura:IsHidden() return true end
function modifier_custom_dark_lord_silence_aura:IsPurgable() return false end
function modifier_custom_dark_lord_silence_aura:IsDebuff() return false end


function modifier_custom_dark_lord_silence_aura:GetAuraEntityReject(target)
	if not target:HasModifier("modifier_custom_dark_lord_silence") and target:CanEntityBeSeenByMyTeam(self:GetParent())then
		return false 
	end
	return true
end
function modifier_custom_dark_lord_silence_aura:OnCreated(table)
if not IsServer() then return end
self:StartIntervalThink(0.2)
self.particle = nil

end

function modifier_custom_dark_lord_silence_aura:OnIntervalThink()
if not IsServer() then return end
local enemies = FindUnitsInRadius(self:GetParent():GetTeamNumber(),
									  self:GetParent():GetAbsOrigin(),
									  nil,
									  self:GetAbility().silence_radius,
									  DOTA_UNIT_TARGET_TEAM_ENEMY,
									  DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
									  DOTA_UNIT_TARGET_FLAG_NONE,
									  FIND_ANY_ORDER,
									  false)

if self.particle == nil then 
	if #enemies > 0 then 
		self.particle  = ParticleManager:CreateParticle( "particles/sf_aura.vpcf"	, PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
	end
end
if self.particle ~= nil then
	if #enemies == 0 then 
		ParticleManager:DestroyParticle(self.particle, false)
		ParticleManager:ReleaseParticleIndex( self.particle)
		self.particle = nil
	end
end

end



function modifier_custom_dark_lord_silence_aura:GetAuraRadius()
	return self:GetAbility().silence_radius
end

function modifier_custom_dark_lord_silence_aura:GetAuraSearchFlags()
	return DOTA_UNIT_TARGET_FLAG_NONE
end

function modifier_custom_dark_lord_silence_aura:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_ENEMY
end

function modifier_custom_dark_lord_silence_aura:GetAuraSearchType()
	return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
end

function modifier_custom_dark_lord_silence_aura:GetModifierAura()
	return "modifier_custom_dark_lord_silence_timer"
end

function modifier_custom_dark_lord_silence_aura:IsAura()
	if self:GetCaster():PassivesDisabled() then
		return false
	end
	return true
end



modifier_custom_dark_lord_silence_timer = class({})
function modifier_custom_dark_lord_silence_timer:IsHidden() return false end
function modifier_custom_dark_lord_silence_timer:IsPurgable() return true end
function modifier_custom_dark_lord_silence_timer:GetTexture() return "buffs/darklord_silence" end
function modifier_custom_dark_lord_silence_timer:OnCreated(table)
if not IsServer() then return end

self.timer = self:GetAbility().silence_timer
self.count = 0
self:StartIntervalThink(1)
end

function modifier_custom_dark_lord_silence_timer:OnIntervalThink()
if not IsServer() then return end
self.count = self.count + 1
self:SetStackCount(self.count)
if self.count >= self.timer then 

	local duration = self:GetAbility().silence_duration
	self:GetParent():EmitSound("Sf.Aura_Silence")
	self:GetParent():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_custom_dark_lord_silence", {duration = duration * (1 - self:GetParent():GetStatusResistance())})


 	self:Destroy()
else 

EmitSoundOnEntityForPlayer("Sf.Aura_Silence_Tick", self:GetParent(), self:GetParent():GetPlayerOwnerID())

end

end

function modifier_custom_dark_lord_silence_timer:OnDestroy()
if not IsServer() then return end
	if self.pfx then
 		ParticleManager:DestroyParticle(self.pfx, false)
 		ParticleManager:ReleaseParticleIndex(self.pfx)  
 	end
end


function modifier_custom_dark_lord_silence_timer:OnStackCountChanged(iStackCount)
    if not IsServer() then return end

    if not self.pfx then
        self.pfx = ParticleManager:CreateParticle("particles/sf_timer.vpcf", PATTACH_OVERHEAD_FOLLOW, self:GetParent())
    end

    ParticleManager:SetParticleControl(self.pfx, 1, Vector(0, self:GetStackCount(), 0))
end


modifier_custom_dark_lord_silence = class({})
function modifier_custom_dark_lord_silence:IsHidden() return false end
function modifier_custom_dark_lord_silence:IsPurgable() return true end
function modifier_custom_dark_lord_silence:GetTexture() return "buffs/darklord_silence" end
function modifier_custom_dark_lord_silence:CheckState() return {[MODIFIER_STATE_SILENCED] = true} end
function modifier_custom_dark_lord_silence:GetEffectName() return "particles/generic_gameplay/generic_silenced.vpcf" end
function modifier_custom_dark_lord_silence:GetEffectAttachType() return PATTACH_OVERHEAD_FOLLOW end







modifier_custom_dark_lord_nil = class({})
function modifier_custom_dark_lord_nil:IsHidden() return true end
function modifier_custom_dark_lord_nil:IsPurgable() return false end





modifier_custom_dark_lord_legendary = class({})
function modifier_custom_dark_lord_legendary:IsHidden() return false end
function modifier_custom_dark_lord_legendary:IsPurgable() return false end
function modifier_custom_dark_lord_legendary:GetTexture() return "buffs/darklord_legen" end
function modifier_custom_dark_lord_legendary:OnCreated(table)
if not IsServer() then return end
	self.RemoveForDuel = true
self:GetParent():EmitSound("Sf.Aura_Legendary_Buff")
self.particle = ParticleManager:CreateParticle( "particles/sf_legendary.vpcf" 	, PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
	ParticleManager:SetParticleControl( self.particle , 0, self:GetParent():GetAbsOrigin() )
	ParticleManager:SetParticleControl( self.particle , 2, Vector(230,0,0))
end

function modifier_custom_dark_lord_legendary:OnDestroy()
if not IsServer() then return end
ParticleManager:DestroyParticle(self.particle, false)
ParticleManager:ReleaseParticleIndex(self.particle)

for _,mod in pairs(self:GetParent():FindAllModifiers()) do

	if mod:GetName() == "modifier_custom_dark_lord_self_armor_count" or
		mod:GetName() == "modifier_custom_dark_lord_self_armor" or
		mod:GetName() == "modifier_custom_dark_lord_self_damage" or
		mod:GetName() == "modifier_custom_dark_lord_self_damage_count" or
		mod:GetName() == "modifier_custom_dark_lord_self_speed" or
		mod:GetName() == "modifier_custom_dark_lord_self_speed_count" or
		mod:GetName() == "modifier_custom_dark_lord_self_attackspeed" or
		mod:GetName() == "modifier_custom_dark_lord_self_attackspeed_count" or
		mod:GetName() == "modifier_custom_dark_lord_self_healing" or
		mod:GetName() == "modifier_custom_dark_lord_self_healing_count" 
	  then 

	   mod:Destroy()
	end


end


end
















modifier_custom_dark_lord_healing_aura = class({})


function modifier_custom_dark_lord_healing_aura:IsHidden() return true end
function modifier_custom_dark_lord_healing_aura:IsPurgable() return false end
function modifier_custom_dark_lord_healing_aura:IsDebuff() return false end

function modifier_custom_dark_lord_healing_aura:DeclareFunctions()
return
{
	MODIFIER_EVENT_ON_TAKEDAMAGE
}

end


function modifier_custom_dark_lord_healing_aura:OnTakeDamage(params)
if self:GetParent() ~= params.attacker then return end
if self:GetParent() == params.unit  then return end
if not params.unit:HasModifier("modifier_custom_dark_lord_healing") then return end
if bit.band(params.damage_flags, DOTA_DAMAGE_FLAG_REFLECTION) == DOTA_DAMAGE_FLAG_REFLECTION then return end

local heal = self:GetAbility().healing_lifesteal*params.damage
self:GetParent():Heal(heal, self:GetAbility())

local particle = ParticleManager:CreateParticle( "particles/huskar_leap_heal.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
ParticleManager:ReleaseParticleIndex( particle )

end

function modifier_custom_dark_lord_healing_aura:GetAuraEntityReject(target)
	if not target:CanEntityBeSeenByMyTeam(self:GetCaster()) or target:GetHealthPercent() > self:GetAbility().healing_health then
		return true 
	end

	return false
end

function modifier_custom_dark_lord_healing_aura:GetAuraRadius()
	return 1200
end

function modifier_custom_dark_lord_healing_aura:GetAuraSearchFlags()
	return DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE
	 end

function modifier_custom_dark_lord_healing_aura:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_ENEMY
end

function modifier_custom_dark_lord_healing_aura:GetAuraSearchType()
	return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
end

function modifier_custom_dark_lord_healing_aura:GetModifierAura()
	return "modifier_custom_dark_lord_healing"
end

function modifier_custom_dark_lord_healing_aura:IsAura()
	if self:GetCaster():PassivesDisabled() then
		return false
	end

	return true
end




modifier_custom_dark_lord_healing = class({})
function modifier_custom_dark_lord_healing:IsHidden() return false end
function modifier_custom_dark_lord_healing:IsPurgable() return false end
function modifier_custom_dark_lord_healing:GetTexture() return "buffs/darklord_healing" end
function modifier_custom_dark_lord_healing:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_HEAL_AMPLIFY_PERCENTAGE_TARGET,
    MODIFIER_PROPERTY_HP_REGEN_AMPLIFY_PERCENTAGE,
	MODIFIER_PROPERTY_LIFESTEAL_AMPLIFY_PERCENTAGE
    }
 end




function modifier_custom_dark_lord_healing:OnCreated(table)

self.range_buf = 0
self.range = 0


self.reduce = self:GetAbility().healing_reduce

self:StartIntervalThink(0.2)

end



function modifier_custom_dark_lord_healing:OnIntervalThink()


if self:GetCaster():HasModifier("modifier_nevermore_darklord_health") then 
	self.range = 1 - self:GetParent():GetHealthPercent()/100
	self.range_buf =  self.range*(self:GetAbility().lowhealth_init + self:GetAbility().lowhealth_inc*self:GetCaster():GetUpgradeStack("modifier_nevermore_darklord_health"))
end


self.reduce = self:GetAbility().healing_reduce

self.reduce = (self.range_buf + 1)*self.reduce

if not IsServer() then return end

if self:GetCaster():HasModifier("modifier_custom_dark_lord_legendary") and (not self.caster_buf or self.caster_buf:IsNull())
	and not self:GetParent():IsIllusion() then 

	self.caster_buf_count = self:GetCaster():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_custom_dark_lord_self_healing_count", {})
	self.caster_buf = self:GetCaster():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_custom_dark_lord_self_healing", {})
	self.creep = 1
	if not self:GetParent():IsHero() then 
		self.creep = self:GetAbility().legendary_creep
	end

end

if self.caster_buf and not self.caster_buf:IsNull() then
	self.caster_buf:SetStackCount(-10*self.reduce/self.creep)
end

end

function modifier_custom_dark_lord_healing:GetModifierLifestealRegenAmplify_Percentage() 
return self.reduce
end


function modifier_custom_dark_lord_healing:GetModifierHealAmplify_PercentageTarget() 
return self.reduce 
end

function modifier_custom_dark_lord_healing:GetModifierHPRegenAmplify_Percentage() 
return self.reduce
end



function modifier_custom_dark_lord_healing:OnDestroy() 
if not IsServer() then return end

if self.caster_buf and not self.caster_buf:IsNull() then self.caster_buf:Destroy() end

if not self:GetCaster():HasModifier("modifier_custom_dark_lord_self_healing") and self.caster_buf_count and not self.caster_buf_count:IsNull()
 then self.caster_buf_count:Destroy() end
end















modifier_custom_dark_lord_self_armor = class({})
function modifier_custom_dark_lord_self_armor:IsHidden() return true end
function modifier_custom_dark_lord_self_armor:IsPurgable() return false end 
function modifier_custom_dark_lord_self_armor:RemoveOnDeath() return false end
function modifier_custom_dark_lord_self_armor:GetAttributes()  return MODIFIER_ATTRIBUTE_MULTIPLE end
function modifier_custom_dark_lord_self_armor:OnCreated(table)
if not IsServer() then return end
self:SetStackCount(0)
end
function modifier_custom_dark_lord_self_armor:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS
}
end

function modifier_custom_dark_lord_self_armor:GetModifierPhysicalArmorBonus() return self:GetStackCount()/10 end






 modifier_custom_dark_lord_self_speed = class({})
function modifier_custom_dark_lord_self_speed:IsHidden() return true end
function modifier_custom_dark_lord_self_speed:IsPurgable() return false end
function modifier_custom_dark_lord_self_speed:RemoveOnDeath() return false end
function modifier_custom_dark_lord_self_speed:GetAttributes()  return MODIFIER_ATTRIBUTE_MULTIPLE end
function modifier_custom_dark_lord_self_speed:OnCreated(table)
if not IsServer() then return end
self:SetStackCount(0)
end
function modifier_custom_dark_lord_self_speed:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE
}
end

function modifier_custom_dark_lord_self_speed:GetModifierMoveSpeedBonus_Percentage()
 return self:GetStackCount()/10 end



 modifier_custom_dark_lord_self_attackspeed = class({})
function modifier_custom_dark_lord_self_attackspeed:IsHidden() return true end
function modifier_custom_dark_lord_self_attackspeed:IsPurgable() return false end
function modifier_custom_dark_lord_self_attackspeed:RemoveOnDeath() return false end
function modifier_custom_dark_lord_self_attackspeed:GetAttributes()  return MODIFIER_ATTRIBUTE_MULTIPLE end
function modifier_custom_dark_lord_self_attackspeed:OnCreated(table)
if not IsServer() then return end
self:SetStackCount(0)
end
function modifier_custom_dark_lord_self_attackspeed:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT
}
end

function modifier_custom_dark_lord_self_attackspeed:GetModifierAttackSpeedBonus_Constant()
 return self:GetStackCount()/10 end







modifier_custom_dark_lord_self_damage = class({})
function modifier_custom_dark_lord_self_damage:IsHidden() return true end
function modifier_custom_dark_lord_self_damage:IsPurgable() return false end
function modifier_custom_dark_lord_self_damage:RemoveOnDeath() return false end
function modifier_custom_dark_lord_self_damage:GetAttributes()  return MODIFIER_ATTRIBUTE_MULTIPLE end
function modifier_custom_dark_lord_self_damage:OnCreated(table)
if not IsServer() then return end
self:SetStackCount(0)
end
function modifier_custom_dark_lord_self_damage:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS
}
end



function modifier_custom_dark_lord_self_damage:GetModifierMagicalResistanceBonus()

 return self:GetStackCount()/10 end




modifier_custom_dark_lord_self_healing = class({})
function modifier_custom_dark_lord_self_healing:IsHidden() return true end
function modifier_custom_dark_lord_self_healing:IsPurgable() return false end
function modifier_custom_dark_lord_self_healing:RemoveOnDeath() return false end
function modifier_custom_dark_lord_self_healing:GetAttributes()  return MODIFIER_ATTRIBUTE_MULTIPLE end
function modifier_custom_dark_lord_self_healing:OnCreated(table)
if not IsServer() then return end
self:SetStackCount(0)
end
function modifier_custom_dark_lord_self_healing:DeclareFunctions()
return
{	
	MODIFIER_PROPERTY_HEAL_AMPLIFY_PERCENTAGE_TARGET,
    MODIFIER_PROPERTY_HP_REGEN_AMPLIFY_PERCENTAGE,
	MODIFIER_PROPERTY_LIFESTEAL_AMPLIFY_PERCENTAGE
}
end


function modifier_custom_dark_lord_self_healing:GetModifierLifestealRegenAmplify_Percentage()
return self:GetStackCount()/10 
end

function modifier_custom_dark_lord_self_healing:GetModifierHealAmplify_PercentageTarget() 
return self:GetStackCount()/10 
end

function modifier_custom_dark_lord_self_healing:GetModifierHPRegenAmplify_Percentage() 
return self:GetStackCount()/10
end








modifier_custom_dark_lord_self_attackspeed_count = class({})
function modifier_custom_dark_lord_self_attackspeed_count:IsHidden() return true end
function modifier_custom_dark_lord_self_attackspeed_count:IsPurgable() return false end
function modifier_custom_dark_lord_self_attackspeed_count:RemoveOnDeath() return false end


 modifier_custom_dark_lord_self_speed_count = class({})
function modifier_custom_dark_lord_self_speed_count:IsHidden() return false end
function modifier_custom_dark_lord_self_speed_count:IsPurgable() return false end
function modifier_custom_dark_lord_self_speed_count:RemoveOnDeath() return false end
function modifier_custom_dark_lord_self_speed_count:GetTexture() return "buffs/darklord_slow" end

 modifier_custom_dark_lord_self_armor_count = class({})
function modifier_custom_dark_lord_self_armor_count:IsHidden() return false end
function modifier_custom_dark_lord_self_armor_count:IsPurgable() return false end
function modifier_custom_dark_lord_self_armor_count:RemoveOnDeath() return false end
function modifier_custom_dark_lord_self_armor_count:GetTexture() return "nevermore_dark_lord" end


 modifier_custom_dark_lord_self_damage_count = class({})
function modifier_custom_dark_lord_self_damage_count:IsHidden() return false end
function modifier_custom_dark_lord_self_damage_count:IsPurgable() return false end
function modifier_custom_dark_lord_self_damage_count:RemoveOnDeath() return false end
function modifier_custom_dark_lord_self_damage_count:GetTexture() return "buffs/darklord_damage" end


 modifier_custom_dark_lord_self_healing_count = class({})
function modifier_custom_dark_lord_self_healing_count:IsHidden() return false end
function modifier_custom_dark_lord_self_healing_count:IsPurgable() return false end
function modifier_custom_dark_lord_self_healing_count:RemoveOnDeath() return false end
function modifier_custom_dark_lord_self_healing_count:GetTexture() return "buffs/darklord_healing" end
