LinkLuaModifier("modifier_up_statusresist_stack", "upgrade/general/modifier_up_statusresist", LUA_MODIFIER_MOTION_NONE)

modifier_up_statusresist = class({})


function modifier_up_statusresist:IsHidden() return true end
function modifier_up_statusresist:IsPurgable() return false end


function modifier_up_statusresist:OnCreated(table)
if not IsServer() then return end
  self:SetStackCount(1)
   self:GetParent():AddNewModifier(self:GetParent(), nil, "modifier_up_statusresist_stack", {})
end


function modifier_up_statusresist:OnRefresh(table)
if not IsServer() then return end
  self:SetStackCount(self:GetStackCount()+1)
   self:GetParent():AddNewModifier(self:GetParent(), nil, "modifier_up_statusresist_stack", {})
  
end




function modifier_up_statusresist:RemoveOnDeath() return false end





modifier_up_statusresist_stack = class({})


function modifier_up_statusresist_stack:IsHidden() return true end
function modifier_up_statusresist_stack:IsPurgable() return false end
function modifier_up_statusresist_stack:RemoveOnDeath() return false end

function modifier_up_statusresist_stack:OnCreated(table)

   self.StackOnIllusion = true 
end

function modifier_up_statusresist_stack:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end

function modifier_up_statusresist_stack:DeclareFunctions()
    return {

         MODIFIER_PROPERTY_STATUS_RESISTANCE_STACKING

    } end

function modifier_up_statusresist_stack:GetModifierStatusResistanceStacking() return 5*(1+0.2*self:GetParent():GetUpgradeStack("modifier_up_graypoints")) end
