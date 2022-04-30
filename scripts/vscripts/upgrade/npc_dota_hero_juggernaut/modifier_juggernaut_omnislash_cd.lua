
modifier_juggernaut_omnislash_cd = class({})


function modifier_juggernaut_omnislash_cd:IsHidden() return true end
function modifier_juggernaut_omnislash_cd:IsPurgable() return false end


function modifier_juggernaut_omnislash_cd:IsPurgable() return false end

function modifier_juggernaut_omnislash_cd:OnCreated(table)
if not IsServer() then return end
  self:SetStackCount(1)
end

function modifier_juggernaut_omnislash_cd:OnRefresh(table)
if not IsServer() then return end
  self:SetStackCount(self:GetStackCount()+1)
end



function modifier_juggernaut_omnislash_cd:RemoveOnDeath() return false end