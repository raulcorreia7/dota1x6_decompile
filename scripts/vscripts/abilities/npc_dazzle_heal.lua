LinkLuaModifier("modifier_dazzle_passive", "abilities/npc_dazzle_heal.lua", LUA_MODIFIER_MOTION_NONE)

npc_dazzle_heal = class({})


function npc_dazzle_heal:GetIntrinsicModifierName() return "modifier_dazzle_passive" end
 
modifier_dazzle_passive = class ({})

function modifier_dazzle_passive:IsHidden() return true end

function modifier_dazzle_passive:DeclareFunctions() return {

    MODIFIER_EVENT_ON_ATTACK_LANDED

} end

function modifier_dazzle_passive:OnAttackLanded( params ) 
    if not IsServer() then end 
    if params.attacker:GetTeam() == self:GetParent():GetTeam() and self:GetParent():IsAlive()
    and (self:GetParent():GetAbsOrigin() - params.attacker:GetAbsOrigin() ):Length2D() <= self:GetAbility():GetSpecialValueFor("radius")  then
        local heal = self:GetAbility():GetSpecialValueFor("heal")
        params.attacker:Heal(params.attacker:GetMaxHealth()*heal/100, self:GetParent())
              local particle = ParticleManager:CreateParticle( "particles/generic_gameplay/generic_lifesteal.vpcf", PATTACH_ABSORIGIN_FOLLOW, params.attacker)
        ParticleManager:ReleaseParticleIndex( particle )
       
    end

end

