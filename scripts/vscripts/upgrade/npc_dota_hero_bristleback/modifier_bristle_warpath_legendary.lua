

modifier_bristle_warpath_legendary = class({})


function modifier_bristle_warpath_legendary:IsHidden() return true end
function modifier_bristle_warpath_legendary:IsPurgable() return false end



function modifier_bristle_warpath_legendary:OnCreated(table)
if not IsServer() then return end
  self:SetStackCount(1)
  self.ActiveTalent = true
end


function modifier_bristle_warpath_legendary:OnRefresh(table)
if not IsServer() then return end
  self:SetStackCount(self:GetStackCount()+1)
  
end

function modifier_bristle_warpath_legendary:RemoveOnDeath() return false end