LinkLuaModifier("modifier_custom_phantom_assassin_stifling_dagger_attack", "abilities/phantom_assassin/custom_phantom_assassin_stifling_dagger", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_custom_phantom_assassin_stifling_dagger_slow", "abilities/phantom_assassin/custom_phantom_assassin_stifling_dagger", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_custom_phantom_assassin_stifling_dagger_armor", "abilities/phantom_assassin/custom_phantom_assassin_stifling_dagger", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_custom_phantom_assassin_stifling_dagger_stackig_damage", "abilities/phantom_assassin/custom_phantom_assassin_stifling_dagger", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_custom_phantom_assassin_stifling_dagger_tracker", "abilities/phantom_assassin/custom_phantom_assassin_stifling_dagger", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_custom_phantom_assassin_stifling_dagger_poison", "abilities/phantom_assassin/custom_phantom_assassin_stifling_dagger", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_custom_phantom_assassin_stifling_dagger_poisonstack", "abilities/phantom_assassin/custom_phantom_assassin_stifling_dagger", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_custom_phantom_assassin_stifling_dagger_heal", "abilities/phantom_assassin/custom_phantom_assassin_stifling_dagger", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_custom_phantom_assassin_stifling_dagger_root", "abilities/phantom_assassin/custom_phantom_assassin_stifling_dagger", LUA_MODIFIER_MOTION_NONE)


custom_phantom_assassin_stifling_dagger = class({})

custom_phantom_assassin_stifling_dagger.cd_init = 0.5
custom_phantom_assassin_stifling_dagger.cd_inc = 0.5

custom_phantom_assassin_stifling_dagger.aoe_inc = 1

custom_phantom_assassin_stifling_dagger.chance_inc = 20

custom_phantom_assassin_stifling_dagger.healing = 15
custom_phantom_assassin_stifling_dagger.healing_duration = 10
custom_phantom_assassin_stifling_dagger.healing_max = 6

custom_phantom_assassin_stifling_dagger.root_chance = 30
custom_phantom_assassin_stifling_dagger.root_duration = 1.5

custom_phantom_assassin_stifling_dagger.legendary_chance = 33
custom_phantom_assassin_stifling_dagger.legendary_cast = 0.1


custom_phantom_assassin_stifling_dagger.stacking_damage_init = -1
custom_phantom_assassin_stifling_dagger.stacking_damage_inc = -1
custom_phantom_assassin_stifling_dagger.stacking_duration = 12

custom_phantom_assassin_stifling_dagger.poison_inc = 50
custom_phantom_assassin_stifling_dagger.poison_init = 50
custom_phantom_assassin_stifling_dagger.poison_duration = 4


function custom_phantom_assassin_stifling_dagger:GetCastPoint()
if self:GetCaster():HasModifier("modifier_phantom_assassin_dagger_legendary") then return self.legendary_cast
else return 0.3 end end

function custom_phantom_assassin_stifling_dagger:Dagger( target )

local caster = self:GetCaster()
self.duration = self:GetSpecialValueFor("duration")
  local projectile_name = "particles/units/heroes/hero_phantom_assassin/phantom_assassin_stifling_dagger.vpcf"
  local projectile_speed = self:GetSpecialValueFor("speed")
  local projectile_vision = 450

  local info = {
    Target = target,
    Source = caster,
    Ability = self, 
    EffectName = projectile_name,
    iMoveSpeed = projectile_speed,
    bReplaceExisting = false,                         
    bProvidesVision = true,                           
    iVisionRadius = projectile_vision,        
    iVisionTeamNumber = caster:GetTeamNumber()        
  }
  ProjectileManager:CreateTrackingProjectile(info)

  self:PlayEffects1()

if self:GetCaster():HasModifier("modifier_phantom_assassin_dagger_legendary") then 

  local chance = self.legendary_chance

     local random = RollPseudoRandomPercentage(chance,18,self:GetCaster())
     if random then 
 Timers:CreateTimer(0.13,function()
  if  target:IsAlive() then 
            self:Dagger(target) end
        end)
      end
