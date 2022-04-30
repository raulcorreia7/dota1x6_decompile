LinkLuaModifier("modifier_custom_pudge_dismember","abilities/pudge/custom_pudge_dismember", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_custom_pudge_dismember_pull", "abilities/pudge/custom_pudge_dismember", LUA_MODIFIER_MOTION_HORIZONTAL)
LinkLuaModifier("modifier_custom_pudge_dismember_visual", "abilities/pudge/custom_pudge_dismember", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_custom_pudge_dismember_illusion", "abilities/pudge/custom_pudge_dismember", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_custom_pudge_dismember_outgoing", "abilities/pudge/custom_pudge_dismember", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_custom_pudge_dismember_legendary", "abilities/pudge/custom_pudge_dismember", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_custom_pudge_dismember_legendary_ondeath", "abilities/pudge/custom_pudge_dismember", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_custom_pudge_dismember_legendary_ondeath_cd", "abilities/pudge/custom_pudge_dismember", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_custom_pudge_dismember_legendary_aura", "abilities/pudge/custom_pudge_dismember", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_custom_pudge_dismember_stats_regen", "abilities/pudge/custom_pudge_dismember", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_custom_pudge_dismember_stats_speed", "abilities/pudge/custom_pudge_dismember", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_custom_pudge_dismember_stats_cdr", "abilities/pudge/custom_pudge_dismember", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_custom_pudge_dismember_caster", "abilities/pudge/custom_pudge_dismember", LUA_MODIFIER_MOTION_NONE)


custom_pudge_dismember = class({})

custom_pudge_dismember.range_bonus = 100
custom_pudge_dismember.range_stun = 0.5
custom_pudge_dismember.range_tick = 1

custom_pudge_dismember.damage_init = 0.1	
custom_pudge_dismember.damage_inc = 0.1

custom_pudge_dismember.str_init = 0.1
custom_pudge_dismember.str_inc = 0.1

custom_pudge_dismember.cd_init = -1
custom_pudge_dismember.cd_inc = -1

custom_pudge_dismember.outgoing_init = -5
custom_pudge_dismember.outgoing_inc = -5
custom_pudge_dismember.outgoing_duration = 5

custom_pudge_dismember.legendary_cd = 60
custom_pudge_dismember.legendary_range = 70
custom_pudge_dismember.legendary_save_duration = 2
custom_pudge_dismember.legendary_ticks = 5

custom_pudge_dismember.stats_regen = 2
custom_pudge_dismember.stats_cdr = 25
custom_pudge_dismember.stats_speed = 20
custom_pudge_dismember.stats_duration = 30

custom_pudge_dismember.health_init = 0.01
custom_pudge_dismember.health_inc = 0.01

function custom_pudge_dismember:GetIntrinsicModifierName()
if not self:GetCaster():HasModifier("modifier_custom_pudge_dismember_visual") then 
	return "modifier_custom_pudge_dismember_visual"
end 
	return 
end



function custom_pudge_dismember:GetBehavior()
  if self:GetCaster():HasModifier("modifier_pudge_dismember_legendary") then
    return DOTA_ABILITY_BEHAVIOR_NO_TARGET + DOTA_ABILITY_BEHAVIOR_CHANNELLED + DOTA_ABILITY_BEHAVIOR_IGNORE_BACKSWING end
 return DOTA_ABILITY_BEHAVIOR_UNIT_TARGET + DOTA_ABILITY_BEHAVIOR_CHANNELLED + DOTA_ABILITY_BEHAVIOR_IGNORE_BACKSWING
end

function custom_pudge_dismember:GetChannelTime()

if self:GetCaster():HasModifier("modifier_pudge_dismember_legendary") then 
	local duration =  self:GetSpecialValueFor("duration")

	if self:GetCaster():HasModifier("modifier_pudge_dismember_5") then 
    	duration = duration + self.range_stun
	end
	return duration
else 

	if self:GetCaster():HasModifier("modifier_custom_pudge_dismember_visual") then 
		return self:GetCaster():GetModifierStackCount("modifier_custom_pudge_dismember_visual", self:GetCaster()) * 0.01
	end
end

end

function custom_pudge_dismember:OnAbilityPhaseStart()
if not IsServer() then return end
self.target = nil
self.targets = {}

if not self:GetCaster():HasModifier("modifier_pudge_dismember_legendary") then return true end

	local radius = self:GetSpecialValueFor("radius") + self.legendary_range

	if self:GetCaster():HasModifier("modifier_pudge_dismember_5") then 
		radius = radius + self.range_bonus
	end



	self.targets = FindUnitsInRadius(self:GetCaster():GetTeamNumber(), self:GetCaster():GetAbsOrigin(), nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false)

	if #self.targets == 0 then 
		 CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(self:GetCaster():GetPlayerID()), "CreateIngameErrorMessage", {message = "#no_targets"})
		return false 
	end

