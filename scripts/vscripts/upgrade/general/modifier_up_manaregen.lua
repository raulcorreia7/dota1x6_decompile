

modifier_up_manaregen = class({})

function modifier_up_manaregen:IsHidden() return true end
function modifier_up_manaregen:IsPurgable() return false end


function modifier_up_manaregen:DeclareFunctions()
    return {

        MODIFIER_PROPERTY_MANA_REGEN_CONSTANT

    } end

function modifier_up_manaregen:OnCreated(table)
if not IsServer() then return end
  self:SetStackCount(1)
   self.StackOnIllusion = true 
end


function modifier_up_manaregen:OnRefresh(table)
if not IsServer() then return end
  self:SetStackCount(self:GetStackCount()+1)
  
end

function modifier_up_manaregen:GetModifierConstantManaRegen() return 2*self:GetStackCount()*(1+0.2*self:GetParent():GetUpgradeStack("modifier_up_graypoints")) end

function modifier_up_manaregen:RemoveOnDeath() return false end