end

end


function custom_phantom_assassin_stifling_dagger:GetCooldown(iLevel)
local upgrade_cooldown = 0 

if self:GetCaster():HasModifier("modifier_phantom_assassin_dagger_cd") then 
  upgrade_cooldown = self.cd_init + self.cd_inc*self:GetCaster():GetUpgradeStack("modifier_phantom_assassin_dagger_cd")
end

 return self.BaseClass.GetCooldown(self, iLevel) - upgrade_cooldown
 
  end



function custom_phantom_assassin_stifling_dagger:OnSpellStart(target)
  
  local caster = self:GetCaster() 

  self.target = self:GetCursorTarget()
  if target ~= nil then 
    self.target = target
  end

  self:Dagger(self.target)
 

 if self:GetCaster():HasModifier("modifier_phantom_assassin_dagger_aoe")  then
  local j = 0
  local count = self.aoe_inc*my_game:GetUpgradeStack(self:GetCaster(),"modifier_phantom_assassin_dagger_aoe")

  local more_targets = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, self:GetSpecialValueFor("radius"), DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE, FIND_ANY_ORDER, false)
    if #more_targets ~= 0 then


      for _,i in ipairs(more_targets) do

        if  (i ~= self.target) and (j < count ) and (i:GetUnitName() ~= "npc_teleport") and not i:IsCourier() then 
           j = j+1
           self:Dagger(i)

        end
      end

    end

  end



end



function custom_phantom_assassin_stifling_dagger:OnProjectileHit( hTarget, vLocation )
  local target = hTarget
  if target==nil then return end
  if target:IsInvulnerable() then return end
  if target:TriggerSpellAbsorb( self ) then return end
  
  local modifier = self:GetCaster():AddNewModifier(self:GetCaster(),self,"modifier_custom_phantom_assassin_stifling_dagger_attack",{})


    -----------------------------------------ТАЛАНТ LEGEND-----------------------------------------------------------
  if self:GetCaster():HasModifier("modifier_phantom_assassin_dagger_double") then
    hTarget:EmitSound("Phantom_Assassin.LegendaryPosison")
local mod = hTarget:FindModifierByName("modifier_custom_phantom_assassin_stifling_dagger_stackig_damage")
if mod then 
  mod:SetStackCount(mod:GetStackCount()+1)
  else 
  hTarget:AddNewModifier(self:GetCaster(), self, "modifier_custom_phantom_assassin_stifling_dagger_stackig_damage", {duration = self.stacking_duration})
end
end
  -----------------------------------------------------------------------------------------------------------------------

-----------------------------------------ТАЛАНТ ХИЛ-----------------------------------------------------------
  if self:GetCaster():HasModifier("modifier_phantom_assassin_dagger_duration") and not hTarget:IsMagicImmune() then 

    local chance = self.root_chance
    local random = RollPseudoRandomPercentage(chance,48,hTarget)
     if random then 
          hTarget:AddNewModifier(self:GetCaster(), self, "modifier_custom_phantom_assassin_stifling_dagger_root", {duration = self.root_duration* (1-hTarget:GetStatusResistance())})
     end
end
------------------------------------------------------------------------------------------------------------



    -----------------------------------------ТАЛАНТ ХИЛ-----------------------------------------------------------
  if self:GetCaster():HasModifier("modifier_phantom_assassin_dagger_heal") and not hTarget:IsMagicImmune() then 
  hTarget:AddNewModifier(self:GetCaster(), self, "modifier_custom_phantom_assassin_stifling_dagger_heal", {duration = self.healing_duration* (1-hTarget:GetStatusResistance())})
end
------------------------------------------------------------------------------------------------------------

    -----------------------------------------ТАЛАНТ УРОН-----------------------------------------------------------
