

modifier_void_astral_1 = class({})


function modifier_void_astral_1:IsHidden() return true end
function modifier_void_astral_1:IsPurgable() return false end



function modifier_void_astral_1:OnCreated(table)
if not IsServer() then return end
  self:SetStackCount(1)
end


function modifier_void_astral_1:OnRefresh(table)
if not IsServer() then return end
  self:SetStackCount(self:GetStackCount()+1)
  
end

function modifier_void_astral_1:RemoveOnDeath() return false end