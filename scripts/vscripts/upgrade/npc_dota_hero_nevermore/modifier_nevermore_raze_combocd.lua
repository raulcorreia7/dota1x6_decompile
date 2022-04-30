

modifier_nevermore_raze_combocd = class({})


function modifier_nevermore_raze_combocd:IsHidden() return true end
function modifier_nevermore_raze_combocd:IsPurgable() return false end



function modifier_nevermore_raze_combocd:OnCreated(table)
if not IsServer() then return end
  self:SetStackCount(1)
   self.StackOnIllusion = true 
end


function modifier_nevermore_raze_combocd:OnRefresh(table)
if not IsServer() then return end
  self:SetStackCount(self:GetStackCount()+1)
  
end

function modifier_nevermore_raze_combocd:RemoveOnDeath() return false end