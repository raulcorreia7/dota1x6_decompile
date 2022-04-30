LinkLuaModifier("modifier_neutral_cast", "modifiers/modifier_neutral_cast", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_golem_stun", "abilities/neutral_golem_stun", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_golem_stun_cd", "abilities/neutral_golem_stun", LUA_MODIFIER_MOTION_NONE)




neutral_golem_stun = class({})

function neutral_golem_stun:GetIntrinsicModifierName() return "modifier_golem_stun" end 



function neutral_golem_stun:OnProjectileHit(hTarget, vLocation)
if not IsServer() then return end

  if hTarget==nil then return end
  if hTarget:IsInvulnerable() then return end
  if hTarget:TriggerSpellAbsorb( self ) then return end
  if hTarget:IsMagicImmune() then return end
  
self.stun = self:GetSpecialValueFor("stun")
self.damage = self:GetSpecialValueFor("damage")

hTarget:AddNewModifier(self:GetCaster(), self, "modifier_stunned", {duration = self.stun*(1 - hTarget:GetStatusResistance())})     
 ApplyDamage({victim = hTarget, attacker = self:GetCaster(), damage = self.damage, damage_type = DAMAGE_TYPE_MAGICAL, ability = self})
    hTarget:EmitSound("n_mud_golem.Boulder.Target")
end


modifier_golem_stun = class({})

function modifier_golem_stun:IsPurgable() return false end

function modifier_golem_stun:IsHidden() return true end

function modifier_golem_stun:OnCreated(table)
if not IsServer() then return end
self.cd = self:GetAbility():GetSpecialValueFor("cd")
 self.target = nil
 self.timer = nil
self:StartIntervalThink(FrameTime())
end

function modifier_golem_stun:OnIntervalThink()
if not IsServer() then return end

if self:GetParent():IsSilenced() or self:GetParent():IsStunned() or not self:GetParent():IsAlive() then 
  if self.timer ~= nil then 
    Timers:RemoveTimer(self.timer)
    self:GetParent():FadeGesture(ACT_DOTA_CAST_ABILITY_1)
    self.timer = nil
    self:GetParent():RemoveModifierByName("modifier_neutral_cast")
  end
  return
end

if not self:GetParent():IsSilenced() and self:GetParent():GetAttackTarget() ~= nil and not self:GetParent():HasModifier("modifier_golem_stun_cd") 
  and not  self:GetParent():HasModifier("modifier_neutral_cast") 
and  not self:GetParent():GetAttackTarget():HasModifier("modifier_stunned") and not self:GetParent():GetAttackTarget():IsMagicImmune()
 and self:GetParent():GetMana() >= self:GetAbility():GetManaCost(1)
    then 

    self:GetParent():StartGestureWithPlaybackRate(ACT_DOTA_CAST_ABILITY_1, 1)
    self:GetParent():EmitSound("n_mud_golem.Boulder.Cast")

self.target = self:GetParent():GetAttackTarget()
   
     self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_neutral_cast", {})
     
            self.timer = Timers:CreateTimer(0.1,function()
              self.timer = nil 
            self:GetParent():RemoveModifierByName("modifier_neutral_cast")

            if self.target ~= nil and self.target:IsAlive() and self:GetParent():IsAlive() and self:GetParent():GetMana() >= self:GetAbility():GetManaCost(1) then 
            self:GetParent():SpendMana(self:GetAbility():GetManaCost(1), self:GetAbility())
            self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_golem_stun_cd", {duration = self.cd})

              local projectile_name = "particles/neutral_fx/mud_golem_hurl_boulder.vpcf"
              local projectile_speed = self:GetAbility():GetSpecialValueFor("speed")
              local projectile_vision = 450

              local info = {
                 Target = self.target,
                 Source = self:GetParent(),
                 Ability = self:GetAbility(), 
                 EffectName = projectile_name,
                 iMoveSpeed = projectile_speed,
                 bReplaceExisting = false,                         
                 bProvidesVision = true,                           
                 iVisionRadius = projectile_vision,        
                 iVisionTeamNumber = self:GetParent():GetTeamNumber()        
                  }
              ProjectileManager:CreateTrackingProjectile(info)

            end

            if self.target:IsAlive() and self.target ~= nil then 

          self:GetParent():SetForceAttackTarget(self.target)
           Timers:CreateTimer(0.7,function()  
          self:GetParent():SetForceAttackTarget(nil)  end)
         end

        end)



end



end




modifier_golem_stun_cd = class({})

function modifier_golem_stun_cd:IsPurgable() return false end

function modifier_golem_stun_cd:IsHidden() return false end



