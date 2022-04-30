LinkLuaModifier("modifier_custom_puck_dream_coil", "abilities/puck/custom_puck_dream_coil", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_custom_puck_dream_coil_thinker", "abilities/puck/custom_puck_dream_coil", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_custom_puck_dream_coil_resist", "abilities/puck/custom_puck_dream_coil", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_custom_puck_dream_coil_legendary", "abilities/puck/custom_puck_dream_coil", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_custom_puck_dream_coil_cooldowns", "abilities/puck/custom_puck_dream_coil", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_custom_puck_dream_coil_knockback", "abilities/puck/custom_puck_dream_coil", LUA_MODIFIER_MOTION_HORIZONTAL)
LinkLuaModifier("modifier_custom_puck_dream_coil_knockback_legendary", "abilities/puck/custom_puck_dream_coil", LUA_MODIFIER_MOTION_HORIZONTAL)
LinkLuaModifier("modifier_custom_puck_dream_coil_cd", "abilities/puck/custom_puck_dream_coil", LUA_MODIFIER_MOTION_NONE)

custom_puck_dream_coil = class({})

custom_puck_dream_coil.cd_init = 10
custom_puck_dream_coil.cd_inc = 10

custom_puck_dream_coil.resist_armor_init = -0.5
custom_puck_dream_coil.resist_armor_inc = -0.5
custom_puck_dream_coil.resist_magic_init = -1
custom_puck_dream_coil.resist_magic_inc = -1
custom_puck_dream_coil.resist_duration = 4
custom_puck_dream_coil.resist_interval = 1

custom_puck_dream_coil.legendary_radius = 100
custom_puck_dream_coil.legendary_knockback_distance = 200
custom_puck_dream_coil.legendary_knockback_duration = 0.3

custom_puck_dream_coil.attacks_delay = 1
custom_puck_dream_coil.attacks_radius = 800

custom_puck_dream_coil.cooldowns_damage = -25

custom_puck_dream_coil.knockback_duration = 0.3
custom_puck_dream_coil.knockback_radius = 600
custom_puck_dream_coil.knockback_distance = 100
custom_puck_dream_coil.knockback_interval_init = 4
custom_puck_dream_coil.knockback_interval_inc = -1
custom_puck_dream_coil.knockback_damage = 1.5

custom_puck_dream_coil.duration_init = 0.5
custom_puck_dream_coil.duration_inc = 0.5


function custom_puck_dream_coil:GetCooldown(iLevel)

local upgrade_cooldown = 0
if self:GetCaster():HasModifier("modifier_puck_coil_cd") then 
 upgrade_cooldown = self.cd_init + self.cd_inc*self:GetCaster():GetUpgradeStack("modifier_puck_coil_cd")
end


 return self.BaseClass.GetCooldown(self, iLevel) - upgrade_cooldown
 
end




function custom_puck_dream_coil:GetAOERadius()
	return self:GetSpecialValueFor("coil_radius")
end

function custom_puck_dream_coil:OnSpellStart()
	
	if self:GetCaster():GetName() == "npc_dota_hero_puck" then
		self:GetCaster():EmitSound("puck_puck_ability_dreamcoil_0"..RandomInt(1, 2))
	end
	
	local target_flag		= DOTA_UNIT_TARGET_FLAG_NONE
	local latch_duration	= self:GetSpecialValueFor("coil_duration")
	
	if self:GetCaster():HasScepter() then
		target_flag		= DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES
		latch_duration	= self:GetSpecialValueFor("coil_duration_scepter")
	end
	
	if self:GetCaster():HasModifier("modifier_puck_coil_duration") then 
		latch_duration = latch_duration + self.duration_init + self.duration_inc*self:GetCaster():GetUpgradeStack("modifier_puck_coil_duration")
	end
	
	-- Create thinker for...I guess just the particle effects?
	local coil_thinker = CreateModifierThinker(
		self:GetCaster(),
		self,
		"modifier_custom_puck_dream_coil_thinker",
		{duration = latch_duration},
		self:GetCursorPosition(),
		self:GetCaster():GetTeamNumber(),
		false
	)
	
	local target_type = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
	 	
	local enemies = FindUnitsInRadius(self:GetCaster():GetTeamNumber(), self:GetCursorPosition(), nil, self:GetSpecialValueFor("coil_radius"), DOTA_UNIT_TARGET_TEAM_ENEMY, target_type, target_flag, FIND_ANY_ORDER, false)

	for _, enemy in pairs(enemies) do
	   if not enemy:IsIllusion() then 
		ApplyDamage({
			victim 			= enemy,
			damage 			= self:GetSpecialValueFor("coil_initial_damage"),
			damage_type		= self:GetAbilityDamageType(),
			damage_flags 	= DOTA_DAMAGE_FLAG_NONE,
			attacker 		= self:GetCaster(),
			ability 		= self
		})
	


		local coil_modifier = enemy:AddNewModifier(self:GetCaster(), self, "modifier_custom_puck_dream_coil", 
		{
			duration		= latch_duration*(1 - enemy:GetStatusResistance()),
			coil_thinker	= coil_thinker:entindex()
		})
	  end
	end

end

-------------------------
-- DREAM COIL MODIFIER --
-------------------------

modifier_custom_puck_dream_coil = class({})

function modifier_custom_puck_dream_coil:IsPurgable()		return false end
function modifier_custom_puck_dream_coil:GetAttributes()	return MODIFIER_ATTRIBUTE_MULTIPLE end

function modifier_custom_puck_dream_coil:OnDestroy()
if not IsServer() then return end
	if self:GetParent():HasModifier("modifier_custom_puck_dream_coil_cooldowns") then 
		self:GetParent():RemoveModifierByName("modifier_custom_puck_dream_coil_cooldowns")
	end

end



function modifier_custom_puck_dream_coil:OnCreated(params)
	self.coil_break_radius			= self:GetAbility():GetSpecialValueFor("coil_break_radius")
	self.coil_stun_duration			= self:GetAbility():GetSpecialValueFor("coil_stun_duration")
	self.coil_break_damage			= self:GetAbility():GetSpecialValueFor("coil_break_damage")
	self.coil_break_damage_scepter	= self:GetAbility():GetSpecialValueFor("coil_break_damage_scepter")
	self.coil_stun_duration_scepter	= self:GetAbility():GetSpecialValueFor("coil_stun_duration_scepter")


	
	self.RemoveForDuel = true

	self.rapid_fire_interval		= self:GetAbility().attacks_delay
	self.rapid_fire_max_distance	= self:GetAbility().attacks_radius

	if not IsServer() then return end

	if self:GetCaster():HasModifier("modifier_puck_coil_legendary") then 
		self.coil_break_radius = self.coil_break_radius - self:GetAbility().legendary_radius
	end

	if self:GetCaster():HasModifier("modifier_puck_coil_resist") then
		self:GetParent():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_custom_puck_dream_coil_resist", {duration = self:GetAbility().resist_duration})
	end

	if self:GetCaster():HasModifier("modifier_puck_coil_cooldowns") then 
		self:GetParent():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_custom_puck_dream_coil_cooldowns", {})
	end

	
	self.ability_damage_type		= self:GetAbility():GetAbilityDamageType()
	self.coil_thinker				= EntIndexToHScript(params.coil_thinker)
	self.coil_thinker_location		= self.coil_thinker:GetAbsOrigin()

	local effect_cast = ParticleManager:CreateParticle( "particles/units/heroes/hero_puck/puck_dreamcoil_tether.vpcf", PATTACH_ABSORIGIN, self.coil_thinker )
    ParticleManager:SetParticleControl( effect_cast, 0, self.coil_thinker_location )
    ParticleManager:SetParticleControlEnt(effect_cast,1,self:GetParent(),PATTACH_POINT_FOLLOW,"attach_hitloc",self:GetParent():GetOrigin(),true)
    self:AddParticle(effect_cast,false,false,-1,false,false)


	
	self.interval 	= 0.1
	self.counter	= 0
	
	self:StartIntervalThink(self.interval)
end



function modifier_custom_puck_dream_coil:OnIntervalThink()
	if not IsServer() then return end
	
	self.counter = self.counter + self.interval

	if self:GetParent():IsMagicImmune() and not self:GetCaster():HasScepter() then
		self:Destroy()
		return
	end

	if self:GetCaster():IsAlive() and self.counter >= self.rapid_fire_interval and self:GetAbility() and self:GetCaster():HasModifier("modifier_puck_coil_attacks") then
		
		self.counter = 0

		if (self:GetCaster():GetAbsOrigin() - self.coil_thinker_location):Length2D() <= self.rapid_fire_max_distance and not self:GetParent():IsAttackImmune() then
			self:GetCaster():PerformAttack(self:GetParent(), true, true, true, false, true, false, false)
		end
	end
	


	

	if (self:GetParent():GetAbsOrigin() - self.coil_thinker_location):Length2D() >= self.coil_break_radius and not self:GetParent():HasModifier("modifier_custom_puck_dream_coil_cd") then
		self:GetParent():EmitSound("Hero_Puck.Dream_Coil_Snap")
		
		-- Check for scepter 
		local stun_duration	= self.coil_stun_duration
		local break_damage	= self.coil_break_damage
		
		if self:GetCaster():HasScepter() then
			stun_duration	= self.coil_stun_duration_scepter
			break_damage	= self.coil_break_damage_scepter
		end

		local damageTable = {
			victim 			= self:GetParent(),
			damage 			= break_damage,
			damage_type		= self.ability_damage_type,
			damage_flags 	= DOTA_DAMAGE_FLAG_NONE,
			attacker 		= self:GetCaster(),
			ability 		= self:GetAbility()
		}

		ApplyDamage(damageTable)
		
	
		local stun_modifier = self:GetParent():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_stunned", {duration = stun_duration * (1 - self:GetParent():GetStatusResistance())})
		
		if self:GetCaster():HasModifier("modifier_puck_coil_legendary") and not self:GetParent():HasModifier("modifier_custom_puck_dream_coil_legendary") then 
		
			self:GetParent():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_custom_puck_dream_coil_knockback_legendary", {duration = self:GetAbility().legendary_knockback_duration, x = self.coil_thinker_location.x, y = self.coil_thinker_location.y})

			self:GetParent():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_custom_puck_dream_coil_cd", {duration = 0.3})
		else 
			self:Destroy()
		end
	end
end

function modifier_custom_puck_dream_coil:CheckState()
	return {[MODIFIER_STATE_TETHERED] = true}
end

---------------------------------
-- DREAM COIL THINKER MODIFIER --
---------------------------------

modifier_custom_puck_dream_coil_thinker = class({})

function modifier_custom_puck_dream_coil_thinker:OnCreated()
	if not IsServer() then return end
	self:GetParent():EmitSound("Hero_Puck.Dream_Coil")

	self.pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_puck/puck_dreamcoil.vpcf", PATTACH_WORLDORIGIN, nil)
	ParticleManager:SetParticleControl(self.pfx, 0, self:GetParent():GetAbsOrigin())

	if not self:GetCaster():HasModifier("modifier_puck_coil_magic") then return end


	local interval = self:GetAbility().knockback_interval_init + self:GetAbility().knockback_interval_inc*self:GetCaster():GetUpgradeStack("modifier_puck_coil_magic")

	self:StartIntervalThink(interval) 
	self:OnIntervalThink()			
end

function modifier_custom_puck_dream_coil_thinker:OnIntervalThink()
if not IsServer() then return end
local target_type = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
	 	
local enemies = FindUnitsInRadius(self:GetCaster():GetTeamNumber(), self:GetParent():GetAbsOrigin(), nil, self:GetAbility().knockback_radius, DOTA_UNIT_TARGET_TEAM_ENEMY, target_type, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
local damage = self:GetAbility().knockback_damage*self:GetCaster():GetIntellect()

self:GetParent():EmitSound("Puck.Coil_Wave")
local particle = ParticleManager:CreateParticle("particles/puck_magic.vpcf", PATTACH_WORLDORIGIN, nil)
ParticleManager:SetParticleControl(particle, 0, self:GetParent():GetAbsOrigin())
ParticleManager:SetParticleControl(particle, 1, self:GetParent():GetAbsOrigin())
ParticleManager:SetParticleControl(particle, 2, Vector(self:GetAbility().knockback_radius, 0, 0))
ParticleManager:ReleaseParticleIndex(particle)

for _, enemy in pairs(enemies) do

    local damageTable = {
      victim      = enemy,
      damage      = damage,
      damage_type   = DAMAGE_TYPE_MAGICAL,
      damage_flags  = DOTA_DAMAGE_FLAG_NONE,
      attacker    = self:GetCaster(),
      ability     = self:GetAbility()
    }

    ApplyDamage(damageTable)


    SendOverheadEventMessage(enemy, 4, enemy, damage, nil)
	enemy:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_custom_puck_dream_coil_knockback", {duration = self:GetAbility().knockback_duration * (1 - enemy:GetStatusResistance()), x = self:GetParent():GetAbsOrigin().x, y = self:GetParent():GetAbsOrigin().y})
end

end




function modifier_custom_puck_dream_coil_thinker:OnDestroy()
	if not IsServer() then return end

	if self.pfx then
		ParticleManager:DestroyParticle(self.pfx, false)
		ParticleManager:ReleaseParticleIndex(self.pfx)
	end
	self:GetParent():StopSound("Hero_Puck.Dream_Coil")
	self:GetParent():RemoveSelf()
end




modifier_custom_puck_dream_coil_resist = class({})
function modifier_custom_puck_dream_coil_resist:IsHidden() 
return self:GetStackCount() < 1 end
function modifier_custom_puck_dream_coil_resist:IsPurgable() return false end
function modifier_custom_puck_dream_coil_resist:GetTexture() return "buffs/coil_resist" end
function modifier_custom_puck_dream_coil_resist:OnCreated(table)
if not IsServer() then return end
	self:SetStackCount(0)
	self.RemoveForDuel = true
	self:StartIntervalThink(self:GetAbility().resist_interval)
end


function modifier_custom_puck_dream_coil_resist:OnIntervalThink()
if not IsServer() then return end
if not self:GetParent():HasModifier("modifier_custom_puck_dream_coil") then return end
	self:GetParent():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_custom_puck_dream_coil_resist", {duration = self:GetAbility().resist_duration})
end

function modifier_custom_puck_dream_coil_resist:OnRefresh(table)
if not IsServer() then return end
	self:IncrementStackCount()
end

function modifier_custom_puck_dream_coil_resist:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
	MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS
}
end

function modifier_custom_puck_dream_coil_resist:GetModifierPhysicalArmorBonus() 
return (self:GetAbility().resist_armor_init + self:GetAbility().resist_armor_inc*self:GetCaster():GetUpgradeStack("modifier_puck_coil_resist"))*self:GetStackCount()
end

function modifier_custom_puck_dream_coil_resist:GetModifierMagicalResistanceBonus()
return (self:GetAbility().resist_magic_init + self:GetAbility().resist_magic_inc*self:GetCaster():GetUpgradeStack("modifier_puck_coil_resist"))*self:GetStackCount()
end



modifier_custom_puck_dream_coil_legendary = class({})
function modifier_custom_puck_dream_coil_legendary:IsHidden() return true end
function modifier_custom_puck_dream_coil_legendary:IsPurgable() return false end
function modifier_custom_puck_dream_coil_legendary:OnCreated(table)
if not IsServer() then return end
self.RemoveForDuel = true
self.duration = table.left_time

self.t = -1
self.timer = self:GetRemainingTime()*2
self:StartIntervalThink(0.5)
self:OnIntervalThink()
end


function modifier_custom_puck_dream_coil_legendary:OnDestroy()
if not IsServer() then return end
if not self:GetParent():IsAlive() then return end
if self:GetParent():IsMagicImmune() and not self:GetCaster():HasScepter() then return end
	self.location = self:GetParent():GetAbsOrigin() + RandomVector(RandomInt(-1, 1) + 200 )



	-- Create thinker for...I guess just the particle effects?
	local coil_thinker = CreateModifierThinker(
		self:GetCaster(),
		self:GetAbility(),
		"modifier_custom_puck_dream_coil_thinker",
		{duration = self.duration},
		self.location,
		self:GetCaster():GetTeamNumber(),
		false
	)
	
		ApplyDamage({
			victim 			= self:GetParent(),
			damage 			= self:GetAbility():GetSpecialValueFor("coil_initial_damage"),
			damage_type		= self:GetAbility():GetAbilityDamageType(),
			damage_flags 	= DOTA_DAMAGE_FLAG_NONE,
			attacker 		= self:GetCaster(),
			ability 		= self
		})
		

		local coil_modifier = self:GetParent():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_custom_puck_dream_coil", 
		{
			duration		= self.duration*(1 - self:GetParent():GetStatusResistance()),
			coil_thinker	= coil_thinker:entindex()
		})
