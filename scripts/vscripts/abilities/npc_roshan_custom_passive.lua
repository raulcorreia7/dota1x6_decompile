LinkLuaModifier("modifier_roshan_custom_gospawn", "abilities/npc_roshan_custom_passive", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_roshan_custom_bash", "abilities/npc_roshan_custom_passive", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_roshan_custom_slow", "abilities/npc_roshan_custom_passive", LUA_MODIFIER_MOTION_NONE)

npc_roshan_custom_passive = class({})



function npc_roshan_custom_passive:GetIntrinsicModifierName() return "modifier_roshan_custom_bash" end


modifier_roshan_custom_bash = class({})
function modifier_roshan_custom_bash:IsHidden() return true end
function modifier_roshan_custom_bash:IsPurgable() return false end
function modifier_roshan_custom_bash:CheckState()
return
{[MODIFIER_STATE_CANNOT_MISS] = true}
end

function modifier_roshan_custom_bash:DeclareFunctions()
return
{
  MODIFIER_EVENT_ON_ATTACK_LANDED
}
end
function modifier_roshan_custom_bash:OnAttackLanded(params)
if not IsServer() then return end
if self:GetParent() ~= params.attacker then return end

params.target:AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_roshan_custom_slow", {duration = (1 - params.target:GetStatusResistance())*self:GetAbility():GetSpecialValueFor("slow_duration")})

end


modifier_roshan_custom_slow = class({})
function modifier_roshan_custom_slow:IsHidden() return false end
function modifier_roshan_custom_slow:IsPurgable() return false end
function modifier_roshan_custom_slow:OnCreated(table)
  self.slow = self:GetAbility():GetSpecialValueFor("slow")
  self.max = self:GetAbility():GetSpecialValueFor("max")
if not IsServer() then return end
  self:SetStackCount(1)
end

function modifier_roshan_custom_slow:OnRefresh(table)
if not IsServer() then return end
  self:IncrementStackCount()

  if self:GetStackCount() >= self.max then 
    self:Destroy()
    self:GetParent():EmitSound("Roshan.Bash")
    self:GetParent():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_bashed", {duration = (1 - self:GetParent():GetStatusResistance())*self:GetAbility():GetSpecialValueFor("bash")})
  

  end

end



function modifier_roshan_custom_slow:OnStackCountChanged(iStackCount)
  if not IsServer() then return end

  if not self.pfx then
    self.pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_centaur/centaur_shard_buff_strength_counter_stack.vpcf", PATTACH_OVERHEAD_FOLLOW, self:GetParent())
    
  end

  ParticleManager:SetParticleControl(self.pfx, 2, Vector(self:GetStackCount(), 0 , 0))
  ParticleManager:SetParticleControlEnt(self.pfx, 3, self:GetParent(), PATTACH_OVERHEAD_FOLLOW, nil , self:GetParent():GetAbsOrigin(), true )
end

function modifier_roshan_custom_slow:OnDestroy()
if not IsServer() then return end

if self.pfx then
  ParticleManager:DestroyParticle(self.pfx,false )
end

end

function modifier_roshan_custom_slow:DeclareFunctions()
return
{
  MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
  MODIFIER_PROPERTY_TOOLTIP
}
end

function modifier_roshan_custom_slow:GetModifierMoveSpeedBonus_Percentage() return self.slow end
function modifier_roshan_custom_slow:OnTooltip() return self.max end




modifier_roshan_custom_gospawn = class({})

function modifier_roshan_custom_gospawn:IsHidden() return true end
function modifier_roshan_custom_gospawn:IsPurgable() return false end
function modifier_roshan_custom_gospawn:CheckState()
return
{
  [MODIFIER_STATE_FLYING_FOR_PATHING_PURPOSES_ONLY] = true,
  [MODIFIER_STATE_NO_UNIT_COLLISION] = true
}
end
function modifier_roshan_custom_gospawn:DeclareFunctions()
return
{
  MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
}
end

function modifier_roshan_custom_gospawn:GetModifierMoveSpeedBonus_Percentage() return 50 end
