

modifier_up_lifesteal = class({})


function modifier_up_lifesteal:IsHidden() return true end
function modifier_up_lifesteal:IsPurgable() return false end


function modifier_up_lifesteal:DeclareFunctions()
    return {

        MODIFIER_EVENT_ON_ATTACK_LANDED,
        MODIFIER_EVENT_ON_TAKEDAMAGE

    } end



function modifier_up_lifesteal:OnTakeDamage( param )

    if self:GetParent() == param.attacker and param.inflictor == nil  and not param.unit:IsBuilding() then 


        self:GetParent():Heal(param.damage * (6*self:GetStackCount()*(1+0.2*self:GetParent():GetUpgradeStack("modifier_up_graypoints")) / 100), self:GetParent())
          local particle = ParticleManager:CreateParticle( "particles/generic_gameplay/generic_lifesteal.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
    ParticleManager:ReleaseParticleIndex( particle )
    end


end


function modifier_up_lifesteal:OnCreated(table)
if not IsServer() then return end
  self:SetStackCount(1)
   self.StackOnIllusion = true 
end


function modifier_up_lifesteal:OnRefresh(table)
if not IsServer() then return end
  self:SetStackCount(self:GetStackCount()+1)
  
end


function modifier_up_lifesteal:RemoveOnDeath() return false end
  