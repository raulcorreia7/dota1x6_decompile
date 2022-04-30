LinkLuaModifier("modifier_boar_passive", "abilities/npc_boar_slow", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_boar_slow_debuf", "abilities/npc_boar_slow", LUA_MODIFIER_MOTION_NONE)

npc_boar_slow = class({})

function npc_boar_slow:GetIntrinsicModifierName() return "modifier_boar_passive" end

modifier_boar_passive = class ({})

function modifier_boar_passive:IsHidden() return true end
function modifier_boar_passive:IsPurgable()
 return false end
function modifier_boar_passive:DeclareFunctions() return {

    MODIFIER_EVENT_ON_ATTACK_LANDED

} end

function modifier_boar_passive:OnAttackLanded( param )
    if not IsServer() then end 
    if self:GetParent() == param.attacker and not param.target:IsMagicImmune()  then
    
            local duration = self:GetAbility():GetSpecialValueFor("duration")
            param.target:AddNewModifier(param.attacker, self:GetAbility(), "modifier_boar_slow_debuf", { duration = duration*(1 - param.target:GetStatusResistance()) })  
   
    end
end



modifier_boar_slow_debuf = class ({})

function modifier_boar_slow_debuf:IsHidden() return false end

function modifier_boar_slow_debuf:IsPurgable() return false end

function modifier_boar_slow_debuf:OnCreated(table)
    self.slow = -self:GetAbility():GetSpecialValueFor("slow")

end



function modifier_boar_slow_debuf:DeclareFunctions()
    return {
        MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
        MODIFIER_PROPERTY_TOOLTIP
    }
 end

 function modifier_boar_slow_debuf:GetTexture() return "beastmaster_boar_poison" end

function modifier_boar_slow_debuf:GetModifierMoveSpeedBonus_Percentage() return self.slow  end


 function modifier_boar_slow_debuf:OnTooltip() return self:GetAbility():GetSpecialValueFor("slow") end