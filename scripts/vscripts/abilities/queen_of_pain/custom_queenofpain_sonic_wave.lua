LinkLuaModifier("modifier_generic_motion_controller", "abilities/generic/modifier_generic_motion_controller", LUA_MODIFIER_MOTION_BOTH)
LinkLuaModifier("modifier_custom_sonic_heal", "abilities/queen_of_pain/custom_queenofpain_sonic_wave", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_custom_sonic_kills", "abilities/queen_of_pain/custom_queenofpain_sonic_wave", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_custom_sonic_kills_cd", "abilities/queen_of_pain/custom_queenofpain_sonic_wave", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_custom_sonic_tracker", "abilities/queen_of_pain/custom_queenofpain_sonic_wave", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_custom_sonic_fire_thinker", "abilities/queen_of_pain/custom_queenofpain_sonic_wave", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_custom_sonic_reduce", "abilities/queen_of_pain/custom_queenofpain_sonic_wave", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_custom_sonic_damage", "abilities/queen_of_pain/custom_queenofpain_sonic_wave", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_custom_sonic_order_move", "abilities/queen_of_pain/custom_queenofpain_sonic_wave", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_custom_sonic_order_attack", "abilities/queen_of_pain/custom_queenofpain_sonic_wave", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_custom_sonic_order_cast", "abilities/queen_of_pain/custom_queenofpain_sonic_wave", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_custom_sonic_neworder", "abilities/queen_of_pain/custom_queenofpain_sonic_wave", LUA_MODIFIER_MOTION_NONE)




custom_queenofpain_sonic_wave = class({})

custom_queenofpain_sonic_wave.blink_heal = 0.5

custom_queenofpain_sonic_wave.damage_init = 0
custom_queenofpain_sonic_wave.damage_inc = 60

custom_queenofpain_sonic_wave.legendary_creep = 3
custom_queenofpain_sonic_wave.legendary_hero = 30

custom_queenofpain_sonic_wave.fire_duration = 12
custom_queenofpain_sonic_wave.fire_radius = 150
custom_queenofpain_sonic_wave.fire_length = 1300
custom_queenofpain_sonic_wave.fire_interval = 0.5
custom_queenofpain_sonic_wave.fire_damage_init = 0.05
custom_queenofpain_sonic_wave.fire_damage_inc = 0.05

custom_queenofpain_sonic_wave.far_stun = 3

custom_queenofpain_sonic_wave.reduce_init = 0
custom_queenofpain_sonic_wave.reduce_inc = -10
custom_queenofpain_sonic_wave.reduce_duration = 10

custom_queenofpain_sonic_wave.cd_kill = 1
custom_queenofpain_sonic_wave.cd_hero = 2
custom_queenofpain_sonic_wave.cd_max = 30

custom_queenofpain_sonic_wave.taken_duration = 4
custom_queenofpain_sonic_wave.taken_init = 0
custom_queenofpain_sonic_wave.taken_inc = 0.2




function custom_queenofpain_sonic_wave:GetIntrinsicModifierName()
return "modifier_custom_sonic_tracker"
end


function custom_queenofpain_sonic_wave:GetCooldown(iLevel)
local upgrade_cooldown = 0	
local base = self.BaseClass.GetCooldown(self, iLevel)
if self:GetCaster():HasScepter() then base =  self:GetSpecialValueFor("cooldown_scepter") end
upgrade_cooldown = self:GetCaster():GetUpgradeStack("modifier_custom_sonic_kills_cd")
return base - upgrade_cooldown 
end



function custom_queenofpain_sonic_wave:OnAbilityPhaseStart()
	if not IsServer() then return end

	self:GetCaster():EmitSound("Hero_QueenOfPain.SonicWave.Precast")

	return true
end

function custom_queenofpain_sonic_wave:OnAbilityPhaseInterrupted()
	if not IsServer() then return end

	self:GetCaster():StopSound("Hero_QueenOfPain.SonicWave.Precast")
end

