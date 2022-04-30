

modifier_queen_Sonic_legendary = class({})


function modifier_queen_Sonic_legendary:IsHidden() return true end
function modifier_queen_Sonic_legendary:IsPurgable() return false end



function modifier_queen_Sonic_legendary:OnCreated(table)
if not IsServer() then return end
  self:SetStackCount(1)
   self.StackOnIllusion = true 
end


function modifier_queen_Sonic_legendary:OnRefresh(table)
if not IsServer() then return end
  self:SetStackCount(self:GetStackCount()+1)
  
end

function modifier_queen_Sonic_legendary:RemoveOnDeath() return false end