

modifier_up_speed = class({})


function modifier_up_speed:IsHidden() return true end
function modifier_up_speed:IsPurgable() return false end

function modifier_up_speed:DeclareFunctions()
    return {

         MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT

    } end

function modifier_up_speed:OnCreated(table)
if not IsServer() then return end
  self:SetStackCount(1)
   self.StackOnIllusion = true 
end


function modifier_up_speed:OnRefresh(table)
if not IsServer() then return end
  self:SetStackCount(self:GetStackCount()+1)
  
end

function modifier_up_speed:GetModifierAttackSpeedBonus_Constant() return 12*self:GetStackCount()*(1+0.2*self:GetParent():GetUpgradeStack("modifier_up_graypoints")) end


function modifier_up_speed:RemoveOnDeath() return false end