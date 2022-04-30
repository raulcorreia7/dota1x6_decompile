

modifier_nevermore_requiem_proc = class({})


function modifier_nevermore_requiem_proc:IsHidden() return true end
function modifier_nevermore_requiem_proc:IsPurgable() return false end



function modifier_nevermore_requiem_proc:OnCreated(table)
if not IsServer() then return end
  self:SetStackCount(1)
end


function modifier_nevermore_requiem_proc:OnRefresh(table)
if not IsServer() then return end
  self:SetStackCount(self:GetStackCount()+1)
  
end

function modifier_nevermore_requiem_proc:RemoveOnDeath() return false end