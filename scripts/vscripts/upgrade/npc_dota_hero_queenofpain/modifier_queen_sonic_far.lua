

modifier_queen_Sonic_far = class({})


function modifier_queen_Sonic_far:IsHidden() return true end
function modifier_queen_Sonic_far:IsPurgable() return false end



function modifier_queen_Sonic_far:OnCreated(table)
if not IsServer() then return end
  self:SetStackCount(1)
   self.StackOnIllusion = true 
end


function modifier_queen_Sonic_far:OnRefresh(table)
if not IsServer() then return end
  self:SetStackCount(self:GetStackCount()+1)
  
end

function modifier_queen_Sonic_far:RemoveOnDeath() return false end