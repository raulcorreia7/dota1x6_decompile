LinkLuaModifier("modifier_neutral_cast", "modifiers/modifier_neutral_cast", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_ursa_clap", "abilities/neutral_ursa_clap", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_ursa_clap_cd", "abilities/neutral_ursa_clap", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_ursa_clap_slow", "abilities/neutral_ursa_clap", LUA_MODIFIER_MOTION_NONE)




neutral_ursa_clap = class({})

function neutral_ursa_clap:GetIntrinsicModifierName() return "modifier_ursa_clap" end 


modifier_ursa_clap = class({})

function modifier_ursa_clap:IsPurgable() return false end

function modifier_ursa_clap:IsHidden() return true end

function modifier_ursa_clap:OnCreated(table)
if not IsServer() then return end
self.slow = self:GetAbility():GetSpecialValueFor("slow")
self.cd = self:GetAbility():GetSpecialValueFor("cd")
self.aoe = self:GetAbility():GetSpecialValueFor("aoe")
self.damage = self:GetAbility():GetSpecialValueFor("damage")
self.duration = self:GetAbility():GetSpecialValueFor("duration")
self.target = nil 
self.timer = nil
self:StartIntervalThink(FrameTime())
end

function modifier_ursa_clap:OnIntervalThink()
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

if not self:GetParent():IsSilenced() and self:GetParent():GetAttackTarget() ~= nil and not self:GetParent():HasModifier("modifier_ursa_clap_cd") and
 not self:GetParent():HasModifier("modifier_neutral_cast") and not self:GetParent():GetAttackTarget():IsMagicImmune() 
 and self:GetParent():GetMana() >= self:GetAbility():GetManaCost(1) then 


  self.sign = ParticleManager:CreateParticle( "particles/generic_gameplay/generic_has_quest.vpcf", PATTACH_OVERHEAD_FOLLOW, self:GetParent())
  self:GetParent():StartGestureWithPlaybackRate(ACT_DOTA_CAST_ABILITY_1, 1)
  self:GetParent():EmitSound("n_creep_Ursa.Clap")
  self.target = self:GetParent():GetAttackTarget()

  self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_neutral_cast", {})

  self.timer = Timers:CreateTimer(0.4,function()
    self.timer = nil
    ParticleManager:DestroyParticle(self.sign, true)
    self:GetParent():RemoveModifierByName("modifier_neutral_cast")

    if not self:GetParent():IsAlive() or self:GetParent():GetMana() < self:GetAbility():GetManaCost(1) then return end 

    self:GetParent():SpendMana(self:GetAbility():GetManaCost(1), self:GetAbility())
    
    self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_ursa_clap_cd", {duration = self.cd})

      local targets = FindUnitsInRadius(self:GetParent():GetTeamNumber(), self:GetParent():GetAbsOrigin(), nil, self.aoe, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_INVULNERABLE, FIND_ANY_ORDER, false)
      for _,target in ipairs(targets) do
          if not target:IsMagicImmune() then 

            local damage = self.damage
            if target:IsIllusion() then 
              damage = self:GetAbility():GetSpecialValueFor("illusion")
            end

             ApplyDamage({victim = target, attacker = self:GetParent(), damage = damage, damage_type = DAMAGE_TYPE_MAGICAL, ability = self:GetAbility()})
     
            target:AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_ursa_clap_slow", {duration = self.duration*(1 - target:GetStatusResistance()), slow = self.slow})
          end
         end

    local trail_pfx = ParticleManager:CreateParticle("particles/neutral_fx/ursa_thunderclap.vpcf", PATTACH_ABSORIGIN, self:GetParent())
    ParticleManager:SetParticleControl(trail_pfx, 1, Vector(self.aoe , 0 , 0 ) )
    ParticleManager:ReleaseParticleIndex(trail_pfx)          

     if self.target:IsAlive() and self.target ~= nil then 

          self:GetParent():SetForceAttackTarget(self.target)
          Timers:CreateTimer(0.7,function()  
            self:GetParent():SetForceAttackTarget(nil)  end)
     end

  end)


end

end



modifier_ursa_clap_cd = class({})

function modifier_ursa_clap_cd:IsPurgable() return false end

function modifier_ursa_clap_cd:IsHidden() return false end


modifier_ursa_clap_slow = class({})

function modifier_ursa_clap_slow:IsPurgable() return true end

function modifier_ursa_clap_slow:IsHidden() return false end




function modifier_ursa_clap_slow:DeclareFunctions()
  return 
{

  MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE
}

end







function modifier_ursa_clap_slow:GetModifierMoveSpeedBonus_Percentage()
 return -1*self:GetAbility():GetSpecialValueFor("slow") 
end