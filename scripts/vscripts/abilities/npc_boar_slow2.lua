LinkLuaModifier("modifier_boar_passive2", "abilities/npc_boar_slow2", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_boar_slow_debuf2", "abilities/npc_boar_slow2", LUA_MODIFIER_MOTION_NONE)

npc_boar_slow2 = class({})

function npc_boar_slow2:GetIntrinsicModifierName() return "modifier_boar_passive2" end

modifier_boar_passive2 = class ({})

function modifier_boar_passive2:IsHidden() return true end
function modifier_boar_passive2:IsPurgable()
 return false end
function modifier_boar_passive2:DeclareFunctions() return {

    MODIFIER_EVENT_ON_ATTACK_LANDED

} end

function modifier_boar_passive2:OnAttackLanded( param )
    if not IsServer() then end 
    if self:GetParent() == param.attacker and not param.target:IsMagicImmune()  then
    
            local duration = self:GetAbility():GetSpecialValueFor("duration")
            param.target:AddNewModifier(param.attacker, self:GetAbility(), "modifier_boar_slow_debuf2", { duration = duration*(1 - param.target:GetStatusResistance()) })  
   
    end
end



modifier_boar_slow_debuf2 = class ({})

function modifier_boar_slow_debuf2:IsHidden() return false end

function modifier_boar_slow_debuf2:IsPurgable() return false end

function modifier_boar_slow_debuf2:OnCreated(table)
    self.slow = -self:GetAbility():GetSpecialValueFor("slow")

end



function modifier_boar_slow_debuf2:DeclareFunctions()
    return {
        MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
        MODIFIER_PROPERTY_TOOLTIP
    }
 end

 function modifier_boar_slow_debuf2:GetTexture() return "beastmaster_boar_poison" end

function modifier_boar_slow_debuf2:GetModifierMoveSpeedBonus_Percentage() return self.slow  end


 function modifier_boar_slow_debuf2:OnTooltip() return self:GetAbility():GetSpecialValueFor("slow") end