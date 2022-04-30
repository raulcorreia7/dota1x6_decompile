LinkLuaModifier("modifier_lizard_mkb", "abilities/neutral_lizard_mkb", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_lizard_mkb_buf", "abilities/neutral_lizard_mkb", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_lizard_mkb_break", "abilities/neutral_lizard_mkb", LUA_MODIFIER_MOTION_NONE)



neutral_lizard_mkb = class({})

function neutral_lizard_mkb:GetIntrinsicModifierName() return "modifier_lizard_mkb" end 


modifier_lizard_mkb = class({})

function modifier_lizard_mkb:IsPurgable() return false end

function modifier_lizard_mkb:IsHidden() return true end
 

function modifier_lizard_mkb:DeclareFunctions()
return
{
	MODIFIER_EVENT_ON_ATTACK_LANDED
}
end

function modifier_lizard_mkb:OnAttackLanded(params)
if not IsServer() then return end
if params.attacker ~= self:GetParent() then return end 
if params.target:IsMagicImmune() then return end

local duration = self:GetAbility():GetSpecialValueFor("break_duration")
local chance = self:GetAbility():GetSpecialValueFor("chance")

local random = RollPseudoRandomPercentage(chance,1,self:GetParent())

if not random then return end

params.target:EmitSound("Lizard.Break")
params.target:AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_lizard_mkb_break", {duration = duration*(1 - params.target:GetStatusResistance())})
end


modifier_lizard_mkb_break = class({})
function modifier_lizard_mkb_break:IsHidden() return false end
function modifier_lizard_mkb_break:IsPurgable() return false end
function modifier_lizard_mkb_break:CheckState()
return
{
	[MODIFIER_STATE_PASSIVES_DISABLED] = true 
}

end
function modifier_lizard_mkb_break:GetEffectName() return "particles/generic_gameplay/generic_break.vpcf" end
function modifier_lizard_mkb_break:GetEffectAttachType() return PATTACH_OVERHEAD_FOLLOW end