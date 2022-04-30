

modifier_phantom_assassin_crit_chance = class({})


function modifier_phantom_assassin_crit_chance:IsHidden() return true end
function modifier_phantom_assassin_crit_chance:IsPurgable() return false end



function modifier_phantom_assassin_crit_chance:OnCreated(table)
if not IsServer() then return end
  self:SetStackCount(1)
   self.StackOnIllusion = true 
end


function modifier_phantom_assassin_crit_chance:OnRefresh(table)
if not IsServer() then return end
  self:SetStackCount(self:GetStackCount()+1)
end



function modifier_phantom_assassin_crit_chance:RemoveOnDeath() return false end
