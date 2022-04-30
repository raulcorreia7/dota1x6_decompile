

modifier_nevermore_raze_speed = class({})


function modifier_nevermore_raze_speed:IsHidden() return true end
function modifier_nevermore_raze_speed:IsPurgable() return false end



function modifier_nevermore_raze_speed:OnCreated(table)
if not IsServer() then return end
  self:SetStackCount(1)
   self.StackOnIllusion = true 
end


function modifier_nevermore_raze_speed:OnRefresh(table)
if not IsServer() then return end
  self:SetStackCount(self:GetStackCount()+1)
  
end

function modifier_nevermore_raze_speed:RemoveOnDeath() return false end