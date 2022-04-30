

modifier_nevermore_souls_kills = class({})


function modifier_nevermore_souls_kills:IsHidden() return true end
function modifier_nevermore_souls_kills:IsPurgable() return false end



function modifier_nevermore_souls_kills:OnCreated(table)
if not IsServer() then return end
  self:SetStackCount(1)
end


function modifier_nevermore_souls_kills:OnRefresh(table)
if not IsServer() then return end
  self:SetStackCount(self:GetStackCount()+1)
  
end

function modifier_nevermore_souls_kills:RemoveOnDeath() return false end