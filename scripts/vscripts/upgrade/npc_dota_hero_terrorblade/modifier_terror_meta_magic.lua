

modifier_terror_meta_magic = class({})


function modifier_terror_meta_magic:IsHidden() return true end
function modifier_terror_meta_magic:IsPurgable() return false end



function modifier_terror_meta_magic:OnCreated(table)
if not IsServer() then return end
  self:SetStackCount(1)
end


function modifier_terror_meta_magic:OnRefresh(table)
if not IsServer() then return end
  self:SetStackCount(self:GetStackCount()+1)
  
end

function modifier_terror_meta_magic:RemoveOnDeath() return false end