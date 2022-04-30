

modifier_primal_beast_uproar_7 = class({})


function modifier_primal_beast_uproar_7:IsHidden() return true end
function modifier_primal_beast_uproar_7:IsPurgable() return false end



function modifier_primal_beast_uproar_7:OnCreated(table)
if not IsServer() then return end
  self:SetStackCount(1)
end


function modifier_primal_beast_uproar_7:OnRefresh(table)
if not IsServer() then return end
  self:SetStackCount(self:GetStackCount()+1)
  
end

function modifier_primal_beast_uproar_7:RemoveOnDeath() return false end