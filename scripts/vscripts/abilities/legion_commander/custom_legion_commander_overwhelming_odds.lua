LinkLuaModifier("modifier_overwhelming_odds_speed", "abilities/legion_commander/custom_legion_commander_overwhelming_odds", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_overwhelming_odds_stack", "abilities/legion_commander/custom_legion_commander_overwhelming_odds", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_overwhelming_odds_proc", "abilities/legion_commander/custom_legion_commander_overwhelming_odds", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_overwhelming_odds_proc_slow", "abilities/legion_commander/custom_legion_commander_overwhelming_odds", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_overwhelming_odds_passive", "abilities/legion_commander/custom_legion_commander_overwhelming_odds", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_overwhelming_odds_mark", "abilities/legion_commander/custom_legion_commander_overwhelming_odds", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_overwhelming_odds_mark_speed", "abilities/legion_commander/custom_legion_commander_overwhelming_odds", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_overwhelming_odds_mark_anim", "abilities/legion_commander/custom_legion_commander_overwhelming_odds", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_overwhelming_odds_legendary", "abilities/legion_commander/custom_legion_commander_overwhelming_odds", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_overwhelming_odds_damage", "abilities/legion_commander/custom_legion_commander_overwhelming_odds", LUA_MODIFIER_MOTION_NONE)


custom_legion_commander_overwhelming_odds = class({})

custom_legion_commander_overwhelming_odds.cd_init = -1
custom_legion_commander_overwhelming_odds.cd_inc = -1

custom_legion_commander_overwhelming_odds.hero_init = 0
custom_legion_commander_overwhelming_odds.hero_inc = 50

custom_legion_commander_overwhelming_odds.damage_init = 2
custom_legion_commander_overwhelming_odds.damage_inc = 2
custom_legion_commander_overwhelming_odds.damage_duration = 5

custom_legion_commander_overwhelming_odds.triple_count_init = 0
custom_legion_commander_overwhelming_odds.triple_count_inc = 1
custom_legion_commander_overwhelming_odds.triple_timer = 2

custom_legion_commander_overwhelming_odds.proc_max = 7
custom_legion_commander_overwhelming_odds.proc_duraion = 1.5
custom_legion_commander_overwhelming_odds.proc_damage_init = 0
custom_legion_commander_overwhelming_odds.proc_damage_inc = 0.8

custom_legion_commander_overwhelming_odds.mark_duration = 5
custom_legion_commander_overwhelming_odds.mark_speed_duration = 3
custom_legion_commander_overwhelming_odds.mark_speed = 800
custom_legion_commander_overwhelming_odds.mark_stun = 1.2
custom_legion_commander_overwhelming_odds.mark_max_range = 2000
custom_legion_commander_overwhelming_odds.mark_min_range = 300

custom_legion_commander_overwhelming_odds.legendary_duration = 10
custom_legion_commander_overwhelming_odds.legendary_radius = 1000
custom_legion_commander_overwhelming_odds.legendary_max_odds = 3
custom_legion_commander_overwhelming_odds.legendary_max = 3

custom_legion_commander_overwhelming_odds.vision_radius = 500
custom_legion_commander_overwhelming_odds.vision_duration = 10




function custom_legion_commander_overwhelming_odds:GetIntrinsicModifierName() return "modifier_overwhelming_odds_passive" end

function custom_legion_commander_overwhelming_odds:GetCooldown(iLevel)

local upgrade_cooldown = self.cd_init + self.cd_inc*self:GetCaster():GetUpgradeStack("modifier_legion_odds_cd")

 return self.BaseClass.GetCooldown(self, iLevel) + upgrade_cooldown

end



function custom_legion_commander_overwhelming_odds:GetCastRange(vLocation, hTarget)
if self:GetCaster():HasModifier("modifier_legion_odds_solo")  then 
    return 99999
end
return self.BaseClass.GetCastRange(self, vLocation, target)
end




function custom_legion_commander_overwhelming_odds:GetAOERadius() 
return self:GetSpecialValueFor("radius") 
end


function custom_legion_commander_overwhelming_odds:OnAbilityPhaseStart()
if not IsServer() then return end
    self.cast = ParticleManager:CreateParticle("particles/units/heroes/hero_legion_commander/legion_commander_odds_cast.vpcf", PATTACH_CUSTOMORIGIN, self:GetCaster())
    ParticleManager:SetParticleControlEnt( self.cast, 1, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_attack1", self:GetCaster():GetAbsOrigin(), true )

	self:GetCaster():EmitSound("Hero_LegionCommander.Overwhelming.Cast")
return true 
end

function custom_legion_commander_overwhelming_odds:OnAbilityPhaseInterrupted()
if not IsServer() then return end

		ParticleManager:DestroyParticle(self.cast, false)
        ParticleManager:ReleaseParticleIndex(self.cast)
end


function custom_legion_commander_overwhelming_odds:OnSpellStart( point )
if not IsServer() then return end
self.caster = self:GetCaster()

if point == nil then 
	self.point = self:GetCursorPosition()
else 
	self.point = point
end

self.radius = self:GetSpecialValueFor("radius")
self.hero_damage = self:GetSpecialValueFor("damage_per_hero")
self.creep_damage = self:GetSpecialValueFor("damage_per_unit")
self.illusion_damage = self:GetSpecialValueFor("illusion_dmg_pct")
self.base_damage = self:GetSpecialValueFor("damage")
self.duration = self:GetSpecialValueFor("duration")
self.hero_speed = self:GetSpecialValueFor("bonus_speed_heroes")
self.creep_speed = self:GetSpecialValueFor("bonus_speed_creeps")
self.damage = 0



if self:GetCaster():HasModifier("modifier_legion_odds_triple") then 
	self.base_damage = self.base_damage + self.hero_init + self.hero_inc*self:GetCaster():GetUpgradeStack("modifier_legion_odds_triple")
end 

EmitSoundOnLocationWithCaster(self.point, "Hero_LegionCommander.Overwhelming.Location", self.caster)

local particle = ParticleManager:CreateParticle( "particles/units/heroes/hero_legion_commander/legion_commander_odds.vpcf", PATTACH_WORLDORIGIN, nil )
    ParticleManager:SetParticleControl( particle, 0, self.point )
    ParticleManager:SetParticleControl( particle, 1, self:GetCaster():GetAbsOrigin() )
    ParticleManager:SetParticleControl( particle, 2, self.point )
    ParticleManager:SetParticleControl( particle, 3, self.point )
    ParticleManager:SetParticleControl( particle, 4, Vector( self.radius, self.radius, self.radius ) )
    ParticleManager:SetParticleControl( particle, 6, self.point )
    ParticleManager:ReleaseParticleIndex( particle )


local flag = DOTA_UNIT_TARGET_FLAG_NONE

self.enemies = FindUnitsInRadius(
self.caster:GetTeamNumber(),
self.point,
nil,
self.radius,
DOTA_UNIT_TARGET_TEAM_ENEMY,
DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
flag,
FIND_ANY_ORDER,
false)

self.hero_count = 0
self.creep_count = 0

if self:GetCaster():HasModifier("modifier_legion_odds_legendary") and point == nil then 
 	self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_overwhelming_odds_legendary", {duration = self.legendary_duration})
end
  
if self:GetCaster():HasModifier("modifier_legion_odds_creep") then 
	self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_overwhelming_odds_damage", { duration = self.damage_duration})
end


local proc_mod = self:GetCaster():FindModifierByName("modifier_overwhelming_odds_proc")

if proc_mod  then 

	EmitSoundOnLocationWithCaster(self.point, "Lc.Odds_Proc_Damage", self.caster)

	 local particle = ParticleManager:CreateParticle( "particles/lc_odd_proc_burst.vpcf", PATTACH_WORLDORIGIN, nil )
 	 ParticleManager:SetParticleControl( particle, 0, self.point )
 	 ParticleManager:SetParticleControl( particle, 1, Vector( self.radius, self.radius, self.radius ) )
  	ParticleManager:ReleaseParticleIndex( particle )
end

if self:GetCaster():HasModifier("modifier_legion_odds_solo") then 

	AddFOWViewer( self.caster:GetTeamNumber(), self.point, self.vision_radius, self.vision_duration, false )
end



if #self.enemies > 0 then 

	for _,enemy in ipairs(self.enemies) do 
		local effect_name = ""

		if enemy:IsRealHero() then 
			self.hero_count = self.hero_count + 1 
			enemy:EmitSound("Hero_LegionCommander.Overwhelming.Hero")
			effect_name = "particles/units/heroes/hero_legion_commander/legion_commander_odds_dmgb.vpcf"		
		else 
			self.creep_count = self.creep_count + 1
			enemy:EmitSound("Hero_LegionCommander.Overwhelming.Creep")
			effect_name = "particles/units/heroes/hero_legion_commander/legion_commander_odds_dmga.vpcf"
		end

		local particle_peffect = ParticleManager:CreateParticle(effect_name, PATTACH_ABSORIGIN_FOLLOW, enemy)
		ParticleManager:SetParticleControlEnt(particle_peffect , 0, enemy, PATTACH_POINT_FOLLOW, "attach_hitloc", enemy:GetAbsOrigin(), true)
		ParticleManager:SetParticleControlEnt(particle_peffect , 1, enemy, PATTACH_POINT_FOLLOW, "attach_hitloc", enemy:GetAbsOrigin(), true)
    	ParticleManager:SetParticleControl(particle_peffect, 3, self:GetCaster():GetAbsOrigin())
    	ParticleManager:ReleaseParticleIndex(particle_peffect)

	end

	if self:GetCaster():HasModifier("modifier_legion_odds_mark") and point == nil then 
		local random = RandomInt(1, #self.enemies)
		self.enemies[random]:AddNewModifier(self:GetCaster(), self, "modifier_overwhelming_odds_mark", {duration = self.mark_duration})
	end


	local move = self.hero_count*self.hero_speed + self.creep_count*self.creep_speed
	self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_overwhelming_odds_speed", {duration = self.duration, move = move})


	self.damage = self.base_damage + self.hero_damage*self.hero_count + self.creep_count*self.creep_damage

	if proc_mod  then

		self.bonus = (self.proc_damage_init + self:GetCaster():GetUpgradeStack("modifier_legion_odds_proc")*self.proc_damage_inc)*self:GetCaster():GetStrength()
		self.damage = self.damage + self.bonus 

	end



	for _,enemy in ipairs(self.enemies) do 

		local illusion = 0

		if enemy:IsIllusion() then 
			illusion = enemy:GetMaxHealth()*self.illusion_damage / 100
		end



		if proc_mod  then 

			local slow_duration = (1 - enemy:GetStatusResistance())*self.proc_duraion

			enemy:AddNewModifier(self:GetCaster(), self, "modifier_overwhelming_odds_proc_slow", {duration = slow_duration })	

			SendOverheadEventMessage(enemy, 4, enemy, self.bonus, nil)
			
		end

		local damage_type = DAMAGE_TYPE_MAGICAL

		local damageTable = {victim = enemy,  damage = self.damage + illusion, damage_type = damage_type, attacker = self.caster, ability = self}
		local actualy_damage = ApplyDamage(damageTable)

	

	end
end 
	

if proc_mod then proc_mod:Destroy() end




end




modifier_overwhelming_odds_speed = class({})

function modifier_overwhelming_odds_speed:IsHidden() return false end
function modifier_overwhelming_odds_speed:IsPurgable() return true end
function modifier_overwhelming_odds_speed:OnCreated(table)
if not IsServer() then return end
self.poof = ParticleManager:CreateParticle("particles/units/heroes/hero_legion_commander/legion_commander_odds_buff.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
ParticleManager:SetParticleControl(self.poof, 0, self:GetParent():GetAbsOrigin())


 self:SetHasCustomTransmitterData(true)
self.move = table.move
end
function modifier_overwhelming_odds_speed:DeclareFunctions()
return
{
 	MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
 	MODIFIER_PROPERTY_TRANSLATE_ACTIVITY_MODIFIERS
}
end
function modifier_overwhelming_odds_speed:OnDestroy()
if not IsServer() then return end
ParticleManager:DestroyParticle(self.poof, false)
ParticleManager:ReleaseParticleIndex(self.poof)
end

function modifier_overwhelming_odds_speed:AddCustomTransmitterData() return {
move = self.move,
} end

function modifier_overwhelming_odds_speed:HandleCustomTransmitterData(data)
self.move = data.move
end


function modifier_overwhelming_odds_speed:GetModifierMoveSpeedBonus_Percentage() return self.move end
function modifier_overwhelming_odds_speed:GetActivityTranslationModifiers() return "overwhelmingodds" end








modifier_overwhelming_odds_passive = class({})

function modifier_overwhelming_odds_passive:IsHidden() return true end
function modifier_overwhelming_odds_passive:IsPurgable() return false end
function modifier_overwhelming_odds_passive:DeclareFunctions()
return
{
	MODIFIER_EVENT_ON_ATTACK_LANDED
}

end

function modifier_overwhelming_odds_passive:OnAttackLanded(params)
if not IsServer() then return end
if not self:GetParent():HasModifier("modifier_legion_odds_proc") then return end
if self:GetParent() ~= params.attacker then return end
if self:GetParent():HasModifier("modifier_overwhelming_odds_proc") then return end


self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_overwhelming_odds_stack", {})

end


modifier_overwhelming_odds_stack = class({})

function modifier_overwhelming_odds_stack:IsHidden() return false end
function modifier_overwhelming_odds_stack:IsPurgable() return false end
function modifier_overwhelming_odds_stack:GetTexture() return "buffs/odds_proc" end
function modifier_overwhelming_odds_stack:OnCreated(table)
if not IsServer() then return end
self:SetStackCount(1)
end


function modifier_overwhelming_odds_stack:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_TOOLTIP
}
end

function modifier_overwhelming_odds_stack:OnTooltip() return self:GetAbility().proc_max end

function modifier_overwhelming_odds_stack:OnRefresh(table)
if not IsServer() then return end
self:IncrementStackCount()
if self:GetStackCount() >= self:GetAbility().proc_max then 
	EmitSoundOnEntityForPlayer("Lc.Odds_Proc", self:GetParent(), self:GetParent():GetPlayerOwnerID())
	
	self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_overwhelming_odds_proc", {})

	local particle_peffect = ParticleManager:CreateParticle("particles/lc_odd_proc_.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
    ParticleManager:SetParticleControl(particle_peffect, 0, self:GetParent():GetAbsOrigin())
    ParticleManager:SetParticleControl(particle_peffect, 2, self:GetParent():GetAbsOrigin())
   	ParticleManager:ReleaseParticleIndex(particle_peffect)

	

	self:Destroy()

end
end


modifier_overwhelming_odds_proc = class({})
function modifier_overwhelming_odds_proc:IsHidden() return false end
function modifier_overwhelming_odds_proc:IsPurgable() return false end
function modifier_overwhelming_odds_proc:GetTexture() return "buffs/odds_proc" end
function modifier_overwhelming_odds_proc:GetEffectName() return "particles/lc_odd_proc_hands.vpcf" end

modifier_overwhelming_odds_proc_slow = class({})
function modifier_overwhelming_odds_proc_slow:IsHidden() return false end
function modifier_overwhelming_odds_proc_slow:IsPurgable() return true end
function modifier_overwhelming_odds_proc_slow:GetTexture() return "buffs/odds_proc" end
function modifier_overwhelming_odds_proc_slow:CheckState() return {[MODIFIER_STATE_SILENCED] = true} end


function modifier_overwhelming_odds_proc_slow:GetEffectName() return "particles/generic_gameplay/generic_silenced.vpcf" end
 
function modifier_overwhelming_odds_proc_slow:GetEffectAttachType() return PATTACH_OVERHEAD_FOLLOW end





modifier_overwhelming_odds_mark = class({})
function modifier_overwhelming_odds_mark:IsHidden() return false end
function modifier_overwhelming_odds_mark:IsPurgable() return true end
function modifier_overwhelming_odds_mark:GetTexture() return "buffs/odds_mark" end
function modifier_overwhelming_odds_mark:GetEffectName() return "particles/lc_odd_charge_mark.vpcf" end
function modifier_overwhelming_odds_mark:GetEffectAttachType() return PATTACH_OVERHEAD_FOLLOW end

function modifier_overwhelming_odds_mark:DeclareFunctions()
return
{
	MODIFIER_EVENT_ON_ORDER,
	MODIFIER_EVENT_ON_ATTACK_LANDED
}

end
function modifier_overwhelming_odds_mark:OnAttackLanded(params)
if not IsServer() then return end
if self:GetParent() ~= params.target then return end
if self:GetCaster() ~= params.attacker then return end

self:SetDuration(self:GetAbility().mark_duration*(1 - self:GetParent():GetStatusResistance()), true)
end


function modifier_overwhelming_odds_mark:OnOrder( ord )
if not IsServer() then return end
if ord.order_type ~= DOTA_UNIT_ORDER_ATTACK_TARGET and ord.order_type ~= DOTA_UNIT_ORDER_MOVE_TO_TARGET then return end
if ord.target ~= self:GetParent() then return end
if (self:GetParent():GetAbsOrigin() - ord.unit:GetAbsOrigin()):Length2D() < self:GetAbility().mark_min_range then return end
if (self:GetParent():GetAbsOrigin() - ord.unit:GetAbsOrigin()):Length2D() > self:GetAbility().mark_max_range then return end
if self:GetCaster() ~= ord.unit then return end



ord.unit:AddNewModifier(ord.unit, self:GetAbility(), "modifier_overwhelming_odds_mark_speed", {duration = self:GetAbility().mark_speed_duration, target = self:GetParent():entindex()})
ord.unit:EmitSound("Lc.Odds_Charge")

self:Destroy()

end

modifier_overwhelming_odds_mark_speed = class({})
function modifier_overwhelming_odds_mark_speed:IsHidden() return false end
function modifier_overwhelming_odds_mark_speed:IsPurgable() return true end
function modifier_overwhelming_odds_mark_speed:GetTexture() return "buffs/odds_mark" end

function modifier_overwhelming_odds_mark_speed:OnCreated(table)
if not IsServer() then return end
self.target = EntIndexToHScript(table.target)
self.stun = false 
self:GetParent():SetForceAttackTarget(self.target)
self:StartIntervalThink(FrameTime())
end

function modifier_overwhelming_odds_mark_speed:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_MOVESPEED_ABSOLUTE,
	MODIFIER_PROPERTY_TRANSLATE_ACTIVITY_MODIFIERS,
	MODIFIER_EVENT_ON_ATTACK_START
}

end


function modifier_overwhelming_odds_mark_speed:OnAttackStart(params)
if not IsServer() then return end
if self:GetParent() ~= params.attacker then return end

self.stun = true 
self:Destroy()

end


function modifier_overwhelming_odds_mark_speed:OnIntervalThink()
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
or self:GetParent():IsAttackImmune()
or self:GetParent():IsHexed()
or self:GetParent():IsRooted() then 
 	self:Destroy()
end

end

function modifier_overwhelming_odds_mark_speed:OnDestroy()
if not IsServer() then return end
local stun = self:GetAbility().mark_stun

	if self.stun then 

		local anim = self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_overwhelming_odds_mark_anim", {})
		self:GetParent():EmitSound("Lc.Odds_ChargeHit")
		self:GetParent():StartGesture(ACT_DOTA_ATTACK)
		if anim then 
			anim:Destroy()
		end
		if not  self.target:IsMagicImmune() then
			self.target:AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_stunned", {duration = stun})

			local particle_peffect = ParticleManager:CreateParticle("particles/lc_odd_charge_hit_.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.target)
		
    		ParticleManager:SetParticleControl(particle_peffect, 0, self.target:GetAbsOrigin())
    		ParticleManager:SetParticleControl(particle_peffect, 1, self.target:GetAbsOrigin())
    	 	ParticleManager:SetParticleControl(particle_peffect, 3, self.target:GetAbsOrigin())
    		ParticleManager:ReleaseParticleIndex(particle_peffect)
			

		end
	end


self:GetParent():SetForceAttackTarget(nil)
end
function modifier_overwhelming_odds_mark_speed:GetEffectName() return "particles/lc_odd_charge.vpcf" end

function modifier_overwhelming_odds_mark_speed:GetModifierMoveSpeed_Absolute() return self:GetAbility().mark_speed
 end
function modifier_overwhelming_odds_mark_speed:GetActivityTranslationModifiers() return "overwhelmingodds" end



modifier_overwhelming_odds_mark_anim = class({})
function modifier_overwhelming_odds_mark_anim:IsHidden() return true end
function modifier_overwhelming_odds_mark_anim:IsPurgable() return false end
function modifier_overwhelming_odds_mark_anim:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_TRANSLATE_ACTIVITY_MODIFIERS
}

end
function modifier_overwhelming_odds_mark_anim:GetActivityTranslationModifiers() return "duel_kill" end



modifier_overwhelming_odds_legendary = class({})
function modifier_overwhelming_odds_legendary:IsHidden() return false end
function modifier_overwhelming_odds_legendary:IsPurgable() return false end
function modifier_overwhelming_odds_legendary:GetTexture() return "buffs/odds_legendary" end
function modifier_overwhelming_odds_legendary:GetEffectName() return "particles/lc_odds_l.vpcf" end
function modifier_overwhelming_odds_legendary:GetEffectAttachType() return PATTACH_OVERHEAD_FOLLOW end
function modifier_overwhelming_odds_legendary:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end


function modifier_overwhelming_odds_legendary:OnCreated(table)
self.RemoveForDuel = true 
self.radius = self:GetAbility().legendary_radius
self.count = 0
self.flag = DOTA_UNIT_TARGET_FLAG_NONE + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES 
if not IsServer() then return end
self:SetStackCount(0)
end


function modifier_overwhelming_odds_legendary:DeclareFunctions()
return
{
	MODIFIER_EVENT_ON_ATTACK_LANDED
}
end


function modifier_overwhelming_odds_legendary:OnAttackLanded(params)
if not IsServer() then return end
if self:GetParent() ~= params.attacker then return end

if self:GetStackCount() < self:GetAbility().legendary_max then
	self:IncrementStackCount()
end

if self:GetStackCount() == self:GetAbility().legendary_max then 
	self:LaunchOdds()
end

end



function modifier_overwhelming_odds_legendary:LaunchOdds()
if not IsServer() then return end
local enemies_hero = FindUnitsInRadius(self:GetParent():GetTeamNumber(),self:GetParent():GetAbsOrigin(),nil,self.radius,DOTA_UNIT_TARGET_TEAM_ENEMY,DOTA_UNIT_TARGET_HERO,self.flag,FIND_ANY_ORDER,false)
local enemies_creep = FindUnitsInRadius(self:GetParent():GetTeamNumber(),self:GetParent():GetAbsOrigin(),nil,self.radius,DOTA_UNIT_TARGET_TEAM_ENEMY,DOTA_UNIT_TARGET_BASIC,self.flag,FIND_ANY_ORDER,false)

if #enemies_creep < 1 and #enemies_hero < 1 then return end

self:SetStackCount(0)


if #enemies_hero > 0 then 
	local target = enemies_hero[RandomInt(1, #enemies_hero)]
	self:GetAbility():OnSpellStart(target:GetAbsOrigin())
else
	if #enemies_creep > 0 then 
		local target = enemies_creep[RandomInt(1, #enemies_creep)]
		self:GetAbility():OnSpellStart(target:GetAbsOrigin())
	end
end

self.count = self.count + 1
if self.count >= self:GetAbility().legendary_max_odds then 
	self:Destroy()
end

end


modifier_overwhelming_odds_damage = class({})
function modifier_overwhelming_odds_damage:IsHidden() return false end
function modifier_overwhelming_odds_damage:IsPurgable() return true end
function modifier_overwhelming_odds_damage:GetTexture() return "buffs/odds_damage" end
function modifier_overwhelming_odds_damage:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_DAMAGEOUTGOING_PERCENTAGE
}
end

function modifier_overwhelming_odds_damage:GetModifierDamageOutgoing_Percentage()
return
self:GetAbility().damage_init + self:GetAbility().damage_inc*self:GetCaster():GetUpgradeStack("modifier_legion_odds_creep")
end