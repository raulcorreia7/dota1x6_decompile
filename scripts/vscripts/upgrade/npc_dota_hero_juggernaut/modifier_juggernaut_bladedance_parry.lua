

modifier_juggernaut_bladedance_parry = class({})


function modifier_juggernaut_bladedance_parry:IsHidden() return true end
function modifier_juggernaut_bladedance_parry:IsPurgable() return false end



function modifier_juggernaut_bladedance_parry:OnCreated(table)
if not IsServer() then return end
  self:SetStackCount(1)
   self.StackOnIllusion = true 
end



function modifier_juggernaut_bladedance_parry:RemoveOnDeath() return false end