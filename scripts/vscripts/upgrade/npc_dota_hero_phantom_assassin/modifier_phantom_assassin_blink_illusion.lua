

modifier_phantom_assassin_blink_illusion = class({})


function modifier_phantom_assassin_blink_illusion:IsHidden() return true end
function modifier_phantom_assassin_blink_illusion:IsPurgable() return false end



function modifier_phantom_assassin_blink_illusion:OnCreated(table)
if not IsServer() then return end
  self:SetStackCount(1)
   self.StackOnIllusion = true 
end


function modifier_phantom_assassin_blink_illusion:OnRefresh(table)
if not IsServer() then return end
  self:SetStackCount(self:GetStackCount()+1)
end



function modifier_phantom_assassin_blink_illusion:RemoveOnDeath() return false end