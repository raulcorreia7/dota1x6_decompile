
modifier_up_cooldown = class({})


function modifier_up_cooldown:IsHidden() return true end
function modifier_up_cooldown:IsPurgable() return false end
function modifier_up_cooldown:RemoveOnDeath() return false end


function modifier_up_cooldown:OnCreated(table)
if not IsServer() then return end
  self:SetStackCount(1)
   self.StackOnIllusion = true 
end


function modifier_up_cooldown:OnRefresh(table)
if not IsServer() then return end
  self:SetStackCount(self:GetStackCount()+1)
end



function modifier_up_cooldown:DeclareFunctions()
    return {

         MODIFIER_PROPERTY_COOLDOWN_PERCENTAGE

    } end


 function modifier_up_cooldown:GetModifierPercentageCooldown() return 5*self:GetStackCount()
  end
   

