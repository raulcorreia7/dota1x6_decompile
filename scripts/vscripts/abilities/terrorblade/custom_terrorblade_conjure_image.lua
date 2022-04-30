LinkLuaModifier("modifier_conjure_image_tracker", "abilities/terrorblade/custom_terrorblade_conjure_image", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_conjure_image_slow", "abilities/terrorblade/custom_terrorblade_conjure_image", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_conjure_image_slow_tracker", "abilities/terrorblade/custom_terrorblade_conjure_image", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_conjure_image_reduce_aura", "abilities/terrorblade/custom_terrorblade_conjure_image", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_conjure_image_legendary_aura", "abilities/terrorblade/custom_terrorblade_conjure_image", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_conjure_image_legendary_aura_damage", "abilities/terrorblade/custom_terrorblade_conjure_image", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_conjure_image_legendary_aura_damage_count", "abilities/terrorblade/custom_terrorblade_conjure_image", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_conjure_image_legendary_invun", "abilities/terrorblade/custom_terrorblade_conjure_image", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_conjure_image_legendary_invun_illusion", "abilities/terrorblade/custom_terrorblade_conjure_image", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_conjure_image_legendary_legendary_cd", "abilities/terrorblade/custom_terrorblade_conjure_image", LUA_MODIFIER_MOTION_NONE)


custom_terrorblade_conjure_image = class({})

custom_terrorblade_conjure_image.duration_init = 1
custom_terrorblade_conjure_image.duration_inc = 1

custom_terrorblade_conjure_image.incoming_init = 0
custom_terrorblade_conjure_image.incoming_inc = -20

custom_terrorblade_conjure_image.illusion_heal = 15

custom_terrorblade_conjure_image.double_init = 5
custom_terrorblade_conjure_image.double_inc = 10

custom_terrorblade_conjure_image.reduce = -4
custom_terrorblade_conjure_image.reduce_radius = 700

custom_terrorblade_conjure_image.legendary_radius = 700
custom_terrorblade_conjure_image.legendary_delay = 0.25
custom_terrorblade_conjure_image.legendary_cd = 5

custom_terrorblade_conjure_image.burn_radius = 400
custom_terrorblade_conjure_image.burn_agility_init = 0.05
custom_terrorblade_conjure_image.burn_agility_inc = 0.05
custom_terrorblade_conjure_image.burn_interval = 1



function custom_terrorblade_conjure_image:GetCooldown(iLevel)

local upgrade_cooldown = 0

if self:GetCaster():HasModifier("modifier_terror_illusion_duration") then 
	upgrade_cooldown = self.duration_init + self.duration_inc*self:GetCaster():GetUpgradeStack("modifier_terror_illusion_duration")
end

return self.BaseClass.GetCooldown(self, iLevel) - upgrade_cooldown
end



function custom_terrorblade_conjure_image:GetIntrinsicModifierName()
return "modifier_conjure_image_tracker"
end

function custom_terrorblade_conjure_image:OnSpellStart()
	if not IsServer() then return end



	self.duration = self:GetSpecialValueFor("illusion_duration")



	self.incoming = self:GetSpecialValueFor("illusion_incoming_damage")

	if self:GetCaster():HasModifier("modifier_terror_illusion_incoming") then 
		self.incoming = self.incoming + self.incoming_init + self.incoming_inc*self:GetCaster():GetUpgradeStack("modifier_terror_illusion_incoming")
	end

	local position = 108
 	local scramble = false 
 	local count = 1

 	if self:GetCaster():HasModifier("modifier_terror_illusion_double") then 
		local chance = self.double_init + self.double_inc*self:GetCaster():GetUpgradeStack("modifier_terror_illusion_double")

		local random = RollPseudoRandomPercentage(chance,41,self:GetCaster())
		if random then
			count = 2
		end
	end


	local illusions = CreateIllusions(self:GetCaster(), self:GetCaster(), {
		outgoing_damage = self:GetSpecialValueFor("illusion_outgoing_damage"),
		incoming_damage	= self.incoming,
		bounty_base		= nil, 
		bounty_growth	= nil,
		outgoing_damage_structure	= nil,
		outgoing_damage_roshan		= nil,
		duration		= self.duration
	}
	, count, position, scramble, true)

	if illusions then
		for _, illusion in pairs(illusions) do

		 self:GetCaster():EmitSound("Hero_Terrorblade.ConjureImage")
		 illusion.owner = self:GetCaster()	

		 illusion:AddNewModifier(self:GetCaster(), self, "modifier_terrorblade_conjureimage", {})

	     for _,mod in pairs(self:GetCaster():FindAllModifiers()) do
          if mod.StackOnIllusion ~= nil and mod.StackOnIllusion == true then
            illusion:UpgradeIllusion(mod:GetName(), mod:GetStackCount() )
          end
         end

			illusion:StartGesture(ACT_DOTA_CAST_ABILITY_3_END)
		end
	end



end




modifier_conjure_image_tracker = class({})
function modifier_conjure_image_tracker:IsHidden() return true end
function modifier_conjure_image_tracker:IsPurgable() return false end
function modifier_conjure_image_tracker:DeclareFunctions()
return
{
	MODIFIER_EVENT_ON_TAKEDAMAGE,

}
end
function modifier_conjure_image_tracker:OnTakeDamage(params)
if not IsServer() then return end

if self:GetParent():HasModifier("modifier_terror_illusion_texture") and self:GetParent() == params.attacker and params.inflictor == nil then 


	local heal = self:GetAbility().illusion_heal

	local heal_target = nil


	if self:GetParent():IsIllusion() then 
		if self:GetParent().owner ~= nil then 
			heal_target = self:GetParent().owner
		end
	else 
		heal_target = self:GetParent()
	end

	if heal_target then 

		heal_target:Heal(heal, self:GetAbility())
		local particle = ParticleManager:CreateParticle( "particles/units/heroes/hero_meepo/meepo_ransack.vpcf", PATTACH_ABSORIGIN_FOLLOW, heal_target )
		ParticleManager:ReleaseParticleIndex( particle )

	end

	local all_illusions = FindUnitsInRadius(self:GetCaster():GetTeamNumber(), self:GetCaster():GetAbsOrigin(), nil, FIND_UNITS_EVERYWHERE , DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NOT_CREEP_HERO + DOTA_UNIT_TARGET_FLAG_PLAYER_CONTROLLED, FIND_CLOSEST, false) 

	for _,illusion in pairs(all_illusions) do

		if illusion:IsIllusion() then 
			illusion:Heal(heal, self:GetAbility())
			local particle = ParticleManager:CreateParticle( "particles/units/heroes/hero_meepo/meepo_ransack.vpcf", PATTACH_ABSORIGIN_FOLLOW, illusion )
			ParticleManager:ReleaseParticleIndex( particle )
		end
	end


end




if self:GetParent():GetHealth() > 1 then return end 
if self:GetParent():IsIllusion() then return end
if not self:GetParent():HasModifier("modifier_terror_illusion_legendary") then return end
if self:GetParent() ~= params.unit then return end
if params.attacker == self:GetParent() then return end
if self:GetParent():HasModifier("modifier_death") then return end
if self:GetParent():HasModifier("modifier_up_res") and not self:GetParent():HasModifier("modifier_up_res_cd") then return end
if self:GetParent():HasModifier("modifier_terror_meta_lowhp")
and self:GetParent():HasModifier("modifier_custom_terrorblade_metamorphosis") and not self:GetParent():HasModifier("modifier_custom_terrorblade_metamorphosis_lowhp_cd") then return end
if self:GetParent():HasModifier("modifier_conjure_image_legendary_legendary_cd") then return end



local all_illusions = FindUnitsInRadius(self:GetCaster():GetTeamNumber(), self:GetCaster():GetAbsOrigin(), nil, self:GetAbility().legendary_radius, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NOT_CREEP_HERO + DOTA_UNIT_TARGET_FLAG_PLAYER_CONTROLLED  , FIND_CLOSEST, false) 
	if #all_illusions < 1 then return end	
	for _,i in ipairs(all_illusions) do
		if i:IsAlive() and i:GetHealth() > 1
			and i:FindModifierByName("modifier_illusion"):GetRemainingTime() > self:GetAbility().legendary_delay + 0.1 then 
			self:GetParent():SetHealth(1)

			--self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_conjure_image_legendary_legendary_cd", {duration = self:GetAbility().legendary_cd})
			self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_conjure_image_legendary_invun", {duration = self:GetAbility().legendary_delay, target = i:entindex()})
 			i:AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_conjure_image_legendary_invun_illusion", {})

			self:GetParent():EmitSound("TB.Image_legendary") 



 			break

		end
end


end










modifier_conjure_image_slow_tracker = class({})
function modifier_conjure_image_slow_tracker:IsPurgable() return true end
function modifier_conjure_image_slow_tracker:IsHidden() return true end
function modifier_conjure_image_slow_tracker:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end
function modifier_conjure_image_slow_tracker:OnCreated(table)
if not IsServer() then return end
self.owner = self:GetCaster()
end

function modifier_conjure_image_slow_tracker:OnDestroy()
if not IsServer() then return end
local mod = self:GetParent():FindModifierByName("modifier_conjure_image_slow")
if mod then 
	mod:DecrementStackCount()
end
if mod:GetStackCount() < 1 then 
	mod:Destroy()
end

end



modifier_conjure_image_reduce_aura = class({})
function modifier_conjure_image_reduce_aura:IsHidden() return false end
function modifier_conjure_image_reduce_aura:IsPurgable() return false end
function modifier_conjure_image_reduce_aura:RemoveOnDeath() return false end
function modifier_conjure_image_reduce_aura:GetTexture() return "buffs/image_reduce" end
function modifier_conjure_image_reduce_aura:OnCreated(table)
if not IsServer() then return end
self.radius = self:GetAbility().reduce_radius
self:StartIntervalThink(0.3)
end


function modifier_conjure_image_reduce_aura:OnIntervalThink()
if not IsServer() then return end

if not self:GetParent():IsIllusion() then 

	if not self:GetParent():IsAlive() then self:SetStackCount(0) return end


	local all_illusions = FindUnitsInRadius(self:GetParent():GetTeamNumber(), self:GetParent():GetAbsOrigin(), nil, self.radius, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NOT_CREEP_HERO + DOTA_UNIT_TARGET_FLAG_PLAYER_CONTROLLED  , FIND_CLOSEST, false) 
	local count = 0

	for _,i in ipairs(all_illusions) do 
		if not i:HasModifier("modifier_custom_terrorblade_reflection_invulnerability") and i ~= self:GetParent() then 

				local mod = i:FindModifierByName("modifier_conjure_image_reduce_aura") 
				if not mod then 
					mod = i:AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_conjure_image_reduce_aura", {})
				end

				count = count + 1
			end
	end

	self:SetStackCount(count)



else
	if (self:GetParent():GetAbsOrigin() - self:GetCaster():GetAbsOrigin()):Length2D() > self.radius
	or not self:GetCaster():IsAlive() then self:Destroy() return end
	local mod = self:GetCaster():FindModifierByName("modifier_conjure_image_reduce_aura")
	if mod then 
		self:SetStackCount(mod:GetStackCount())
	end
end


end

function modifier_conjure_image_reduce_aura:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
	MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE
}

