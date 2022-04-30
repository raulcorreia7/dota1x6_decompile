

modifier_phantom_assassin_blink_duration = class({})


function modifier_phantom_assassin_blink_duration:IsHidden() return true end
function modifier_phantom_assassin_blink_duration:IsPurgable() return false end



function modifier_phantom_assassin_blink_duration:OnCreated(table)
if not IsServer() then return end
  self:SetStackCount(1)
   self.StackOnIllusion = true 
end


function modifier_phantom_assassin_blink_duration:OnRefresh(table)
if not IsServer() then return end
  self:SetStackCount(self:GetStackCount()+1)
end



function modifier_phantom_assassin_blink_duration:RemoveOnDeath() return false end