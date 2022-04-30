LinkLuaModifier("modifier_neutral_cast", "modifiers/modifier_neutral_cast", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_ogre_armor", "abilities/neutral_ogre_armor", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_ogre_armor_buff", "abilities/neutral_ogre_armor", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_ogre_armor_cd", "abilities/neutral_ogre_armor", LUA_MODIFIER_MOTION_NONE)




neutral_ogre_armor = class({})

function neutral_ogre_armor:GetIntrinsicModifierName() return "modifier_ogre_armor" end 

modifier_ogre_armor = class({})

function modifier_ogre_armor:IsPurgable() return false end

function modifier_ogre_armor:IsHidden() return true end

function modifier_ogre_armor:OnCreated(table)
if not IsServer() then return end
self.cd = self:GetAbility():GetSpecialValueFor("cd")
self.duration = self:GetAbility():GetSpecialValueFor("duration")
 self.target = nil
 self.timer = nil
self:StartIntervalThink(FrameTime())
end

function modifier_ogre_armor:OnIntervalThink()
if not IsServer() then return end

if self:GetParent():IsSilenced() or self:GetParent():IsStunned() or not self:GetParent():IsAlive() then 
  if self.timer ~= nil then 
    Timers:RemoveTimer(self.timer)
    self.timer = nil
    self:GetParent():RemoveModifierByName("modifier_neutral_cast")
    self:GetParent():FadeGesture(ACT_DOTA_CAST_ABILITY_1)
  end
  return
end

if not self:GetParent():IsSilenced() and self:GetParent():GetAttackTarget() ~= nil and not self:GetParent():HasModifier("modifier_ogre_armor_cd") and 
  not  self:GetParent():HasModifier("modifier_neutral_cast")  and self:GetParent():GetMana() >= self:GetAbility():GetManaCost(1)  then 

    self:GetParent():StartGestureWithPlaybackRate(ACT_DOTA_CAST_ABILITY_1, 1)
    self:GetParent():EmitSound("n_creep_OgreMagi.FrostArmor")
    self.target = self:GetParent():GetAttackTarget()

     self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_neutral_cast", {})
          self.timer = Timers:CreateTimer(0.3,function()
            self.timer = nil
          self:GetParent():RemoveModifierByName("modifier_neutral_cast")
          if not self:GetParent():IsAlive() or self:GetParent():GetMana() < self:GetAbility():GetManaCost(1) then return end
          
        self:GetParent():SpendMana(self:GetAbility():GetManaCost(1), self:GetAbility())
         self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_ogre_armor_cd", {duration = self.cd})

               local targets = FindUnitsInRadius(self:GetParent():GetTeamNumber(), self:GetParent():GetAbsOrigin(), nil, 400, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_INVULNERABLE, FIND_CLOSEST, false)
            for _,target in ipairs(targets) do

                 if not target:HasModifier("modifier_ogre_armor_buff") then 
                
                  target:AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_ogre_armor_buff", {duration = self.duration})
                    break
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




modifier_ogre_armor_cd = class({})

function modifier_ogre_armor_cd:IsPurgable() return false end

function modifier_ogre_armor_cd:IsHidden() return false end




modifier_ogre_armor_buff = class({})

function modifier_ogre_armor_buff:IsPurgable() return true end

function modifier_ogre_armor_buff:IsHidden() return false end


function modifier_ogre_armor_buff:OnCreated(table)
if not IsServer() then return end
 self:SetHasCustomTransmitterData(true)
self.armor =  self:GetAbility():GetSpecialValueFor("armor")
self.magic = self:GetAbility():GetSpecialValueFor("magic")
end

function modifier_ogre_armor_buff:DeclareFunctions()

  return 
{

         MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
                  MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS,
                  MODIFIER_PROPERTY_TOOLTIP,
                MODIFIER_PROPERTY_TOOLTIP2
   
}

end

function modifier_ogre_armor_buff:OnTooltip() return self:GetAbility():GetSpecialValueFor("armor") end
function modifier_ogre_armor_buff:OnTooltip2() return self:GetAbility():GetSpecialValueFor("magic") end
 


function modifier_ogre_armor_buff:AddCustomTransmitterData() return {
magic = self.magic,
armor = self.armor

} end

function modifier_ogre_armor_buff:HandleCustomTransmitterData(data)
self.magic = data.magic
self.armor = data.armor
end


function modifier_ogre_armor_buff:GetEffectName() return "particles/neutral_fx/ogre_magi_frost_armor.vpcf" end
 
function modifier_ogre_armor_buff:GetEffectAttachType() return PATTACH_OVERHEAD_FOLLOW end



function modifier_ogre_armor_buff:GetModifierMagicalResistanceBonus() return self.magic end

function modifier_ogre_armor_buff:GetModifierPhysicalArmorBonus() return self.armor end