end

function modifier_conjure_image_reduce_aura:GetModifierIncomingDamage_Percentage() return
self:GetStackCount()*self:GetAbility().reduce
end

function modifier_conjure_image_reduce_aura:GetModifierTotalDamageOutgoing_Percentage() return 
self:GetStackCount()*self:GetAbility().reduce*-1
end


modifier_conjure_image_legendary_invun = class({})
function modifier_conjure_image_legendary_invun:IsHidden() return true end
function modifier_conjure_image_legendary_invun:IsPurgable() return false end
function modifier_conjure_image_legendary_invun:CheckState() return {[MODIFIER_STATE_INVULNERABLE] = true , [MODIFIER_STATE_STUNNED] = true} end
function modifier_conjure_image_legendary_invun:OnCreated(table)
if not IsServer() then return end
self:GetParent():AddNoDraw()

ProjectileManager:ProjectileDodge(self:GetParent())

self.target = EntIndexToHScript(table.target)
self.origin = self.target:GetAbsOrigin()

local point_1 = self.origin + Vector(0,0,150)
local point_2 = self:GetParent():GetAbsOrigin() + Vector(0,0,150)
local sunder_particle_2 = ParticleManager:CreateParticle("particles/units/heroes/hero_terrorblade/terrorblade_sunder.vpcf", PATTACH_WORLDORIGIN, self:GetParent())
ParticleManager:SetParticleControl(sunder_particle_2, 0, point_1)
ParticleManager:SetParticleControl(sunder_particle_2, 1, point_2)
ParticleManager:SetParticleControl(sunder_particle_2, 61, Vector(1,0,0))
ParticleManager:SetParticleControl(sunder_particle_2, 60, Vector(150,150,150))
ParticleManager:ReleaseParticleIndex(sunder_particle_2)

