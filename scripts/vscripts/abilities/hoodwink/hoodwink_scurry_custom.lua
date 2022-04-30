LinkLuaModifier( "modifier_hoodwink_scurry_custom", "abilities/hoodwink/hoodwink_scurry_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_hoodwink_scurry_custom_buff", "abilities/hoodwink/hoodwink_scurry_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_hoodwink_scurry_custom_legendary", "abilities/hoodwink/hoodwink_scurry_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_hoodwink_scurry_custom_legendary_timer", "abilities/hoodwink/hoodwink_scurry_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_hoodwink_scurry_custom_vision", "abilities/hoodwink/hoodwink_scurry_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_hoodwink_scurry_custom_vision_timer", "abilities/hoodwink/hoodwink_scurry_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_hoodwink_scurry_custom_knock", "abilities/hoodwink/hoodwink_scurry_custom", LUA_MODIFIER_MOTION_HORIZONTAL )

hoodwink_scurry_custom = class({})

hoodwink_scurry_custom.evasion_init = 5
hoodwink_scurry_custom.evasion_inc = 5

hoodwink_scurry_custom.regen_init = 1
hoodwink_scurry_custom.regen_inc = 1

hoodwink_scurry_custom.speed_init = 20
hoodwink_scurry_custom.speed_inc = 20

hoodwink_scurry_custom.legendary_bva = 1.2
hoodwink_scurry_custom.legendary_range = 300
hoodwink_scurry_custom.legendary_duration = 2
hoodwink_scurry_custom.legendary_max = 6
hoodwink_scurry_custom.legendary_distance = 166

hoodwink_scurry_custom.duration_init = 1
hoodwink_scurry_custom.duration_hit = 0.3

hoodwink_scurry_custom.attacks_duration = 0.15
hoodwink_scurry_custom.attacks_knockback = 40
hoodwink_scurry_custom.attacks_chance_init = 10
hoodwink_scurry_custom.attacks_chance_inc = 20
hoodwink_scurry_custom.attacks_damage = 0.4

hoodwink_scurry_custom.vision_timer = 3
hoodwink_scurry_custom.vision_agility = 20

function hoodwink_scurry_custom:GetIntrinsicModifierName()
	return "modifier_hoodwink_scurry_custom"
end

function hoodwink_scurry_custom:CastFilterResult()
	if self:GetCaster():HasModifier( "modifier_hoodwink_scurry_custom_buff" ) then
		return UF_FAIL_CUSTOM
	end

	return UF_SUCCESS
end

function hoodwink_scurry_custom:GetCustomCastError()
	if self:GetCaster():HasModifier( "modifier_hoodwink_scurry_custom_buff" ) then
		return "#dota_hud_error_hoodwink_already_scurrying"
	end

	return ""
end

function hoodwink_scurry_custom:OnSpellStart()
	if not IsServer() then return end
	local duration = self:GetSpecialValueFor( "duration" )

	if self:GetCaster():HasModifier("modifier_hoodwink_scurry_5") then 
		duration = duration + self.duration_init
	end
	

	self:GetCaster():AddNewModifier( self:GetCaster(), self, "modifier_hoodwink_scurry_custom_buff", { duration = duration } )
end

modifier_hoodwink_scurry_custom = class({})

function modifier_hoodwink_scurry_custom:IsHidden()
	return self:GetStackCount()~=0
end

function modifier_hoodwink_scurry_custom:OnCreated( kv )
	self.parent = self:GetParent()
	self.evasion = self:GetAbility():GetSpecialValueFor( "evasion" )
	self.radius = self:GetAbility():GetSpecialValueFor( "radius" )
	self.near_trees = false
	if not IsServer() then return end
	self:StartIntervalThink( FrameTime() )
	self:OnIntervalThink()
end

function modifier_hoodwink_scurry_custom:OnRefresh( kv )
	self.evasion = self:GetAbility():GetSpecialValueFor( "evasion" )
	self.radius = self:GetAbility():GetSpecialValueFor( "radius" )
end

function modifier_hoodwink_scurry_custom:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_EVASION_CONSTANT
	}

	return funcs
