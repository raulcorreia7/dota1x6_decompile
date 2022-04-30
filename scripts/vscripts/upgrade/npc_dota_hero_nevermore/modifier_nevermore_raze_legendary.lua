

modifier_nevermore_raze_legendary = class({})


function modifier_nevermore_raze_legendary:IsHidden() return true end
function modifier_nevermore_raze_legendary:IsPurgable() return false end



function modifier_nevermore_raze_legendary:OnCreated(table)
if not IsServer() then return end
  self:SetStackCount(1)
   self.StackOnIllusion = true 
end


function modifier_nevermore_raze_legendary:OnRefresh(table)
if not IsServer() then return end
  self:SetStackCount(self:GetStackCount()+1)
  
end

function modifier_nevermore_raze_legendary:RemoveOnDeath() return false end