end

function modifier_conjure_image_legendary_invun:OnDestroy()
if not IsServer() then return end
self:GetParent():RemoveNoDraw()
self.origin = self.target:GetAbsOrigin()


local face_origin = self.target:GetForwardVector()*50 + self.origin

self:GetParent():SetHealth(math.max(1,self.target:GetHealth()))
	
for _,mod in ipairs(self.target:FindAllModifiers()) do 
    mod:Destroy()
end


self.target:ForceKill(false)

self:GetParent():SetOrigin(self.origin)
FindClearSpaceForUnit( self:GetParent(), self.origin, true )
if IsServer() then

   local angel = face_origin - self:GetParent():GetAbsOrigin()
   angel.z = 0.0
   angel = angel:Normalized()

   self:GetParent():SetForwardVector(angel)
   self:GetParent():FaceTowards(face_origin)
end


end


modifier_conjure_image_legendary_invun_illusion = class({})
function modifier_conjure_image_legendary_invun_illusion:IsHidden() return true  end
function modifier_conjure_image_legendary_invun_illusion:IsPurgable() return false end
function modifier_conjure_image_legendary_invun_illusion:CheckState()
return
{
	[MODIFIER_STATE_INVULNERABLE] = true
}
end


modifier_conjure_image_legendary_aura = class({})

