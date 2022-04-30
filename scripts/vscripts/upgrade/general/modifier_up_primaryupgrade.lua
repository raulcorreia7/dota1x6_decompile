
modifier_up_primaryupgrade = class({})

function modifier_up_primaryupgrade:IsHidden() return true end
function modifier_up_primaryupgrade:IsPurgable() return false end

function modifier_up_primaryupgrade:DeclareFunctions()

return{

MODIFIER_PROPERTY_STATUS_RESISTANCE_STACKING,
MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE
     } end



function modifier_up_primaryupgrade:OnCreated(table)

  --print(self:GetParent():GetAgility()/700)
if not IsServer() then return end
 self:SetHasCustomTransmitterData(true)
self.str = 0
self.agi = 0
self.int = 0
self.bva = self:GetParent():GetBaseAttackTime()

 if self:GetParent():GetPrimaryAttribute() == 0 then 
	self.str = 1 end 
 if self:GetParent():GetPrimaryAttribute() == 1 then 
	self.agi = 1 end 
 if self:GetParent():GetPrimaryAttribute() == 2 then 
	self.int = 1 end 	

  self:SetStackCount(1)
   self.StackOnIllusion = true 
  self:GetParent():CalculateStatBonus(true)
end

function modifier_up_primaryupgrade:AddCustomTransmitterData() return {
agi = self.agi,
int = self.int,
str = self.str,
bva = self.bva

} end

function modifier_up_primaryupgrade:HandleCustomTransmitterData(data)
self.agi = data.agi
self.str = data.str
self.int = data.int
self.bva = data.bva
end


function modifier_up_primaryupgrade:OnRefresh(table)
if not IsServer() then return end
  self:SetStackCount(self:GetStackCount()+1)
  self:GetParent():CalculateStatBonus(true)
end


--function modifier_up_primaryupgrade:GetModifierBaseAttackTimeConstant() return (self.bva - self:GetParent():GetAgility()/700)*self.agi end
function modifier_up_primaryupgrade:GetModifierSpellAmplify_Percentage() return self:GetParent():GetIntellect()*self.int/15 end
function modifier_up_primaryupgrade:GetModifierStatusResistanceStacking() return self:GetParent():GetStrength()*0.1*self.str end

function modifier_up_primaryupgrade:GetModifierMoveSpeedBonus_Percentage() return 0.1*self:GetParent():GetAgility()*self.agi end


function modifier_up_primaryupgrade:RemoveOnDeath() return false end