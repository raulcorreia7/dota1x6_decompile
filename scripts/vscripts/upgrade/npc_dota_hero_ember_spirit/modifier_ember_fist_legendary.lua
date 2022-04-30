

modifier_ember_fist_legendary = class({})


function modifier_ember_fist_legendary:IsHidden() return true end
function modifier_ember_fist_legendary:IsPurgable() return false end



function modifier_ember_fist_legendary:OnCreated(table)
if not IsServer() then return end
  self:SetStackCount(1)

end


function modifier_ember_fist_legendary:OnRefresh(table)
if not IsServer() then return end
  self:SetStackCount(self:GetStackCount()+1)
  
end

function modifier_ember_fist_legendary:RemoveOnDeath() return false end