LinkLuaModifier("modifier_lich_ice_cd", "abilities/npc_lich_ice.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_lich_ice", "abilities/npc_lich_ice.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_lich_ice_resist", "abilities/npc_lich_ice.lua", LUA_MODIFIER_MOTION_NONE)

npc_lich_ice = class({})



function npc_lich_ice:OnSpellStart()


    self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_lich_ice_cd", {duration = self:GetCooldownTimeRemaining()})
  
    self.radius = self:GetSpecialValueFor("radius")
    if not IsServer() then return end

self:GetCaster():EmitSound("Hero_Lich.IceSpire")
    local new_tomb = CreateUnitByName("npc_lich_ice_unit", self:GetAbsOrigin()+RandomVector(RandomInt(-1, 1)+self.radius), true, nil, nil, DOTA_TEAM_CUSTOM_5)
     self:GetCaster():AddNewModifier(new_tomb, self, "modifier_lich_ice_resist", {})

     new_tomb:AddNewModifier(new_tomb, self, "modifier_lich_ice", {})

     new_tomb:SetBaseMaxHealth(self:GetSpecialValueFor("hits"))
     new_tomb:SetHealth(self:GetSpecialValueFor("hits"))

     new_tomb.owner = self:GetCaster()
  new_tomb.seed_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_lich/lich_ice_spire.vpcf", PATTACH_ABSORIGIN_FOLLOW, new_tomb)
  ParticleManager:SetParticleControl(new_tomb.seed_particle, 0, new_tomb:GetAbsOrigin())
  ParticleManager:SetParticleControl(new_tomb.seed_particle, 1, new_tomb:GetAbsOrigin())
  ParticleManager:SetParticleControl(new_tomb.seed_particle, 2, new_tomb:GetAbsOrigin())
  ParticleManager:SetParticleControl(new_tomb.seed_particle, 3, new_tomb:GetAbsOrigin())
  ParticleManager:SetParticleControl(new_tomb.seed_particle, 4, new_tomb:GetAbsOrigin())
  ParticleManager:SetParticleControl(new_tomb.seed_particle, 5, Vector(550,550,550))    
end


modifier_lich_ice_resist = class({})
function modifier_lich_ice_resist:IsHidden() return true end
function modifier_lich_ice_resist:IsPurgable() return false end
function modifier_lich_ice_resist:GetAttributes() return  MODIFIER_ATTRIBUTE_MULTIPLE end
function modifier_lich_ice_resist:GetEffectName() return "particles/units/heroes/hero_lich/lich_frost_armor.vpcf" end
function modifier_lich_ice_resist:GetEffectAttachType() return PATTACH_OVERHEAD_FOLLOW end
function modifier_lich_ice_resist:OnCreated(table)
self.armor = self:GetAbility():GetSpecialValueFor("armor")
self.magic = self:GetAbility():GetSpecialValueFor("magic")
self.regen = self:GetAbility():GetSpecialValueFor("regen")
end

function modifier_lich_ice_resist:DeclareFunctions()
return
{
    MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
    MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS,
    MODIFIER_PROPERTY_HEALTH_REGEN_PERCENTAGE,
    MODIFIER_EVENT_ON_DEATH
}
end
function modifier_lich_ice_resist:GetModifierPhysicalArmorBonus() return self.armor end
function modifier_lich_ice_resist:GetModifierMagicalResistanceBonus() return self.magic end
function modifier_lich_ice_resist:GetModifierHealthRegenPercentage() return self.regen end


function modifier_lich_ice_resist:OnDeath(params)
if not IsServer() then return end
if self:GetCaster() == params.unit or self:GetCaster().owner == params.unit then 

if self:GetCaster().seed_particle then 
    ParticleManager:DestroyParticle(self:GetCaster().seed_particle, false)
     ParticleManager:ReleaseParticleIndex(self:GetCaster().seed_particle) 
end

self:GetCaster():EmitSound("Hero_Lich.IceSpire.Destroy")
self:Destroy()

if self:GetCaster().owner == params.unit then 
    self:GetCaster():Kill(nil,params.attacker)
end

end


end



modifier_lich_ice = class({})
function modifier_lich_ice:IsHidden() return true end
function modifier_lich_ice:IsPurgable() return false end
function modifier_lich_ice:OnCreated(table)
if not IsServer() then return end
self.hits = self:GetAbility():GetSpecialValueFor("hits")
end
function modifier_lich_ice:DeclareFunctions()

return
  {
MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_MAGICAL,
MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_PHYSICAL,
MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_PURE,
MODIFIER_EVENT_ON_ATTACK_LANDED
 } end


    function modifier_lich_ice:GetAbsoluteNoDamageMagical() return 1 end

     function modifier_lich_ice:GetAbsoluteNoDamagePhysical() return 1 end

     function modifier_lich_ice:GetAbsoluteNoDamagePure() return 1 end

function modifier_lich_ice:OnAttackLanded( param )
if not IsServer() then return end
if self:GetParent() == param.target then

   self.hits = self.hits - 1

    self:GetParent():SetHealth(self.hits)
    if self.hits <= 0 then
     
            self:GetParent():Kill(nil, param.attacker)
    end
end
end


modifier_lich_ice_cd = class({})

function modifier_lich_ice_cd:IsHidden() return false end
function modifier_lich_ice_cd:IsPurgable() return false end