end



function modifier_custom_puck_dream_coil_legendary:OnIntervalThink()
if not IsServer() then return end
  self.t = self.t + 1
  local caster = self:GetParent()

        local number = (self.timer-self.t)/2 
        local int = 0
        int = number
       if number % 1 ~= 0 then int = number - 0.5  end

        local digits = math.floor(math.log10(number)) + 2

        local decimal = number % 1

        if decimal == 0.5 then
            decimal = 8
        else 
            decimal = 1
        end

local particleName = "particles/huskar_timer.vpcf"
local particle = ParticleManager:CreateParticle(particleName, PATTACH_OVERHEAD_FOLLOW, caster)
ParticleManager:SetParticleControl(particle, 0, caster:GetAbsOrigin())
ParticleManager:SetParticleControl(particle, 1, Vector(0, int, decimal))
ParticleManager:SetParticleControl(particle, 2, Vector(digits, 0, 0))
ParticleManager:ReleaseParticleIndex(particle)

end




modifier_custom_puck_dream_coil_cooldowns = class({})
function modifier_custom_puck_dream_coil_cooldowns:IsHidden() return true end
function modifier_custom_puck_dream_coil_cooldowns:IsPurgable() return false end
function modifier_custom_puck_dream_coil_cooldowns:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE
}