function custom_queenofpain_sonic_wave:OnSpellStart()
if not IsServer() then return end
		local caster = self:GetCaster()
		local target_loc = self:GetCursorPosition()
		local caster_loc = caster:GetAbsOrigin()


		local damage = self:GetSpecialValueFor("damage")
		local start_radius = self:GetSpecialValueFor("starting_aoe")
		local end_radius = self:GetSpecialValueFor("final_aoe")
		local travel_distance = self:GetSpecialValueFor("distance")
		local projectile_speed = self:GetSpecialValueFor("speed")

		local direction
		if target_loc == caster_loc then
			direction = caster:GetForwardVector()
		else
			direction = (target_loc - caster_loc):Normalized()
		end

		
		if caster:HasScepter() then
			damage = self:GetSpecialValueFor("damage_scepter")
		end
		
		if self:GetCaster():HasModifier("modifier_custom_sonic_kills") then 
			damage = damage + self:GetCaster():GetUpgradeStack("modifier_custom_sonic_kills")
		end


		if self:GetCaster():HasModifier("modifier_queen_Sonic_damage") then 
			damage = damage + self.damage_init + self.damage_inc*self:GetCaster():GetUpgradeStack("modifier_queen_Sonic_damage")
		end


		caster:EmitSound("Hero_QueenOfPain.SonicWave")


		if self:GetCaster():HasModifier("modifier_custom_blink_spell") then 
			self:GetCaster():AddNewModifier(caster, self, "modifier_custom_sonic_heal", {duration = 3})
			self:GetCaster():RemoveModifierByName("modifier_custom_blink_spell")
		end
	
		local effect = "particles/units/heroes/hero_queenofpain/queen_sonic_wave.vpcf"
		if self:GetCaster():GetModelName() == "models/items/queenofpain/queenofpain_arcana/queenofpain_arcana.vmdl" then 
			effect = "particles/econ/items/queen_of_pain/qop_arcana/qop_arcana_sonic_wave.vpcf"
		end


		projectile =
			{
				Ability				= self,
				EffectName			= effect,
				vSpawnOrigin		= caster_loc,
				fDistance			= travel_distance,
				fStartRadius		= start_radius,
				fEndRadius			= end_radius,
				Source				= caster,
				bHasFrontalCone		= true,
				bReplaceExisting	= false,
				iUnitTargetTeam		= DOTA_UNIT_TARGET_TEAM_ENEMY,
				iUnitTargetFlags	= DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,
				iUnitTargetType		= DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
				fExpireTime 		= GameRules:GetGameTime() + 10.0,
				bDeleteOnHit		= true,
				vVelocity			= Vector(direction.x,direction.y,0) * projectile_speed,
				bProvidesVision		= false,
				ExtraData			= {damage = damage, x = caster_loc.x, y = caster_loc.y, z = caster_loc.z}
			}

		ProjectileManager:CreateLinearProjectile(projectile)

	if caster:HasModifier("modifier_queen_Sonic_fire") then 
		local end_pos = caster:GetAbsOrigin() + caster:GetForwardVector()*self.fire_length	


		local damage_burn = self.fire_damage_init + self.fire_damage_inc*caster:GetUpgradeStack("modifier_queen_Sonic_fire")
		damage_burn = damage*damage_burn*self.fire_interval
			

		 CreateModifierThinker(caster, self, "modifier_custom_sonic_fire_thinker",
	  	{duration = self.fire_duration, damage = damage_burn, end_x = end_pos.x, end_y = end_pos.y,end_z = end_pos.z}, 
	    caster:GetAbsOrigin(), caster:GetTeamNumber(), false)

	end


end

