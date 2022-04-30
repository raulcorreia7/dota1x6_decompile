

modifier_up_magicresist = class({})


function modifier_up_magicresist:IsHidden() return true end
function modifier_up_magicresist:IsPurgable() return false end


function modifier_up_magicresist:DeclareFunctions()
    return {

         MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS

    } end

function modifier_up_magicresist:OnCreated(table)
if not IsServer() then return end
  self:SetStackCount(1)
   self.StackOnIllusion = true 
end


function modifier_up_magicresist:OnRefresh(table)
if not IsServer() then return end
  self:SetStackCount(self:GetStackCount()+1)
  
end

function modifier_up_magicresist:GetModifierMagicalResistanceBonus() return 6*self:GetStackCount()*(1+0.2*self:GetParent():GetUpgradeStack("modifier_up_graypoints")) end


function modifier_up_magicresist:RemoveOnDeath() return false end