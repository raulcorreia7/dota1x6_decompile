LinkLuaModifier("modifier_up_res_cd", "upgrade/general/modifier_up_res", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_up_res_nodmg", "upgrade/general/modifier_up_res", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_up_res_ready", "upgrade/general/modifier_up_res", LUA_MODIFIER_MOTION_NONE)

modifier_up_res = class({})

modifier_up_res.cd = 300
modifier_up_res.heal = 0.15
modifier_up_res.stun = 1.5


function modifier_up_res:IsHidden() return true end
function modifier_up_res:IsPurgable() return false end

function modifier_up_res:GetTexture()
  return "item_phoenix_ash" end


function modifier_up_res:DeclareFunctions()
    return {

        MODIFIER_EVENT_ON_TAKEDAMAGE

    } end



function modifier_up_res:OnTakeDamage(params)
if not IsServer() then return end
if params.attacker == nil then return end
if self:GetParent() ~= params.unit then return end 
if self:GetParent():GetHealth() > 1 then return end 
if self:GetParent():HasModifier("modifier_up_res_cd") then return end
if self:GetParent():HasModifier("modifier_death") then return end
if self:GetParent():IsInvulnerable() then return end
if self:GetParent():HasModifier("modifier_troll_warlord_battle_trance_custom") then return end
--if self:GetParent():HasModifier("modifier_skeleton_king_reincarnation_custom_legendary") then return end
if self:GetParent():HasModifier("modifier_custom_juggernaut_healing_ward_reduction_aura")  then return end
if self:GetParent():HasModifier("modifier_ember_spirit_flame_guard_custom") and self:GetParent():HasModifier("modifier_ember_guard_5")
  then return end

local ability = self:GetParent():FindAbilityByName("skeleton_king_reincarnation_custom")
if ability and ability:IsFullyCastable() then return end


self:GetParent():Heal(self:GetParent():GetMaxHealth()*self.heal, self:GetParent())

self:GetParent():Purge(false, true, false, true, false)

self:GetParent():AddNewModifier(self:GetParent(), nil, "modifier_up_res_cd", {duration = self.cd})
self:GetParent():AddNewModifier(self:GetParent(), nil, "modifier_up_res_nodmg", {duration = 0.2})
local pfxName = "particles/units/heroes/hero_phoenix/phoenix_supernova_reborn.vpcf"
self:GetParent():EmitSound( "Hero_Phoenix.SuperNova.Explode")


local pfx = ParticleManager:CreateParticle( pfxName, PATTACH_WORLDORIGIN, nil)
ParticleManager:SetParticleControl( pfx, 0, self:GetParent():GetAbsOrigin() )
ParticleManager:SetParticleControl( pfx, 1, Vector(1.5,1.5,1.5) )
ParticleManager:SetParticleControl( pfx, 3, self:GetParent():GetAbsOrigin() )
ParticleManager:ReleaseParticleIndex(pfx)

local targets = FindUnitsInRadius(self:GetParent():GetTeamNumber(), self:GetParent():GetAbsOrigin(), nil, 500, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_INVULNERABLE, FIND_ANY_ORDER, false)
for _,target in ipairs(targets) do

     if not target:IsMagicImmune() then 
              target:AddNewModifier(self:GetParent(), self, "modifier_stunned", {duration = self.stun*(1-target:GetStatusResistance())})
      end
end 


end


function modifier_up_res:OnCreated(table)
if not IsServer() then return end
  self:SetStackCount(1)
  self:GetParent():AddNewModifier(self:GetParent(), nil, "modifier_up_res_ready", {})
end




function modifier_up_res:RemoveOnDeath() return false end
  




modifier_up_res_cd = class({})

function modifier_up_res_cd:IsPurgable() return false end
function modifier_up_res_cd:IsHidden() return false end
function modifier_up_res_cd:IsDebuff() return true end
function modifier_up_res_cd:RemoveOnDeath() return false end


function modifier_up_res_cd:GetTexture()
  return "item_phoenix_ash" end

modifier_up_res_ready = class({})

function modifier_up_res_ready:IsPurgable() return false end
function modifier_up_res_ready:IsHidden() 
  if self:GetParent():HasModifier("modifier_up_res_cd") then 
  return true end  
  return false 
end
function modifier_up_res_ready:RemoveOnDeath() return false end
function modifier_up_res_ready:GetTexture()
  return "item_phoenix_ash" end




 modifier_up_res_nodmg = class({})
 function modifier_up_res_nodmg:IsHidden() return true end 
 function modifier_up_res_nodmg:IsPurgable() return false end
 function modifier_up_res_nodmg:DeclareFunctions()
  return
{
  MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE
}
end

 function modifier_up_res_nodmg:GetModifierIncomingDamage_Percentage() return -100 end