function custom_queenofpain_sonic_wave:OnProjectileHit_ExtraData(target, location, ExtraData)
if not target then return end

		local damage = ExtraData.damage



		if self:GetCaster():HasModifier("modifier_queen_Sonic_taken") then 
			local bonus = 0
			for _,mod in pairs(target:FindAllModifiers()) do
				if mod:GetName() == "modifier_custom_sonic_damage" then 
					bonus = bonus + mod:GetStackCount()
				end	
			end
			local k = self.taken_init + self.taken_inc*self:GetCaster():GetUpgradeStack("modifier_queen_Sonic_taken")
			
			damage = damage + bonus*k
			if bonus > 0 then 
				SendOverheadEventMessage(nil, 6, target, bonus*k, nil)
			end
		end


		

		ApplyDamage({attacker = self:GetCaster(), victim = target, ability = self, damage = damage, damage_type = DAMAGE_TYPE_PURE})
		

		if self:GetCaster():HasModifier("modifier_queen_Sonic_reduce") then 
			target:AddNewModifier(self:GetCaster(), self, "modifier_custom_sonic_reduce", {duration = self.reduce_duration}) 
		end

		if self:GetCaster():HasModifier("modifier_queen_Sonic_far") then 
			local origin = Vector(ExtraData.x, ExtraData.y, ExtraData.z)
			local distance = (origin - target:GetAbsOrigin()):Length2D()
			local stun_duration = (distance / self:GetSpecialValueFor("distance"))*self.far_stun
			target:AddNewModifier(self:GetCaster(), self, "modifier_stunned", {duration = stun_duration*(1 - target:GetStatusResistance())})

		end
	

		local speed = self:GetSpecialValueFor("knockback_distance") / self:GetSpecialValueFor("knockback_duration")

		local duration_knock = self:GetSpecialValueFor("knockback_duration") * (1 - target:GetStatusResistance())

		local distance_knock = speed*duration_knock

		target:AddNewModifier(self:GetCaster(), self, "modifier_generic_motion_controller", 
		{
			distance		= distance_knock,
			direction_x 	= target:GetAbsOrigin().x - ExtraData.x,
			direction_y 	= target:GetAbsOrigin().y - ExtraData.y,
			direction_z 	= target:GetAbsOrigin().z - ExtraData.z,
			duration 		= duration_knock,
			bGroundStop 	= false,
			bDecelerate 	= false,
			bInterruptible 	= false,
			bIgnoreTenacity	= false,
			bDestroyTreesAlongPath	= true
		})
		

end


function custom_queenofpain_sonic_wave:MakeOrder(target, last_order)
if not IsServer() then return end

local random = -1

repeat random = RandomInt(1, 3)
until random ~= last_order 

if random == 1 then 
	target:AddNewModifier(self:GetCaster(), self, "modifier_custom_sonic_order_move", {duration = self.order_duration})
end
if random == 2 then 
	target:AddNewModifier(self:GetCaster(), self, "modifier_custom_sonic_order_attack", {duration = self.order_duration})
end
if random == 3 then 
	target:AddNewModifier(self:GetCaster(), self, "modifier_custom_sonic_order_cast", {duration = self.order_duration})
end

	target:EmitSound("QoP.Sonic_order")

end




modifier_custom_sonic_heal = class({})
function modifier_custom_sonic_heal:IsHidden() return true end
function modifier_custom_sonic_heal:IsPurgable() return false end



modifier_custom_sonic_tracker = class({})
function modifier_custom_sonic_tracker:IsHidden() return true end
function modifier_custom_sonic_tracker:IsPurgable() return false end
function modifier_custom_sonic_tracker:DeclareFunctions()
return
{
	MODIFIER_EVENT_ON_TAKEDAMAGE,
	MODIFIER_EVENT_ON_DEATH
}
end
function modifier_custom_sonic_tracker:OnTakeDamage(params)
if not IsServer() then return end
if params.attacker ~= self:GetParent() then return end

if self:GetParent():HasModifier("modifier_queen_Sonic_taken") then 
	local mod = params.unit:AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_custom_sonic_damage", {duration = self:GetAbility().taken_duration})
	if mod then 
		mod:SetStackCount(params.damage)
	end
end


if not self:GetParent():HasModifier("modifier_custom_sonic_heal") then return end
if params.inflictor ~= self:GetAbility() then return end

local heal = params.damage*self:GetAbility().blink_heal

