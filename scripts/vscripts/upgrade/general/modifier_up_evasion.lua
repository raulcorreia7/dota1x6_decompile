

modifier_up_evasion = class({})

function modifier_up_evasion:IsHidden() return true end
function modifier_up_evasion:IsPurgable() return false end


function modifier_up_evasion:DeclareFunctions()
    return {

        MODIFIER_PROPERTY_EVASION_CONSTANT

    } end

function modifier_up_evasion:OnCreated(table)
if not IsServer() then return end
  self:SetStackCount(1)
   self.StackOnIllusion = true 
end


function modifier_up_evasion:OnRefresh(table)
if not IsServer() then return end
  self:SetStackCount(self:GetStackCount()+1)
  
end

function modifier_up_evasion:GetModifierEvasion_Constant() return 6*self:GetStackCount()*(1+0.2*self:GetParent():GetUpgradeStack("modifier_up_graypoints")) end


function modifier_up_evasion:RemoveOnDeath() return false end
  