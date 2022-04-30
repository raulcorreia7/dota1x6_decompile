

modifier_phantom_assassin_blink_blink = class({})


function modifier_phantom_assassin_blink_blink:IsHidden() return true end
function modifier_phantom_assassin_blink_blink:IsPurgable() return false end



function modifier_phantom_assassin_blink_blink:OnCreated(table)
if not IsServer() then return end
  self:SetStackCount(1)
   self.StackOnIllusion = true 
end


function modifier_phantom_assassin_blink_blink:OnRefresh(table)
if not IsServer() then return end
  self:SetStackCount(self:GetStackCount()+1)
end



function modifier_phantom_assassin_blink_blink:RemoveOnDeath() return false end

