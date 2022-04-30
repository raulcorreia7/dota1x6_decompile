

modifier_queen_Sonic_reduce = class({})


function modifier_queen_Sonic_reduce:IsHidden() return true end
function modifier_queen_Sonic_reduce:IsPurgable() return false end



function modifier_queen_Sonic_reduce:OnCreated(table)
if not IsServer() then return end
  self:SetStackCount(1)
   self.StackOnIllusion = true 
end


function modifier_queen_Sonic_reduce:OnRefresh(table)
if not IsServer() then return end
  self:SetStackCount(self:GetStackCount()+1)
  
end

function modifier_queen_Sonic_reduce:RemoveOnDeath() return false end