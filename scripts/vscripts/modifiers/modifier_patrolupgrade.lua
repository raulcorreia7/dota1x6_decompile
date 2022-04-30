
modifier_patrolupgrade = class({})


function modifier_patrolupgrade:IsHidden() return true end
function modifier_patrolupgrade:IsPurgable() return false end


function modifier_patrolupgrade:DeclareFunctions()
   return   {
    MODIFIER_PROPERTY_EXTRA_HEALTH_BONUS,
    MODIFIER_PROPERTY_BASEATTACK_BONUSDAMAGE,
    MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
    MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS,


  }

 
end





function modifier_patrolupgrade:OnCreated()
if not IsServer() then return end

self.health = self:GetParent():GetBaseMaxHealth()
self.damage = self:GetParent():GetBaseDamageMin()
self.gold = self:GetParent():GetMinimumGoldBounty()
self.exp = self:GetParent():GetDeathXP()

self.change_health = 0
self.change_damage = 0

for i = 8,my_game.current_wave do

self.up_damage = 1.20
self.up_health = 1.15

self.up_gold = 1.05
self.up_exp = 1.05

if i >= 10 then self.up_damage = 1.13 self.up_health = 1.13  self.magic = 0 end 
if i >= 15 then self.up_damage = 1.12 self.up_health = 1.13  self.magic = -10 self.pure = 10 end 
if i >= 20 then self.up_damage = 1.11 self.up_health = 1.11 self.magic = -15 self.pure = 15 end 
if i >= 25 then self.up_damage = 1.10 self.up_health = 1.10 self.magic = -20 self.pure = 20 end 

self.health = self.health*self.up_health
self.damage = self.damage*self.up_damage
self.gold = self.gold*self.up_gold
self.exp = self.exp*self.up_exp

if i == 17 then 
  self.health = self.health*1.4
end

end
  
  self.change_health = self.health - self:GetParent():GetBaseMaxHealth()
  self.change_damage = self.damage - self:GetParent():GetBaseDamageMin()

  self:GetParent():SetMinimumGoldBounty(self.gold)
  self:GetParent():SetMaximumGoldBounty(self.gold)

  self:GetParent():SetDeathXP(self.exp)
self:SetHasCustomTransmitterData(true)

end


function modifier_patrolupgrade:GetModifierIncomingDamage_Percentage(params)
if params.damage_type == DAMAGE_TYPE_PURE then 
  return self.pure
end

end

function modifier_patrolupgrade:AddCustomTransmitterData() return 
{
magic = self.magic,
} 
end

function modifier_patrolupgrade:HandleCustomTransmitterData(data)
self.magic = data.magic
end


function modifier_patrolupgrade:GetModifierBaseAttack_BonusDamage()
return self.change_damage
end


function modifier_patrolupgrade:GetModifierExtraHealthBonus()
return self.change_health
end


function modifier_patrolupgrade:GetModifierMagicalResistanceBonus()
return self.magic
end



