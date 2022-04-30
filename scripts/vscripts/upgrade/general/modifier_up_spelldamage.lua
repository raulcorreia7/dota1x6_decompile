

modifier_up_spelldamage = class({})


function modifier_up_spelldamage:IsHidden() return true end
function modifier_up_spelldamage:IsPurgable() return false end


function modifier_up_spelldamage:DeclareFunctions()
    return {

        MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE

    } end

function modifier_up_spelldamage:OnCreated(table)
if not IsServer() then return end
  self:SetStackCount(1)
   self.StackOnIllusion = true 
end


function modifier_up_spelldamage:OnRefresh(table)
if not IsServer() then return end
  self:SetStackCount(self:GetStackCount()+1)
  
end

function modifier_up_spelldamage:GetModifierSpellAmplify_Percentage() return 3*self:GetStackCount()*(1+0.2*self:GetParent():GetUpgradeStack("modifier_up_graypoints")) end


function modifier_up_spelldamage:RemoveOnDeath() return false end