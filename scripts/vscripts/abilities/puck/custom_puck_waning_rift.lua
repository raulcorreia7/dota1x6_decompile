LinkLuaModifier("modifier_custom_puck_waning_rift", "abilities/puck/custom_puck_waning_rift", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_custom_waning_rift_knockback", "abilities/puck/custom_puck_waning_rift", LUA_MODIFIER_MOTION_HORIZONTAL)
LinkLuaModifier("modifier_custom_puck_waning_rift_legendary", "abilities/puck/custom_puck_waning_rift", LUA_MODIFIER_MOTION_NONE)


custom_puck_waning_rift = class({})

custom_puck_waning_rift.shard_damage = 70
custom_puck_waning_rift.shard_duration = 5	
custom_puck_waning_rift.shard_radius = 200
custom_puck_waning_rift.shard_knockback = 0.4 	 	

custom_puck_waning_rift.damage_init = 0.05
custom_puck_waning_rift.damage_inc = 0.05

custom_puck_waning_rift.cd_init = 0
custom_puck_waning_rift.cd_inc = 2

custom_puck_waning_rift.range_inc = 200

custom_puck_waning_rift.purge_duration = 1
custom_puck_waning_rift.purge_stun = 1

custom_puck_waning_rift.legendary_interval = 0.5
custom_puck_waning_rift.legendary_max  = 6
custom_puck_waning_rift.legendary_mana = 0.04
custom_puck_waning_rift.legendary_damage = 0.75

custom_puck_waning_rift.tick_damage_init = 0
custom_puck_waning_rift.tick_damage_inc = 0.10

custom_puck_waning_rift.regen_chance = 50
custom_puck_waning_rift.regen_init = 0.05
custom_puck_waning_rift.regen_inc = 0.05



function custom_puck_waning_rift:GetCooldown(iLevel)

local upgrade_cooldown = self.cd_inc*self:GetCaster():GetUpgradeStack("modifier_puck_rift_cd")

 return self.BaseClass.GetCooldown(self, iLevel) - upgrade_cooldown
 
end


function custom_puck_waning_rift:GetCastRange(vLocation, hTarget)
local max_range = self:GetSpecialValueFor("max_distance")
if self:GetCaster():HasModifier("modifier_puck_rift_range") then 
	max_range = max_range + self.range_inc*self:GetCaster():GetUpgradeStack("modifier_puck_rift_range")
end

if IsClient() then
	return max_range
end
return

end




function custom_puck_waning_rift:GetManaCost(level)
return self.BaseClass.GetManaCost(self,level) + self:GetCaster():GetMaxMana()*self.legendary_mana*self:GetCaster():GetUpgradeStack("modifier_custom_puck_waning_rift_legendary")
end

function custom_puck_waning_rift:GetAOERadius()
	return self:GetSpecialValueFor("radius")
end

function custom_puck_waning_rift:CastFilterResultTarget(target)
	return UF_SUCCESS
end




function custom_puck_waning_rift:OnSpellStart()
	self:GetCaster():EmitSound("Hero_Puck.Waning_Rift")

	if self:GetCaster():GetName() == "npc_dota_hero_puck" then
		self:GetCaster():EmitSound("puck_puck_ability_rift_0"..RandomInt(1, 3))
	end


	self.max_range = self:GetSpecialValueFor("max_distance") +  self:GetCaster():GetCastRangeBonus()
	if self:GetCaster():HasModifier("modifier_puck_rift_range") then 
		self.max_range = self.max_range + self.range_inc*self:GetCaster():GetUpgradeStack("modifier_puck_rift_range")
		self:GetCaster():Purge(false, true, false, false, false)
		ProjectileManager:ProjectileDodge(self:GetCaster())
	end


	local old_pos = self:GetCaster():GetAbsOrigin()

	if not self:GetCaster():IsRooted() then

		self.position = self:GetCursorPosition()
		if (self.position - self:GetCaster():GetAbsOrigin()):Length2D() >= self.max_range then 
			self.position = self:GetCaster():GetAbsOrigin() + self:GetCaster():GetForwardVector()*self.max_range
		end

		FindClearSpaceForUnit(self:GetCaster(), self.position, true)
	end
	
	

	if self:GetCaster():HasModifier("modifier_custom_puck_waning_rift_legendary") 
		and self:GetCaster():FindModifierByName("modifier_custom_puck_waning_rift_legendary"):GetStackCount() >= 5 then 
			self:GetCaster():EmitSound("Puck.Rift_Legendary")
			local effect = ParticleManager:CreateParticle("particles/items3_fx/blink_arcane_start.vpcf", PATTACH_WORLDORIGIN, nil)
			ParticleManager:SetParticleControl(effect, 0, old_pos)


			effect = ParticleManager:CreateParticle("particles/items3_fx/blink_arcane_end.vpcf", PATTACH_WORLDORIGIN, nil)
			ParticleManager:SetParticleControl(effect, 0, self:GetCaster():GetAbsOrigin())
	end


	local rift_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_puck/puck_waning_rift.vpcf", PATTACH_WORLDORIGIN, nil)
	ParticleManager:SetParticleControl(rift_particle, 0, self:GetCaster():GetAbsOrigin())
	ParticleManager:SetParticleControl(rift_particle, 1, Vector(self:GetSpecialValueFor("radius"), 0, 0))
	ParticleManager:ReleaseParticleIndex(rift_particle)
	

	self.damage = self:GetSpecialValueFor("damage")

	if self:GetCaster():HasModifier("modifier_puck_rift_legendary") then 
		self.damage = self.damage + self:GetManaCost(self:GetLevel())*self.legendary_damage
	end

	if self:GetCaster():HasShard() then 
		self.damage = self.damage + self.shard_damage

		local wards = FindUnitsInRadius(self:GetCaster():GetTeamNumber(), self:GetCaster():GetAbsOrigin(), nil, self:GetSpecialValueFor("radius"), DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false)
		for _,enemy in pairs(wards) do
			enemy:AddNewModifier(self:GetCaster(), self, "modifier_item_dustofappearance", {duration = self.shard_duration})
		end
	end

	self.silence = self:GetSpecialValueFor("silence_duration")
	
	if self:GetCaster():HasModifier("modifier_puck_rift_purge") then 
		self.silence = self.silence + self.purge_duration
	end



	if self:GetCaster():HasModifier("modifier_puck_rift_damage") then 
		self.damage = self.damage*(1 + self.damage_init + self.damage_inc*self:GetCaster():GetUpgradeStack("modifier_puck_rift_damage"))
	end

	if self:GetCaster():HasModifier("modifier_puck_rift_mana") then 

		local chance = self.regen_chance

		local random = RollPseudoRandomPercentage(chance,78,self:GetCaster())
		if random then 
			local regen = self:GetCaster():GetMaxMana()*(self.regen_init + self.regen_inc*self:GetCaster():GetUpgradeStack("modifier_puck_rift_mana"))
			if (self:GetCaster():GetMaxMana() - self:GetCaster():GetMana()) < regen then
				regen = (self:GetCaster():GetMaxMana() - self:GetCaster():GetMana())
			end
			self:GetCaster():GiveMana(regen)
			self:GetCaster():Heal(regen, self)

			self:GetCaster():EmitSound("Puck.Rift_Mana")
     		SendOverheadEventMessage(self:GetCaster(), 10,self:GetCaster(), regen, nil)

			local mana_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_keeper_of_the_light/keeper_chakra_magic.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster())
			ParticleManager:SetParticleControl(mana_particle, 0, self:GetCaster():GetAbsOrigin())
			ParticleManager:SetParticleControl(mana_particle, 1, self:GetCaster():GetAbsOrigin())
			ParticleManager:ReleaseParticleIndex(mana_particle)
			
		end

	end


	local enemies = FindUnitsInRadius(self:GetCaster():GetTeamNumber(), self:GetCaster():GetAbsOrigin(), nil, self:GetSpecialValueFor("radius"), DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_BUILDING, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
	
	for _, enemy in pairs(enemies) do
	
		local damage = self.damage
		if enemy:IsBuilding() then 
			damage = damage*self:GetSpecialValueFor("building_damage")/100
		end

		local damageTable = {
			victim 			= enemy,
			damage 			= damage,
			damage_type		= self:GetAbilityDamageType(),
			damage_flags 	= DOTA_DAMAGE_FLAG_NONE,
			attacker 		= self:GetCaster(),
			ability 		= self
		}

		if not enemy:IsBuilding() then 
			enemy:AddNewModifier(self:GetCaster(), self, "modifier_custom_puck_waning_rift", {duration = self.silence * (1 - enemy:GetStatusResistance())})
		end

		ApplyDamage(damageTable)
		
		if self:GetCaster():HasShard() then 
			enemy:AddNewModifier(self:GetCaster(), self, "modifier_custom_waning_rift_knockback", {duration = self.shard_knockback * (1 - enemy:GetStatusResistance()), x = self:GetCaster():GetAbsOrigin().x, y = self:GetCaster():GetAbsOrigin().y})
			
		end
	
	end



end

modifier_custom_puck_waning_rift = class({})

function modifier_custom_puck_waning_rift:GetEffectName()
	if not self:GetParent():IsCreep() then
		return "particles/generic_gameplay/generic_silenced.vpcf"
	else
		return "particles/generic_gameplay/generic_silenced_lanecreeps.vpcf"
	end
end

function modifier_custom_puck_waning_rift:GetEffectAttachType()
	return PATTACH_OVERHEAD_FOLLOW
end


function modifier_custom_puck_waning_rift:CheckState()
	return {[MODIFIER_STATE_SILENCED] = true}
end



function modifier_custom_puck_waning_rift:DeclareFunctions()
return
{
	MODIFIER_EVENT_ON_TAKEDAMAGE
}
end

function modifier_custom_puck_waning_rift:OnTakeDamage(params)
if not IsServer() then return end
if not self:GetCaster():HasModifier("modifier_puck_rift_tick") then return end
if params.unit ~= self:GetParent() then return end
self.damage = self.damage + params.damage

end


function modifier_custom_puck_waning_rift:OnCreated(table)
if not IsServer() then return end

self.damage = 0

if not self:GetCaster():HasModifier("modifier_puck_rift_purge") then return end

self.max = self:GetRemainingTime() - 0.1
self.purged = true
self.count = 0
self:StartIntervalThink(0.1)

end

function modifier_custom_puck_waning_rift:OnIntervalThink()
if not IsServer() then return end

self.count = self.count + 0.1

if self.count >= self.max then 
	self.purged = false
end

end

function modifier_custom_puck_waning_rift:OnDestroy()
if not IsServer() then return end
if not self:GetParent():IsAlive() then return end


if self.damage > 0 and self:GetCaster():HasModifier("modifier_puck_rift_tick") and not self:GetParent():IsMagicImmune() then 
	local damage = self.damage*(self:GetAbility().tick_damage_init + self:GetAbility().tick_damage_inc*self:GetCaster():GetUpgradeStack("modifier_puck_rift_tick"))

	
	self:GetParent():EmitSound("Puck.Rift_Damage")
	local effect = ParticleManager:CreateParticle("particles/puck_silence_damage.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())

	ApplyDamage({ victim = self:GetParent(), attacker = self:GetCaster(), ability = self:GetAbility(), damage = damage, damage_type = DAMAGE_TYPE_MAGICAL})

	SendOverheadEventMessage(self:GetParent(), 6, self:GetParent(), damage, nil)
end

if not self:GetCaster():HasModifier("modifier_puck_rift_purge") then return end
if self.purged == false then return end


ParticleManager:CreateParticle("particles/econ/items/outworld_devourer/od_shards_exile/od_shards_exile_prison_end.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
			
self:GetParent():EmitSound("Puck.Rift_Stun")
self:GetParent():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_stunned", {duration = (1 - self:GetParent():GetStatusResistance())*self:GetAbility().purge_stun})

end


modifier_custom_waning_rift_knockback = class({})

function modifier_custom_waning_rift_knockback:IsHidden() return true end

function modifier_custom_waning_rift_knockback:OnCreated(params)
  if not IsServer() then return end
  
  self.ability        = self:GetAbility()
  self.caster         = self:GetCaster()
  self.parent         = self:GetParent()
  self:GetParent():StartGesture(ACT_DOTA_FLAIL)
  
  self.knockback_duration   = self.ability.knockback_duration

  --self.knockback_distance   = math.max(self.ability.knockback_distance - (self.caster:GetAbsOrigin() - self.parent:GetAbsOrigin()):Length2D(), 50)
  
  self.knockback_distance = self.ability.shard_radius

  self.knockback_speed    = self.ability.shard_radius / self.ability.shard_knockback
  
  self.position = GetGroundPosition(Vector(params.x, params.y, 0), nil)
  
  if self:ApplyHorizontalMotionController() == false then 
    self:Destroy()
    return
  end
end

function modifier_custom_waning_rift_knockback:UpdateHorizontalMotion( me, dt )
  if not IsServer() then return end

  local distance = (me:GetOrigin() - self.position):Normalized()
  
  me:SetOrigin( me:GetOrigin() + distance * self.knockback_speed * dt )

  GridNav:DestroyTreesAroundPoint( self.parent:GetOrigin(), self.parent:GetHullRadius(), true )
end

function modifier_custom_waning_rift_knockback:DeclareFunctions()
  local decFuncs = {
    MODIFIER_PROPERTY_OVERRIDE_ANIMATION
    }

    return decFuncs
end

function modifier_custom_waning_rift_knockback:GetOverrideAnimation()
   return ACT_DOTA_FLAIL
end


function modifier_custom_waning_rift_knockback:OnDestroy()
  if not IsServer() then return end
 self.parent:RemoveHorizontalMotionController( self )
  self:GetParent():FadeGesture(ACT_DOTA_FLAIL)
end




modifier_custom_puck_waning_rift_legendary = class({})
function modifier_custom_puck_waning_rift_legendary:IsHidden() return false end
function modifier_custom_puck_waning_rift_legendary:IsPurgable() return false end
function modifier_custom_puck_waning_rift_legendary:RemoveOnDeath() return false end
function modifier_custom_puck_waning_rift_legendary:OnCreated(table)
if not IsServer() then return end
	self:SetStackCount(0)
	self.stack = 1
	self:StartIntervalThink(self:GetAbility().legendary_interval)

	self.particle = ParticleManager:CreateParticle("particles/puck_silence_charges.vpcf", PATTACH_OVERHEAD_FOLLOW, self:GetParent())
	self:AddParticle(self.particle, false, false, -1, false, false)
end

function modifier_custom_puck_waning_rift_legendary:OnIntervalThink()
if not IsServer() then return end
if self:GetCaster():HasModifier("modifier_custom_puck_waning_rift_legendary_freeze") then return end

if self.stack == 1 and self:GetStackCount() == self:GetAbility().legendary_max then 
	self.stack = -1
end

if self.stack == -1 and self:GetStackCount() == 0 then 
	self.stack = 1
end

self:SetStackCount(self:GetStackCount() + self.stack)


if self:GetStackCount() == 5 and  self.hands == nil then 
	self.hands = ParticleManager:CreateParticle("particles/generic_gameplay/rune_arcane_owner.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
	self:AddParticle(self.particle, false, false, -1, false, false)
end

if self:GetStackCount() == 4 and self.hands ~= nil then 
	ParticleManager:DestroyParticle(self.hands, false)
	ParticleManager:ReleaseParticleIndex(self.hands)
	self.hands = nil
end


for i = 1,6 do 
	
	if i <= self:GetStackCount() then 
		ParticleManager:SetParticleControl(self.particle, i, Vector(1, 0, 0))	
	else 
		ParticleManager:SetParticleControl(self.particle, i, Vector(0, 0, 0))	
	end
end

end

function modifier_custom_puck_waning_rift_legendary:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_TOOLTIP
}

end


function modifier_custom_puck_waning_rift_legendary:OnTooltip()
return self:GetCaster():GetMaxMana()*self:GetStackCount()*self:GetAbility().legendary_mana
end


