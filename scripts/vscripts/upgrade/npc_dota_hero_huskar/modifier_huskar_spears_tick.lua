

modifier_huskar_spears_tick = class({})


function modifier_huskar_spears_tick:IsHidden() return true end
function modifier_huskar_spears_tick:IsPurgable() return false end



function modifier_huskar_spears_tick:OnCreated(table)
if not IsServer() then return end
  self:SetStackCount(1)
   self.StackOnIllusion = true
end


function modifier_huskar_spears_tick:OnRefresh(table)
if not IsServer() then return end
  self:SetStackCount(self:GetStackCount()+1)
  
end

function modifier_huskar_spears_tick:RemoveOnDeath() return false end