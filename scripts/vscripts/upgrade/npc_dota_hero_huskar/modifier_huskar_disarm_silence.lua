

modifier_huskar_disarm_silence = class({})


function modifier_huskar_disarm_silence:IsHidden() return true end
function modifier_huskar_disarm_silence:IsPurgable() return false end



function modifier_huskar_disarm_silence:OnCreated(table)
if not IsServer() then return end
  self:SetStackCount(1)
   self.StackOnIllusion = true 
end


function modifier_huskar_disarm_silence:OnRefresh(table)
if not IsServer() then return end
  self:SetStackCount(self:GetStackCount()+1)
  
end

function modifier_huskar_disarm_silence:RemoveOnDeath() return false end