function modifier_conjure_image_legendary_aura:IsHidden() return true end
function modifier_conjure_image_legendary_aura:IsPurgable() return false end
function modifier_conjure_image_legendary_aura:IsDebuff() return false end



function modifier_conjure_image_legendary_aura:GetAuraRadius()
	return self:GetAbility().burn_radius
end

function modifier_conjure_image_legendary_aura:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_ENEMY
end

function modifier_conjure_image_legendary_aura:GetAuraSearchType() 
	return DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO
end


function modifier_conjure_image_legendary_aura:GetModifierAura()
	return "modifier_conjure_image_legendary_aura_damage"
end

function modifier_conjure_image_legendary_aura:IsAura()
	return true
end


modifier_conjure_image_legendary_aura_damage = class({})
function modifier_conjure_image_legendary_aura_damage:IsHidden() return true end
function modifier_conjure_image_legendary_aura_damage:IsPurgable() return false end
function modifier_conjure_image_legendary_aura_damage:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end

function modifier_conjure_image_legendary_aura_damage:OnCreated(table)
if not IsServer() then return end
self:GetParent():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_conjure_image_legendary_aura_damage_count", {})

end

function modifier_conjure_image_legendary_aura_damage:OnDestroy()
if not IsServer() then return end
local mod = self:GetParent():FindModifierByName("modifier_conjure_image_legendary_aura_damage_count")
if mod then 
	mod:DecrementStackCount()
	if mod:GetStackCount() < 1 then 
		mod:Destroy()
	end
end

end


modifier_conjure_image_legendary_aura_damage_count = class({})
function modifier_conjure_image_legendary_aura_damage_count:IsHidden() return false end
function modifier_conjure_image_legendary_aura_damage_count:IsPurgable() return false end
function modifier_conjure_image_legendary_aura_damage_count:GetTexture() return "buffs/illusion_burn" end

function modifier_conjure_image_legendary_aura_damage_count:OnCreated(table)
if not IsServer() then return end
self:SetStackCount(1)
self:StartIntervalThink(self:GetAbility().burn_interval)

end

function modifier_conjure_image_legendary_aura_damage_count:OnIntervalThink()
if not IsServer() then return end

self.damage = self:GetStackCount()*self:GetAbility().burn_interval*self:GetCaster():GetAgility()*(self:GetAbility().burn_agility_init + self:GetAbility().burn_agility_inc*self:GetCaster():GetUpgradeStack("modifier_terror_illusion_stack"))

ApplyDamage({victim = self:GetParent(), attacker = self:GetCaster(), ability = self:GetAbility(), damage = self.damage, damage_type = DAMAGE_TYPE_MAGICAL})
end



function modifier_conjure_image_legendary_aura_damage_count:OnRefresh(table)
if not IsServer() then return end
self:IncrementStackCount()
end

function modifier_conjure_image_legendary_aura_damage_count:GetEffectName()
	return "particles/units/heroes/heroes_underlord/abyssal_underlord_firestorm_wave_burn.vpcf"
end

function modifier_conjure_image_legendary_aura_damage_count:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end


modifier_conjure_image_legendary_legendary_cd = class({})
function modifier_conjure_image_legendary_legendary_cd:IsHidden() return false end
function modifier_conjure_image_legendary_legendary_cd:IsPurgable() return false end
function modifier_conjure_image_legendary_legendary_cd:RemoveOnDeath() return false end
function modifier_conjure_image_legendary_legendary_cd:IsDebuff() return true end