local particle = ParticleManager:CreateParticle( "particles/huskar_leap_heal.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
     ParticleManager:ReleaseParticleIndex( particle )

 self:GetParent():Heal(heal, self:GetParent())
 SendOverheadEventMessage(self:GetParent(), 10, self:GetParent(), heal, nil)

end




function modifier_custom_sonic_tracker:OnDeath(params)
if not IsServer() then return end
if params.inflictor ~= self:GetAbility() then return end
if params.unit:IsIllusion() then return end


if self:GetParent():HasModifier("modifier_queen_Sonic_legendary") then 

	local damage = self:GetAbility().legendary_creep
	if params.unit:IsRealHero() then damage = self:GetAbility().legendary_hero end

	local mod = self:GetParent():FindModifierByName("modifier_custom_sonic_kills")

	if not mod then 
		mod = self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_custom_sonic_kills", {})
	end

	mod:SetStackCount(mod:GetStackCount() + damage)
end

if  self:GetParent():HasModifier("modifier_queen_Sonic_cd") then 

	if self:GetAbility():GetCooldownTimeRemaining() > 0 then 
		local cd = self:GetAbility():GetCooldownTimeRemaining()
		self:GetAbility():EndCooldown()
		if cd > self:GetAbility().cd_kill then 
			self:GetAbility():StartCooldown(cd - self:GetAbility().cd_kill)
		end
	end

	if params.unit:IsRealHero() then 

		local mod_cd = self:GetParent():FindModifierByName("modifier_custom_sonic_kills_cd")

		if not mod_cd then 
			mod_cd = self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_custom_sonic_kills_cd", {})
		end

		if mod_cd:GetStackCount() < self:GetAbility().cd_max then 
			mod_cd:SetStackCount(mod_cd:GetStackCount() + self:GetAbility().cd_hero)
		end
	end

end

end



modifier_custom_sonic_kills = class({})
function modifier_custom_sonic_kills:IsHidden() return false end
function modifier_custom_sonic_kills:IsPurgable() return false end
function modifier_custom_sonic_kills:RemoveOnDeath() return false end
function modifier_custom_sonic_kills:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_TOOLTIP
}
end
function modifier_custom_sonic_kills:OnTooltip() return self:GetStackCount() end




modifier_custom_sonic_fire_thinker = class({})

function modifier_custom_sonic_fire_thinker:IsHidden() return true end

function modifier_custom_sonic_fire_thinker:IsPurgable() return false end


function modifier_custom_sonic_fire_thinker:OnCreated(table)
if not IsServer() then return end
			
	self.start_pos = self:GetParent():GetAbsOrigin()
	self.end_pos = Vector(table.end_x,table.end_y,table.end_z)
	self.damage = table.damage

	self:GetParent():EmitSound("QoP.Sonic_fire")



	self.pfx = ParticleManager:CreateParticle("particles/qop_sonic_fire.vpcf", PATTACH_WORLDORIGIN, nil)
    ParticleManager:SetParticleControl(self.pfx, 0, self.start_pos)
    ParticleManager:SetParticleControl(self.pfx, 2, Vector(self:GetAbility().fire_duration, 0, 0))
    ParticleManager:SetParticleControl(self.pfx, 1, self.end_pos)
    ParticleManager:SetParticleControl(self.pfx, 3, self.end_pos)
     ParticleManager:ReleaseParticleIndex(self.pfx)
 	self:AddParticle(self.pfx,false,false,-1,false,false)

self:StartIntervalThink(self:GetAbility().fire_interval)
self:OnIntervalThink()
end

function modifier_custom_sonic_fire_thinker:OnDestroy()
if not IsServer() then return end
self:GetParent():StopSound("QoP.Sonic_fire")

end


function modifier_custom_sonic_fire_thinker:OnIntervalThink()
if not IsServer() then return end

local enemies = FindUnitsInLine(self:GetParent():GetTeamNumber(), self.start_pos,self.end_pos, nil, self:GetAbility().fire_radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO,DOTA_UNIT_TARGET_FLAG_NONE)

for _,enemy in ipairs(enemies) do 
	if not enemy:IsMagicImmune() then 
		ApplyDamage({attacker = self:GetAbility():GetCaster(), victim = enemy, ability = self:GetAbility(), damage = self.damage, damage_type = DAMAGE_TYPE_MAGICAL})
		SendOverheadEventMessage(enemy, 4, enemy, self.damage, nil)
	end
end

end




modifier_custom_sonic_reduce = class({})