if self:GetCaster():HasModifier("modifier_phantom_assassin_dagger_damage") then 
  
    local damage = self.poison_init + self.poison_inc*self:GetCaster():GetUpgradeStack("modifier_phantom_assassin_dagger_damage")
     
    hTarget:EmitSound("Phantom_Assassin.PoisonImpact")

    hTarget:AddNewModifier(self:GetCaster(), self, "modifier_custom_phantom_assassin_stifling_dagger_poison", {duration = self.poison_duration, damage = damage/self.poison_duration})
    
    hTarget:AddNewModifier(self:GetCaster(), self, "modifier_custom_phantom_assassin_stifling_dagger_poisonstack", {duration = self.poison_duration})



end
------------------------------------------------------------------------------------------------------------
  self:GetCaster():PerformAttack(hTarget,true,true,true,false,false,false,true)

  if modifier then 
    modifier:Destroy()
  end

  if not hTarget:IsMagicImmune() then 
     hTarget:AddNewModifier(self:GetCaster(),self,"modifier_custom_phantom_assassin_stifling_dagger_slow",{duration = self.duration* (1-hTarget:GetStatusResistance())})
  end
  self:PlayEffects2( hTarget )
end

function custom_phantom_assassin_stifling_dagger:PlayEffects1()
 
  local sound_cast = "Hero_PhantomAssassin.Dagger.Cast"

  
  self:GetCaster():EmitSound( sound_cast  )
end


function custom_phantom_assassin_stifling_dagger:PlayEffects2( target )
  
  local sound_target = "Hero_PhantomAssassin.Dagger.Target"

    target:EmitSound( sound_target  )
end


modifier_custom_phantom_assassin_stifling_dagger_attack = class({})


function modifier_custom_phantom_assassin_stifling_dagger_attack:IsHidden() return true end
function modifier_custom_phantom_assassin_stifling_dagger_attack:IsPurgable() return false end


function modifier_custom_phantom_assassin_stifling_dagger_attack:OnCreated( kv )
 
  self.base_damage = self:GetAbility():GetSpecialValueFor( "base_damage" )  
  self.attack_factor = self:GetAbility():GetSpecialValueFor( "attack_factor" )
end


function modifier_custom_phantom_assassin_stifling_dagger_attack:DeclareFunctions()
   return   {
    MODIFIER_PROPERTY_DAMAGEOUTGOING_PERCENTAGE,
    MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,

  }

 
end

function modifier_custom_phantom_assassin_stifling_dagger_attack:GetModifierDamageOutgoing_Percentage( params )
  if IsServer() then
    return self.attack_factor
  end
end

function modifier_custom_phantom_assassin_stifling_dagger_attack:GetModifierPreAttack_BonusDamage( params )
  if IsServer() then
    return self.base_damage * 100/(100+self.attack_factor)
  end
end




modifier_custom_phantom_assassin_stifling_dagger_slow = class({})


function modifier_custom_phantom_assassin_stifling_dagger_slow:IsHidden() return false end

function modifier_custom_phantom_assassin_stifling_dagger_slow:IsDebuff() return true end

function modifier_custom_phantom_assassin_stifling_dagger_slow:IsPurgable()  return true   end 


function modifier_custom_phantom_assassin_stifling_dagger_slow:OnCreated( kv )

  self.move_slow = self:GetAbility():GetSpecialValueFor( "move_slow" )
  if self:GetCaster():HasModifier("modifier_phantom_assassin_dagger_legendary") then
    self:StartIntervalThink(FrameTime())
  end
end

function modifier_custom_phantom_assassin_stifling_dagger_slow:OnIntervalThink()
if not IsServer() then return end
 AddFOWViewer(self:GetCaster():GetTeamNumber(), self:GetParent():GetAbsOrigin(), 10, FrameTime(), false)
end

function modifier_custom_phantom_assassin_stifling_dagger_slow:OnRefresh( kv )

  self.move_slow = self:GetAbility():GetSpecialValueFor( "move_slow" )  
end



function modifier_custom_phantom_assassin_stifling_dagger_slow:DeclareFunctions()
 return {
    MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
MODIFIER_PROPERTY_TOOLTIP
  }


end

function modifier_custom_phantom_assassin_stifling_dagger_slow:OnTooltip() return 
  self.move_slow  end

