

modifier_tower_level = class({})


function modifier_tower_level:IsHidden() return true end


function modifier_tower_level:IsPurgable() return false end

function modifier_tower_level:OnCreated(table)
 self.dmg = 0
 self.cd = false
  if not IsServer() then return end
 self.armor = self:GetParent():GetPhysicalArmorBaseValue()
  self:SetStackCount(1)
end


function modifier_tower_level:OnRefresh(table)
if not IsServer() then return end
self:GetParent():SetPhysicalArmorBaseValue(self.armor + self:GetStackCount())
self:SetStackCount(self:GetStackCount()+1)
self:GetParent():SetBaseMaxHealth(self:GetParent():GetBaseMaxHealth()*1.053)
self:GetParent():SetBaseDamageMin(self:GetParent():GetBaseDamageMin()*1.115)
self:GetParent():SetBaseDamageMax(self:GetParent():GetBaseDamageMax()*1.115)

local fillers = FindUnitsInRadius(self:GetParent():GetTeamNumber(), self:GetParent():GetAbsOrigin(), nil, 1200, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_BUILDING, DOTA_UNIT_TARGET_FLAG_INVULNERABLE, FIND_CLOSEST, false)

for _,i in ipairs(fillers) do
  if i ~= self:GetParent() and i ~= teleports[self:GetParent():GetTeamNumber()] then 
    local n = i:GetBaseMaxHealth() + 15
    local current = i:GetHealthPercent()
    i:SetBaseMaxHealth(n)
    i:SetMaxHealth(n)
    i:SetHealth(math.max(1,n*current/100))
  end
end


end



function modifier_tower_level:DeclareFunctions()
   return   {
    MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE,
    MODIFIER_EVENT_ON_TAKEDAMAGE

  }

 
end

function modifier_tower_level:GetModifierTotalDamageOutgoing_Percentage( params ) 
	if params.attacker == self:GetParent() then 
	if params.target then 
  if params.target:IsHero() and params.damage_type == DAMAGE_TYPE_PHYSICAL then 
	 return -50
	end 
end
end
end

function modifier_tower_level:OnTakeDamage(params)
if not IsServer() then return end
local sound = ''
  if params.unit:IsBuilding() and params.unit:GetTeamNumber() == self:GetParent():GetTeamNumber() then
    sound = "Base.Attack"

    if params.unit == self:GetParent() then 
      sound = "Tower.Attack"
    end

    if not self.cd and players[self:GetParent():GetTeamNumber()] then 
      self.cd = true 
      CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(players[self:GetParent():GetTeamNumber()]:GetPlayerOwnerID()), "Attack_Base", {sound = sound})
      self:StartIntervalThink(6)
    end

  end
end

function modifier_tower_level:OnIntervalThink()
if not IsServer() then return end
self.cd = false 
self:StartIntervalThink(-1)
end