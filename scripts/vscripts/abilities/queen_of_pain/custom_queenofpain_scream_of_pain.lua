LinkLuaModifier("modifier_custom_scream_fear", "abilities/queen_of_pain/custom_queenofpain_scream_of_pain", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_custom_scream_timer", "abilities/queen_of_pain/custom_queenofpain_scream_of_pain", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_custom_scream_knockback", "abilities/queen_of_pain/custom_queenofpain_scream_of_pain", LUA_MODIFIER_MOTION_HORIZONTAL)
LinkLuaModifier("modifier_custom_scream_slow", "abilities/queen_of_pain/custom_queenofpain_scream_of_pain", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_custom_scream_tracker", "abilities/queen_of_pain/custom_queenofpain_scream_of_pain", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_custom_scream_damage", "abilities/queen_of_pain/custom_queenofpain_scream_of_pain", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_custom_scream_legendary", "abilities/queen_of_pain/custom_queenofpain_scream_of_pain", LUA_MODIFIER_MOTION_NONE)



custom_queenofpain_scream_of_pain = class({})

custom_queenofpain_scream_of_pain.damage_init = 0
custom_queenofpain_scream_of_pain.damage_inc = 25

custom_queenofpain_scream_of_pain.cd_init = 0
custom_queenofpain_scream_of_pain.cd_inc = 0.5

custom_queenofpain_scream_of_pain.fear_max = 4
custom_queenofpain_scream_of_pain.fear_fear = 1.2
custom_queenofpain_scream_of_pain.fear_duration = 8

custom_queenofpain_scream_of_pain.knockback_duration = 0.3
custom_queenofpain_scream_of_pain.knockback_distance = 350
custom_queenofpain_scream_of_pain.knockback_speed = -40
custom_queenofpain_scream_of_pain.knockback_duration_slow = 1

custom_queenofpain_scream_of_pain.legendary_health = 0.35
custom_queenofpain_scream_of_pain.legendary_cd = 1

custom_queenofpain_scream_of_pain.heal_init = 0.03
custom_queenofpain_scream_of_pain.heal_inc = 0.01
custom_queenofpain_scream_of_pain.heal_damage = 0.20

custom_queenofpain_scream_of_pain.double_init = 0
custom_queenofpain_scream_of_pain.double_inc = 0.1




function custom_queenofpain_scream_of_pain:GetCooldown(iLevel)
local upgrade_cooldown = 0	
if self:GetCaster():HasModifier("modifier_queen_Scream_cd") then 
	upgrade_cooldown = self.cd_init + self.cd_inc*self:GetCaster():GetUpgradeStack("modifier_queen_Scream_cd")
end

return self.BaseClass.GetCooldown(self, iLevel) - upgrade_cooldown 
end

function custom_queenofpain_scream_of_pain:GetCastRange( location , target)
	return self:GetSpecialValueFor("radius")
end

function custom_queenofpain_scream_of_pain:GetIntrinsicModifierName()
return "modifier_custom_scream_tracker"
end


function custom_queenofpain_scream_of_pain:Scream(caster, damage, hits, slow, double, bonus, fear, passive)
if not IsServer() then return end

caster:EmitSound("Hero_QueenOfPain.ScreamOfPain")
local scream_loc = caster:GetAbsOrigin()

local projectile_speed = self:GetSpecialValueFor("projectile_speed")
local radius = self:GetSpecialValueFor("radius")



local one = false 
if double == false and self:GetCaster():HasModifier("modifier_queen_Scream_double") then 
	one = true 
end

if one == false then 
	local scream_pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_queenofpain/queen_scream_of_pain_owner.vpcf", PATTACH_ABSORIGIN, caster)
	ParticleManager:SetParticleControl(scream_pfx, 0, scream_loc )
	ParticleManager:ReleaseParticleIndex(scream_pfx)

end

local enemies = FindUnitsInRadius(self:GetCaster():GetTeamNumber(), scream_loc, nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_CLOSEST, false)
		for _, enemy in pairs(enemies) do
			if enemy ~= caster then 
				local projectile =
					{
						Target 				= enemy,
						Source 				= caster,
						Ability 			= self,
						EffectName 			= "particles/units/heroes/hero_queenofpain/queen_scream_of_pain.vpcf",
						iMoveSpeed			= projectile_speed,
						vSourceLoc 			= scream_loc,
						bDrawsOnMinimap 	= false,
						bDodgeable 			= true,
						bIsAttack 			= false,
						bVisibleToEnemies 	= true,
						bReplaceExisting 	= false,
						flExpireTime 		= GameRules:GetGameTime() + 20,
						bProvidesVision 	= false,
						iSourceAttachment 	= DOTA_PROJECTILE_ATTACHMENT_HITLOCATION,
						ExtraData			= {damage = damage, double = double, hits = false, bonus = bonus, fear = fear}
					}
				ProjectileManager:CreateTrackingProjectile(projectile)

				if hits == true then 

	 				local no = self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_custom_blink_legendary_nospeed", {})

					self:GetCaster():PerformAttack(enemy, true, true, true, false , true, false , false)
					if no then no:Destroy() end
				end

				if slow and not passive then 
					enemy:AddNewModifier(self:GetCaster(), self, "modifier_custom_scream_knockback", {duration = self.knockback_duration * (1 - enemy:GetStatusResistance()), x = self:GetCaster():GetAbsOrigin().x, y = self:GetCaster():GetAbsOrigin().y})
    			end

    			if one == true then 
    				break
    			end
    		end
	end


end



function custom_queenofpain_scream_of_pain:OnSpellStart(can_hits,passive)
if not IsServer() then	return end		
		


		local can_hit = false
		if not can_hits then
			can_hit = true
		end

		local damage = self:GetSpecialValueFor("damage")
			
		if self:GetCaster():HasModifier("modifier_queen_Scream_damage") then 
			damage = damage + self.damage_init + self.damage_inc*self:GetCaster():GetUpgradeStack("modifier_queen_Scream_damage")
		end


		local bonus = 0
		if self:GetCaster():HasModifier("modifier_queen_Scream_shield") then 


			bonus = self:GetCaster():GetMaxHealth()*(self.heal_init + self.heal_inc*self:GetCaster():GetUpgradeStack("modifier_queen_Scream_shield"))

			local particle = ParticleManager:CreateParticle( "particles/huskar_leap_heal.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster() )
     		ParticleManager:ReleaseParticleIndex( particle )

			damage = damage + bonus*self.heal_damage

 			self:GetCaster():Heal(bonus, self:GetCaster())
 			SendOverheadEventMessage(self:GetCaster(), 10, self:GetCaster(), bonus, nil)


		end



		local slow = false 
		if self:GetCaster():HasModifier("modifier_queen_Scream_slow") then 
			slow = true 
		end

	
		local hits = false 	
		if self:GetCaster():HasModifier("modifier_custom_blink_spell") and can_hit == true then 
			hits = true 
			self:GetCaster():RemoveModifierByName("modifier_custom_blink_spell")
		end

		local double = false 	
		if self:GetCaster():HasModifier("modifier_queen_Scream_double") then 
			double = true 
		end

		local fear = false
		if self:GetCaster():HasModifier("modifier_queen_Scream_fear") then 
			fear = true
		end

		self:Scream(self:GetCaster(), damage, hits, slow, double, bonus*self.heal_damage, fear, passive)

end

function custom_queenofpain_scream_of_pain:OnProjectileHit_ExtraData(target, location, ExtraData)
if not IsServer() then return end
if not target then return end
if target:IsMagicImmune() then return end
local caster = self:GetCaster()
local hits = false

local damage  = ExtraData.damage

if ExtraData.hits == 1 then 
	hits = true 
end


if not target:IsBuilding() and ExtraData.fear == 1 then 
	target:AddNewModifier(caster, self, "modifier_custom_scream_timer", {duration = self.fear_duration})
end

if ExtraData.bonus > 0 then 
	SendOverheadEventMessage(target, 6, target, ExtraData.bonus, nil)
end

ApplyDamage({victim = target, attacker = caster, ability = self, damage = damage, damage_type = DAMAGE_TYPE_MAGICAL})


if ExtraData.double == 1 then 
	local double_damage = self.double_init + self.double_inc*caster:GetUpgradeStack("modifier_queen_Scream_double")
	self:Scream(target, damage*double_damage, hits , false, false, 0, false, false)
end

end


modifier_custom_scream_timer = class({})
function modifier_custom_scream_timer:IsHidden() return false end
function modifier_custom_scream_timer:IsPurgable() return false end
function modifier_custom_scream_timer:GetTexture() return "buffs/scream_fear" end
function modifier_custom_scream_timer:OnCreated(table)
if not IsServer() then return end
 	self.RemoveForDuel = true
	self:SetStackCount(1)
end

function modifier_custom_scream_timer:OnRefresh(table)
if not IsServer() then return end
	self:SetStackCount(self:GetStackCount() + 1)
	if self:GetStackCount() >= self:GetAbility().fear_max then 
		local name = "modifier_nevermore_requiem_fear"

		if self:GetParent():IsCreep() then 
			name = "modifier_stunned"
		end

		self:GetParent():AddNewModifier(self:GetCaster(), self:GetAbility(), name , {duration = self:GetAbility().fear_fear})
		self:Destroy()
	end
end

function modifier_custom_scream_timer:OnDestroy()
if self.pfx then 
    ParticleManager:DestroyParticle(self.pfx, false)
    ParticleManager:ReleaseParticleIndex(self.pfx)
end

end

function modifier_custom_scream_timer:OnStackCountChanged(iStackCount)
    if not IsServer() then return end

    if not self.pfx then
        self.pfx = ParticleManager:CreateParticle("particles/qop_fear_timer.vpcf", PATTACH_OVERHEAD_FOLLOW, self:GetParent())
    end

    ParticleManager:SetParticleControl(self.pfx, 1, Vector(0, self:GetStackCount(), 0))
end






modifier_custom_scream_knockback = class({})

function modifier_custom_scream_knockback:IsHidden() return true end

function modifier_custom_scream_knockback:OnCreated(params)
  if not IsServer() then return end
  
  self.ability        = self:GetAbility()
  self.caster         = self:GetCaster()
  self.parent         = self:GetParent()
  self:GetParent():StartGesture(ACT_DOTA_FLAIL)
  
  self.knockback_duration   = self.ability.knockback_duration

  self.knockback_distance   = math.max(self.ability.knockback_distance - (self.caster:GetAbsOrigin() - self.parent:GetAbsOrigin()):Length2D(), 50)
  
  self.knockback_speed    = self.knockback_distance / self.knockback_duration
  
  self.position = GetGroundPosition(Vector(params.x, params.y, 0), nil)
  
  if self:ApplyHorizontalMotionController() == false then 
    self:Destroy()
    return
  end
end

function modifier_custom_scream_knockback:UpdateHorizontalMotion( me, dt )
  if not IsServer() then return end

  local distance = (me:GetOrigin() - self.position):Normalized()
  
  me:SetOrigin( me:GetOrigin() + distance * self.knockback_speed * dt )

  GridNav:DestroyTreesAroundPoint( self.parent:GetOrigin(), self.parent:GetHullRadius(), true )
end

function modifier_custom_scream_knockback:DeclareFunctions()
  local decFuncs = {
    MODIFIER_PROPERTY_OVERRIDE_ANIMATION
    }

    return decFuncs
end

function modifier_custom_scream_knockback:GetOverrideAnimation()
   return ACT_DOTA_FLAIL
end


function modifier_custom_scream_knockback:OnDestroy()
  if not IsServer() then return end
  self.parent:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_custom_scream_slow", {duration = self:GetAbility().knockback_duration_slow})
  self.parent:RemoveHorizontalMotionController( self )
  self:GetParent():FadeGesture(ACT_DOTA_FLAIL)
end



modifier_custom_scream_slow = class({})
function modifier_custom_scream_slow:IsHidden() return false end
function modifier_custom_scream_slow:IsPurgable() return true end
function modifier_custom_scream_slow:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE
}
end
function modifier_custom_scream_slow:GetModifierMoveSpeedBonus_Percentage() return self:GetAbility().knockback_speed end



modifier_custom_scream_tracker = class({})
function modifier_custom_scream_tracker:IsHidden() return true end
function modifier_custom_scream_tracker:IsPurgable() return false end
function modifier_custom_scream_tracker:DeclareFunctions()
return
{
	MODIFIER_EVENT_ON_ATTACK_LANDED,
	MODIFIER_EVENT_ON_TAKEDAMAGE
}
end


function modifier_custom_scream_tracker:OnTakeDamage(params)
if not IsServer() then return end
if params.unit ~= self:GetParent() then return end



if self:GetParent():HasModifier("modifier_queen_Scream_legendary") 
and not self:GetParent():PassivesDisabled() and self:GetParent():IsAlive() then 

	if self.particle == nil then 
		self.particle = ParticleManager:CreateParticle("particles/axe_spin.vpcf", PATTACH_OVERHEAD_FOLLOW, self:GetParent())
		self:AddParticle(self.particle, false, false, -1, false, false)
	end	

	local mod = self:GetParent():FindModifierByName("modifier_custom_scream_legendary")

	if not mod then 
		mod = self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_custom_scream_legendary", {})
		mod:SetStackCount(params.damage)
	else 
		mod:SetStackCount(mod:GetStackCount() + params.damage)
	end


	local tr = self:GetParent():GetMaxHealth()*self:GetAbility().legendary_health
	local proc = false

	if mod:GetStackCount() >= tr then 
		mod:Destroy()
		self:GetAbility():OnSpellStart(true,true)
		proc = true 
	end


	local count = 0
	if mod and proc == false then 
		count = mod:GetStackCount()
	end

	local max = 6
	local tick = self:GetParent():GetMaxHealth()*self:GetAbility().legendary_health / max
	local stack = math.floor(count/tick)

	for i = 1,max do 
	
		if i <= stack then 
			ParticleManager:SetParticleControl(self.particle, i, Vector(1, 0, 0))	
		else 
			ParticleManager:SetParticleControl(self.particle, i, Vector(0, 0, 0))	
		end
	end




end


end




modifier_custom_scream_legendary = class({})
function modifier_custom_scream_legendary:IsHidden() return true end
function modifier_custom_scream_legendary:IsPurgable() return false end
function modifier_custom_scream_legendary:RemoveOnDeath() return false end

function modifier_custom_scream_legendary:OnCreated(table)
self.RemoveForDuel = true
self:SetStackCount(0)
end

