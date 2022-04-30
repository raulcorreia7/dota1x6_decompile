
modifier_juggernaut_omnislash_aoe_attack = class({})


function modifier_juggernaut_omnislash_aoe_attack:IsHidden() return true end
function modifier_juggernaut_omnislash_aoe_attack:IsPurgable() return false end



function modifier_juggernaut_omnislash_aoe_attack:OnCreated(table)
if not IsServer() then return end
  self:SetStackCount(1)
   self.StackOnIllusion = true 
end



function modifier_juggernaut_omnislash_aoe_attack:RemoveOnDeath() return false end