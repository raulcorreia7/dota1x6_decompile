LinkLuaModifier("modifier_frostgolem_root_ability", "abilities/neutral_frostgolem_root.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_frostbitten_thinker", "abilities/neutral_frostgolem_root.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_frostgolem_root_cd", "abilities/neutral_frostgolem_root.lua", LUA_MODIFIER_MOTION_NONE)


neutral_frostgolem_root = class({})

function neutral_frostgolem_root:GetIntrinsicModifierName() return "modifier_frostgolem_root_ability" end 


modifier_frostgolem_root_ability = class({})

function modifier_frostgolem_root_ability:IsPurgable() return false end

function modifier_frostgolem_root_ability:IsHidden() return true end

function modifier_frostgolem_root_ability:OnCreated(table)
if not IsServer() then return end
self.cd = self:GetAbility():GetSpecialValueFor("cd")
self.damage = self:GetAbility():GetSpecialValueFor("damage")
self.delay = self:GetAbility():GetSpecialValueFor("delay")
self.target = nil
self.point = nil
self.timer = nil
self:StartIntervalThink(FrameTime())
end

function modifier_frostgolem_root_ability:OnIntervalThink()
if not IsServer() then return end

if self:GetParent():IsSilenced() or self:GetParent():IsStunned() or not self:GetParent():IsAlive() then 
  if self.timer ~= nil then 
    Timers:RemoveTimer(self.timer)
    self:GetParent():FadeGesture(ACT_DOTA_CAST_ABILITY_3)
    self.timer = nil
    self:GetParent():RemoveModifierByName("modifier_neutral_cast")
    ParticleManager:DestroyParticle(self.sign, true)
  end
  return
end


if not self:GetParent():IsSilenced() and self:GetParent():GetAttackTarget() ~= nil and not self:GetParent():HasModifier("modifier_frostgolem_root_cd") and 
    not self:GetParent():HasModifier("modifier_neutral_cast") and not self:GetParent():GetAttackTarget():IsMagicImmune()
     and self:GetParent():GetMana() >= self:GetAbility():GetManaCost(1) then 

    self:GetParent():StartGestureWithPlaybackRate(ACT_DOTA_CAST_ABILITY_3, 1)

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

                CreateModifierThinker(self:GetParent(), self:GetAbility(), "modifier_frostbitten_thinker", {caster = self:GetParent():entindex(), damage = self.damage, duration = self.delay}, self.target:GetAbsOrigin(), self:GetCaster():GetTeamNumber(), false)

                self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_frostgolem_root_cd", {duration = self.cd})

                end 


          if self.target:IsAlive() and self.target ~= nil then 

          self:GetParent():SetForceAttackTarget(self.target)
           Timers:CreateTimer(0.7,function()  
          self:GetParent():SetForceAttackTarget(nil)  end)
         end

        end)



end



end




modifier_frostbitten_thinker = class({})

function modifier_frostbitten_thinker:IsHidden() return true end

function modifier_frostbitten_thinker:IsPurgable() return false end

function modifier_frostbitten_thinker:OnCreated(table)
if not IsServer() then return end

    self.caster = EntIndexToHScript(table.caster)
    self.damage = table.damage


    self.radius = self:GetAbility():GetSpecialValueFor("radius")
    local particle_cast = "particles/units/heroes/hero_snapfire/hero_snapfire_ultimate_calldown.vpcf"
    self.effect_cast = ParticleManager:CreateParticle(particle_cast, PATTACH_CUSTOMORIGIN, self:GetParent())
    ParticleManager:SetParticleControl( self.effect_cast, 0, self:GetParent():GetOrigin() )
    ParticleManager:SetParticleControl( self.effect_cast, 1, Vector( self.radius, 0, -self.radius) )
    ParticleManager:SetParticleControl( self.effect_cast, 2, Vector( self:GetRemainingTime(), 0, 0 ) )



end


function modifier_frostbitten_thinker:OnDestroy(table)
if not IsServer() then return end
if not self.caster then return end
if self.caster:IsNull() then return end
if not self.caster:IsAlive() then return end


    ParticleManager:DestroyParticle( self.effect_cast, true )
    ParticleManager:ReleaseParticleIndex( self.effect_cast )

     local zap_pfx = ParticleManager:CreateParticle("particles/frostbitten_strike.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.caster)
    ParticleManager:SetParticleControlEnt(zap_pfx, 0, self.caster, PATTACH_POINT_FOLLOW, "attach_staff", self.caster:GetAbsOrigin(), true)
    ParticleManager:SetParticleControl(zap_pfx, 1, self:GetParent():GetAbsOrigin())
    ParticleManager:ReleaseParticleIndex(zap_pfx)

    self:GetCaster():EmitSound("Ability.FrostNova")  
   
    local seed_particle = ParticleManager:CreateParticle("particles/econ/items/lich/frozen_chains_ti6/lich_frozenchains_frostnova.vpcf", PATTACH_WORLDORIGIN, nil)
    ParticleManager:SetParticleControl(seed_particle, 0, self:GetParent():GetAbsOrigin())
    ParticleManager:SetParticleControl(seed_particle, 1, self:GetParent():GetAbsOrigin())
     ParticleManager:SetParticleControl(seed_particle, 2, self:GetParent():GetAbsOrigin())
    ParticleManager:ReleaseParticleIndex(seed_particle)

    local  enemy_for_ability = FindUnitsInRadius(self:GetCaster():GetTeamNumber(), self:GetParent():GetAbsOrigin(), nil, self.radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE , FIND_CLOSEST, false)
     for _,i in ipairs(enemy_for_ability) do
         if not i:IsMagicImmune() then 

             ApplyDamage({ victim = i, attacker = self:GetAbility():GetCaster(), ability = self:GetAbility(), damage = self.damage, damage_type = DAMAGE_TYPE_MAGICAL})

         end

     end
   
end









modifier_frostgolem_root_cd = class({})

function modifier_frostgolem_root_cd:IsHidden() return false end
function modifier_frostgolem_root_cd:IsPurgable() return false end