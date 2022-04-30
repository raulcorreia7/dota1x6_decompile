

modifier_ogremagi_blast_1 = class({})


function modifier_ogremagi_blast_1:IsHidden() return true end
function modifier_ogremagi_blast_1:IsPurgable() return false end



function modifier_ogremagi_blast_1:OnCreated(table)
if not IsServer() then return end
  self:SetStackCount(1)
end


function modifier_ogremagi_blast_1:OnRefresh(table)
if not IsServer() then return end
  self:SetStackCount(self:GetStackCount()+1)
  
end

function modifier_ogremagi_blast_1:RemoveOnDeath() return false end