end












function modifier_hoodwink_scurry_custom:GetModifierEvasion_Constant()
if self:GetStackCount()==1 then return 0 end
	local bonus = 0
	if self:GetParent():HasModifier("modifier_hoodwink_scurry_1") then 
		bonus = self:GetAbility().evasion_init + self:GetAbility().evasion_inc*self:GetParent():GetUpgradeStack("modifier_hoodwink_scurry_1") 
	end

	return self.evasion + bonus
end

function modifier_hoodwink_scurry_custom:OnIntervalThink()


	local trees = GridNav:GetAllTreesAroundPoint( self.parent:GetOrigin(), self.radius, false )
	local stack = 1

	if #trees>0 or (self:GetParent():HasModifier("modifier_hoodwink_scurry_1") and self:GetParent():HasModifier("modifier_hoodwink_scurry_custom_buff")) then
	 	stack = 0 
	end

	if #trees>0 and self.near_trees == false then 
		self.near_trees = true
		if self:GetParent():HasModifier("modifier_hoodwink_scurry_6") then 
			self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_hoodwink_scurry_custom_vision_timer", {duration = self:GetAbility().vision_timer})
		end
	end

	if #trees == 0 and self.near_trees == true then 
		self.near_trees = false
		if self:GetParent():HasModifier("modifier_hoodwink_scurry_custom_vision_timer") then 
			local mod = self:GetParent():FindModifierByName("modifier_hoodwink_scurry_custom_vision_timer")
			mod.buf = false
			self:GetParent():RemoveModifierByName("modifier_hoodwink_scurry_custom_vision_timer")
		end

		if self:GetParent():HasModifier("modifier_hoodwink_scurry_custom_vision") then 
			self:GetParent():RemoveModifierByName("modifier_hoodwink_scurry_custom_vision")
		end
	end

	if self:GetStackCount()~=stack then
		self:SetStackCount( stack )
		if stack==0 then

		
			self.effect_cast = ParticleManager:CreateParticle( "particles/units/heroes/hero_hoodwink/hoodwink_scurry_passive.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.parent )
			ParticleManager:SetParticleControl( self.effect_cast, 2, Vector( self.radius, 0, 0 ) )
		else

			if not self.effect_cast then return end
			ParticleManager:DestroyParticle( self.effect_cast, false )
			ParticleManager:ReleaseParticleIndex( self.effect_cast )
		end
	end
end

modifier_hoodwink_scurry_custom_buff = class({})

function modifier_hoodwink_scurry_custom_buff:IsPurgable()
	return true
end

function modifier_hoodwink_scurry_custom_buff:OnCreated( kv )
	self.movespeed = self:GetAbility():GetSpecialValueFor( "movement_speed_pct" )
	if not IsServer() then return end
	self:GetParent():EmitSound("Hero_Hoodwink.Scurry.Cast")
end

function modifier_hoodwink_scurry_custom_buff:OnRefresh( kv )
	self.movespeed = self:GetAbility():GetSpecialValueFor( "movement_speed_pct" )	
end

function modifier_hoodwink_scurry_custom_buff:OnDestroy()
if not IsServer() then return end
	self:GetParent():EmitSound("Hero_Hoodwink.Scurry.End")



end

function modifier_hoodwink_scurry_custom_buff:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
		MODIFIER_PROPERTY_TRANSLATE_ACTIVITY_MODIFIERS,
		MODIFIER_PROPERTY_HEALTH_REGEN_PERCENTAGE,
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
		MODIFIER_EVENT_ON_ATTACK_LANDED
	}

	return funcs
end
function modifier_hoodwink_scurry_custom_buff:GetActivityTranslationModifiers()
return "scurry"
end

function modifier_hoodwink_scurry_custom_buff:GetModifierAttackSpeedBonus_Constant()
if not self:GetParent():HasModifier("modifier_hoodwink_scurry_3") then return end
return self:GetAbility().speed_init + self:GetAbility().speed_inc*self:GetParent():GetUpgradeStack("modifier_hoodwink_scurry_3")
end

