LinkLuaModifier("modifier_attack_shield", "upgrade/general/modifier_up_attackblock", LUA_MODIFIER_MOTION_NONE)

modifier_up_attackblock = class({})


function modifier_up_attackblock:IsHidden() return true end
function modifier_up_attackblock:IsPurgable() return false end


function modifier_up_attackblock:OnCreated(table)
if not IsServer() then return end
  self:SetStackCount(1)
  
    self:GetParent():AddNewModifier(self:GetParent(), nil, "modifier_attack_shield", {duration = 30.5})
  

end


function modifier_up_attackblock:OnRefresh(table)
if not IsServer() then return end
  self:SetStackCount(self:GetStackCount()+1)
end


function modifier_up_attackblock:RemoveOnDeath() return false end




modifier_attack_shield = class({})
function modifier_attack_shield:IsHidden() return false end
function modifier_attack_shield:IsPurgable() return false end
function modifier_attack_shield:RemoveOnDeath() return false end

function modifier_attack_shield:GetTexture() return "item_crimson_guard"
	 end


function modifier_attack_shield:RefreshShield()
if not IsServer() then return end
self:GetParent():EmitSound("Item.CrimsonGuard.Cast")
    
local shield_size = 85
self.crimson_guard_pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_abaddon/abaddon_aphotic_shield_2.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
    local common_vector = Vector(shield_size,0,shield_size)
    ParticleManager:SetParticleControl(self.crimson_guard_pfx, 1, common_vector)
    ParticleManager:SetParticleControl(self.crimson_guard_pfx, 2, common_vector)
    ParticleManager:SetParticleControl(self.crimson_guard_pfx, 4, common_vector)
    ParticleManager:SetParticleControl(self.crimson_guard_pfx, 5, Vector(shield_size,0,0))
    ParticleManager:SetParticleControlEnt(self.crimson_guard_pfx, 0, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetParent():GetAbsOrigin(), true)
end
function modifier_attack_shield:DestroyShield()
if not IsServer() then return end
self.shield = 0

       if self.crimson_guard_pfx ~= nil then 
           ParticleManager:DestroyParticle(self.crimson_guard_pfx, false)
           self.crimson_guard_pfx = nil
        end

     self:SetStackCount(0)
end



function modifier_attack_shield:OnCreated(table)
if not IsServer() then return end

self.shield = 200*self:GetParent():GetUpgradeStack("modifier_up_attackblock")
self:RefreshShield()
self.duration = self:GetRemainingTime()
self.count = 0
self.max = 30
self:SetStackCount(self.shield)
self:StartIntervalThink(1)

end

function modifier_attack_shield:OnIntervalThink()
if not IsServer() then return end

self.count = self.count + 1

if self.count >= self.max and self:GetParent():IsAlive() then  
  self.count = 0

  if self.crimson_guard_pfx == nil then 
    self:RefreshShield()
  end

  self.shield = 200*self:GetParent():GetUpgradeStack("modifier_up_attackblock")
  self:SetStackCount(self.shield)
  self:SetDuration(self.duration, true)

end

end


function modifier_attack_shield:DeclareFunctions()

return 
{
    MODIFIER_PROPERTY_TOTAL_CONSTANT_BLOCK,
    MODIFIER_EVENT_ON_DEATH,
    MODIFIER_PROPERTY_TOOLTIP,
    MODIFIER_EVENT_ON_RESPAWN
}
end
function modifier_attack_shield:OnTooltip() return self:GetStackCount() end


function modifier_attack_shield:OnDeath(params)
if not IsServer() then return end
if params.unit ~= self:GetParent() then return end
  self:SetDuration(-1, true)
  self:DestroyShield()
       
end
function modifier_attack_shield:OnRespawn(params)
if not IsServer() then return end
if params.unit ~= self:GetParent() then return end

self:SetDuration(30.5, true)
self:OnCreated()
       
end

function modifier_attack_shield:GetModifierTotal_ConstantBlock(params)
if not IsServer() then return end
if self:GetParent() == params.attacker then return end
if self.shield == 0 then return end

if params.damage_type ~= DAMAGE_TYPE_PHYSICAL then return end

  if self.shield > params.damage then
    self.shield = self.shield - params.damage
    self:SetStackCount(self.shield)
    local i = params.damage
return i
else
    
    local i = self.shield
   	self:DestroyShield()
    return i
end
end



