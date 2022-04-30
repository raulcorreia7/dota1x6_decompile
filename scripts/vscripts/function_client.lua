

function C_DOTA_BaseNPC:GetUpgradeStack( mod )
   if self:HasModifier(mod) then 
   			
		return self:GetModifierStackCount(mod, self)
	else return 0 end 

end

function C_DOTA_BaseNPC:HasShard()
    if self:HasModifier("modifier_item_aghanims_shard") then
        return true
    end

    return false
end


function C_DOTA_BaseNPC:UpgradeIllusion(mod, stack  )

    local i = self:AddNewModifier(self, nil, mod, {})

    i:SetStackCount(stack)
end


function C_DOTABaseAbility:GetState()
return self:GetAutoCastState()
end

C_DOTA_Ability_Lua.GetCastRangeBonus = function(self, hTarget)
    if(not self or self:IsNull() == true) then
        return 0
    end
    local caster = self:GetCaster()
    if(not caster or caster:IsNull() == true) then
        return 0
    end
    return caster:GetCastRangeBonus()
end
 
C_DOTABaseAbility.GetCastRangeBonus = function(self, hTarget)
    if(not self or self:IsNull() == true) then
        return 0
    end
    local caster = self:GetCaster()
    if(not caster or caster:IsNull() == true) then
        return 0
    end
    return caster:GetCastRangeBonus()
end

