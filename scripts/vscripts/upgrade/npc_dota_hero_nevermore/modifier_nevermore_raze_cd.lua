

modifier_nevermore_raze_cd = class({})


function modifier_nevermore_raze_cd:IsHidden() return true end
function modifier_nevermore_raze_cd:IsPurgable() return false end



function modifier_nevermore_raze_cd:OnCreated(table)
if not IsServer() then return end
  self:SetStackCount(1)
   self.StackOnIllusion = true 
end


function modifier_nevermore_raze_cd:OnRefresh(table)
if not IsServer() then return end
  self:SetStackCount(self:GetStackCount()+1)
  
end

function modifier_nevermore_raze_cd:RemoveOnDeath() return false end