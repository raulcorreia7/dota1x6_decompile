LinkLuaModifier("modifier_npc_necro_range_passive", "abilities/npc_necro_range_passive", LUA_MODIFIER_MOTION_NONE)

npc_necro_range_passive = class({})

function npc_necro_range_passive:GetIntrinsicModifierName() 
return "modifier_npc_necro_range_passive"
end

modifier_npc_necro_range_passive = class({})

function modifier_npc_necro_range_passive:IsHidden() return true end
function modifier_npc_necro_range_passive:IsPurgable() return false end

function modifier_npc_necro_range_passive:OnCreated(table)
if not IsServer() then return end

self.mana = self:GetAbility():GetSpecialValueFor("mana")

end



function modifier_npc_necro_range_passive:CheckState()
return
{
    [MODIFIER_STATE_CANNOT_MISS] = true
}
end

function modifier_npc_necro_range_passive:DeclareFunctions()
return
{
    MODIFIER_EVENT_ON_ATTACK_LANDED
}

end

function modifier_npc_necro_range_passive:OnAttackLanded(params)
if not IsServer() then return end
if self:GetParent() ~= params.attacker then return end
if params.target:IsBuilding() or params.target:IsMagicImmune() then return end

--params.target:EmitSound("n_creep_SatyrSoulstealer.ManaBurn")

local effect = ParticleManager:CreateParticle( "particles/generic_gameplay/generic_manaburn.vpcf", PATTACH_ABSORIGIN_FOLLOW, params.target)

params.target:SpendMana(self.mana, self:GetAbility())


end