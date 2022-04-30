LinkLuaModifier("modifier_roshan_clap_silence", "abilities/npc_roshan_clap", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_roshan_clap_cd", "abilities/npc_roshan_clap", LUA_MODIFIER_MOTION_NONE)

npc_roshan_clap = class({})


function npc_roshan_clap:OnSpellStart()
if not IsServer() then return end

self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_roshan_clap_cd", {duration = self:GetCooldownTimeRemaining()})

self.damage = self:GetSpecialValueFor("damage")/100
self.radius = self:GetSpecialValueFor("radius")

self:GetCaster():EmitSound("Roshan.Slam")

local particle_peffect = ParticleManager:CreateParticle("particles/neutral_fx/roshan_slam.vpcf", PATTACH_ABSORIGIN, self:GetCaster())	
ParticleManager:SetParticleControl(particle_peffect, 0, self:GetCaster():GetAbsOrigin())
ParticleManager:SetParticleControl(particle_peffect, 1, Vector(self.radius,0,0))
ParticleManager:ReleaseParticleIndex(particle_peffect)

local enemies_hero = FindUnitsInRadius(self:GetCaster():GetTeamNumber(),self:GetCaster():GetAbsOrigin(),nil, self.radius ,DOTA_UNIT_TARGET_TEAM_ENEMY,DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_NONE,FIND_ANY_ORDER,false)

for _,enemy in pairs(enemies_hero) do

	local damage = self.damage*enemy:GetMaxHealth()
	
	if enemy:IsIllusion() then 
		damage = damage*self:GetSpecialValueFor("illusion")
	end

	local damageTable = {victim = enemy,  damage = damage, damage_type = DAMAGE_TYPE_MAGICAL, attacker = self:GetCaster(), ability = self}
	local actualy_damage = ApplyDamage(damageTable)
	enemy:AddNewModifier(self:GetCaster(), self, "modifier_roshan_clap_silence", {duration = (1 - enemy:GetStatusResistance())*self:GetSpecialValueFor("duration")})
end


end


modifier_roshan_clap_silence = class({})

function modifier_roshan_clap_silence:IsHidden() return false end
function modifier_roshan_clap_silence:IsPurgable() return true end
function modifier_roshan_clap_silence:CheckState() return {[MODIFIER_STATE_SILENCED] = true} end

function modifier_roshan_clap_silence:GetEffectName() return "particles/generic_gameplay/generic_silenced.vpcf" end
 
function modifier_roshan_clap_silence:GetEffectAttachType() return PATTACH_OVERHEAD_FOLLOW end



modifier_roshan_clap_cd = class({})
function modifier_roshan_clap_cd:IsHidden() return false end
function modifier_roshan_clap_cd:IsPurgable() return true end