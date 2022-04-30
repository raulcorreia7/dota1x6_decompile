LinkLuaModifier("modifier_neutral_cast", "modifiers/modifier_neutral_cast", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_satyr_purge", "abilities/neutral_satyr_purge", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_satyr_purge_cd", "abilities/neutral_satyr_purge", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_satyr_purge_slow", "abilities/neutral_satyr_purge", LUA_MODIFIER_MOTION_NONE)




neutral_satyr_purge = class({})

function neutral_satyr_purge:GetIntrinsicModifierName() return "modifier_satyr_purge" end 





modifier_satyr_purge = class({})

function modifier_satyr_purge:IsPurgable() return false end

function modifier_satyr_purge:IsHidden() return true end

function modifier_satyr_purge:OnCreated(table)
if not IsServer() then return end
self.cd = self:GetAbility():GetSpecialValueFor("cd")
self.duration = self:GetAbility():GetSpecialValueFor("duration")
self.illusion = self:GetAbility():GetSpecialValueFor("illusion")
self.target = nil
self:StartIntervalThink(FrameTime())
end

function modifier_satyr_purge:OnIntervalThink()
if not IsServer() then return end
if not self:GetParent():IsSilenced() and self:GetParent():GetAttackTarget() ~= nil and not self:GetParent():HasModifier("modifier_satyr_purge_cd") and
 not  self:GetParent():HasModifier("modifier_neutral_cast") and  not self:GetParent():GetAttackTarget():HasModifier("modifier_satyr_purge_slow")
 and not self:GetParent():GetAttackTarget():IsMagicImmune()
 and self:GetParent():GetMana() >= self:GetAbility():GetManaCost(1)
    then 

    self:GetParent():StartGestureWithPlaybackRate(ACT_DOTA_CAST_ABILITY_1, 1)
    self.target = self:GetParent():GetAttackTarget()

   
     self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_neutral_cast", {})
     
            Timers:CreateTimer(0,function()
            
            self:GetParent():RemoveModifierByName("modifier_neutral_cast")

            if self.target ~= nil and self.target:IsAlive() and not self.target:IsMagicImmune() and self:GetParent():IsAlive()
            and self:GetParent():GetMana() >= self:GetAbility():GetManaCost(1)  then 

              self:GetParent():SpendMana(self:GetAbility():GetManaCost(1), self:GetAbility())
            
            self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_satyr_purge_cd", {duration = self.cd})
            if self.target:TriggerSpellAbsorb( self:GetAbility() ) then return end

              self.target:EmitSound("n_creep_SatyrTrickster.Cast")
              local effect = ParticleManager:CreateParticle( "particles/generic_gameplay/generic_purge.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.target)
              self.target:Purge(true, false, false, false, false)
           
              if self.target:IsIllusion() then 
                 ApplyDamage({victim = self.target, attacker = self:GetParent(), damage = self.illusion, damage_type = DAMAGE_TYPE_MAGICAL, ability = self:GetAbility()})
              end


              self.target:AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_satyr_purge_slow", {duration = self.duration*(1 - self.target:GetStatusResistance())})
             end

             if self.target:IsAlive() and self.target ~= nil then 

                self:GetParent():SetForceAttackTarget(self.target)
                Timers:CreateTimer(0.7,function()  
                  self:GetParent():SetForceAttackTarget(nil)  end)
             end

            end)



end



end




modifier_satyr_purge_cd = class({})

function modifier_satyr_purge_cd:IsPurgable() return false end

function modifier_satyr_purge_cd:IsHidden() return false end



modifier_satyr_purge_slow = class({})

function modifier_satyr_purge_slow:IsPurgable() return true end

function modifier_satyr_purge_slow:IsHidden() return false end


function modifier_satyr_purge_slow:OnCreated(table)
if not IsServer() then return end
self.slow = -1*self:GetAbility():GetSpecialValueFor("slow")
end

function modifier_satyr_purge_slow:DeclareFunctions()

  return 
{

         MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE
}

end


 


function modifier_satyr_purge_slow:AddCustomTransmitterData() return {
slow = self.slow


} end

function modifier_satyr_purge_slow:HandleCustomTransmitterData(data)
self.slow = data.slow
end






function modifier_satyr_purge_slow:GetModifierMoveSpeedBonus_Percentage() return self.slow end