LinkLuaModifier("modifier_custom_huskar_burning_spear_counter", "abilities/huskar/custom_huskar_burning_spear", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_custom_huskar_burning_spear_debuff", "abilities/huskar/custom_huskar_burning_spear", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier( "modifier_generic_orb_effect_lua", "abilities/generic/modifier_generic_orb_effect_lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier("modifier_custom_huskar_burning_spear_armor", "abilities/huskar/custom_huskar_burning_spear", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_custom_huskar_burning_spear_legendary", "abilities/huskar/custom_huskar_burning_spear", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_custom_huskar_burning_spear_legendary_buff", "abilities/huskar/custom_huskar_burning_spear", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_custom_huskar_burning_spear_heal", "abilities/huskar/custom_huskar_burning_spear", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_custom_huskar_burning_spear_slow", "abilities/huskar/custom_huskar_burning_spear", LUA_MODIFIER_MOTION_NONE)





custom_huskar_burning_spear               = class({})
modifier_custom_huskar_burning_spear_counter        = class({})
modifier_custom_huskar_burning_spear_debuff        = class({})
modifier_custom_huskar_burning_spear_armor        = class({})
modifier_custom_huskar_burning_spear_legendary    = class({})
modifier_custom_huskar_burning_spear_heal           = class({})

custom_huskar_burning_spear.double_chance = {12, 20}
custom_huskar_burning_spear.double_slow = -40
custom_huskar_burning_spear.double_slow_duration = 1

custom_huskar_burning_spear.legendary_cd = 20
custom_huskar_burning_spear.legendary_damage = 0.8
custom_huskar_burning_spear.legendary_stun = 0.2
custom_huskar_burning_spear.legendary_stun_max = 1.6

custom_huskar_burning_spear.armor_chance_init = 5
custom_huskar_burning_spear.armor_chance_inc = 5

custom_huskar_burning_spear.aoe_max = 2
custom_huskar_burning_spear.aoe_radius = 300
custom_huskar_burning_spear.aoe_duration = 1

custom_huskar_burning_spear.reduce_heal = -1
custom_huskar_burning_spear.reduce_damage = -1

custom_huskar_burning_spear.damage_init = 0
custom_huskar_burning_spear.damage_inc = 2

custom_huskar_burning_spear.heal_init = 0.05
custom_huskar_burning_spear.heal_inc = 0.05
custom_huskar_burning_spear.heal_creeps = 0.33


function custom_huskar_burning_spear:GetIntrinsicModifierName()
  if self:GetCaster():HasModifier("modifier_huskar_spears_legendary") then 
    return "modifier_custom_huskar_burning_spear_legendary"
 else 
 return "modifier_generic_orb_effect_lua" end
end

function custom_huskar_burning_spear:GetBehavior()
  if self:GetCaster():HasModifier("modifier_huskar_spears_legendary") then
    return DOTA_ABILITY_BEHAVIOR_NO_TARGET
   end
 return DOTA_ABILITY_BEHAVIOR_UNIT_TARGET + DOTA_ABILITY_BEHAVIOR_AUTOCAST + DOTA_ABILITY_BEHAVIOR_ATTACK 
end

function custom_huskar_burning_spear:GetProjectileName()
if not self:GetCaster():HasModifier("modifier_huskar_spears_legendary") then 
  return "particles/units/heroes/hero_huskar/huskar_burning_spear.vpcf"
end
end

function custom_huskar_burning_spear:GetCooldown(iLevel)
if self:GetCaster():HasModifier("modifier_huskar_spears_legendary") then return self.legendary_cd end  
end

--function custom_huskar_burning_spear:GetAbilityTargetFlags()
--  if self:GetCaster():HasModifier("modifier_huskar_spears_pure") then
 --   return DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES
 -- else
 --   return DOTA_UNIT_TARGET_FLAG_NONE
 -- end
--end

function custom_huskar_burning_spear:OnAbilityPhaseStart()
if not IsServer() then return end
self:GetCaster():StartGesture(ACT_DOTA_CAST_ABILITY_1)
return true
end

function custom_huskar_burning_spear:OnAbilityPhaseInterrupted()
if not IsServer() then return end
self:GetCaster():FadeGesture(ACT_DOTA_CAST_ABILITY_1)
end


function custom_huskar_burning_spear:OnSpellStart()
if not IsServer() then return end
if not self:GetCaster():HasModifier("modifier_huskar_spears_legendary") then return end

local effect = ParticleManager:CreateParticle("particles/huskar_fast.vpcf", PATTACH_ABSORIGIN, self:GetCaster())
ParticleManager:SetParticleControlEnt(effect, 0, self:GetCaster(), PATTACH_ABSORIGIN, nil, self:GetCaster():GetOrigin(), true)
ParticleManager:SetParticleControlEnt(effect, 1, self:GetCaster(), PATTACH_ABSORIGIN, nil, self:GetCaster():GetOrigin(), true)
ParticleManager:ReleaseParticleIndex(effect)

self:GetCaster():EmitSound("Huskar.Spear_Cast")
 

local enemies = FindUnitsInRadius(self:GetCaster():GetTeamNumber(), Vector(0,0,0), nil, FIND_UNITS_EVERYWHERE, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_OUT_OF_WORLD + DOTA_UNIT_TARGET_FLAG_INVULNERABLE, FIND_CLOSEST, false)

for _,enemy in pairs(enemies) do 
  
    if enemy:HasModifier("modifier_custom_huskar_burning_spear_debuff") then 

        local count = 0
        local total = 0
        for _,mod in pairs(enemy:FindAllModifiers()) do 
            if mod:GetName() == "modifier_custom_huskar_burning_spear_debuff" then 
        
            local damage = self:GetSpecialValueFor("burn_damage") 

            if self:GetCaster():HasModifier("modifier_huskar_spears_damage") then 
              damage = damage + self.damage_init + self.damage_inc*self:GetCaster():GetUpgradeStack("modifier_huskar_spears_damage")
            end

            damage = damage*mod:GetRemainingTime()

            count = count + 1
            total = total + damage
            mod:Destroy()
            end
        end

        local stun = math.min(count*self.legendary_stun, self.legendary_stun_max)

        enemy:AddNewModifier(self:GetCaster(), self, "modifier_stunned", {duration = (1 - enemy:GetStatusResistance())*stun})

        ApplyDamage({victim = enemy,attacker = self:GetCaster(),ability = self,damage = total*self.legendary_damage, damage_type = DAMAGE_TYPE_MAGICAL,ability = self })

        local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_ogre_magi/ogre_magi_fireblast.vpcf", PATTACH_ABSORIGIN_FOLLOW, enemy)
        ParticleManager:SetParticleControlEnt( particle, 0, enemy, PATTACH_POINT_FOLLOW, "attach_hitloc", Vector(0,0,0), true )
        ParticleManager:SetParticleControl( particle, 1, enemy:GetOrigin() )
        ParticleManager:ReleaseParticleIndex( particle )
        enemy:EmitSound("Hero_OgreMagi.Fireblast.Target")
    end


end  


end



function custom_huskar_burning_spear:AddFire(target)
if not IsServer() then return end
local duration = self:GetDuration() + self.aoe_duration*self:GetCaster():GetUpgradeStack("modifier_huskar_spears_aoe")


target:EmitSound("Hero_Huskar.Burning_Spear")
target:AddNewModifier(self:GetCaster(), self, "modifier_custom_huskar_burning_spear_debuff", { duration = duration })
target:AddNewModifier(self:GetCaster(), self, "modifier_custom_huskar_burning_spear_counter", { duration = duration })

if self:GetCaster():HasModifier("modifier_huskar_spears_tick") then 

  local chance = self.double_chance[self:GetCaster():GetUpgradeStack("modifier_huskar_spears_tick")]

  local random = RollPseudoRandomPercentage(chance,182,target)

  if random then
    target:EmitSound("Huskar.Spear_double")
    target:AddNewModifier(self:GetCaster(), self, "modifier_custom_huskar_burning_spear_slow", {duration = (1 - target:GetStatusResistance())*self.double_slow_duration})
    target:AddNewModifier(self:GetCaster(), self, "modifier_custom_huskar_burning_spear_debuff", { duration = duration })
    target:AddNewModifier(self:GetCaster(), self, "modifier_custom_huskar_burning_spear_counter", { duration = duration })
  end 


end

end

function custom_huskar_burning_spear:FireStack( target  )
if not IsServer() then return end
if target:IsBuilding() or target:IsCourier()  then return end



self:AddFire(target)


if self:GetCaster():HasModifier("modifier_huskar_spears_aoe")  then 

    local count = 0
    local enemy = nil

    enemy = FindUnitsInRadius(self:GetCaster():GetTeamNumber(), target:GetAbsOrigin(), nil, self.aoe_radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NONE , FIND_CLOSEST, false)

  
    for _,i in ipairs(enemy) do
           if i ~= target and not i:IsBuilding() and count < self.aoe_max and i:IsAlive() then 
              count = count + 1
              self:AddFire(i)
          end
    end
end





end




function custom_huskar_burning_spear:FireTick( target, stack )
if not IsServer() then return end

  if self and self:GetCaster() then

    self.damageTable = {
    victim = target,
    attacker = self:GetCaster(),
    ability = self
      }

    self.burn_damage = self:GetSpecialValueFor("burn_damage") 

    if self:GetCaster():HasModifier("modifier_huskar_spears_damage") then 
      self.burn_damage = self.burn_damage + self.damage_init + self.damage_inc*self:GetCaster():GetUpgradeStack("modifier_huskar_spears_damage")
    end

    self.damage_type = DAMAGE_TYPE_MAGICAL


  end
  
  self.damageTable.damage    = stack * self.burn_damage
  self.damageTable.damage_type  = self.damage_type

  ApplyDamage( self.damageTable )



end



function custom_huskar_burning_spear:MakeSpear(caster)
if not IsServer() then return end

caster:EmitSound("Hero_Huskar.Burning_Spear.Cast")
  
  local health_cost = (caster:GetHealth() * self:GetSpecialValueFor("health_cost") * 0.01)


  caster:SetHealth(math.max(caster:GetHealth() - health_cost, 1))


end



function custom_huskar_burning_spear:OnOrbFire()
  if self:GetCaster():IsSilenced() then return end
 self:MakeSpear(self:GetCaster())
end

function custom_huskar_burning_spear:OnOrbImpact( keys )

  if self:GetCaster():IsSilenced() then return end

  if not keys.target:IsMagicImmune() then  
    self:FireStack(keys.target)
  end

end

------------------------------------
-- BURNING SPEAR COUNTER MODIFIER --
------------------------------------

function modifier_custom_huskar_burning_spear_counter:IgnoreTenacity()  return true end
function modifier_custom_huskar_burning_spear_counter:IsPurgable()    return false end

function modifier_custom_huskar_burning_spear_counter:GetEffectName()
  return "particles/units/heroes/hero_huskar/huskar_burning_spear_debuff.vpcf"
end

function modifier_custom_huskar_burning_spear_counter:Procs()
if not IsServer() then return end



end
function modifier_custom_huskar_burning_spear_counter:DeclareFunctions()
if self:GetCaster():HasModifier("modifier_huskar_spears_pure") then 
return
{
  MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE, 
  MODIFIER_PROPERTY_HEAL_AMPLIFY_PERCENTAGE_TARGET,
    MODIFIER_PROPERTY_HP_REGEN_AMPLIFY_PERCENTAGE,
MODIFIER_PROPERTY_LIFESTEAL_AMPLIFY_PERCENTAGE
}
end

end

function modifier_custom_huskar_burning_spear_counter:GetModifierTotalDamageOutgoing_Percentage()
return self:GetStackCount()*(self:GetAbility().reduce_damage)
end

function modifier_custom_huskar_burning_spear_counter:GetModifierLifestealRegenAmplify_Percentage()
return self:GetStackCount()*(self:GetAbility().reduce_heal)
end

function modifier_custom_huskar_burning_spear_counter:GetModifierHealAmplify_PercentageTarget() 
return self:GetStackCount()*(self:GetAbility().reduce_heal)
end

function modifier_custom_huskar_burning_spear_counter:GetModifierHPRegenAmplify_Percentage() 
return self:GetStackCount()*(self:GetAbility().reduce_heal)
end




function modifier_custom_huskar_burning_spear_counter:OnCreated()
if not IsServer() then return end
  self.RemoveForDuel = true
 
  self:Procs()

  self:IncrementStackCount()

  self:StartIntervalThink(1)
end

function modifier_custom_huskar_burning_spear_counter:OnRefresh()
if not IsServer() then return end
  
  self:Procs()
  self:IncrementStackCount()

end

function modifier_custom_huskar_burning_spear_counter:OnIntervalThink()

 self:GetAbility():FireTick(self:GetParent(), self:GetStackCount())  

end



function modifier_custom_huskar_burning_spear_counter:OnDestroy()
  if not IsServer() then return end
  
  self:GetParent():StopSound("Hero_Huskar.Burning_Spear")
end

----------------------------------------------------------------------------------------------------------------------------


---------------------------------------------------СТРЕЛЫ-------------------------------------------------------

function modifier_custom_huskar_burning_spear_debuff:IgnoreTenacity() return true end
function modifier_custom_huskar_burning_spear_debuff:IsHidden()     return true end
function modifier_custom_huskar_burning_spear_debuff:IsPurgable()   return false end
function modifier_custom_huskar_burning_spear_debuff:GetAttributes()  return MODIFIER_ATTRIBUTE_MULTIPLE end

function modifier_custom_huskar_burning_spear_debuff:OnCreated(table)
self.RemoveForDuel = true


end


function modifier_custom_huskar_burning_spear_debuff:OnDestroy()
  if not IsServer() then return end
  
  local burning_spear_counter = self:GetParent():FindModifierByNameAndCaster("modifier_custom_huskar_burning_spear_counter", self:GetCaster())
  
  if burning_spear_counter then
    burning_spear_counter:DecrementStackCount()

    if burning_spear_counter:GetStackCount() == 0 then 
       burning_spear_counter:Destroy()
    end
  end

  if self:GetCaster() and self.tick then 
      self.tick:DecrementStackCount()
      if self.tick:GetStackCount() < 1 then 
        self.tick:Destroy()
      end
  end

end

----------------------------------------------------------------------------------------------------------------------------


-----------------------------------------------------ТАЛАНТ АРМОР-----------------------------------------------------
function modifier_custom_huskar_burning_spear_armor:IsHidden() return true end
function modifier_custom_huskar_burning_spear_armor:IsPurgable() return false end
function modifier_custom_huskar_burning_spear_armor:RemoveOnDeath() return false end
function modifier_custom_huskar_burning_spear_armor:DeclareFunctions()
return
{
  MODIFIER_EVENT_ON_ATTACK_LANDED
}
end
function modifier_custom_huskar_burning_spear_armor:OnAttackLanded(params)
if not IsServer() then return end
if self:GetParent() ~= params.target then return end
if params.attacker:IsMagicImmune() then return end
if params.attacker:IsBuilding() then return end

local chance = self:GetAbility().armor_chance_init + self:GetAbility().armor_chance_inc*self:GetParent():GetUpgradeStack("modifier_huskar_spears_armor")
local random = RollPseudoRandomPercentage(chance,18,self:GetParent())

if random then 
  self:GetAbility():FireStack(params.attacker)
end

end


----------------------------------------------------------------------------------------------------------------------------






function modifier_custom_huskar_burning_spear_heal:IsHidden() return true end
function modifier_custom_huskar_burning_spear_heal:IsPurgable() return false end
function modifier_custom_huskar_burning_spear_heal:RemoveOnDeath() return false end
function modifier_custom_huskar_burning_spear_heal:DeclareFunctions()
return
{
  MODIFIER_EVENT_ON_TAKEDAMAGE
}
end
function modifier_custom_huskar_burning_spear_heal:OnTakeDamage(params)
if not IsServer() then return end
if self:GetParent() ~= params.attacker then return end
if params.inflictor ~= self:GetAbility() then return end 
if not self:GetParent():IsAlive() then return end

local heal = params.damage*(self:GetAbility().heal_init + self:GetAbility().heal_inc*self:GetCaster():GetUpgradeStack("modifier_huskar_spears_blast"))

if params.unit:IsCreep() then 
  heal = heal*self:GetAbility().heal_creeps
end

self:GetCaster():Heal(heal, self:GetCaster())

local particle = ParticleManager:CreateParticle( "particles/orange_heal.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster() )
ParticleManager:ReleaseParticleIndex( particle )
SendOverheadEventMessage(self:GetCaster(), 10, self:GetCaster(), heal, nil)


end







-----------------------------------------------------ТАЛАНТ ЛЕГЕНДАРНЫЙ-----------------------------------------------------

function modifier_custom_huskar_burning_spear_legendary:IsHidden() return true end
function modifier_custom_huskar_burning_spear_legendary:IsPurgable() return false end
function modifier_custom_huskar_burning_spear_legendary:RemoveOnDeath() return false
end


function modifier_custom_huskar_burning_spear_legendary:DeclareFunctions()
return
{
  MODIFIER_EVENT_ON_ATTACK_LANDED,
  MODIFIER_EVENT_ON_ATTACK_START,
  MODIFIER_EVENT_ON_ATTACK
}

end
function modifier_custom_huskar_burning_spear_legendary:OnAttackStart(params)
if not IsServer() then return end
if self:GetParent() ~= params.attacker then return end

if (not params.target:IsMagicImmune()) and not self:GetParent():PassivesDisabled()
  and not params.target:IsBuilding() and not params.target:IsCourier()  then 

  self:GetParent():SetRangedProjectileName("particles/units/heroes/hero_huskar/huskar_burning_spear.vpcf")
else
  self:GetParent():SetRangedProjectileName("particles/units/heroes/hero_huskar/huskar_base_attack.vpcf")

end



end

function modifier_custom_huskar_burning_spear_legendary:OnAttack(params)
if not IsServer() then return end
if self:GetParent() ~= params.attacker then return end
if self:GetParent():PassivesDisabled() then return end

if params.target:IsMagicImmune() then return end
if params.target:IsBuilding() or params.target:IsCourier() then return end 

  self:GetAbility():MakeSpear(self:GetParent())

end


function modifier_custom_huskar_burning_spear_legendary:OnAttackLanded(params)
if not IsServer() then return end
if self:GetParent():PassivesDisabled() then return end

if self:GetParent() ~= params.attacker then return end
if params.target:IsBuilding() or params.target:IsCourier()  then return end  

if params.target:IsMagicImmune() then return end

    self:GetAbility():FireStack(params.target, true )



end

----------------------------------------------------------------------------------------------------------------------------




----------------------------------------------------------------------------------------------------------------------------


modifier_custom_huskar_burning_spear_legendary_buff = class({})
function modifier_custom_huskar_burning_spear_legendary_buff:IsHidden() return false end
function modifier_custom_huskar_burning_spear_legendary_buff:IsPurgable() return false end
function modifier_custom_huskar_burning_spear_legendary_buff:GetEffectName() return "particles/huskar_spears_legen.vpcf" end

function modifier_custom_huskar_burning_spear_legendary_buff:OnCreated(table)
if not IsServer() then return end
  self.RemoveForDuel = true
  self.hands = ParticleManager:CreateParticle("particles/huskar_hands.vpcf",PATTACH_ABSORIGIN_FOLLOW,self:GetParent())
  ParticleManager:SetParticleControlEnt(self.hands,0,self:GetParent(),PATTACH_ABSORIGIN_FOLLOW,"follow_origin",self:GetParent():GetOrigin(),false)
  self:AddParticle(self.hands,true,false,0,false,false)
end




modifier_custom_huskar_burning_spear_slow = class({})
function modifier_custom_huskar_burning_spear_slow:IsHidden() return false end
function modifier_custom_huskar_burning_spear_slow:IsPurgable() return true end
function modifier_custom_huskar_burning_spear_slow:GetTexture() return "buffs/remnant_slow" end
function modifier_custom_huskar_burning_spear_slow:GetEffectName()
  return "particles/units/heroes/hero_phoenix/phoenix_icarus_dive_burn_debuff.vpcf"
end
function modifier_custom_huskar_burning_spear_slow:OnCreated(table)
if not IsServer() then return end

local iParticleID = ParticleManager:CreateParticle("particles/units/heroes/hero_terrorblade/ember_slow.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
ParticleManager:SetParticleControl(iParticleID, 0, self:GetParent():GetAbsOrigin())
self:AddParticle(iParticleID, true, false, -1, false, false)

end




function modifier_custom_huskar_burning_spear_slow:DeclareFunctions()
return
{
  MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
}

end

function modifier_custom_huskar_burning_spear_slow:GetModifierMoveSpeedBonus_Percentage()
return self:GetAbility().double_slow
end