end

function modifier_custom_puck_dream_coil_cooldowns:GetModifierTotalDamageOutgoing_Percentage() return 
self:GetAbility().cooldowns_damage
end


function modifier_custom_puck_dream_coil_cooldowns:OnCreated(table)
if not IsServer() then return end

self.cds = {}

for i = 0,self:GetParent():GetAbilityCount()-1 do
   local a = self:GetParent():GetAbilityByIndex(i)
   
   if not a or a:GetName() == "ability_capture" then break end

   if a:GetCooldownTimeRemaining() > 0 then 
   	 self.cds[i] = a:GetCooldownTimeRemaining()
   end

end


self:StartIntervalThink(0.1)
end

function modifier_custom_puck_dream_coil_cooldowns:OnIntervalThink()
if not IsServer() then return end 

for i = 0,self:GetParent():GetAbilityCount()-1 do
   local a = self:GetParent():GetAbilityByIndex(i)
   
   if not a or a:GetName() == "ability_capture" then break end

   if a:GetCooldownTimeRemaining() > 0 then 

   	if self.cds[i] == nil then 
   		self.cds[i] = a:GetCooldownTimeRemaining()
   	end
   	  a:EndCooldown()
   	  a:StartCooldown(self.cds[i])
   end

end
      
	
end







modifier_custom_puck_dream_coil_knockback = class({})