function modifier_custom_sonic_reduce:IsHidden() return false end
function modifier_custom_sonic_reduce:IsPurgable() return false end
function modifier_custom_sonic_reduce:GetTexture() return "buffs/sonic_reduce" end
function modifier_custom_sonic_reduce:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE
}

end

function modifier_custom_sonic_reduce:GetModifierTotalDamageOutgoing_Percentage() return 
self:GetAbility().reduce_init + self:GetAbility().reduce_inc*self:GetCaster():GetUpgradeStack("modifier_queen_Sonic_reduce")
end



modifier_custom_sonic_kills_cd = class({})
function modifier_custom_sonic_kills_cd:IsHidden() return false end
function modifier_custom_sonic_kills_cd:IsPurgable() return false end
function modifier_custom_sonic_kills_cd:RemoveOnDeath() return false end
function modifier_custom_sonic_kills_cd:GetTexture() return "buffs/sonic_cd" end
function modifier_custom_sonic_kills_cd:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_TOOLTIP
}

end
function modifier_custom_sonic_kills_cd:OnTooltip() return self:GetStackCount() end




modifier_custom_sonic_damage = class({})
function modifier_custom_sonic_damage:IsHidden() return true end
function modifier_custom_sonic_damage:IsPurgable() return true end
function modifier_custom_sonic_damage:IsDebuff() return true end
function modifier_custom_sonic_damage:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end
function modifier_custom_sonic_damage:RemoveOnDeath() return false end



modifier_custom_sonic_order_cast = class({})
function modifier_custom_sonic_order_cast:IsHidden() return false end
function modifier_custom_sonic_order_cast:IsPurgable() return false end
function modifier_custom_sonic_order_cast:GetEffectName() return "particles/econ/items/silencer/silencer_ti6/silencer_last_word_ti6_silence.vpcf" end
function modifier_custom_sonic_order_cast:GetEffectAttachType() return PATTACH_OVERHEAD_FOLLOW end

function modifier_custom_sonic_order_cast:GetTexture() return "buffs/sonic_cast" end

function modifier_custom_sonic_order_cast:OnCreated(table)
if not IsServer() then return end
self.RemoveForDuel = true
	self.comlete = false
self:StartIntervalThink(1)

end
function modifier_custom_sonic_order_cast:OnIntervalThink()
if not IsServer() then return end
		if self:GetParent():IsRealHero() then 
		self:GetParent():EmitSound("QoP.Sonic_timer")
	end
end

function modifier_custom_sonic_order_cast:DeclareFunctions()
return
{
	MODIFIER_EVENT_ON_ABILITY_FULLY_CAST
}
end
function modifier_custom_sonic_order_cast:OnAbilityFullyCast(params)
if self:GetParent() ~= params.unit then return end
if params.ability:IsItem() then return end
	self.comlete = true
	self:Destroy()
end

function modifier_custom_sonic_order_cast:OnDestroy()
if not IsServer() then return end
if not self:GetParent():IsAlive() then return end
if self:GetParent():HasModifier("modifier_final_duel_start") then return end
if self.comlete == true then return end
	local stun = self:GetAbility().order_stun*(1 - self:GetParent():GetStatusResistance())
  
	self:GetParent():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_stunned", {duration = stun})
	self:GetParent():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_custom_sonic_neworder", {duration = stun, last_order = 3})

end

modifier_custom_sonic_order_move = class({})
function modifier_custom_sonic_order_move:IsHidden() return false end
function modifier_custom_sonic_order_move:IsPurgable() return false end
function modifier_custom_sonic_order_move:GetEffectName() return "particles/units/heroes/hero_centaur/centaur_stampede_overhead.vpcf" end
function modifier_custom_sonic_order_move:GetEffectAttachType() return PATTACH_OVERHEAD_FOLLOW end

function modifier_custom_sonic_order_move:GetTexture() return "buffs/sonic_move" end

function modifier_custom_sonic_order_move:OnCreated(table)
if not IsServer() then return end
self.RemoveForDuel = true
self:SetStackCount(self:GetAbility().order_distance)
self.comlete = false 
self.old = self:GetParent():GetAbsOrigin()
self:StartIntervalThink(1)

