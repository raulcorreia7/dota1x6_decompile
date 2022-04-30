

modifier_phantom_assassin_blink_damage = class({})


function modifier_phantom_assassin_blink_damage:IsHidden() return true end
function modifier_phantom_assassin_blink_damage:IsPurgable() return false end



function modifier_phantom_assassin_blink_damage:OnCreated(table)
if not IsServer() then return end
  self:SetStackCount(1)
   self.StackOnIllusion = true 
end


function modifier_phantom_assassin_blink_damage:OnRefresh(table)
if not IsServer() then return end
  self:SetStackCount(self:GetStackCount()+1)
end



function modifier_phantom_assassin_blink_damage:RemoveOnDeath() return false end