function modifier_custom_puck_dream_coil_knockback:IsHidden() return true end

function modifier_custom_puck_dream_coil_knockback:OnCreated(params)
  if not IsServer() then return end
  
  self.ability        = self:GetAbility()
  self.caster         = self:GetCaster()
  self.parent         = self:GetParent()
  self:GetParent():StartGesture(ACT_DOTA_FLAIL)
  
  self.knockback_duration   = self.ability.knockback_duration

  --self.knockback_distance   = math.max(self.ability.knockback_distance - (self.caster:GetAbsOrigin() - self.parent:GetAbsOrigin()):Length2D(), 50)
  
  self.knockback_distance = self.ability.knockback_distance

  self.knockback_speed    = self.knockback_distance / self.knockback_duration
  
  self.position = GetGroundPosition(Vector(params.x, params.y, 0), nil)
  
  if self:ApplyHorizontalMotionController() == false then 
    self:Destroy()
    return
  end
end

function modifier_custom_puck_dream_coil_knockback:UpdateHorizontalMotion( me, dt )
  if not IsServer() then return end

  local distance = (me:GetOrigin() - self.position):Normalized()
  
  me:SetOrigin( me:GetOrigin() + distance * self.knockback_speed * dt )

  GridNav:DestroyTreesAroundPoint( self.parent:GetOrigin(), self.parent:GetHullRadius(), true )
