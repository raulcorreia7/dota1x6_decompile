

modifier_up_towerdamage = class({})

modifier_up_towerdamage.damage = 5

function modifier_up_towerdamage:IsHidden() return true end
function modifier_up_towerdamage:IsPurgable() return false end

function modifier_up_towerdamage:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE
  
    }

 end

function modifier_up_towerdamage:OnCreated(table)
if not IsServer() then return end
  self:SetStackCount(1)
   self.StackOnIllusion = true 
  self:GetParent():CalculateStatBonus(true)
end


function modifier_up_towerdamage:OnRefresh(table)
if not IsServer() then return end
  self:SetStackCount(self:GetStackCount()+1)
end


function modifier_up_towerdamage:GetModifierTotalDamageOutgoing_Percentage( params ) 
	if params.attacker == self:GetParent() then 
	if params.target then 
if params.target:IsBuilding() then 
	return self.damage*self:GetStackCount()*(1+0.2*self:GetParent():GetUpgradeStack("modifier_up_graypoints"))
	end 
end
end
end



function modifier_up_towerdamage:RemoveOnDeath() return false end