function modifier_custom_phantom_assassin_stifling_dagger_slow:GetModifierMoveSpeedBonus_Percentage()
  return self.move_slow
end


function modifier_custom_phantom_assassin_stifling_dagger_slow:GetEffectName()
  return "particles/units/heroes/hero_phantom_assassin/phantom_assassin_stifling_dagger_debuff.vpcf"
end

function modifier_custom_phantom_assassin_stifling_dagger_slow:GetEffectAttachType()
  return PATTACH_ABSORIGIN_FOLLOW
end


---------------------------------------------------------ТАЛАНТ ЛЕГЕНДАРНЫЙ-----------------------------------------------------------------------------------

modifier_custom_phantom_assassin_stifling_dagger_stackig_damage = class({})

function modifier_custom_phantom_assassin_stifling_dagger_stackig_damage:IsHidden() return false end


function modifier_custom_phantom_assassin_stifling_dagger_stackig_damage:GetTexture() return "buffs/dagger_legendary" end


function modifier_custom_phantom_assassin_stifling_dagger_stackig_damage:IsPurgable() return true   end


function modifier_custom_phantom_assassin_stifling_dagger_stackig_damage:OnCreated(table)

self.caster = self:GetCaster()

if self.caster:IsIllusion() then 
  self.caster = self.caster.owner
end

self.ability = self:GetAbility()

self.armor = self.ability.stacking_damage_init + self.ability.stacking_damage_inc*self:GetCaster():GetUpgradeStack("modifier_phantom_assassin_dagger_double")

if not IsServer() then return end
self:SetStackCount(1)
end

function modifier_custom_phantom_assassin_stifling_dagger_stackig_damage:DeclareFunctions()

  return 
{ MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS}
end


function modifier_custom_phantom_assassin_stifling_dagger_stackig_damage:GetModifierPhysicalArmorBonus()
  return 
self:GetStackCount()*self.armor
end 
  


function modifier_custom_phantom_assassin_stifling_dagger_stackig_damage:OnStackCountChanged(iStackCount)
  if not IsServer() then return end

  if not self.pfx then
    self.pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_centaur/centaur_shard_buff_strength_counter_stack.vpcf", PATTACH_OVERHEAD_FOLLOW, self:GetParent())
    
  end

  ParticleManager:SetParticleControl(self.pfx, 2, Vector(self:GetStackCount(), 0 , 0))
  ParticleManager:SetParticleControlEnt(self.pfx, 3, self:GetParent(), PATTACH_OVERHEAD_FOLLOW, nil , self:GetParent():GetAbsOrigin(), true )
end

function modifier_custom_phantom_assassin_stifling_dagger_stackig_damage:OnDestroy()
if not IsServer() then return end
if self.pfx then
ParticleManager:DestroyParticle(self.pfx,false )

  end

end

--------------------------------------------------------------------------------------------------------------------------------------------


------------------------------------------------------------ТАЛАНТ УРОН-----------------------------------------------------------------------------






modifier_custom_phantom_assassin_stifling_dagger_poison = class({})

function modifier_custom_phantom_assassin_stifling_dagger_poison:IsHidden() return true end

function modifier_custom_phantom_assassin_stifling_dagger_poison:IsPurgable()
  return true  end

 
function modifier_custom_phantom_assassin_stifling_dagger_poison:GetAttributes()
  return MODIFIER_ATTRIBUTE_MULTIPLE 
end



function modifier_custom_phantom_assassin_stifling_dagger_poison:OnCreated(table)
if not IsServer() then return end
self.damage = table.damage
self:StartIntervalThink(1)

end

function modifier_custom_phantom_assassin_stifling_dagger_poison:OnIntervalThink()
if not IsServer() then return end
local tik = self.damage

ApplyDamage({ victim = self:GetParent(), attacker = self:GetCaster(), ability = self:GetAbility(), damage = tik, damage_type = DAMAGE_TYPE_MAGICAL})

SendOverheadEventMessage(self:GetParent(), 9, self:GetParent(), tik, nil)


end