return true

end


function custom_pudge_dismember:GetCastRange(location, target)
local bonus = 0
if self:GetCaster():HasModifier("modifier_pudge_dismember_5") then 
    bonus = self.range_bonus
end

if self:GetCaster():HasModifier("modifier_pudge_dismember_legendary") then 
	bonus = bonus + self.legendary_range
end

    return self.BaseClass.GetCastRange(self, location, target) + bonus
end


function custom_pudge_dismember:GetChannelAnimation()
	return ACT_DOTA_CHANNEL_ABILITY_4
end

function custom_pudge_dismember:GetCooldown(level)
local bonus = 0
if self:GetCaster():HasModifier("modifier_pudge_dismember_3") then 
	bonus = self.cd_init + self.cd_inc*self:GetCaster():GetUpgradeStack("modifier_pudge_dismember_3")
end

    return self.BaseClass.GetCooldown( self, level ) + bonus
end

function custom_pudge_dismember:OnSpellStart(new_target)
if not IsServer() then return end

if self:GetCaster():HasShard() then 
	self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_custom_pudge_dismember_caster", {})
end

if not self:GetCaster():HasModifier("modifier_pudge_dismember_legendary") then 

	local target

	if self:GetCaster():IsIllusion() then 
		self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_custom_pudge_dismember_illusion", {duration = self:GetChannelTime()})
	end

	if new_target ~= nil then
		target = new_target
	else
	 	target = self:GetCursorTarget()
	end


	if target:TriggerSpellAbsorb(self) then self:GetCaster():Interrupt() return end

	self.target = target

	target:AddNewModifier(self:GetCaster(), self, "modifier_custom_pudge_dismember", {duration = self:GetChannelTime()  })

else


	if self.targets[1] == nil then return end

	local radius = self:GetSpecialValueFor("radius") + self.legendary_range
	local duration = self:GetSpecialValueFor("duration")

	if self:GetCaster():HasModifier("modifier_pudge_dismember_5") then 
    	duration = duration + self.range_stun
		radius = radius + self.range_bonus
	end

	local count = 0

	for _,target in pairs(self.targets) do
		if target:IsAlive() then 
			if not target:TriggerSpellAbsorb(self) then 
				count = count + 1
				target:AddNewModifier(self:GetCaster(), self, "modifier_custom_pudge_dismember_legendary", {duration = (1 - target:GetStatusResistance())*duration})
			end
		end
	end
	if count == 0 then 
		self:GetCaster():Interrupt()
	end

end



end

function custom_pudge_dismember:OnChannelFinish(bInterrupted)

	if self:GetCaster():HasModifier("modifier_custom_pudge_dismember_caster") then 
		self:GetCaster():RemoveModifierByName("modifier_custom_pudge_dismember_caster")
	end

	if self.target then
		local target_buff = self.target:FindModifierByName("modifier_custom_pudge_dismember")
		if target_buff then

			target_buff:Destroy()
		end
	end

	if self.targets and self.targets[1] ~= nil then 
		for _,target in pairs(self.targets) do 

		

			local target_buff = target:FindModifierByName("modifier_custom_pudge_dismember_legendary")
			if target_buff then
				target_buff:Destroy()
			end
		end
	end


end


