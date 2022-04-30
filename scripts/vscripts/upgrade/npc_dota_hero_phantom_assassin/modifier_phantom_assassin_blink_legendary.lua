

modifier_phantom_assassin_blink_legendary = class({})


function modifier_phantom_assassin_blink_legendary:IsHidden() return true end
function modifier_phantom_assassin_blink_legendary:IsPurgable() return false end



function modifier_phantom_assassin_blink_legendary:OnCreated(table)
if not IsServer() then return end
self:SetStackCount(1)
self.StackOnIllusion = true 

local ability = self:GetParent():FindAbilityByName("custom_phantom_assassin_phantom_strike_legendary")
if ability then 
	ability:SetHidden(false)
end

end


function modifier_phantom_assassin_blink_legendary:RemoveOnDeath() return false end