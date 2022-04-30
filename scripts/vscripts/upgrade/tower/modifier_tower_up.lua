



modifier_tower_up = class({})

function modifier_tower_up:IsHidden() return true end

function modifier_tower_up:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT
    }

 end

function modifier_tower_up:OnCreated(table)
if not IsServer() then return end
  self:SetStackCount(1)
end


function modifier_tower_up:OnRefresh(table)
if not IsServer() then return end
  self:SetStackCount(self:GetStackCount()+1)
end


function modifier_tower_up:GetModifierConstantHealthRegen() return
2*self:GetStackCount()*(1+0.2*self:GetCaster():GetUpgradeStack("modifier_up_graypoints"))
end 