end

function modifier_custom_puck_dream_coil_knockback:DeclareFunctions()
  local decFuncs = {
    MODIFIER_PROPERTY_OVERRIDE_ANIMATION
    }

    return decFuncs
end

function modifier_custom_puck_dream_coil_knockback:GetOverrideAnimation()
   return ACT_DOTA_FLAIL
end


function modifier_custom_puck_dream_coil_knockback:OnDestroy()
  if not IsServer() then return end
 self.parent:RemoveHorizontalMotionController( self )
  self:GetParent():FadeGesture(ACT_DOTA_FLAIL)
end





modifier_custom_puck_dream_coil_knockback_legendary = class({})

function modifier_custom_puck_dream_coil_knockback_legendary:IsHidden() return true end

function modifier_custom_puck_dream_coil_knockback_legendary:OnCreated(params)
  if not IsServer() then return end
  
  self.ability        = self:GetAbility()
  self.caster         = self:GetCaster()
  self.parent         = self:GetParent()
  self:GetParent():StartGesture(ACT_DOTA_FLAIL)
  
  self.knockback_duration   = self.ability.legendary_knockback_duration

  --self.knockback_distance   = math.max(self.ability.knockback_distance - (self.caster:GetAbsOrigin() - self.parent:GetAbsOrigin()):Length2D(), 50)
  
  self.knockback_distance = self.ability.legendary_knockback_distance

  self.knockback_speed    = self.knockback_distance / self.knockback_duration
  
  self.position = GetGroundPosition(Vector(params.x, params.y, 0), nil)
  
  if self:ApplyHorizontalMotionController() == false then 
    self:Destroy()
    return
  end
end

function modifier_custom_puck_dream_coil_knockback_legendary:UpdateHorizontalMotion( me, dt )
  if not IsServer() then return end

  local distance = (self.position - me:GetOrigin()):Normalized()
  
  me:SetOrigin( me:GetOrigin() + distance * self.knockback_speed * dt )

  GridNav:DestroyTreesAroundPoint( self.parent:GetOrigin(), self.parent:GetHullRadius(), true )
end

function modifier_custom_puck_dream_coil_knockback_legendary:DeclareFunctions()
  local decFuncs = {
    MODIFIER_PROPERTY_OVERRIDE_ANIMATION
    }

    return decFuncs
end

function modifier_custom_puck_dream_coil_knockback_legendary:GetOverrideAnimation()
   return ACT_DOTA_FLAIL
end


function modifier_custom_puck_dream_coil_knockback_legendary:OnDestroy()
  if not IsServer() then return end
 self.parent:RemoveHorizontalMotionController( self )
  self:GetParent():FadeGesture(ACT_DOTA_FLAIL)
end


modifier_custom_puck_dream_coil_cd = class({})
function modifier_custom_puck_dream_coil_cd:IsHidden() return true end
function modifier_custom_puck_dream_coil_cd:IsPurgable() return false end