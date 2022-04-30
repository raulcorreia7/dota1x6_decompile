

modifier_up_stun = class({})


function modifier_up_stun:IsHidden() 
	return true
end

function modifier_up_stun:IsPurgable() return false end

function modifier_up_stun:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE
  
    }

 end

function modifier_up_stun:OnCreated(table)
if not IsServer() then return end
  self:SetStackCount(1)
end


function modifier_up_stun:OnRefresh(table)
if not IsServer() then return end
  self:SetStackCount(self:GetStackCount()+1)
end


function modifier_up_stun:GetModifierIncomingDamage_Percentage()
if self:GetParent():IsStunned() or self:GetParent():IsHexed() or self:GetParent():GetForceAttackTarget() ~= nil then 
	return -8*self:GetStackCount()
end
	return 0
end

function modifier_up_stun:RemoveOnDeath() return false end