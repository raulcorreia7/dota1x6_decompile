

modifier_up_cleave = class({})


function modifier_up_cleave:IsHidden() return true end
function modifier_up_cleave:IsPurgable() return false end


function modifier_up_cleave:DeclareFunctions()
  return {
        MODIFIER_EVENT_ON_ATTACK_LANDED
  

    } end



function modifier_up_cleave:OnAttackLanded( param )
if self:GetParent():HasModifier("modifier_tidehunter_anchor_smash_caster") then return end
if self:GetParent() == param.attacker and not self:GetParent():IsRangedAttacker() then 
    	DoCleaveAttack(self:GetParent(), param.target, nil, param.damage*(7*self:GetStackCount()*(1+0.2*self:GetParent():GetUpgradeStack("modifier_up_graypoints")) /100 ), 150, 360, 650, "particles/units/heroes/hero_magnataur/magnataur_empower_cleave_effect.vpcf")
          
    end

end
function modifier_up_cleave:OnCreated(table)
if not IsServer() then return end
  self:SetStackCount(1)
  self:GetParent():CalculateStatBonus(true)
end


function modifier_up_cleave:OnRefresh(table)
if not IsServer() then return end
  self:SetStackCount(self:GetStackCount()+1)
  self:GetParent():CalculateStatBonus(true)
end



function modifier_up_cleave:RemoveOnDeath() return false end