LinkLuaModifier("modifier_neutral_cast", "modifiers/modifier_neutral_cast", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_dragon_fire_ability", "abilities/neutral_dragon_fire", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_dragon_fire_thinker", "abilities/neutral_dragon_fire", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_dragon_fire_aura", "abilities/neutral_dragon_fire", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_dragon_fire_slow", "abilities/neutral_dragon_fire", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_dragon_fire_cd", "abilities/neutral_dragon_fire", LUA_MODIFIER_MOTION_NONE)




neutral_dragon_fire = class({})

function neutral_dragon_fire:GetIntrinsicModifierName() return "modifier_dragon_fire_ability" end 


modifier_dragon_fire_ability = class({})

function modifier_dragon_fire_ability:IsPurgable() return false end

function modifier_dragon_fire_ability:IsHidden() return true end

function modifier_dragon_fire_ability:OnCreated(table)
if not IsServer() then return end
self.cd = self:GetAbility():GetSpecialValueFor("cd")
self.duration = self:GetAbility():GetSpecialValueFor("duration")
self.target = nil
self.point = nil
self.timer = nil
self:StartIntervalThink(FrameTime())
end

function modifier_dragon_fire_ability:OnIntervalThink()
if not IsServer() then return end

if self:GetParent():IsSilenced() or self:GetParent():IsStunned() or not self:GetParent():IsAlive() then 
  if self.timer ~= nil then 
    Timers:RemoveTimer(self.timer)
    self:GetParent():FadeGesture(ACT_DOTA_CAST_ABILITY_1)
    self.timer = nil
    self:GetParent():RemoveModifierByName("modifier_neutral_cast")
    ParticleManager:DestroyParticle(self.sign, true)
  end
  return
end


if not self:GetParent():IsSilenced() and self:GetParent():GetAttackTarget() ~= nil and not self:GetParent():HasModifier("modifier_dragon_fire_cd") and 
    not self:GetParent():HasModifier("modifier_neutral_cast") and not self:GetParent():GetAttackTarget():IsMagicImmune()
     and self:GetParent():GetMana() >= self:GetAbility():GetManaCost(1) then 

    self:GetParent():StartGestureWithPlaybackRate(ACT_DOTA_CAST_ABILITY_1, 1)
    self:GetParent():EmitSound("n_black_dragon.Fireball.Cast")
    self.sign = ParticleManager:CreateParticle( "particles/generic_gameplay/generic_has_quest.vpcf", PATTACH_OVERHEAD_FOLLOW, self:GetParent())

self.target = self:GetParent():GetAttackTarget()

     self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_neutral_cast", {})

            self.timer = Timers:CreateTimer(0.7,function()
                self.timer = nil
                ParticleManager:DestroyParticle(self.sign, true)
                self:GetParent():RemoveModifierByName("modifier_neutral_cast")
              if self.target ~= nil and self.target:IsAlive()  and self:GetParent():IsAlive()  and self:GetParent():GetMana() >= self:GetAbility():GetManaCost(1) then 
                self:GetParent():SpendMana(self:GetAbility():GetManaCost(1), self:GetAbility())
                self.point = self.target:GetAbsOrigin()

                CreateModifierThinker(self:GetParent(), self:GetAbility(), "modifier_dragon_fire_thinker", {duration = self.duration}, self.point, self:GetParent():GetTeamNumber(), false)
              
                self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_dragon_fire_cd", {duration = self.cd})

                end 


          if self.target:IsAlive() and self.target ~= nil then 

          self:GetParent():SetForceAttackTarget(self.target)
           Timers:CreateTimer(0.7,function()  
          self:GetParent():SetForceAttackTarget(nil)  end)
         end

        end)



end



end









modifier_dragon_fire_thinker = class({})

function modifier_dragon_fire_thinker:IsHidden() return false end

function modifier_dragon_fire_thinker:IsPurgable() return false end

function modifier_dragon_fire_thinker:IsAura() return true end

function modifier_dragon_fire_thinker:GetAuraDuration() return 0.1 end

function modifier_dragon_fire_thinker:GetAuraRadius() return 200
 end
function modifier_dragon_fire_thinker:OnCreated(table)
if not IsServer() then return end
self.nFXIndex = ParticleManager:CreateParticle("particles/dragon_fireball.vpcf", PATTACH_WORLDORIGIN, nil)
        ParticleManager:SetParticleControl(self.nFXIndex, 0, self:GetParent():GetOrigin())
        ParticleManager:SetParticleControl(self.nFXIndex, 1, self:GetParent():GetOrigin())
        ParticleManager:SetParticleControl(self.nFXIndex, 2, Vector(200, 0, 0))
        ParticleManager:ReleaseParticleIndex(self.nFXIndex)


end

function modifier_dragon_fire_thinker:OnDestroy()
if not IsServer() then return end
 ParticleManager:DestroyParticle(self.nFXIndex, false )
 ParticleManager:ReleaseParticleIndex(self.nFXIndex)

end

function modifier_dragon_fire_thinker:GetAuraSearchTeam() return DOTA_UNIT_TARGET_TEAM_ENEMY end

function modifier_dragon_fire_thinker:GetAuraSearchType() return DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO end

function modifier_dragon_fire_thinker:GetModifierAura() return "modifier_dragon_fire_aura" end



modifier_dragon_fire_aura = class({})

function modifier_dragon_fire_aura:IsPurgable() return false end

function modifier_dragon_fire_aura:IsHidden() return true end 
function modifier_dragon_fire_aura:IsDebuff() return true end

function modifier_dragon_fire_aura:OnCreated(table)
if not IsServer() then return end
if not self:GetAbility() then return end

self.damage = self:GetAbility():GetSpecialValueFor("damage")
self:StartIntervalThink(0.5)
end

function modifier_dragon_fire_aura:OnIntervalThink()
if not IsServer() then return end
ApplyDamage({victim = self:GetParent(), attacker = self:GetCaster(), damage = self.damage/2, damage_type = DAMAGE_TYPE_MAGICAL, ability = self:GetAbility()})
self:GetParent():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_dragon_fire_slow", {duration = 1*(1 - self:GetParent():GetStatusResistance())})    
    
end



modifier_dragon_fire_slow = class({})
function modifier_dragon_fire_slow:IsHidden() return false end
function modifier_dragon_fire_slow:IsPurgable() return true end

function modifier_dragon_fire_slow:OnTooltip() return self:GetAbility():GetSpecialValueFor("slow")*self:GetStackCount() end
function modifier_dragon_fire_slow:OnTooltip2() return self:GetAbility():GetSpecialValueFor("damage_plus")*self:GetStackCount() end
 
function modifier_dragon_fire_slow:GetTexture() return "black_dragon_fireball" end
function modifier_dragon_fire_slow:IsDebuff() return true end
function modifier_dragon_fire_slow:DeclareFunctions()
return 
{
  MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
          MODIFIER_PROPERTY_TOOLTIP,
          MODIFIER_PROPERTY_TOOLTIP2

}
end



function modifier_dragon_fire_slow:GetModifierIncomingDamage_Percentage() 

  return 3*self:GetStackCount()

end 
  


function modifier_dragon_fire_slow:OnCreated(table)
if not IsServer() then return end
self:SetStackCount(1)
end
function modifier_dragon_fire_slow:OnRefresh(table)
if not IsServer() then return end
self:SetStackCount(self:GetStackCount()+1)
end
 







function modifier_dragon_fire_slow:GetModifierMoveSpeedBonus_Percentage() return -10*self:GetStackCount() end











modifier_dragon_fire_cd = class({})

function modifier_dragon_fire_cd:IsPurgable() return false end

function modifier_dragon_fire_cd:IsHidden() return false end
