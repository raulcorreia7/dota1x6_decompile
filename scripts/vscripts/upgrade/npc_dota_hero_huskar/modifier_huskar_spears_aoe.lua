

modifier_huskar_spears_aoe = class({})


function modifier_huskar_spears_aoe:IsHidden() return true end
function modifier_huskar_spears_aoe:IsPurgable() return false end



function modifier_huskar_spears_aoe:OnCreated(table)
if not IsServer() then return end
  self:SetStackCount(1)
   self.StackOnIllusion = true 
end


function modifier_huskar_spears_aoe:OnRefresh(table)
if not IsServer() then return end
  self:SetStackCount(self:GetStackCount()+1)
  
end

function modifier_huskar_spears_aoe:RemoveOnDeath() return false end