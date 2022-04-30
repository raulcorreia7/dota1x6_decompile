
modifier_phantom_assassin_crit_lowhp = class({})


function modifier_phantom_assassin_crit_lowhp:IsHidden() return true end
function modifier_phantom_assassin_crit_lowhp:IsPurgable() return false end



function modifier_phantom_assassin_crit_lowhp:OnCreated(table)
if not IsServer() then return end
  self:SetStackCount(1)
   self.StackOnIllusion = true 
end


function modifier_phantom_assassin_crit_lowhp:OnRefresh(table)
if not IsServer() then return end
  self:SetStackCount(self:GetStackCount()+1)
end



function modifier_phantom_assassin_crit_lowhp:RemoveOnDeath() return false end
