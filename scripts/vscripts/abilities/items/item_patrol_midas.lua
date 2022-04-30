item_patrol_midas = class({})



function item_patrol_midas:CastFilterResultTarget(target)
  if IsServer() then
    local caster = self:GetCaster()

    if target:GetUnitName() == "npc_lich" or target:GetUnitName() == "npc_roshan_custom" then 
      return UF_FAIL_OTHER
    end


    return UnitFilter( target, self:GetAbilityTargetTeam(), self:GetAbilityTargetType(), self:GetAbilityTargetFlags(), self:GetCaster():GetTeamNumber() )
  end
end



function item_patrol_midas:OnSpellStart()
if not IsServer() then return end

self:GetCaster():EmitSound("DOTA_Item.Hand_Of_Midas")

local bonus_gold = self:GetSpecialValueFor("gold")
self:GetCaster():ModifyGold(bonus_gold , true , DOTA_ModifyGold_CreepKill)
SendOverheadEventMessage(self:GetCaster(), 0, self:GetCaster(), bonus_gold, nil)

local item_effect = ParticleManager:CreateParticle( "particles/items2_fx/hand_of_midas.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCursorTarget())
ParticleManager:SetParticleControl( item_effect, 0, self:GetCursorTarget():GetAbsOrigin() )
ParticleManager:SetParticleControlEnt(item_effect, 1, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetCaster():GetOrigin(), true )
  
ParticleManager:ReleaseParticleIndex(item_effect)

self:GetCursorTarget():Kill(self, self:GetCaster())
self:SpendCharge()
end


