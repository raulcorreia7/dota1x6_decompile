LinkLuaModifier("modifier_neutral_cast", "modifiers/modifier_neutral_cast", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_troll_raise", "abilities/neutral_troll_raise", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_troll_raise_cd", "abilities/neutral_troll_raise", LUA_MODIFIER_MOTION_NONE)




neutral_troll_raise = class({})

function neutral_troll_raise:GetIntrinsicModifierName() return "modifier_troll_raise" end 





modifier_troll_raise = class({})

function modifier_troll_raise:IsPurgable() return false end

function modifier_troll_raise:IsHidden() return true end

function modifier_troll_raise:OnCreated(table)
if not IsServer() then return end
self.cd = self:GetAbility():GetSpecialValueFor("cd")
self.number = self:GetAbility():GetSpecialValueFor("number")
self.duration = self:GetAbility():GetSpecialValueFor("duration")
self.target = nil
self.timer = nil
self:StartIntervalThink(FrameTime())
end

function modifier_troll_raise:OnIntervalThink()
if not IsServer() then return end


if self:GetParent():IsSilenced() or self:GetParent():IsStunned() or not self:GetParent():IsAlive() then 
  if self.timer ~= nil then 
    Timers:RemoveTimer(self.timer)
    self.timer = nil
    self:GetParent():RemoveModifierByName("modifier_neutral_cast")
    self:GetParent():FadeGesture(ACT_DOTA_CAST_ABILITY_2)
  end
  return
end

if not self:GetParent():IsSilenced() and self:GetParent():GetAttackTarget() ~= nil and not self:GetParent():HasModifier("modifier_troll_raise_cd") and
 not  self:GetParent():HasModifier("modifier_neutral_cast")  and self:GetParent():GetMana() >= self:GetAbility():GetManaCost(1)
    then 

    self:GetParent():StartGestureWithPlaybackRate(ACT_DOTA_CAST_ABILITY_2, 1)

   self.target = self:GetParent():GetAttackTarget()
     self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_neutral_cast", {})
     
           self.timer = Timers:CreateTimer(0.4,function()
            self.timer = nil
          self:GetParent():RemoveModifierByName("modifier_neutral_cast")
         if not self:GetParent():IsAlive() or  self:GetParent():GetMana() < self:GetAbility():GetManaCost(1) then return end
         
          self:GetParent():SpendMana(self:GetAbility():GetManaCost(1), self:GetAbility())
         self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_troll_raise_cd", {duration = self.cd})

    for i = 1,self.number do
         self:GetParent():EmitSound("n_creep_TrollWarlord.RaiseDead")
         local new_skelet = CreateUnitByName("npc_dota_dark_troll_warlord_skeleton_warrior", self:GetParent():GetAbsOrigin(), true, nil, nil, DOTA_TEAM_NEUTRALS)
         new_skelet:SetOwner(self:GetParent())
         new_skelet:AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_kill", {duration = self.duration})
         if self.target:IsAlive() then 
         new_skelet:SetForceAttackTarget(self.target)
       end
    end



  if self.target:IsAlive() and self.target ~= nil then 

          self:GetParent():SetForceAttackTarget(self.target)
           Timers:CreateTimer(0.7,function()  
          self:GetParent():SetForceAttackTarget(nil)  end)
         end

        end)



end



end




modifier_troll_raise_cd = class({})

function modifier_troll_raise_cd:IsPurgable() return false end

function modifier_troll_raise_cd:IsHidden() return false end