function custom_pudge_dismember:DealDamage(caster, target, tick)
if not IsServer() then return end

	self.dismember_damage	= self:GetSpecialValueFor("dismember_damage")
	self.strength_damage	= (self:GetSpecialValueFor("strength_damage"))


	if caster:HasModifier("modifier_pudge_dismember_1") then 
    	self.strength_damage = self.strength_damage + self.str_init + self.str_inc*caster:GetUpgradeStack("modifier_pudge_dismember_1")
	end
	self.strength_damage =  self.strength_damage * caster:GetStrength()

	self.damage = (self.dismember_damage + self.strength_damage)*tick

	if caster:HasModifier("modifier_pudge_dismember_4") then 
		local k = 1 + (1 - math.max(caster:GetHealthPercent(),1)/100)*(self.damage_init + self.damage_inc*caster:GetUpgradeStack("modifier_pudge_dismember_4"))
	
    	self.damage = self.damage*k
	end 

	local damageTable = { victim = target, attacker = caster, damage = self.damage, damage_type = DAMAGE_TYPE_MAGICAL, damage_flags = DOTA_DAMAGE_FLAG_NONE, ability = self}
	ApplyDamage(damageTable)


	if caster:HasModifier("modifier_pudge_dismember_2") then 
		target:AddNewModifier(caster, self, "modifier_custom_pudge_dismember_outgoing", {duration = (1 - target:GetStatusResistance())*self.outgoing_duration})
	end

	if target:IsHero() and caster:HasModifier("modifier_pudge_dismember_6") then 


		if target:GetPrimaryAttribute() == 0 then 
			caster:AddNewModifier(caster, self, "modifier_custom_pudge_dismember_stats_regen", {duration = self.stats_duration})
		end		
		if target:GetPrimaryAttribute() == 1 then 
			caster:AddNewModifier(caster, self, "modifier_custom_pudge_dismember_stats_speed", {duration = self.stats_duration})
		end		
		if target:GetPrimaryAttribute() == 2 then 
			caster:AddNewModifier(caster, self, "modifier_custom_pudge_dismember_stats_cdr", {duration = self.stats_duration})
		end
	

	end

	target:EmitSound("Hero_Pudge.Dismember")

	caster:Heal(self.damage, self)
 	SendOverheadEventMessage(caster, 10, caster, self.damage, nil)


end










modifier_custom_pudge_dismember = class({})

function modifier_custom_pudge_dismember:IsDebuff() return true end

function modifier_custom_pudge_dismember:CheckState()
if not self:GetCaster():HasShard() then 
	return {[MODIFIER_STATE_STUNNED] = true,}
else 
		return {[MODIFIER_STATE_PASSIVES_DISABLED] = true,
			[MODIFIER_STATE_STUNNED] = true,}
end

end


function modifier_custom_pudge_dismember:GetEffectName() 
if self:GetCaster():HasShard() then 
	return "particles/generic_gameplay/generic_break.vpcf" 
end

end
 
function modifier_custom_pudge_dismember:GetEffectAttachType() return PATTACH_OVERHEAD_FOLLOW end


function modifier_custom_pudge_dismember:DeclareFunctions()
	return {MODIFIER_PROPERTY_OVERRIDE_ANIMATION}
end

function modifier_custom_pudge_dismember:GetOverrideAnimation()
	return ACT_DOTA_FLAIL
end

function modifier_custom_pudge_dismember:OnCreated()
if not IsServer() then return end

	if self:GetCaster():GetModelName() == "models/items/pudge/arcana/pudge_arcana_base.vmdl" then
		self.pfx = ParticleManager:CreateParticle("particles/econ/items/pudge/pudge_arcana/pudge_arcana_dismember_default.vpcf", PATTACH_ABSORIGIN, self:GetParent())
		ParticleManager:SetParticleControl(self.pfx, 1, self:GetParent():GetAbsOrigin())
		ParticleManager:SetParticleControl(self.pfx, 8, Vector(1, 1, 1))
		ParticleManager:SetParticleControl(self.pfx, 15, Vector(64, 9, 9))
	else
		self.pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_pudge/pudge_dismember.vpcf", PATTACH_ABSORIGIN, self:GetParent())
		ParticleManager:SetParticleControlEnt(self.pfx, 0, self:GetCaster(), PATTACH_ABSORIGIN_FOLLOW, "attach_attack1", self:GetCaster():GetAbsOrigin(), true)
	end

	self:AddParticle(self.pfx, false, false, -1, false, false)



	local tick = self:GetAbility():GetSpecialValueFor("ticks")


	if self:GetCaster():HasModifier("modifier_pudge_dismember_5") then 
    	tick = tick + self:GetAbility().range_tick
	end

	self.max = tick
	self.count = 0

	self.standard_tick_interval	= self:GetAbility():GetChannelTime() / tick 
	self:StartIntervalThink(self.standard_tick_interval)

	self:OnIntervalThink()
	self:GetParent():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_custom_pudge_dismember_pull", {duration = self:GetAbility():GetChannelTime()})