function modifier_hoodwink_scurry_custom_buff:GetModifierHealthRegenPercentage()
if not self:GetParent():HasModifier("modifier_hoodwink_scurry_2") then return end
return self:GetAbility().regen_init + self:GetAbility().regen_inc*self:GetParent():GetUpgradeStack("modifier_hoodwink_scurry_2")
end

function modifier_hoodwink_scurry_custom_buff:GetModifierMoveSpeedBonus_Percentage()
	return self.movespeed
end

function modifier_hoodwink_scurry_custom_buff:OnAttackLanded(params)
if not IsServer() then return end
if params.attacker ~= self:GetParent() then return end

if not params.target:IsBuilding() and self:GetParent():HasModifier("modifier_hoodwink_scurry_4") and not self:GetParent():HasModifier("modifier_hoodwink_acorn_shot_custom") then 
	local chance = self:GetAbility().attacks_chance_init + self:GetAbility().attacks_chance_inc*self:GetParent():GetUpgradeStack("modifier_hoodwink_scurry_4")
	
	local random = RollPseudoRandomPercentage(chance,62,self:GetParent())
	if random then 
		local damage = self:GetAbility().attacks_damage*self:GetParent():GetAgility()

  		params.target:EmitSound("Hoodwink.Scurry_attack")
		params.target:AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_hoodwink_scurry_custom_knock", {duration = self:GetAbility().attacks_duration, x = self:GetCaster():GetAbsOrigin().x, y = self:GetCaster():GetAbsOrigin().y})
    		


		local damageTable = { victim = params.target, attacker = self:GetParent(), damage = damage, damage_type = DAMAGE_TYPE_MAGICAL, ability = self:GetAbility(), damage_flags = DOTA_DAMAGE_FLAG_NONE }
		ApplyDamage(damageTable)

		SendOverheadEventMessage( nil, OVERHEAD_ALERT_BONUS_SPELL_DAMAGE, params.target, damage, self:GetCaster():GetPlayerOwner() )
	
	end
end



if not self:GetParent():HasModifier("modifier_hoodwink_scurry_5") then return end

self:SetDuration(self:GetRemainingTime() + self:GetAbility().duration_hit, true)

end



function modifier_hoodwink_scurry_custom_buff:CheckState()
	local state = {
		[MODIFIER_STATE_NO_UNIT_COLLISION] = true,
		[MODIFIER_STATE_ALLOW_PATHING_THROUGH_TREES] = true,
	}

	return state
end

function modifier_hoodwink_scurry_custom_buff:GetEffectName()
	return "particles/units/heroes/hero_hoodwink/hoodwink_scurry_aura.vpcf"
end

function modifier_hoodwink_scurry_custom_buff:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end





modifier_hoodwink_scurry_custom_legendary = class({})
function modifier_hoodwink_scurry_custom_legendary:IsHidden() return false end
function modifier_hoodwink_scurry_custom_legendary:IsPurgable() return false end
function modifier_hoodwink_scurry_custom_legendary:GetTexture() return "buffs/scurry_ground" end

function modifier_hoodwink_scurry_custom_legendary:OnCreated(table)
if not IsServer() then return end
self.moved = false
self.location = self:GetParent():GetAbsOrigin()
self.proj = self:GetCaster():GetRangedProjectileName()

self:GetCaster():SetRangedProjectileName("particles/hood_proj.vpcf")
self:GetParent():EmitSound("Hoodwink.Scurry_legendary")

