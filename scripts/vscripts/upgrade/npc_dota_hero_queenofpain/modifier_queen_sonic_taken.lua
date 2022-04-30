

modifier_queen_Sonic_taken = class({})


function modifier_queen_Sonic_taken:IsHidden() return true end
function modifier_queen_Sonic_taken:IsPurgable() return false end



function modifier_queen_Sonic_taken:OnCreated(table)
if not IsServer() then return end
  self:SetStackCount(1)
   self.StackOnIllusion = true 
end


function modifier_queen_Sonic_taken:OnRefresh(table)
if not IsServer() then return end
  self:SetStackCount(self:GetStackCount()+1)
  
end

function modifier_queen_Sonic_taken:RemoveOnDeath() return false end