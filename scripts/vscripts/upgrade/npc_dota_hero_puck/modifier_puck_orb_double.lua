

modifier_puck_orb_double = class({})


function modifier_puck_orb_double:IsHidden() return true end
function modifier_puck_orb_double:IsPurgable() return false end



function modifier_puck_orb_double:OnCreated(table)
if not IsServer() then return end
  self:SetStackCount(1)

end


function modifier_puck_orb_double:OnRefresh(table)
if not IsServer() then return end
  self:SetStackCount(self:GetStackCount()+1)
  
end

function modifier_puck_orb_double:RemoveOnDeath() return false end