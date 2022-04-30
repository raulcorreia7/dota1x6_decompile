

modifier_bristle_warpath_damage = class({})


function modifier_bristle_warpath_damage:IsHidden() return true end
function modifier_bristle_warpath_damage:IsPurgable() return false end



function modifier_bristle_warpath_damage:OnCreated(table)
if not IsServer() then return end
  self:SetStackCount(1)
end


function modifier_bristle_warpath_damage:OnRefresh(table)
if not IsServer() then return end
  self:SetStackCount(self:GetStackCount()+1)
  
end

function modifier_bristle_warpath_damage:RemoveOnDeath() return false end