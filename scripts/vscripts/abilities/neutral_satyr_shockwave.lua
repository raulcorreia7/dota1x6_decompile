LinkLuaModifier("modifier_neutral_cast", "modifiers/modifier_neutral_cast", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_satyr_shockwave", "abilities/neutral_satyr_shockwave", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_satyr_shockwave_cd", "abilities/neutral_satyr_shockwave", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_satyr_shockwave_silence", "abilities/neutral_satyr_shockwave", LUA_MODIFIER_MOTION_NONE)





neutral_satyr_shockwave = class({})

function neutral_satyr_shockwave:GetIntrinsicModifierName() return "modifier_satyr_shockwave" end 



function neutral_satyr_shockwave:OnProjectileHit(hTarget, vLocation)
if not IsServer() then return end

  if hTarget==nil then return end
  if hTarget:IsInvulnerable() then return end
  if hTarget:IsMagicImmune() then return end

self.silence = self:GetSpecialValueFor("silence")
self.damage = self:GetSpecialValueFor("damage")

hTarget:AddNewModifier(self:GetCaster(), self, "modifier_satyr_shockwave_silence", {duration = self.silence*(1 - hTarget:GetStatusResistance())})     
 ApplyDamage({victim = hTarget, attacker = self:GetCaster(), damage = self.damage, damage_type = DAMAGE_TYPE_MAGICAL, ability = self})
    hTarget:EmitSound("n_creep_SatyrHellcaller.Shockwave.Damage")

end


modifier_satyr_shockwave = class({})

function modifier_satyr_shockwave:IsPurgable() return false end

function modifier_satyr_shockwave:IsHidden() return true end

function modifier_satyr_shockwave:OnCreated(table)
if not IsServer() then return end
self.cd = self:GetAbility():GetSpecialValueFor("cd")
self.speed = self:GetAbility():GetSpecialValueFor("speed")
self.distance = self:GetAbility():GetSpecialValueFor("distance")
 self.target = nil
 self.timer = nil
self.radius = self:GetAbility():GetSpecialValueFor("radius")
self:StartIntervalThink(FrameTime())
end


 


function modifier_satyr_shockwave:OnIntervalThink()
if not IsServer() then return end


if self:GetParent():IsSilenced() or self:GetParent():IsStunned() or not self:GetParent():IsAlive() then 
  if self.timer ~= nil then 
    Timers:RemoveTimer(self.timer)
    self.timer = nil
    self:GetParent():RemoveModifierByName("modifier_neutral_cast")
     ParticleManager:DestroyParticle(self.sign, true)
    self:GetParent():FadeGesture(ACT_DOTA_CAST_ABILITY_1)
  end
  return
end

if not self:GetParent():IsSilenced() and self:GetParent():GetAttackTarget() ~= nil and not self:GetParent():HasModifier("modifier_satyr_shockwave_cd") and not 
  self:GetParent():HasModifier("modifier_neutral_cast") and not self:GetParent():GetAttackTarget():IsMagicImmune() 
 and self:GetParent():GetMana() >= self:GetAbility():GetManaCost(1)
    then 

    self:GetParent():StartGestureWithPlaybackRate(ACT_DOTA_CAST_ABILITY_1, 0.8)
self.sign = ParticleManager:CreateParticle( "particles/generic_gameplay/generic_has_quest.vpcf", PATTACH_OVERHEAD_FOLLOW, self:GetParent())

  self.target = self:GetParent():GetAttackTarget()
     self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_neutral_cast", {})



    local point = self:GetParent():GetAttackTarget():GetAbsOrigin()

         self.timer = Timers:CreateTimer(0.8,function()
          self.timer = nil
          ParticleManager:DestroyParticle(self.sign, true)

          self:GetParent():RemoveModifierByName("modifier_neutral_cast")

            if self.target ~= nil and self.target:IsAlive() and self:GetParent():IsAlive()  and self:GetParent():GetMana() >= self:GetAbility():GetManaCost(1) then 
              self:GetParent():SpendMana(self:GetAbility():GetManaCost(1), self:GetAbility())
         self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_satyr_shockwave_cd", {duration = self.cd})

    local direction = point - self:GetParent():GetAbsOrigin() + self:GetParent():GetForwardVector()*10
    self:GetParent():EmitSound("n_creep_SatyrHellcaller.Shockwave")
    direction.z = 0.0
    direction = direction:Normalized()
    local info = {
            EffectName = "particles/neutral_fx/satyr_hellcaller.vpcf",
            Ability = self:GetAbility(),
            vSpawnOrigin = self:GetParent():GetOrigin(), 
            fStartRadius = 70,
            fEndRadius = self.radius,
            vVelocity = direction * self.speed,
            fDistance = self.distance,
            Source = self:GetParent(),
            bDeleteOnHit = false,
            fExpireTime = GameRules:GetGameTime() + 4,
            iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
            iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
        }


    ProjectileManager:CreateLinearProjectile(info)


       end

  if self.target:IsAlive() and self.target ~= nil then 

          self:GetParent():SetForceAttackTarget(self.target)
           Timers:CreateTimer(0.7,function()  
          self:GetParent():SetForceAttackTarget(nil)  end)
         end


        end)



end



end




modifier_satyr_shockwave_cd = class({})

function modifier_satyr_shockwave_cd:IsPurgable() return false end

function modifier_satyr_shockwave_cd:IsHidden() return false end



modifier_satyr_shockwave_silence = class({})

function modifier_satyr_shockwave_silence:IsPurgable() return true end

function modifier_satyr_shockwave_silence:IsHidden() return false end
function modifier_satyr_shockwave_silence:CheckState() return {[MODIFIER_STATE_SILENCED] = true} end


function modifier_satyr_shockwave_silence:GetEffectName() return "particles/generic_gameplay/generic_silenced.vpcf" end
 
function modifier_satyr_shockwave_silence:GetEffectAttachType() return PATTACH_OVERHEAD_FOLLOW end