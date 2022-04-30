
modifier_juggernaut_omnislash_legendary = class({})


function modifier_juggernaut_omnislash_legendary:IsHidden() return true end
function modifier_juggernaut_omnislash_legendary:IsPurgable() return false end



function modifier_juggernaut_omnislash_legendary:OnCreated(table)
if not IsServer() then return end
  self:SetStackCount(1)
  self.ActiveTalent = true
end


function modifier_juggernaut_omnislash_legendary:RemoveOnDeath() return false end