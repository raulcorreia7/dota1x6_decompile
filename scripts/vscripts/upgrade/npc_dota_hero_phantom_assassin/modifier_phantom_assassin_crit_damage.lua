

modifier_phantom_assassin_crit_damage = class({})


function modifier_phantom_assassin_crit_damage:IsHidden() return true end
function modifier_phantom_assassin_crit_damage:IsPurgable() return false end



function modifier_phantom_assassin_crit_damage:OnCreated(table)
if not IsServer() then return end
  self:SetStackCount(1)
   self.StackOnIllusion = true 
end


function modifier_phantom_assassin_crit_damage:OnRefresh(table)
if not IsServer() then return end
  self:SetStackCount(self:GetStackCount()+1)
end



function modifier_phantom_assassin_crit_damage:RemoveOnDeath() return false end
