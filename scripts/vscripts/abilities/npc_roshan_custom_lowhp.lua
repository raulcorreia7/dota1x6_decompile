LinkLuaModifier("modifier_roshan_custom_lowhp", "abilities/npc_roshan_custom_lowhp", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_roshan_custom_buff", "abilities/npc_roshan_custom_lowhp", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_roshan_custom_curse", "abilities/npc_roshan_custom_lowhp", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_roshan_custom_spawn", "abilities/npc_roshan_custom_lowhp", LUA_MODIFIER_MOTION_NONE)

npc_roshan_custom_lowhp = class({})



function npc_roshan_custom_lowhp:GetIntrinsicModifierName() return "modifier_roshan_custom_lowhp" end


modifier_roshan_custom_lowhp = class({})
function modifier_roshan_custom_lowhp:IsHidden() return true end
function modifier_roshan_custom_lowhp:IsPurgable() return false end
function modifier_roshan_custom_lowhp:DeclareFunctions()
return
{
  MODIFIER_EVENT_ON_TAKEDAMAGE
}
end

function modifier_roshan_custom_lowhp:OnCreated(table)
if not IsServer() then return end
self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_roshan_custom_curse", {})
self:StartIntervalThink(0.2)
end

function modifier_roshan_custom_lowhp:OnTakeDamage(params)
if not IsServer() then return end
if params.unit ~= self:GetParent() then return end

local health = self:GetAbility():GetSpecialValueFor("health")*self:GetParent():GetMaxHealth()/100

self:SetStackCount(self:GetStackCount() + params.damage)

if self:GetStackCount() < health then return end

self:SetStackCount(0)
self:GetParent():Purge(false, true, false, true, true)
self:GetParent():EmitSound("Roshan.Lowhp")
self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_roshan_custom_buff", {duration = self:GetAbility():GetSpecialValueFor("duration")})


end


function modifier_roshan_custom_lowhp:OnIntervalThink()
if not self:GetParent():IsAlive() then return end
if not IsServer() then return end


local p = FindUnitsInRadius(self:GetParent():GetTeamNumber(), self:GetParent():GetAbsOrigin(), nil, 1025, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_INVULNERABLE +  DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, 0, false)

for _,player in pairs(p) do 
  if player:HasModifier("modifier_smoke_of_deceit") then 
    player:RemoveModifierByName("modifier_smoke_of_deceit")
  end
end


local health = self:GetParent():GetHealth()
local curse = self:GetParent():FindModifierByName("modifier_roshan_custom_curse"):GetStackCount()
local percent = self:GetParent():GetHealthPercent()

CustomGameEventManager:Send_ServerToAllClients( 'roshan_heath_update', {curse = curse, health = health, percent = percent} )

for i = 1,11 do
  if players[i] ~= nil then 
    AddFOWViewer(i, self:GetParent():GetAbsOrigin(), 1200, 0.2, true)
  end
end 


end




modifier_roshan_custom_buff = class({})
function modifier_roshan_custom_buff:IsHidden() return false end
function modifier_roshan_custom_buff:IsPurgable() return false end

function modifier_roshan_custom_buff:OnCreated(table)

self.particle_peffect = ParticleManager:CreateParticle("particles/units/heroes/hero_ogre_magi/ogre_magi_bloodlust_buff.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent()) 
ParticleManager:SetParticleControl(self.particle_peffect, 0, self:GetParent():GetAbsOrigin())
ParticleManager:ReleaseParticleIndex(self.particle_peffect)
self:AddParticle(self.particle_peffect, false, false, -1, false, false)

self.speed = self:GetAbility():GetSpecialValueFor("speed")
self.resist = self:GetAbility():GetSpecialValueFor("resist")
self.move = self:GetAbility():GetSpecialValueFor("move")

if not IsServer() then return end
self:IncrementStackCount()

end

function modifier_roshan_custom_buff:OnRefresh(table)
if not IsServer() then return end
self:OnCreated()
end

function modifier_roshan_custom_buff:DeclareFunctions()
return
{
  MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
  MODIFIER_PROPERTY_STATUS_RESISTANCE_STACKING,
  MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
  MODIFIER_PROPERTY_MODEL_SCALE
}
end

function modifier_roshan_custom_buff:GetModifierAttackSpeedBonus_Constant() return self:GetStackCount()*self.speed end
function modifier_roshan_custom_buff:GetModifierStatusResistanceStacking() return self:GetStackCount()*self.resist end
function modifier_roshan_custom_buff:GetModifierMoveSpeedBonus_Percentage() return self:GetStackCount()*self.move end



function modifier_roshan_custom_buff:GetModifierModelScale() return self:GetStackCount() * 10 end





modifier_roshan_custom_curse = class({})
function modifier_roshan_custom_curse:IsHidden() return true end
function modifier_roshan_custom_curse:IsPurgable() return false end
function modifier_roshan_custom_curse:IsDebuff() return true end

function modifier_roshan_custom_curse:OnCreated(table)
if not IsServer() then return end
self:SetStackCount(self:GetAbility():GetSpecialValueFor("time"))
self:StartIntervalThink(1)
end

function modifier_roshan_custom_curse:OnIntervalThink()
if not IsServer() then return end
self:DecrementStackCount()

if self:GetStackCount() == 0 then 
  self:GetParent():ForceKill(false)
end
end

function modifier_roshan_custom_curse:DeclareFunctions()
return
{
  MODIFIER_EVENT_ON_DEATH
}

end

function modifier_roshan_custom_curse:OnDeath(params)
if self:GetParent() ~= params.unit then return end

self.particle_peffect = ParticleManager:CreateParticle("particles/neutral_fx/roshan_death.vpcf", PATTACH_WORLDORIGIN, nil) 
ParticleManager:SetParticleControl(self.particle_peffect, 0, self:GetParent():GetAbsOrigin())
ParticleManager:ReleaseParticleIndex(self.particle_peffect)


my_game:DestroyRoshan()

end


modifier_roshan_custom_spawn = class({})
function modifier_roshan_custom_spawn:IsHidden() return true end
function modifier_roshan_custom_spawn:IsPurgable() return false end
function modifier_roshan_custom_spawn:CheckState() return {[MODIFIER_STATE_INVULNERABLE] = true} end
function modifier_roshan_custom_spawn:OnCreated(table)
if not IsServer() then return end
self:GetParent():StartGesture(ACT_DOTA_CAST_ABILITY_1)
end