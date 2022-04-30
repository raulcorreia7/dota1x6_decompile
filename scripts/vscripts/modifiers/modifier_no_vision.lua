

modifier_no_vision = class({})


function modifier_no_vision:IsHidden() return false end
function modifier_no_vision:IsPurgable() return false end



function modifier_no_vision:DeclareFunctions()
return 
{
	MODIFIER_PROPERTY_DONT_GIVE_VISION_OF_ATTACKER
}

end

function modifier_no_vision:RemoveOnDeath() return false end


function modifier_no_vision:GetModifierNoVisionOfAttacker() 
return 1
 end 