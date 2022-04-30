LinkLuaModifier("modifier_ravager", "modifiers/modifier_ravager", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_ravager_burn", "modifiers/modifier_ravager", LUA_MODIFIER_MOTION_NONE)

modifier_ravager = class({})


function modifier_ravager:IsHidden() return false end
function modifier_ravager:IsPurgable() return false end
function modifier_ravager:IsDebuff() return true end
function modifier_ravager:GetTexture()
 return "buffs/ravager" end

function modifier_ravager:OnCreated(table)
if not IsServer() then return end
self:GetParent():AddNewModifier(self:GetParent(), nil, "modifier_ravager_burn", {duration = 10})
self:SetStackCount(1)
end

function modifier_ravager:OnRefresh(table)
if not IsServer() then return end
self:GetParent():AddNewModifier(self:GetParent(), nil, "modifier_ravager_burn", {duration = 10})
self:IncrementStackCount()
end

function modifier_ravager:OnStackCountChanged(iStackCount)
  if not IsServer() then return end

  if not self.pfx then
    self.pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_centaur/centaur_shard_buff_strength_counter_stack.vpcf", PATTACH_OVERHEAD_FOLLOW, self:GetParent())
    
  end

  ParticleManager:SetParticleControl(self.pfx, 2, Vector(self:GetStackCount(), 0 , 0))
  ParticleManager:SetParticleControlEnt(self.pfx, 3, self:GetParent(), PATTACH_OVERHEAD_FOLLOW, nil , self:GetParent():GetAbsOrigin(), true )
end


function modifier_ravager:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE
}
end


function modifier_ravager:GetModifierIncomingDamage_Percentage()
return self:GetStackCount()*15
end

modifier_ravager_burn = class({})
function modifier_ravager_burn:IsHidden() return true end
function modifier_ravager_burn:IsPurgable() return false end

function modifier_ravager_burn:GetEffectName()
    return "particles/roshan_meteor_burn_.vpcf"
end