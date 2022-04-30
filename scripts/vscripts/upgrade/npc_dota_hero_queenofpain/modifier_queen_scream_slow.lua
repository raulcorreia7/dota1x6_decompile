

modifier_queen_Scream_slow = class({})


function modifier_queen_Scream_slow:IsHidden() return true end
function modifier_queen_Scream_slow:IsPurgable() return false end



function modifier_queen_Scream_slow:OnCreated(table)
if not IsServer() then return end
  self:SetStackCount(1)
   self.StackOnIllusion = true 
end


function modifier_queen_Scream_slow:OnRefresh(table)
if not IsServer() then return end
  self:SetStackCount(self:GetStackCount()+1)
  
end

function modifier_queen_Scream_slow:RemoveOnDeath() return false end