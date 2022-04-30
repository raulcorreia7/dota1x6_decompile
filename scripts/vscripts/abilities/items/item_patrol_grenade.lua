item_patrol_grenade = class({})

function item_patrol_grenade:OnSpellStart()
if not IsServer() then return end

self:GetCaster():EmitSound("Item.Paintball.Cast")

self.damage = self:GetSpecialValueFor("damage")
if self:GetCursorTarget():GetUnitName() ~= "npc_towerradiant" and self:GetCursorTarget():GetUnitName() ~= "npc_towerdire" then 
	self.damage = self:GetSpecialValueFor("damage_shrine")
end

local info = {
                 Target = self:GetCursorTarget(),
                 Source = self:GetCaster(),
                 Ability = self, 
                 EffectName = "particles/items2_fx/paintball.vpcf",
                 iMoveSpeed = 900,
                 bReplaceExisting = false,                         
                 bProvidesVision = true,                           
                 iVisionRadius = 30,        
                 iVisionTeamNumber = self:GetCaster():GetTeamNumber()      
                  }
              ProjectileManager:CreateTrackingProjectile(info)



end


function item_patrol_grenade:OnProjectileHit(hTarget, vLocation)
if not IsServer() then return end

  if hTarget==nil then return end
  if hTarget:IsInvulnerable() then return end
  if hTarget:TriggerSpellAbsorb( self ) then return end
  if hTarget:IsMagicImmune() then return end


local damage = self.damage*hTarget:GetMaxHealth()/100

 ApplyDamage({victim = hTarget, attacker = self:GetCaster(), damage = damage, damage_type = DAMAGE_TYPE_PURE, ability = self, damage_flags = DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION})
    hTarget:EmitSound("Item.Paintball.Target")


self:SpendCharge()
end

