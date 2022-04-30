

modifier_queen_Scream_shield = class({})


function modifier_queen_Scream_shield:IsHidden() return true end
function modifier_queen_Scream_shield:IsPurgable() return false end



function modifier_queen_Scream_shield:OnCreated(table)
if not IsServer() then return end
  self:SetStackCount(1)
   self.StackOnIllusion = true 
end


function modifier_queen_Scream_shield:OnRefresh(table)
if not IsServer() then return end
  self:SetStackCount(self:GetStackCount()+1)
  
end

function modifier_queen_Scream_shield:RemoveOnDeath() return false end