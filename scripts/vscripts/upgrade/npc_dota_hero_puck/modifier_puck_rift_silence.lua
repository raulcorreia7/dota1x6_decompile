

modifier_puck_rift_silence = class({})


function modifier_puck_rift_silence:IsHidden() return true end
function modifier_puck_rift_silence:IsPurgable() return false end



function modifier_puck_rift_silence:OnCreated(table)
if not IsServer() then return end
  self:SetStackCount(1)
end


function modifier_puck_rift_silence:OnRefresh(table)
if not IsServer() then return end
  self:SetStackCount(self:GetStackCount()+1)
  
end

function modifier_puck_rift_silence:RemoveOnDeath() return false end