end

function modifier_custom_pudge_dismember:OnIntervalThink()
if not IsServer() then return end
if self.count >= self.max then return end

	self.count = self.count + 1

	self:GetAbility():DealDamage(self:GetCaster(), self:GetParent(), self.standard_tick_interval)
end

function modifier_custom_pudge_dismember:OnDestroy()
	if not IsServer() then return end
	if self:GetCaster():IsChanneling() then
		self:GetAbility():EndChannel(false)
		self:GetCaster():MoveToPositionAggressive(self:GetParent():GetAbsOrigin())
	end
end

modifier_custom_pudge_dismember_pull = class({})

function modifier_custom_pudge_dismember_pull:IsHidden() return true end

function modifier_custom_pudge_dismember_pull:OnCreated(params)
if not IsServer() then return end
	self.ability = self:GetAbility()
	self.caster = self:GetCaster()
	self.parent = self:GetParent()
	self.pull_units_per_second = self.ability:GetSpecialValueFor("pull_units_per_second")
	self.pull_distance_limit = self.ability:GetSpecialValueFor("pull_distance_limit")
	if self:ApplyHorizontalMotionController() == false then 
		self:Destroy()
		return
	end
end

function modifier_custom_pudge_dismember_pull:UpdateHorizontalMotion( me, dt )
	if not IsServer() then return end
	local distance = self.caster:GetOrigin() - me:GetOrigin()

	if distance:Length2D() > self.pull_distance_limit and 
		(self.parent:HasModifier("modifier_custom_pudge_dismember_legendary_aura") or self.parent:HasModifier("modifier_custom_pudge_dismember") or self.parent:HasModifier("modifier_custom_pudge_dismember_legendary")) then
		me:SetOrigin( me:GetOrigin() + distance:Normalized() * self.pull_units_per_second * dt )
	else
		self:Destroy()
	end
end

function modifier_custom_pudge_dismember_pull:OnDestroy()
	if not IsServer() then return end
	self.parent:RemoveHorizontalMotionController( self )
end
modifier_custom_pudge_dismember_visual = class({})


function modifier_custom_pudge_dismember_visual:IsHidden()	return true end
function modifier_custom_pudge_dismember_visual:IsPurgable()	return false end
function modifier_custom_pudge_dismember_visual:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE
end
function modifier_custom_pudge_dismember_visual:DeclareFunctions()
	local decFuncs = 
	{
		MODIFIER_EVENT_ON_ABILITY_EXECUTED,
		MODIFIER_EVENT_ON_TAKEDAMAGE,
		MODIFIER_PROPERTY_MIN_HEALTH

	}
	
	return decFuncs
end

function modifier_custom_pudge_dismember_visual:OnTakeDamage(params)
if not IsServer() then return end
if self:GetParent() ~= params.unit then return end
if params.attacker == self:GetParent() then return end
if self:GetParent():PassivesDisabled() then return end
if self:GetParent():HasModifier("modifier_death") then return end
if not self:GetParent():HasModifier("modifier_pudge_dismember_legendary") then return end
if self:GetParent():GetHealth() > 1 then return end
if self:GetParent():HasModifier("modifier_custom_pudge_dismember_legendary_ondeath_cd") then return end
if self:GetParent():HasModifier("modifier_custom_pudge_dismember_legendary_ondeath") then return end
if self:GetParent():HasModifier("modifier_up_res") and not self:GetParent():HasModifier("modifier_up_res_cd") then return end

