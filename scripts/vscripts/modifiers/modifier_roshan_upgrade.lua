
modifier_roshan_upgrade = class({})


function modifier_roshan_upgrade:IsHidden() return true end
function modifier_roshan_upgrade:IsPurgable() return false end



function modifier_roshan_upgrade:DeclareFunctions()
   return   {
    MODIFIER_PROPERTY_EXTRA_HEALTH_BONUS,
    MODIFIER_PROPERTY_BASEATTACK_BONUSDAMAGE,
    MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
    MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS,

  }

 
end




function modifier_roshan_upgrade:OnCreated(table)

self.gold = 0

if table.number == 1 then 
  self.health = 15000 - self:GetParent():GetMaxHealth()
  self.damage = 200 - self:GetParent():GetBaseDamageMax()
  self.armor = 5
  self.magic = -30
  self.gold = 500
end

if table.number == 2 then 
  self.health = 25000 - self:GetParent():GetMaxHealth()
  self.damage = 300 - self:GetParent():GetBaseDamageMax()
  self.armor = 5
  self.magic = -30
  self.gold = 750
end

if table.number >= 3 then 
  self.health = 35000 - self:GetParent():GetMaxHealth()
  self.damage = 400 - self:GetParent():GetBaseDamageMax()
  self.armor = 5
  self.magic = -40
  self.gold = 1000
end

if not self:GetParent() then return end
if not IsServer() then return end
  self:GetParent():SetMinimumGoldBounty(self.gold)
  self:GetParent():SetMaximumGoldBounty(self.gold)


self:SetHasCustomTransmitterData(true)
end



function modifier_roshan_upgrade:AddCustomTransmitterData() return 
{
armor = self.armor,
magic = self.magic,
} 
end

function modifier_roshan_upgrade:HandleCustomTransmitterData(data)

self.armor = data.armor
self.magic = data.magic
end


function modifier_roshan_upgrade:GetModifierMagicalResistanceBonus()
return self.magic
end


function modifier_roshan_upgrade:GetModifierBaseAttack_BonusDamage()
return self.damage
end


function modifier_roshan_upgrade:GetModifierExtraHealthBonus()
return self.health
end

function modifier_roshan_upgrade:GetModifierPhysicalArmorBonus()
return self.armor
end





