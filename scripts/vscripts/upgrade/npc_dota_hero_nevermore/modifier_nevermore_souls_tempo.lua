

modifier_nevermore_souls_tempo = class({})


function modifier_nevermore_souls_tempo:IsHidden() return true end
function modifier_nevermore_souls_tempo:IsPurgable() return false end



function modifier_nevermore_souls_tempo:OnCreated(table)
if not IsServer() then return end
  self:SetStackCount(1)
end


function modifier_nevermore_souls_tempo:OnRefresh(table)
if not IsServer() then return end
  self:SetStackCount(self:GetStackCount()+1)
  
end

function modifier_nevermore_souls_tempo:RemoveOnDeath() return false end