self:GetParent():Purge(false, true, false, true, true)
self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_custom_pudge_dismember_legendary_ondeath", {duration = self:GetAbility().legendary_save_duration + FrameTime()})

end

function modifier_custom_pudge_dismember_visual:GetMinHealth()
if self:GetParent():HasModifier("modifier_death") then return end
if self:GetParent():PassivesDisabled() then return end
if not self:GetParent():HasModifier("modifier_pudge_dismember_legendary") then return end
if self:GetParent():HasModifier("modifier_custom_pudge_dismember_legendary_ondeath_cd") then return end
return 1
end




function modifier_custom_pudge_dismember_visual:OnCreated(table)
if not IsServer() then return end
	self:SetStackCount(300)
end

function modifier_custom_pudge_dismember_visual:OnAbilityExecuted(params)
if not IsServer() then return end

    if params.ability == nil or not ( params.ability:GetCaster() == self:GetParent() ) then
        return
    end

if self:GetCaster():HasModifier("modifier_pudge_dismember_legendary") then return end

	if params.ability == self:GetAbility() then
		local duration = self:GetAbility():GetSpecialValueFor("duration")

		if self:GetCaster():HasModifier("modifier_pudge_dismember_5") then 
    		duration = duration + self:GetAbility().range_stun
		end

			self:GetCaster():SetModifierStackCount("modifier_custom_pudge_dismember_visual", self:GetCaster(), duration * (1 - params.target:GetStatusResistance()) * 100)

	end
end


modifier_custom_pudge_dismember_illusion = class({})
function modifier_custom_pudge_dismember_illusion:CheckState()
return
{
	[MODIFIER_STATE_STUNNED] = true
}
end

function modifier_custom_pudge_dismember_illusion:OnCreated(table)
if not IsServer() then return end
	self:GetParent():StartGesture(ACT_DOTA_CHANNEL_ABILITY_4)
end

function modifier_custom_pudge_dismember_illusion:OnDestroy()
if not IsServer() then return end
	self:GetParent():RemoveGesture(ACT_DOTA_CHANNEL_ABILITY_4)
end



modifier_custom_pudge_dismember_outgoing = class({})
function modifier_custom_pudge_dismember_outgoing:IsHidden() return false end
function modifier_custom_pudge_dismember_outgoing:IsPurgable() return true end
function modifier_custom_pudge_dismember_outgoing:GetTexture() return "buffs/dismember_damage" end

function modifier_custom_pudge_dismember_outgoing:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE
}
end

function modifier_custom_pudge_dismember_outgoing:GetModifierTotalDamageOutgoing_Percentage()
return self:GetAbility().outgoing_init + self:GetAbility().outgoing_inc*self:GetCaster():GetUpgradeStack("modifier_pudge_dismember_2")
end











modifier_custom_pudge_dismember_legendary = class({})

function modifier_custom_pudge_dismember_legendary:IsDebuff() return true end


function modifier_custom_pudge_dismember_legendary:CheckState()
if not self:GetCaster():HasShard() then 
	return {[MODIFIER_STATE_STUNNED] = true,}
else 
	return {[MODIFIER_STATE_PASSIVES_DISABLED] = true,
			[MODIFIER_STATE_STUNNED] = true,}
end

end


function modifier_custom_pudge_dismember_legendary:GetEffectName() 
if self:GetCaster():HasShard() then 
	return "particles/generic_gameplay/generic_break.vpcf" 
end

end
 
function modifier_custom_pudge_dismember_legendary:GetEffectAttachType() return PATTACH_OVERHEAD_FOLLOW end

function modifier_custom_pudge_dismember_legendary:DeclareFunctions()
	return {MODIFIER_PROPERTY_OVERRIDE_ANIMATION}
end

function modifier_custom_pudge_dismember_legendary:GetOverrideAnimation()
	return ACT_DOTA_FLAIL
end