self.ground_particle = ParticleManager:CreateParticle("particles/hoodwink_head.vpcf", PATTACH_CUSTOMORIGIN, self:GetParent())
ParticleManager:SetParticleControlEnt(self.ground_particle, 0, self:GetParent(), PATTACH_OVERHEAD_FOLLOW, "attach_hitloc", self:GetParent():GetAbsOrigin(), true)
ParticleManager:SetParticleControlEnt(self.ground_particle, 1, self:GetParent(), PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", self:GetParent():GetAbsOrigin(), true)
ParticleManager:SetParticleControlEnt(self.ground_particle, 5, self:GetParent(), PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", self:GetParent():GetAbsOrigin(), true)
self:AddParticle(self.ground_particle, false, false, -1, true, false)

self:StartIntervalThink(FrameTime())
end

function modifier_hoodwink_scurry_custom_legendary:DeclareFunctions()
return
{
  MODIFIER_PROPERTY_BASE_ATTACK_TIME_CONSTANT,
  MODIFIER_PROPERTY_ATTACK_RANGE_BONUS,
  MODIFIER_PROPERTY_BONUS_NIGHT_VISION
}
end
function modifier_hoodwink_scurry_custom_legendary:OnDestroy()
if not IsServer() then return end
self:GetCaster():SetRangedProjectileName(self.proj)
end



function modifier_hoodwink_scurry_custom_legendary:GetModifierBaseAttackTimeConstant()
return
self:GetAbility().legendary_bva
end

function modifier_hoodwink_scurry_custom_legendary:GetModifierAttackRangeBonus()
return
self:GetAbility().legendary_range
end



modifier_hoodwink_scurry_custom_legendary_timer = class({})
function modifier_hoodwink_scurry_custom_legendary_timer:IsHidden() return true end
function modifier_hoodwink_scurry_custom_legendary_timer:IsPurgable() return false end
function modifier_hoodwink_scurry_custom_legendary_timer:RemoveOnDeath() return false end


function modifier_hoodwink_scurry_custom_legendary_timer:OnCreated(table)
if not IsServer() then return end

self.distance = 0
self.stack = 0
self.old_pos = self:GetParent():GetAbsOrigin()

self.particle = ParticleManager:CreateParticle("particles/hood_charge.vpcf", PATTACH_OVERHEAD_FOLLOW, self:GetParent())
self:AddParticle(self.particle, false, false, -1, false, false)
self:StartIntervalThink(FrameTime())
end


function modifier_hoodwink_scurry_custom_legendary_timer:OnIntervalThink()
if not IsServer() then return end
if self:GetParent():HasModifier("modifier_hoodwink_scurry_custom_legendary") then return end
if self.old_pos == self:GetParent():GetAbsOrigin() then return end
if not self:GetParent():IsAlive() then return end

local distance = math.min((self:GetParent():GetAbsOrigin() - self.old_pos):Length2D(), self:GetAbility().legendary_distance)
self.old_pos = self:GetParent():GetAbsOrigin()

self.distance = self.distance + distance

local stack = math.floor(self.distance/self:GetAbility().legendary_distance)

if self.stack ~= stack then 
	self.stack = stack


	if self.stack >= self:GetAbility().legendary_max then 
		ParticleManager:DestroyParticle(self.particle, false)
		ParticleManager:ReleaseParticleIndex(self.particle)
		self.particle = nil
		self.stack = 0
		self.distance = 0
		self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_hoodwink_scurry_custom_legendary", {duration = self:GetAbility().legendary_duration})
	else 

		if self.particle == nil then 
			self.particle = ParticleManager:CreateParticle("particles/hood_charge.vpcf", PATTACH_OVERHEAD_FOLLOW, self:GetParent())
			self:AddParticle(self.particle, false, false, -1, false, false)
		end

		local max = self:GetAbility().legendary_max
		local s = self.stack


		for i = 1,max do 
	
			if i <= s then 
				ParticleManager:SetParticleControl(self.particle, i, Vector(1, 0, 0))	
			else 
				ParticleManager:SetParticleControl(self.particle, i, Vector(0, 0, 0))	
			end
		end

	end

end

end








modifier_hoodwink_scurry_custom_vision_timer = class({})
function modifier_hoodwink_scurry_custom_vision_timer:IsHidden() return true end
function modifier_hoodwink_scurry_custom_vision_timer:IsPurgable() return false end
function modifier_hoodwink_scurry_custom_vision_timer:OnCreated(table)
if not IsServer() then return end
self.buf = true 
end

function modifier_hoodwink_scurry_custom_vision_timer:OnDestroy()
if not IsServer() then return end
if self.buf == false then return end

self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_hoodwink_scurry_custom_vision", {})
end



modifier_hoodwink_scurry_custom_vision = class({})
function modifier_hoodwink_scurry_custom_vision:IsHidden() return false end
function modifier_hoodwink_scurry_custom_vision:IsPurgable() return false end
function modifier_hoodwink_scurry_custom_vision:GetTexture() return "buffs/scurry_vision" end

function modifier_hoodwink_scurry_custom_vision:OnCreated(table)
if not IsServer() then return end
self.location = self:GetParent():GetAbsOrigin()


self:GetParent():EmitSound("Item.SeerStone")
self.agi_percentage = self:GetAbility().vision_agility

self.ground_particle = ParticleManager:CreateParticle("particles/hoodwink_ground.vpcf", PATTACH_CUSTOMORIGIN, self:GetParent())
ParticleManager:SetParticleControlEnt(self.ground_particle, 0, self:GetParent(), PATTACH_OVERHEAD_FOLLOW, "attach_hitloc", self:GetParent():GetAbsOrigin(), true)
ParticleManager:SetParticleControlEnt(self.ground_particle, 1, self:GetParent(), PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", self:GetParent():GetAbsOrigin(), true)
ParticleManager:SetParticleControlEnt(self.ground_particle, 5, self:GetParent(), PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", self:GetParent():GetAbsOrigin(), true)
self:AddParticle(self.ground_particle, false, false, -1, true, false)


self:OnIntervalThink()
self:StartIntervalThink(0.5)
end


function modifier_hoodwink_scurry_custom_vision:CheckState()
return
{
	[MODIFIER_STATE_FORCED_FLYING_VISION] = true
}
end
function modifier_hoodwink_scurry_custom_vision:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
	MODIFIER_PROPERTY_TOOLTIP
}
end


function modifier_hoodwink_scurry_custom_vision:GetModifierBonusStats_Agility()
  return self.agility
end


function modifier_hoodwink_scurry_custom_vision:OnIntervalThink()
if not IsServer() then return end


  self.agility  = 0
  self.agility   = self:GetParent():GetAgility() * self.agi_percentage * 0.01

  self:GetParent():CalculateStatBonus(true)

end


function modifier_hoodwink_scurry_custom_vision:OnTooltip()
return self:GetAbility().vision_agility
end








modifier_hoodwink_scurry_custom_knock = class({})

function modifier_hoodwink_scurry_custom_knock:IsHidden() return true end

function modifier_hoodwink_scurry_custom_knock:OnCreated(params)
  if not IsServer() then return end
  
  self.ability        = self:GetAbility()
  self.caster         = self:GetCaster()
  self.parent         = self:GetParent()
  self:GetParent():StartGesture(ACT_DOTA_FLAIL)
  
  self.knockback_duration   = self.ability.attacks_duration

  self.knockback_distance   = math.max(self.ability.attacks_knockback - (self.caster:GetAbsOrigin() - self.parent:GetAbsOrigin()):Length2D(), 50)
  
  self.knockback_speed    = self.knockback_distance / self.knockback_duration
  
  self.position = GetGroundPosition(Vector(params.x, params.y, 0), nil)
  
  if self:ApplyHorizontalMotionController() == false then 
    self:Destroy()
    return
  end
end

function modifier_hoodwink_scurry_custom_knock:UpdateHorizontalMotion( me, dt )
  if not IsServer() then return end

  local distance = (me:GetOrigin() - self.position):Normalized()
  
  me:SetOrigin( me:GetOrigin() + distance * self.knockback_speed * dt )

  --GridNav:DestroyTreesAroundPoint( self.parent:GetOrigin(), self.parent:GetHullRadius(), true )
end

function modifier_hoodwink_scurry_custom_knock:DeclareFunctions()
  local decFuncs = {
    MODIFIER_PROPERTY_OVERRIDE_ANIMATION
    }

    return decFuncs
end

function modifier_hoodwink_scurry_custom_knock:GetOverrideAnimation()
   return ACT_DOTA_FLAIL
end


function modifier_hoodwink_scurry_custom_knock:OnDestroy()
  if not IsServer() then return end
  self.parent:RemoveHorizontalMotionController( self )
  self:GetParent():FadeGesture(ACT_DOTA_FLAIL)
end

