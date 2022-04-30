LinkLuaModifier("modifier_up_slow_debuff", "upgrade/general/modifier_up_slow", LUA_MODIFIER_MOTION_NONE)

modifier_up_slow = class({})



function modifier_up_slow:IsHidden() return true end
function modifier_up_slow:IsPurgable() return false end


function modifier_up_slow:DeclareFunctions()
    return {

        MODIFIER_EVENT_ON_ATTACK_LANDED

    } end



function modifier_up_slow:OnCreated(table)
if not IsServer() then return end
  self:SetStackCount(1)
end


function modifier_up_slow:OnRefresh(table)
if not IsServer() then return end
  self:SetStackCount(self:GetStackCount()+1)
  
end



function modifier_up_slow:OnAttackLanded( param )

    if self:GetParent() == param.attacker then 
       local random = RollPseudoRandomPercentage(20,100,self:GetParent())
          if random  then 
            param.target:AddNewModifier(param.attacker, self:GetAbility(), "modifier_up_slow_debuff", { duration = 5*(1-param.target:GetStatusResistance()) , stacks = self:GetStackCount()})
         
        end
    end


end



function modifier_up_slow:RemoveOnDeath() return false end

modifier_up_slow_debuff = class({})

function modifier_up_slow_debuff:IsPurgable() return true end


function modifier_up_slow_debuff:OnCreated(table)
  
if not IsServer() then return end
  
  self:SetHasCustomTransmitterData(true)

  self:GetParent():EmitSound("DOTA_Item.Maim")
  self.slow = table.stacks*(-15)

end


function modifier_up_slow_debuff:AddCustomTransmitterData() return {
slow = self.slow,


} end

function modifier_up_slow_debuff:HandleCustomTransmitterData(data)
self.slow = data.slow
end

function modifier_up_slow_debuff:DeclareFunctions()
    return {

        MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
          MODIFIER_PROPERTY_TOOLTIP
}
end
 

function modifier_up_slow_debuff:GetTexture() return "buffs/Penta-Edged_Sword" end

function modifier_up_slow_debuff:OnTooltip()
return self.slow
end
    



function modifier_up_slow_debuff:GetModifierMoveSpeedBonus_Percentage() return self.slow end


