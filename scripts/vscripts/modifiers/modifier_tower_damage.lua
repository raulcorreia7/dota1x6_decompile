

modifier_tower_damage = class({})


function modifier_tower_damage:IsHidden() return true end
function modifier_tower_damage:IsPurgable() return false end
function modifier_tower_damage:RemoveOnDeath() return false end

function modifier_tower_damage:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE
  
    }

 end

function modifier_tower_damage:OnCreated(table)
if not IsServer() then return end
   self.StackOnIllusion = true 
   self.damage = my_game:GetTowerDamage(self:GetParent())
end



function modifier_tower_damage:GetModifierTotalDamageOutgoing_Percentage( params ) 
if not IsServer() then return end
if params.attacker == self:GetParent() and params.inflictor == nil then 
	if params.target then 
		if params.target:IsBuilding() then 
			return self.damage
		end 
	end
end

end