end
function modifier_custom_sonic_order_move:OnIntervalThink()
if not IsServer() then return end
	if self:GetParent():IsRealHero() then 
		self:GetParent():EmitSound("QoP.Sonic_timer")
end
end

function modifier_custom_sonic_order_move:DeclareFunctions()
return
{
	MODIFIER_EVENT_ON_UNIT_MOVED
}

end

function modifier_custom_sonic_order_move:OnUnitMoved(params)
if not IsServer() then return end
if params.unit ~= self:GetParent() then return end

if self.old == params.new_pos then return end

local distance = (self.old - params.new_pos):Length2D()

self.old = params.new_pos

if self:GetParent():HasModifier("modifier_generic_motion_controller") then return end

if self:GetStackCount() > distance then 
	self:SetStackCount(self:GetStackCount() - distance)	
else 
	self.comlete = true
	self:Destroy()
end

end

function modifier_custom_sonic_order_move:OnDestroy()
if not IsServer() then return end
if not self:GetParent():IsAlive() then return end
if self:GetParent():HasModifier("modifier_final_duel_start") then return end
if self.comlete == true then return end
	local stun = self:GetAbility().order_stun*(1 - self:GetParent():GetStatusResistance())
  
	self:GetParent():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_stunned", {duration = stun})
	self:GetParent():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_custom_sonic_neworder", {duration = stun, last_order = 1})

end



modifier_custom_sonic_order_attack = class({})
function modifier_custom_sonic_order_attack:IsHidden() return false end
function modifier_custom_sonic_order_attack:IsPurgable() return false end

function modifier_custom_sonic_order_attack:GetEffectName() return "particles/qop_order_attack.vpcf" end
function modifier_custom_sonic_order_attack:GetEffectAttachType() return PATTACH_OVERHEAD_FOLLOW end

function modifier_custom_sonic_order_attack:GetTexture() return "buffs/sonic_attack" end

function modifier_custom_sonic_order_attack:OnCreated(table)
if not IsServer() then return end
self.RemoveForDuel = true
local damage = self:GetCaster():GetMaxHealth()*self:GetAbility().order_damage
self:SetStackCount(damage)
self.comlete = false 
self:StartIntervalThink(1)

end
function modifier_custom_sonic_order_attack:OnIntervalThink()
if not IsServer() then return end
		if self:GetParent():IsRealHero() then 
		self:GetParent():EmitSound("QoP.Sonic_timer")
	end
end


function modifier_custom_sonic_order_attack:DeclareFunctions()
return
{
	MODIFIER_EVENT_ON_TAKEDAMAGE
}

end

function modifier_custom_sonic_order_attack:OnTakeDamage(params)
if not IsServer() then return end
if params.unit ~= self:GetCaster() then return end
if params.attacker ~= self:GetParent() then return end

local distance = params.damage

if self:GetStackCount() > distance then 
	self:SetStackCount(self:GetStackCount() - distance)	
else 
	self.comlete = true
	self:Destroy()
end

end

function modifier_custom_sonic_order_attack:OnDestroy()
if not IsServer() then return end
if not self:GetParent():IsAlive() then return end
if self:GetParent():HasModifier("modifier_final_duel_start") then return end
if self.comlete == true then return end
	local stun = self:GetAbility().order_stun*(1 - self:GetParent():GetStatusResistance())
  
	self:GetParent():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_stunned", {duration = stun})
	self:GetParent():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_custom_sonic_neworder", {duration = stun, last_order = 2})

end






modifier_custom_sonic_neworder = class({})
function modifier_custom_sonic_neworder:IsHidden() return true end
function modifier_custom_sonic_neworder:IsPurgable() return false end
function modifier_custom_sonic_neworder:OnCreated(table)
if not IsServer() then return end
 	self.RemoveForDuel = true
	self:GetParent():EmitSound("QoP.Sonic_stun")
	self.last_order = table.last_order
end

function modifier_custom_sonic_neworder:OnDestroy()
if not IsServer() then return end
if not self:GetParent():IsAlive() then return end
	self:GetAbility():MakeOrder(self:GetParent() , self.last_order)
end