function modifier_custom_pudge_dismember_legendary:OnCreated()
if not IsServer() then return end


	if self:GetCaster():GetModelName() == "models/items/pudge/arcana/pudge_arcana_base.vmdl" then
		self.pfx = ParticleManager:CreateParticle("particles/econ/items/pudge/pudge_arcana/pudge_arcana_dismember_default.vpcf", PATTACH_ABSORIGIN, self:GetParent())
		ParticleManager:SetParticleControl(self.pfx, 1, self:GetParent():GetAbsOrigin())
		ParticleManager:SetParticleControl(self.pfx, 8, Vector(1, 1, 1))
		ParticleManager:SetParticleControl(self.pfx, 15, Vector(64, 9, 9))
	else
		self.pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_pudge/pudge_dismember.vpcf", PATTACH_ABSORIGIN, self:GetParent())
		ParticleManager:SetParticleControlEnt(self.pfx, 0, self:GetCaster(), PATTACH_ABSORIGIN_FOLLOW, "attach_attack1", self:GetCaster():GetAbsOrigin(), true)
	end

	self:AddParticle(self.pfx, false, false, -1, false, false)

	local tick = self:GetAbility():GetSpecialValueFor("ticks")


	if self:GetCaster():HasModifier("modifier_pudge_dismember_5") then 
    	tick = tick + self:GetAbility().range_tick
	end


	self.max = tick
	self.count = 0

	self.standard_tick_interval	= self:GetRemainingTime() / tick 
	self:StartIntervalThink(self.standard_tick_interval)

	self:OnIntervalThink()
	self:GetParent():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_custom_pudge_dismember_pull", {duration = self:GetRemainingTime()})
end





function modifier_custom_pudge_dismember_legendary:OnIntervalThink()
if not IsServer() then return end
if self.count >= self.max then return end

	self.count = self.count + 1

	self:GetAbility():DealDamage(self:GetCaster(),self:GetParent(), self.standard_tick_interval)
end

function modifier_custom_pudge_dismember_legendary:OnDestroy()
	if not IsServer() then return end
	if self:GetCaster():IsChanneling() then
		local stop = true 

		if self:GetAbility().targets ~= nil then 
			for _,target in pairs(self:GetAbility().targets) do
				if target:HasModifier("modifier_custom_pudge_dismember_legendary") then 
					stop = false
				end
			end
 		end

 		if stop == true then 
			self:GetAbility():EndChannel(false)

			self:GetCaster():MoveToPositionAggressive(self:GetParent():GetAbsOrigin())
		end
	end
end

modifier_custom_pudge_dismember_legendary_ondeath_cd = class({})
function modifier_custom_pudge_dismember_legendary_ondeath_cd:IsHidden() return false end
function modifier_custom_pudge_dismember_legendary_ondeath_cd:IsDebuff() return true end
function modifier_custom_pudge_dismember_legendary_ondeath_cd:IsPurgable() return false end
function modifier_custom_pudge_dismember_legendary_ondeath_cd:RemoveOnDeath() return false end
function modifier_custom_pudge_dismember_legendary_ondeath_cd:OnCreated(table)
self.RemoveForDuel = true
end





modifier_custom_pudge_dismember_legendary_ondeath = class({})



function modifier_custom_pudge_dismember_legendary_ondeath:IsDebuff() return false end
function modifier_custom_pudge_dismember_legendary_ondeath:IsHidden() return true end
function modifier_custom_pudge_dismember_legendary_ondeath:IsPurgable() return false end

function modifier_custom_pudge_dismember_legendary_ondeath:OnCreated(table)
if not IsServer() then return end

