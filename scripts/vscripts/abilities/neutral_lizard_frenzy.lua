LinkLuaModifier("modifier_neutral_cast", "modifiers/modifier_neutral_cast", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_lizard_frenzy", "abilities/neutral_lizard_frenzy", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_lizard_frenzy_buff", "abilities/neutral_lizard_frenzy", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_lizard_frenzy_cd", "abilities/neutral_lizard_frenzy", LUA_MODIFIER_MOTION_NONE)




neutral_lizard_frenzy = class({})

function neutral_lizard_frenzy:GetIntrinsicModifierName() return "modifier_lizard_frenzy" end 


modifier_lizard_frenzy = class({})

function modifier_lizard_frenzy:IsPurgable() return false end

function modifier_lizard_frenzy:IsHidden() return true end

function modifier_lizard_frenzy:OnCreated(table)
if not IsServer() then return end
self.duration = self:GetAbility():GetSpecialValueFor("duration")
self.cd = self:GetAbility():GetSpecialValueFor("cd")
self.aoe = self:GetAbility():GetSpecialValueFor("aoe")
self.speed = self:GetAbility():GetSpecialValueFor("speed")
self.heal = self:GetAbility():GetSpecialValueFor("heal")/100
self.target = nil
self.timer = nil
self:StartIntervalThink(FrameTime())
end

function modifier_lizard_frenzy:OnIntervalThink()
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

if not self:GetParent():IsSilenced() and self:GetParent():GetAttackTarget() ~= nil and not self:GetParent():HasModifier("modifier_lizard_frenzy_cd") and 
    not self:GetParent():HasModifier("modifier_neutral_cast") and self:GetParent():GetMana() >= self:GetAbility():GetManaCost(1) then 

    self:GetParent():StartGestureWithPlaybackRate(ACT_DOTA_CAST_ABILITY_1, 1)
 
    self.target = self:GetParent():GetAttackTarget()
     self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_neutral_cast", {})

            self.timer = Timers:CreateTimer(0.3,function()
              self.timer = nil
          self:GetParent():RemoveModifierByName("modifier_neutral_cast")

          if not self:GetParent():IsAlive() or self:GetParent():GetMana() < self:GetAbility():GetManaCost(1) then return end

          self:GetParent():EmitSound("n_creep_Thunderlizard_Big.Roar")
          self:GetParent():SpendMana(self:GetAbility():GetManaCost(1), self:GetAbility())
         self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_lizard_frenzy_cd", {duration = self.cd})
         
        local targets = FindUnitsInRadius(self:GetParent():GetTeamNumber(), self:GetParent():GetAbsOrigin(), nil, self.aoe, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_INVULNERABLE, FIND_CLOSEST, false)
            for _,target in ipairs(targets) do

                
            target:AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_lizard_frenzy_buff", {duration = self.duration, speed = self.speed, heal = self.heal})
         end

         


  if self.target:IsAlive() and self.target ~= nil then 

          self:GetParent():SetForceAttackTarget(self.target)
           Timers:CreateTimer(0.7,function()  
          self:GetParent():SetForceAttackTarget(nil)  end)
         end

        end)



end



end

modifier_lizard_frenzy_buff = class({})

function modifier_lizard_frenzy_buff:IsHidden() return false end
function modifier_lizard_frenzy_buff:IsPurgable() return true end
function modifier_lizard_frenzy_buff:IsDebuff() return false end


function modifier_lizard_frenzy_buff:OnCreated(table)
if not IsServer() then return end
 self:SetHasCustomTransmitterData(true)
 self.heal = table.heal
self.slow = table.speed
end

function modifier_lizard_frenzy_buff:DeclareFunctions()

  return 
{

         MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
         MODIFIER_EVENT_ON_TAKEDAMAGE,
         MODIFIER_PROPERTY_TOOLTIP,
         MODIFIER_PROPERTY_TOOLTIP2
}

end

function modifier_lizard_frenzy_buff:OnTooltip() return self:GetAbility():GetSpecialValueFor("speed") end
function modifier_lizard_frenzy_buff:OnTooltip2() return self:GetAbility():GetSpecialValueFor("heal") end

 function modifier_lizard_frenzy_buff:OnTakeDamage( params )
if not IsServer() then return end
if self:GetParent() == params.attacker then 
        self:GetParent():Heal(params.damage*self.heal, self:GetParent())
         local particle = ParticleManager:CreateParticle( "particles/generic_gameplay/generic_lifesteal.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
    ParticleManager:ReleaseParticleIndex( particle )


end

end


function modifier_lizard_frenzy_buff:AddCustomTransmitterData() return {
slow = self.slow


} end

function modifier_lizard_frenzy_buff:HandleCustomTransmitterData(data)
self.slow = data.slow
end



function modifier_lizard_frenzy_buff:GetEffectName() return "particles/neutral_fx/thunder_lizard_frenzy.vpcf" end



function modifier_lizard_frenzy_buff:GetModifierAttackSpeedBonus_Constant() return self.slow end







modifier_lizard_frenzy_cd = class({})

function modifier_lizard_frenzy_cd:IsPurgable() return false end

function modifier_lizard_frenzy_cd:IsHidden() return false end
