LinkLuaModifier("modifier_npc_siege_dmg", "abilities/npc_siege_passive.lua", LUA_MODIFIER_MOTION_NONE)

npc_siege_passive = class({})


function npc_siege_passive:GetIntrinsicModifierName() return "modifier_npc_siege_dmg" end
 
modifier_npc_siege_dmg = class ({})

function modifier_npc_siege_dmg:IsHidden() return true end
function modifier_npc_siege_dmg:IsPurgable() return false end

function modifier_npc_siege_dmg:OnCreated(table)
self.damage = self:GetAbility():GetSpecialValueFor("damage")
end
function modifier_npc_siege_dmg:DeclareFunctions()
   return   {
    MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE,
    MODIFIER_EVENT_ON_DEATH

  }

 
end

function modifier_npc_siege_dmg:OnDeath( params ) 
if not IsServer() then return end
	if params.unit == self:GetParent() then 
		local name = ""
		if self:GetParent():GetUnitName() == "npc_goodsiege_a" then 
		name = "particles/siege_fx/siege_good_death_01.vpcf" else 
		name = "particles/siege_fx/siege_bad_death_01.vpcf" end
		
		self:GetParent():AddNoDraw()
		local puddle_particle = ParticleManager:CreateParticle(name, PATTACH_WORLDORIGIN, nil)
    ParticleManager:SetParticleControl(puddle_particle, 0, self:GetParent():GetAbsOrigin())
    ParticleManager:SetParticleControlOrientation(puddle_particle, 0, self:GetParent():GetForwardVector(), self:GetParent():GetRightVector(),self:GetParent():GetUpVector())
	end
end


function modifier_npc_siege_dmg:GetModifierTotalDamageOutgoing_Percentage( params ) 
	if params.attacker == self:GetParent() then 
	   if params.target then 
        if params.target:IsBuilding() then 
	         return self.damage
        end
    	end 
  end
end