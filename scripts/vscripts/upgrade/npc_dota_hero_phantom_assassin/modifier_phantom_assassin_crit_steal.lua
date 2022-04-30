
modifier_phantom_assassin_crit_steal = class({})


function modifier_phantom_assassin_crit_steal:IsHidden() return true end
function modifier_phantom_assassin_crit_steal:IsPurgable() return false end



function modifier_phantom_assassin_crit_steal:OnCreated(table)
if not IsServer() then return end
  self:SetStackCount(1)
   self.StackOnIllusion = true 
end


function modifier_phantom_assassin_crit_steal:OnRefresh(table)
if not IsServer() then return end
  self:SetStackCount(self:GetStackCount()+1)
end



function modifier_phantom_assassin_crit_steal:RemoveOnDeath() return false end
