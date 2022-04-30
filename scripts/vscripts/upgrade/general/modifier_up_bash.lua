
modifier_up_bash = class({})


function modifier_up_bash:IsHidden() return true end
function modifier_up_bash:IsPurgable() return false end
function modifier_up_bash:RemoveOnDeath() return false end

function modifier_up_bash:DeclareFunctions()
    return {

        MODIFIER_EVENT_ON_ATTACK_LANDED

    } end



function modifier_up_bash:OnCreated(table)
if not IsServer() then return end
  self:SetStackCount(1)
end


function modifier_up_bash:OnRefresh(table)
if not IsServer() then return end
  self:SetStackCount(self:GetStackCount()+1)
  
end



function modifier_up_bash:OnAttackLanded( param )
if param.target:IsBuilding() then return end
    if self:GetParent() == param.attacker then 
       local random = RollPseudoRandomPercentage(5+5*self:GetStackCount(),193,self:GetParent())
          if random  then 
            param.target:AddNewModifier(param.attacker, self:GetAbility(), "modifier_stunned", { duration = 0.1 })
          ApplyDamage({victim = param.target, attacker = self:GetParent(), damage = 100, damage_type = DAMAGE_TYPE_MAGICAL})

          param.target:EmitSound("DOTA_Item.SkullBasher")
           SendOverheadEventMessage(param.target, 4, param.target, 100, nil)       
   
        end
    end


end

