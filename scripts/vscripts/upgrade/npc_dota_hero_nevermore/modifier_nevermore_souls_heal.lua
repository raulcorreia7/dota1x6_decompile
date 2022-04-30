

modifier_nevermore_souls_heal = class({})


function modifier_nevermore_souls_heal:IsHidden() return true end
function modifier_nevermore_souls_heal:IsPurgable() return false end



function modifier_nevermore_souls_heal:OnCreated(table)
if not IsServer() then return end
  self:SetStackCount(1) 
end


function modifier_nevermore_souls_heal:OnRefresh(table)
if not IsServer() then return end
  self:SetStackCount(self:GetStackCount()+1)
  
end

function modifier_nevermore_souls_heal:RemoveOnDeath() return false end