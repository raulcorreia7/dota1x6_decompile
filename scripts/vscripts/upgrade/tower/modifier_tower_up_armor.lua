



modifier_tower_up_armor = class({})

function modifier_tower_up_armor:IsHidden() return true end

function modifier_tower_up_armor:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS
    }

 end

function modifier_tower_up_armor:OnCreated(table)
if not IsServer() then return end
  self:SetStackCount(1)
end


function modifier_tower_up_armor:OnRefresh(table)
if not IsServer() then return end
  self:SetStackCount(self:GetStackCount()+1)
end


function modifier_tower_up_armor:GetModifierPhysicalArmorBonus() return 4*self:GetStackCount() end 