self:GetParent():EmitSound("Pudge.Dismember_grave")
self.pfx = ParticleManager:CreateParticle("particles/econ/items/dazzle/dazzle_dark_light_weapon/pudge_grave.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster())
ParticleManager:SetParticleControl(self.pfx, 0,  self:GetCaster():GetAbsOrigin())

	self:AddParticle(self.pfx,false, false, -1, false, false)


self:GetParent():Stop()
self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_custom_pudge_dismember_legendary_ondeath_cd", {duration = self:GetAbility().legendary_cd})

self.radius = self:GetAbility():GetSpecialValueFor("radius") + self:GetAbility().legendary_range

if self:GetCaster():HasModifier("modifier_pudge_dismember_5") then 
	self.radius = self.radius + self:GetAbility().range_bonus
end

self.targets = {}



self:StartIntervalThink(FrameTime())
end


function modifier_custom_pudge_dismember_legendary_ondeath:OnIntervalThink()
if not IsServer() then return end

if self:GetParent():IsStunned() or self:GetParent():IsSilenced() or self:GetParent():GetForceAttackTarget() ~= nil or self:GetParent():IsHexed() then
	--self:Destroy()
end

local targets = FindUnitsInRadius(self:GetCaster():GetTeamNumber(), self:GetCaster():GetAbsOrigin(), nil, self.radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false)

for _,target in pairs(targets) do 
	if not target:HasModifier("modifier_custom_pudge_dismember_legendary_aura") then
		table.insert(self.targets,target)
		target:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_custom_pudge_dismember_legendary_aura", {duration = self:GetRemainingTime() - FrameTime()})
	end
end
end

function modifier_custom_pudge_dismember_legendary_ondeath:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_MIN_HEALTH,
	MODIFIER_PROPERTY_OVERRIDE_ANIMATION
}
end

function modifier_custom_pudge_dismember_legendary_ondeath:GetOverrideAnimation()
return ACT_DOTA_CHANNEL_ABILITY_4
end

function modifier_custom_pudge_dismember_legendary_ondeath:GetMinHealth()
if not self:GetParent():HasModifier("modifier_death") then return 1 end
end

function modifier_custom_pudge_dismember_legendary_ondeath:GetEffectName()
if self:GetCaster():HasShard() then
	return "particles/items_fx/black_king_bar_avatar.vpcf"
end

end

function modifier_custom_pudge_dismember_legendary_ondeath:CheckState()
if not self:GetCaster():HasShard() then 
	return 
		{
			[MODIFIER_STATE_COMMAND_RESTRICTED] = true,
			[MODIFIER_STATE_STUNNED] = true,
		}
else 
	return 
		{
			[MODIFIER_STATE_COMMAND_RESTRICTED] = true,
			[MODIFIER_STATE_STUNNED] = true,
			[MODIFIER_STATE_MAGIC_IMMUNE] = true
		}

end


end
function modifier_custom_pudge_dismember_legendary_ondeath:OnDestroy()
if not IsServer() then return end

for _,target in pairs(self.targets) do
	if target:HasModifier("modifier_custom_pudge_dismember_legendary_aura") then 
		target:RemoveModifierByName("modifier_custom_pudge_dismember_legendary_aura")
	end
end

if self.pfx then
	ParticleManager:DestroyParticle(self.pfx, false)
	ParticleManager:ReleaseParticleIndex(self.pfx)
end
end








modifier_custom_pudge_dismember_legendary_aura = class({})

function modifier_custom_pudge_dismember_legendary_aura:IsDebuff() return true end

function modifier_custom_pudge_dismember_legendary_aura:CheckState()
if not self:GetCaster():HasShard() then 
	return {[MODIFIER_STATE_STUNNED] = true,}
else 
		return {[MODIFIER_STATE_PASSIVES_DISABLED] = true,
			[MODIFIER_STATE_STUNNED] = true,}
end

end


function modifier_custom_pudge_dismember_legendary_aura:GetEffectName() 
if self:GetCaster():HasShard() then 
	return "particles/generic_gameplay/generic_break.vpcf" 
end

end
 
function modifier_custom_pudge_dismember_legendary_aura:GetEffectAttachType() return PATTACH_OVERHEAD_FOLLOW end

function modifier_custom_pudge_dismember_legendary_aura:DeclareFunctions()
	return {MODIFIER_PROPERTY_OVERRIDE_ANIMATION}
end

function modifier_custom_pudge_dismember_legendary_aura:GetOverrideAnimation()
	return ACT_DOTA_FLAIL
end

