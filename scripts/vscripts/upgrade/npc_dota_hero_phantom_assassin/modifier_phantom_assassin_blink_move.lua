

modifier_phantom_assassin_blink_move = class({})


function modifier_phantom_assassin_blink_move:IsHidden() return true end
function modifier_phantom_assassin_blink_move:IsPurgable() return false end



function modifier_phantom_assassin_blink_move:OnCreated(table)
if not IsServer() then return end
  self:SetStackCount(1)
   self.StackOnIllusion = true 
end


function modifier_phantom_assassin_blink_move:OnRefresh(table)
if not IsServer() then return end
  self:SetStackCount(self:GetStackCount()+1)
end



function modifier_phantom_assassin_blink_move:RemoveOnDeath() return false end