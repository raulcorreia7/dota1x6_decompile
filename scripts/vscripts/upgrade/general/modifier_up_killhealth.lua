LinkLuaModifier("modifier_kill_health", "upgrade/general/modifier_up_killhealth", LUA_MODIFIER_MOTION_NONE)


modifier_up_killhealth = class({})


function modifier_up_killhealth:IsHidden() return true end
function modifier_up_killhealth:IsPurgable() return false end

function modifier_up_killhealth:OnCreated(table)
if not IsServer() then return end
self:SetStackCount(1)
end

function modifier_up_killhealth:DeclareFunctions()
  return {
        MODIFIER_EVENT_ON_DEATH
  

    } end



function modifier_up_killhealth:OnDeath(params)

if params.attacker == self:GetParent() then 
  self:GetParent():AddNewModifier(self:GetParent(), nil, "modifier_kill_health", {duration = 60, bonus = self:GetStackCount()*50})

end
end
function modifier_up_killhealth:OnRefresh(table)
if not IsServer() then return end
  self:SetStackCount(self:GetStackCount()+1)
  self:GetParent():CalculateStatBonus(true)
end



function modifier_up_killhealth:RemoveOnDeath() return false end


modifier_kill_health = class({})

function modifier_kill_health:IsHidden() return false  end
function modifier_kill_health:GetTexture() return "item_urn_of_shadows" end
function modifier_kill_health:IsPurgable() return false end

function modifier_kill_health:DeclareFunctions()
return 
{
  MODIFIER_PROPERTY_HEALTH_BONUS
}
end

function modifier_kill_health:GetModifierHealthBonus()  return self:GetStackCount()*self.bonus
 end

function modifier_kill_health:OnCreated(table)

self.bonus =  table.bonus
self:SetStackCount(1)
end

function modifier_kill_health:OnRefresh(table)

  self.bonus =  table.bonus
  if self:GetStackCount() < 10 then 
    self:SetStackCount(self:GetStackCount()+1)
  end
end

