

modifier_nevermore_souls_max = class({})


function modifier_nevermore_souls_max:IsHidden() return true end
function modifier_nevermore_souls_max:IsPurgable() return false end



function modifier_nevermore_souls_max:OnCreated(table)
if not IsServer() then return end
  self:SetStackCount(1)
end


function modifier_nevermore_souls_max:OnRefresh(table)
if not IsServer() then return end
  self:SetStackCount(self:GetStackCount()+1)
  
end

function modifier_nevermore_souls_max:RemoveOnDeath() return false end