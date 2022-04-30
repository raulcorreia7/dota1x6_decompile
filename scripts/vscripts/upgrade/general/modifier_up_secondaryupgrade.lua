
modifier_up_secondaryupgrade = class({})

function modifier_up_secondaryupgrade:IsHidden() return true end
function modifier_up_secondaryupgrade:IsPurgable() return false end

function modifier_up_secondaryupgrade:DeclareFunctions()

return{

MODIFIER_PROPERTY_STATUS_RESISTANCE_STACKING,
MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE
     } end



function modifier_up_secondaryupgrade:OnCreated(table)

if not IsServer() then return end
 self:SetHasCustomTransmitterData(true)
self.str = 0
self.agi = 0
self.int = 0
self.bva = self:GetParent():GetBaseAttackTime()

 if self:GetParent():GetPrimaryAttribute() == 0 then 
	self.agi = 1 
  self.int = 1
end 
 if self:GetParent():GetPrimaryAttribute() == 1 then 
	self.str = 1
  self.int = 1
   end 
 if self:GetParent():GetPrimaryAttribute() == 2 then 
	self.str = 1
  self.agi = 1
   end 	

  self:SetStackCount(1)
   self.StackOnIllusion = true 
  self:GetParent():CalculateStatBonus(true)
end

function modifier_up_secondaryupgrade:AddCustomTransmitterData() return {
agi = self.agi,
int = self.int,
str = self.str,
bva = self.bva

} end

function modifier_up_secondaryupgrade:HandleCustomTransmitterData(data)
self.agi = data.agi
self.str = data.str
self.int = data.int
self.bva = data.bva
end


function modifier_up_secondaryupgrade:OnRefresh(table)
if not IsServer() then return end
  self:SetStackCount(self:GetStackCount()+1)
  self:GetParent():CalculateStatBonus(true)
end


--function modifier_up_primaryupgrade:GetModifierBaseAttackTimeConstant() return (self.bva - self:GetParent():GetAgility()/700)*self.agi end
function modifier_up_secondaryupgrade:GetModifierSpellAmplify_Percentage() return self:GetParent():GetIntellect()*self.int/15 end
function modifier_up_secondaryupgrade:GetModifierStatusResistanceStacking() return self:GetParent():GetStrength()*0.1*self.str end

function modifier_up_secondaryupgrade:GetModifierMoveSpeedBonus_Percentage() return 0.1*self:GetParent():GetAgility()*self.agi end


function modifier_up_secondaryupgrade:RemoveOnDeath() return false end