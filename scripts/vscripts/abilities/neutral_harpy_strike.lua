LinkLuaModifier("modifier_neutral_cast", "modifiers/modifier_neutral_cast", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_harpy_strike", "abilities/neutral_harpy_strike", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_harpy_strike_cd", "abilities/neutral_harpy_strike", LUA_MODIFIER_MOTION_NONE)




neutral_harpy_strike = class({})

function neutral_harpy_strike:GetIntrinsicModifierName() return "modifier_harpy_strike" end 





modifier_harpy_strike = class({})

function modifier_harpy_strike:IsPurgable() return false end

function modifier_harpy_strike:IsHidden() return true end

function modifier_harpy_strike:OnCreated(table)
if not IsServer() then return end
self.cd = self:GetAbility():GetSpecialValueFor("cd")
self.damage = self:GetAbility():GetSpecialValueFor("damage")
self.target = nil
self.point = nil
self.timer = nil
self:StartIntervalThink(FrameTime())
end

function modifier_harpy_strike:OnIntervalThink()
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

if not self:GetParent():IsSilenced() and self:GetParent():GetAttackTarget() ~= nil and not self:GetParent():HasModifier("modifier_harpy_strike_cd") and
 not  self:GetParent():HasModifier("modifier_neutral_cast") 
 and not self:GetParent():GetAttackTarget():IsMagicImmune()
  and self:GetParent():GetMana() >= self:GetAbility():GetManaCost(1)
    then 

    self:GetParent():StartGestureWithPlaybackRate(ACT_DOTA_CAST_ABILITY_1, 1)


          self.target = self:GetParent():GetAttackTarget()  
   
     self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_neutral_cast", {})
     
            self.timer = Timers:CreateTimer(0.3,function()  
              self.timer = nil
           self:GetParent():RemoveModifierByName("modifier_neutral_cast")
    
              if self.target ~= nil and self.target:IsAlive() and not self.target:IsMagicImmune() and self:GetParent():IsAlive()  
                and self:GetParent():GetMana() >= self:GetAbility():GetManaCost(1)  then 
                  
                  self:GetParent():SpendMana(self:GetAbility():GetManaCost(1), self:GetAbility())
                self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_harpy_strike_cd", {duration = self.cd})
                 if self.target:TriggerSpellAbsorb( self:GetAbility() ) then return end
               

            self.point = self.target:GetAbsOrigin()  
             self:GetParent():EmitSound("n_creep_HarpyStorm.ChainLighting")
            self.nFXIndex = ParticleManager:CreateParticle("particles/neutral_fx/harpy_chain_lightning.vpcf", PATTACH_POINT_FOLLOW, self:GetParent())
                  ParticleManager:SetParticleControlEnt(self.nFXIndex, 0, self.target, PATTACH_POINT_FOLLOW, "attach_hitloc", self.point, true) 
            ParticleManager:SetParticleControlEnt(self.nFXIndex, 1, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetParent():GetAbsOrigin(), true)
            ParticleManager:ReleaseParticleIndex(self.nFXIndex)


            local damage = self.damage
            if self.target:IsIllusion() then 
              damage = self:GetAbility():GetSpecialValueFor("illusion")
            end
             ApplyDamage({victim = self.target, attacker = self:GetParent(), damage = damage, damage_type = DAMAGE_TYPE_MAGICAL, ability = self:GetAbility()})
         
            


   end
       
   if self.target:IsAlive() and self.target ~= nil then

          self:GetParent():SetForceAttackTarget(self.target)
           Timers:CreateTimer(0.7,function()  
          self:GetParent():SetForceAttackTarget(nil)  end)
 end 

        end)



end



end




modifier_harpy_strike_cd = class({})

function modifier_harpy_strike_cd:IsPurgable() return false end

function modifier_harpy_strike_cd:IsHidden() return false end



