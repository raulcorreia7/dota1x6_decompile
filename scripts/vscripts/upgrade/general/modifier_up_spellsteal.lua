

modifier_up_spellsteal = class({})

modifier_up_spellsteal.heal = 4

function modifier_up_spellsteal:IsHidden() return true end
function modifier_up_spellsteal:IsPurgable() return false end


function modifier_up_spellsteal:DeclareFunctions()
    return {

        MODIFIER_EVENT_ON_TAKEDAMAGE

    } end



function modifier_up_spellsteal:OnTakeDamage( param )
if self:GetParent() == param.unit and self:GetParent():IsIllusion() then return end
if bit.band(param.damage_flags, DOTA_DAMAGE_FLAG_REFLECTION) == DOTA_DAMAGE_FLAG_REFLECTION then return end
    if self:GetParent() == param.attacker and param.inflictor and not param.unit:IsBuilding()  then 
      local heal = self.heal
      if not param.unit:IsHero() then heal = heal/2 end
      
        self:GetParent():Heal(param.damage * (heal*self:GetStackCount()*(1+0.2*self:GetParent():GetUpgradeStack("modifier_up_graypoints")) / 100), self:GetParent())
          local particle = ParticleManager:CreateParticle( "particles/items3_fx/octarine_core_lifesteal.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
         ParticleManager:ReleaseParticleIndex( particle )
    end


end


function modifier_up_spellsteal:OnCreated(table)
if not IsServer() then return end
  self:SetStackCount(1)
   self.StackOnIllusion = true 
end


function modifier_up_spellsteal:OnRefresh(table)
if not IsServer() then return end
  self:SetStackCount(self:GetStackCount()+1)
  
end


function modifier_up_spellsteal:RemoveOnDeath() return false end
  