function modifier_custom_phantom_assassin_stifling_dagger_poison:OnDestroy()
if not IsServer() then return end
  local mod = self:GetParent():FindModifierByName("modifier_custom_phantom_assassin_stifling_dagger_poisonstack")
  if mod then
  mod:RemoveStack()
end
end





modifier_custom_phantom_assassin_stifling_dagger_poisonstack = class({})


function modifier_custom_phantom_assassin_stifling_dagger_poisonstack:IsPurgable() return true  end

 

function modifier_custom_phantom_assassin_stifling_dagger_poisonstack:IsDebuff() return true end


function modifier_custom_phantom_assassin_stifling_dagger_poisonstack:GetTexture() return "buffs/dagger_damage" end

function modifier_custom_phantom_assassin_stifling_dagger_poisonstack:OnCreated(table) 
if not IsServer() then return end
self:SetStackCount(1)
 end

 function modifier_custom_phantom_assassin_stifling_dagger_poisonstack:OnRefresh(table) 
if not IsServer() then return end
self:SetStackCount(self:GetStackCount()+1)
 end

 function modifier_custom_phantom_assassin_stifling_dagger_poisonstack:RemoveStack()
if not IsServer() then return end
self:SetStackCount(self:GetStackCount()-1)
if self:GetStackCount() == 0 then self:Destroy() end
 end

 --------------------------------------------------------------------------------------------------------------------------------------------
 ---------------------------------------------------ТАЛАНТ ХИЛ-----------------------------------------------------------------------------------------

 modifier_custom_phantom_assassin_stifling_dagger_heal = class({})


function modifier_custom_phantom_assassin_stifling_dagger_heal:IsPurgable() return true  end

 
function modifier_custom_phantom_assassin_stifling_dagger_heal:IsDebuff() return true end
 
function modifier_custom_phantom_assassin_stifling_dagger_heal:IsHidden() return false end


function modifier_custom_phantom_assassin_stifling_dagger_heal:OnCreated(table) 


self.caster = self:GetCaster()

if self.caster:IsIllusion() then 
  self.caster = self.caster.owner
end

self.ability = self:GetAbility()

if not IsServer() then return end
 self:SetStackCount(1)
end

function modifier_custom_phantom_assassin_stifling_dagger_heal:OnRefresh(table)
 if not IsServer() then return end
 if self:GetStackCount() < self.ability.healing_max then 
 self:SetStackCount(self:GetStackCount()+1)
end
end


function modifier_custom_phantom_assassin_stifling_dagger_heal:GetTexture() return "buffs/dagger_heal" end



function modifier_custom_phantom_assassin_stifling_dagger_heal:DeclareFunctions()
return {
    MODIFIER_PROPERTY_HEAL_AMPLIFY_PERCENTAGE_TARGET,
    MODIFIER_PROPERTY_HP_REGEN_AMPLIFY_PERCENTAGE,
    MODIFIER_PROPERTY_LIFESTEAL_AMPLIFY_PERCENTAGE
    }
 end

function modifier_custom_phantom_assassin_stifling_dagger_heal:GetModifierLifestealRegenAmplify_Percentage() return -1*self.ability.healing*self:GetStackCount() end
function modifier_custom_phantom_assassin_stifling_dagger_heal:GetModifierHealAmplify_PercentageTarget() return -1*self.ability.healing*self:GetStackCount() end
function modifier_custom_phantom_assassin_stifling_dagger_heal:GetModifierHPRegenAmplify_Percentage() return -1*self.ability.healing*self:GetStackCount() end

-------------------

modifier_custom_phantom_assassin_stifling_dagger_root = class({})
function modifier_custom_phantom_assassin_stifling_dagger_root:IsHidden() return false end
function modifier_custom_phantom_assassin_stifling_dagger_root:GetTexture() return "buffs/dagger_root" end
function modifier_custom_phantom_assassin_stifling_dagger_root:IsPurgable()  return true end

function modifier_custom_phantom_assassin_stifling_dagger_root:CheckState() return {[MODIFIER_STATE_ROOTED] = true} end