function modifier_custom_pudge_dismember_legendary_aura:OnCreated()
if not IsServer() then return end
local ability = self:GetCaster():FindAbilityByName("custom_pudge_dismember")
if not ability then return end


	if self:GetCaster():GetModelName() == "models/items/pudge/arcana/pudge_arcana_base.vmdl" then
		self.pfx = ParticleManager:CreateParticle("particles/econ/items/pudge/pudge_arcana/pudge_arcana_dismember_default.vpcf", PATTACH_ABSORIGIN, self:GetParent())
		ParticleManager:SetParticleControl(self.pfx, 1, self:GetParent():GetAbsOrigin())
		ParticleManager:SetParticleControl(self.pfx, 8, Vector(1, 1, 1))
		ParticleManager:SetParticleControl(self.pfx, 15, Vector(64, 9, 9))
	else
		self.pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_pudge/pudge_dismember.vpcf", PATTACH_ABSORIGIN, self:GetParent())
		ParticleManager:SetParticleControlEnt(self.pfx, 0, self:GetCaster(), PATTACH_ABSORIGIN_FOLLOW, "attach_attack1", self:GetCaster():GetAbsOrigin(), true)
	end

	self:AddParticle(self.pfx, false, false, -1, false, false)

	local mod = self:GetCaster():FindModifierByName("modifier_custom_pudge_dismember_legendary_ondeath")

	
	if not mod then return end

	local tick = self:GetAbility().legendary_ticks

	self.standard_tick_interval	= self:GetAbility().legendary_save_duration / tick
	self:StartIntervalThink(self.standard_tick_interval)

	self:OnIntervalThink()
	self:GetParent():AddNewModifier(self:GetCaster(), ability, "modifier_custom_pudge_dismember_pull", {duration = self:GetRemainingTime()})
end

function modifier_custom_pudge_dismember_legendary_aura:OnIntervalThink()
if not IsServer() then return end
local ability = self:GetCaster():FindAbilityByName("custom_pudge_dismember")
if not ability then return end

	ability:DealDamage(self:GetCaster(), self:GetParent(), self.standard_tick_interval)
end


modifier_custom_pudge_dismember_stats_regen = class({})
function modifier_custom_pudge_dismember_stats_regen:IsHidden() return false end
function modifier_custom_pudge_dismember_stats_regen:IsPurgable() return false end
function modifier_custom_pudge_dismember_stats_regen:GetTexture() return "buffs/dismember_regen" end
function modifier_custom_pudge_dismember_stats_regen:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_HEALTH_REGEN_PERCENTAGE
}
end
function modifier_custom_pudge_dismember_stats_regen:GetModifierHealthRegenPercentage()
return self:GetAbility().stats_regen
end


modifier_custom_pudge_dismember_stats_speed = class({})
function modifier_custom_pudge_dismember_stats_speed:IsHidden() return false end
function modifier_custom_pudge_dismember_stats_speed:IsPurgable() return false end
function modifier_custom_pudge_dismember_stats_speed:GetTexture() return "buffs/dismember_speed" end
function modifier_custom_pudge_dismember_stats_speed:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE
}
end
function modifier_custom_pudge_dismember_stats_speed:GetModifierMoveSpeedBonus_Percentage()
return self:GetAbility().stats_speed
end




modifier_custom_pudge_dismember_stats_cdr = class({})
function modifier_custom_pudge_dismember_stats_cdr:IsHidden() return false end
function modifier_custom_pudge_dismember_stats_cdr:IsPurgable() return false end
function modifier_custom_pudge_dismember_stats_cdr:GetTexture() return "buffs/dismember_cdr" end
function modifier_custom_pudge_dismember_stats_cdr:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_COOLDOWN_PERCENTAGE
}
end
function modifier_custom_pudge_dismember_stats_cdr:GetModifierPercentageCooldown()
return self:GetAbility().stats_cdr
end


modifier_custom_pudge_dismember_caster = class({})
function modifier_custom_pudge_dismember_caster:IsHidden() return true end
function modifier_custom_pudge_dismember_caster:IsPurgable() return false end
function modifier_custom_pudge_dismember_caster:CheckState()
return
{
	[MODIFIER_STATE_MAGIC_IMMUNE] = true
}
end
function modifier_custom_pudge_dismember_caster:GetEffectName() return 
"particles/items_fx/black_king_bar_avatar.vpcf"
end