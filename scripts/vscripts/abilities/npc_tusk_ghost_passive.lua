LinkLuaModifier("modifier_tusk_ghost_passive", "abilities/npc_tusk_ghost_passive.lua", LUA_MODIFIER_MOTION_NONE)

npc_tusk_ghost_passive = class({})


function npc_tusk_ghost_passive:GetIntrinsicModifierName() return "modifier_tusk_ghost_passive" end
 
modifier_tusk_ghost_passive = class ({})

function modifier_tusk_ghost_passive:IsHidden() return true end

function modifier_tusk_ghost_passive:CheckState() return {[MODIFIER_STATE_CANNOT_MISS] = true } end

function modifier_tusk_ghost_passive:DeclareFunctions() return {

   MODIFIER_EVENT_ON_ATTACK_LANDED

} end

function modifier_tusk_ghost_passive:OnCreated()	
    if not IsServer() then return end
self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_phased", {})
self:StartIntervalThink(1)
self.timer = 0
self.live = self:GetAbility():GetSpecialValueFor("live")
end



function modifier_tusk_ghost_passive:OnIntervalThink()
	self.timer = self.timer + 1
	if self.timer == self.live then
   		self:GetParent():RemoveModifierByName("modifier_invulnerable")
   		ApplyDamage({ victim = self:GetParent(), attacker = self:GetCaster(), ability = self, damage = 10, damage_type = DAMAGE_TYPE_PURE})
	end
end

function modifier_tusk_ghost_passive:OnAttackLanded( param )
if not IsServer() then end 
   if self:GetParent() == param.attacker  then
   	self:GetParent():RemoveModifierByName("modifier_invulnerable")
   	ApplyDamage({ victim = param.attacker, attacker = self:GetCaster(), ability = self, damage = 10, damage_type = DAMAGE_TYPE_PURE})

    if not param.target:IsMagicImmune() then 

      param.target:EmitSound("Ability.FrostNova")
	local particle = ParticleManager:CreateParticle( "particles/econ/items/lich/frozen_chains_ti6/lich_frozenchains_frostnova.vpcf", PATTACH_ABSORIGIN_FOLLOW, param.target )
           ParticleManager:ReleaseParticleIndex( particle )
   	local damage = self:GetAbility():GetSpecialValueFor("damage")
   	if param.target:IsBuilding() then damage = self:GetAbility():GetSpecialValueFor("tower_damage") end
   	damage = param.target:GetMaxHealth() * (damage / 100)
   	local duration = self:GetAbility():GetSpecialValueFor("duration")

   	param.target:AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_stunned", {duration = duration*(1 - param.target:GetStatusResistance())})
   	ApplyDamage({ victim = param.target, attacker = self:GetCaster(), ability = self, damage = damage, damage_type = DAMAGE_TYPE_MAGICAL})
   end

   end
end

