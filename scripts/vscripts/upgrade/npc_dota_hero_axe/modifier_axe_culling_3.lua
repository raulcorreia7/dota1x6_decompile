

modifier_axe_culling_3 = class({})


function modifier_axe_culling_3:IsHidden() return true end
function modifier_axe_culling_3:IsPurgable() return false end



function modifier_axe_culling_3:OnCreated(table)
if not IsServer() then return end
  self:SetStackCount(1)
end


function modifier_axe_culling_3:OnRefresh(table)
if not IsServer() then return end
  self:SetStackCount(self:GetStackCount()+1)
  
end

function modifier_axe_culling_3:RemoveOnDeath() return false end