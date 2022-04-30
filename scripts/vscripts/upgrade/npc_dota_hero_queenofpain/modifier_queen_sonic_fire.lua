

modifier_queen_Sonic_fire = class({})


function modifier_queen_Sonic_fire:IsHidden() return true end
function modifier_queen_Sonic_fire:IsPurgable() return false end



function modifier_queen_Sonic_fire:OnCreated(table)
if not IsServer() then return end
  self:SetStackCount(1)
   self.StackOnIllusion = true 
end


function modifier_queen_Sonic_fire:OnRefresh(table)
if not IsServer() then return end
  self:SetStackCount(self:GetStackCount()+1)
  
end

function modifier_queen_Sonic_fire:RemoveOnDeath() return false end