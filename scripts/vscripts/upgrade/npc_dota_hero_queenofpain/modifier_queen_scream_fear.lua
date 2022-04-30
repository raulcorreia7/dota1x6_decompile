
modifier_queen_Scream_fear = class({})


function modifier_queen_Scream_fear:IsHidden() return true end
function modifier_queen_Scream_fear:IsPurgable() return false end



function modifier_queen_Scream_fear:OnCreated(table)
if not IsServer() then return end
  self:SetStackCount(1)
   self.StackOnIllusion = true 
end


function modifier_queen_Scream_fear:OnRefresh(table)
if not IsServer() then return end
  self:SetStackCount(self:GetStackCount()+1)
  
end

function modifier_queen_Scream_fear:RemoveOnDeath() return false end