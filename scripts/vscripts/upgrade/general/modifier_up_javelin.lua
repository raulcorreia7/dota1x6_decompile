
modifier_up_javelin = class({})

modifier_up_javelin.chance_init = 15
modifier_up_javelin.damage = 30

function modifier_up_javelin:IsHidden() return true end
function modifier_up_javelin:IsPurgable() return false end
function modifier_up_javelin:RemoveOnDeath() return false end

function modifier_up_javelin:DeclareFunctions()
return {

        MODIFIER_EVENT_ON_ATTACK_LANDED,
        MODIFIER_EVENT_ON_ATTACK_FAIL
} end



function modifier_up_javelin:OnCreated(table)
if not IsServer() then return end
  self:SetStackCount(1)
  self.StackOnIllusion = true 
  self:RandomProcDamage()
end


function modifier_up_javelin:OnRefresh(table)
if not IsServer() then return end
  self:SetStackCount(self:GetStackCount()+1)
end

function modifier_up_javelin:CheckState()
if self.proc == true then 
  return {[MODIFIER_STATE_CANNOT_MISS] = true}
end
return {}

end


function modifier_up_javelin:OnAttackLanded( param )
if param.target:IsBuilding() then return end
if self:GetParent() ~= param.attacker then return end 

if self.proc == true then 
  self.proc = false

  if not self:GetParent():IsIllusion() then 
    ApplyDamage({victim = param.target, attacker = self:GetParent(), damage = self.damage, damage_type = DAMAGE_TYPE_MAGICAL})
    SendOverheadEventMessage(param.target, 4, param.target, self.damage, nil) 
  end  
end

self:RandomProcDamage()

end



function modifier_up_javelin:OnAttackFail(param)
if param.target:IsBuilding() then return end
if self:GetParent() ~= param.attacker then return end 
self:RandomProcDamage()

end



function modifier_up_javelin:RandomProcDamage()

local chance = self.chance_init*self:GetStackCount()*(1+0.2*self:GetParent():GetUpgradeStack("modifier_up_graypoints"))
local random = RollPseudoRandomPercentage(chance,196,self:GetParent())

if random  then 
  self.proc = true
end


end



  