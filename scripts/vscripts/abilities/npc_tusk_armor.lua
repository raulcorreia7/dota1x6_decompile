LinkLuaModifier("modifier_tusk_armor", "abilities/npc_tusk_armor", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_tusk_slow", "abilities/npc_tusk_armor", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_tusk_cd", "abilities/npc_tusk_armor", LUA_MODIFIER_MOTION_NONE)

modifier_tusk_cdnpc_tusk_armor = class({})

function npc_tusk_armor:OnAbilityPhaseStart()
    self:GetCaster():StartGesture(ACT_DOTA_CAST_ABILITY_3)
       return true
end 


function npc_tusk_armor:OnSpellStart()

    
if not IsServer() then return end
 self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_tusk_cd", {duration = self:GetCooldownTimeRemaining()})
        local duration = self:GetSpecialValueFor("duration")
        
        self:GetCursorTarget():AddNewModifier(self:GetCaster(), self, "modifier_tusk_armor", {duration = duration})
end

function npc_tusk_armor:OnAbilityPhaseInterrupted()
    self:GetCaster():RemoveGesture(ACT_DOTA_CAST_ABILITY_3)
end


modifier_tusk_armor = class ({})

function modifier_tusk_armor:IsHidden() return false end

function modifier_tusk_armor:IsPurgable() return true end

function modifier_tusk_armor:GetTexture() return "lich_frost_armor" end

function modifier_tusk_armor:DeclareFunctions() return
    {

    MODIFIER_EVENT_ON_ATTACK_LANDED
    }
end

function modifier_tusk_armor:OnAttackLanded( param ) 
if not IsServer() then return end
    if self:GetParent() == param.target and not param.attacker:IsMagicImmune() then
        local duration_slow = self:GetAbility():GetSpecialValueFor("duration_slow")
        param.attacker:AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_tusk_slow", {duration = duration_slow})
    end

end

function modifier_tusk_armor:GetEffectName() return "particles/neutral_fx/ogre_magi_frost_armor.vpcf" end
 
function modifier_tusk_armor:GetEffectAttachType() return PATTACH_OVERHEAD_FOLLOW end

modifier_tusk_slow = class({})

function modifier_tusk_slow:IsHidden() return false end

function modifier_tusk_slow:IsPurgable() return true end

function modifier_tusk_slow:OnCreated(table)
    self.slow = self:GetAbility():GetSpecialValueFor("slow")
    self.max_stack = self:GetAbility():GetSpecialValueFor("max_stacks")

     if not IsServer() then return end

    self:SetStackCount(1)
   
end

function modifier_tusk_slow:OnRefresh(table)
if not IsServer() then return end
 if self:GetStackCount() < self.max_stack then
    self:SetStackCount(self:GetStackCount() + 1)
end

end

function modifier_tusk_slow:DeclareFunctions() return
    {

        MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE 
    }
 end

 function modifier_tusk_slow:GetTexture() return "lich_frost_armor" end

function modifier_tusk_slow:GetModifierMoveSpeedBonus_Percentage() return -(self.slow * self:GetStackCount()) end


modifier_tusk_cd = class({})
function modifier_tusk_cd:IsHidden() return false end
function modifier_tusk_cd:IsPurgable() return false end