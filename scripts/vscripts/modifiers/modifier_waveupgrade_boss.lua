
modifier_waveupgrade_boss = class({})


function modifier_waveupgrade_boss:IsHidden() return true end
function modifier_waveupgrade_boss:IsPurgable() return false end

function modifier_waveupgrade_boss:DeclareFunctions()
   return   {
    MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE,
    MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE,
    MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
    MODIFIER_EVENT_ON_DEATH,
    MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE

  }

 
end

function modifier_waveupgrade_boss:GetModifierIncomingDamage_Percentage(params)
if params.damage_type == DAMAGE_TYPE_PURE then 
  return self.pure
end

end


function modifier_waveupgrade_boss:GetModifierSpellAmplify_Percentage() return self.amp end
function modifier_waveupgrade_boss:GetModifierAttackSpeedBonus_Constant() return self.speed end


function modifier_waveupgrade_boss:GetModifierTotalDamageOutgoing_Percentage( params ) 
	if params.attacker == self:GetParent() then 
	   if params.target then 
        if params.target:IsBuilding() then 
           if self.wave == 1 then 
	           return 100
           else 
            return -40
           end
        end
    	end 
  end
end


function modifier_waveupgrade_boss:OnCreated(table)
self.wave = table.wave


self.amp = 0
self.magic = 35
self.armor = 5
self.speed = 0
self.pure = 0

self.health = 3800
self.damage = 100
self.gold = 300
self.exp = 350

if self.wave ~= 1 then 

  self.magic = -50
  self.armor = 10
  self.amp = 150
  self.pure = 50

  self.health = 75000
  self.damage = 500
  self.gold = 1000
  self.exp = 3000
  self.speed = 150

end


if not IsServer() then return end


self.multi = 0

if self:GetParent().owner ~= nil then 
  self.multi = self:GetParent().owner.creeps_upgrade
end

if self.multi then 
  local multi_up = 1 + self.multi*0.1

  self.health = self.health*multi_up
  self.damage = self.damage*multi_up
end



  self:GetParent():SetBaseDamageMin(self.damage)
  self:GetParent():SetBaseDamageMax(self.damage)

  self:GetParent():SetBaseMaxHealth(self.health)
  self:GetParent():SetHealth(self.health)

  self:GetParent():SetMinimumGoldBounty(self.gold)
  self:GetParent():SetMaximumGoldBounty(self.gold)

  self:GetParent():SetBaseMagicalResistanceValue(self.magic)

  self:GetParent():SetDeathXP(self.exp)
  self:GetParent():SetPhysicalArmorBaseValue(self.armor)


end

