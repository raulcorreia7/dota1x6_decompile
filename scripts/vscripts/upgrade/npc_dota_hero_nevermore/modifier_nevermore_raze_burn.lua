

modifier_nevermore_raze_burn = class({})


function modifier_nevermore_raze_burn:IsHidden() return true end
function modifier_nevermore_raze_burn:IsPurgable() return false end



function modifier_nevermore_raze_burn:OnCreated(table)
if not IsServer() then return end
  self:SetStackCount(1)
   self.StackOnIllusion = true 
end


function modifier_nevermore_raze_burn:OnRefresh(table)
if not IsServer() then return end
  self:SetStackCount(self:GetStackCount()+1)
  
end

function modifier_nevermore_raze_burn:RemoveOnDeath() return false end