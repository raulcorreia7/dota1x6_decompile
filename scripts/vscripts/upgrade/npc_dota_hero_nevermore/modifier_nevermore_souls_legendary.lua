

modifier_nevermore_souls_legendary = class({})


function modifier_nevermore_souls_legendary:IsHidden() return true end
function modifier_nevermore_souls_legendary:IsPurgable() return false end



function modifier_nevermore_souls_legendary:OnCreated(table)
if not IsServer() then return end
  self:SetStackCount(1)
  self.ActiveTalent = true
    local ability = self:GetParent():FindAbilityByName("custom_nevermore_necromastery")
  if ability and self:GetParent():HasShard() and ability:GetAutoCastState() == true  then 
  	ability:ToggleAutoCast()
  end
end



function modifier_nevermore_souls_legendary:RemoveOnDeath() return false end