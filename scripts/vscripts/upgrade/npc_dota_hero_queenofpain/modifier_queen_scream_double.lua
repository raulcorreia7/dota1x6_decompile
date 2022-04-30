

modifier_queen_Scream_double = class({})


function modifier_queen_Scream_double:IsHidden() return true end
function modifier_queen_Scream_double:IsPurgable() return false end



function modifier_queen_Scream_double:OnCreated(table)
if not IsServer() then return end
  self:SetStackCount(1)
   self.StackOnIllusion = true 
end


function modifier_queen_Scream_double:OnRefresh(table)
if not IsServer() then return end
  self:SetStackCount(self:GetStackCount()+1)
  
end

function modifier_queen_Scream_double:RemoveOnDeath() return false end