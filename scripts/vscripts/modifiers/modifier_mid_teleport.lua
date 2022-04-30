LinkLuaModifier("modifier_mid_teleport", "modifiers/modifier_mid_teleport", LUA_MODIFIER_MOTION_NONE)


modifier_mid_teleport = class({})

function modifier_mid_teleport:IsHidden() return false end

if IsClient() then return end

function modifier_mid_teleport:CheckState()
  return 
  {
    [MODIFIER_STATE_NO_HEALTH_BAR] = true,
    [MODIFIER_STATE_MAGIC_IMMUNE] = true
  }
end

function modifier_mid_teleport:DeclareFunctions() 
  return {
    MODIFIER_EVENT_ON_ORDER,
    MODIFIER_PROPERTY_TRANSLATE_ACTIVITY_MODIFIERS,
    MODIFIER_PROPERTY_OVERRIDE_ANIMATION
  }
  end

  function modifier_mid_teleport:GetActivityTranslationModifiers() return "captured" end

  function modifier_mid_teleport:OnCreated(table)

    local number = tonumber(self:GetParent():GetName())

    self:GetParent():StartGesture(ACT_DOTA_IDLE)
    if number == 3 or number == 8 or number == 9 then
      self:GetParent():SetMaterialGroup("2")
      self:GetParent().ray = ParticleManager:CreateParticle("particles/world_outpost/world_outpost_dire_ambient.vpcf", PATTACH_CUSTOMORIGIN, self:GetParent())
 
    end 
    if number == 2 or number == 6 or number == 7 then
            self:GetParent():SetMaterialGroup("1")
    self:GetParent().ray = ParticleManager:CreateParticle("particles/world_outpost/world_outpost_radiant_ambient.vpcf", PATTACH_CUSTOMORIGIN, self:GetParent())
 
    end 

 if not self:GetParent().ray then return end

 ParticleManager:SetParticleControlEnt(self:GetParent().ray, 0, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_fx", self:GetParent():GetAbsOrigin(), true)
 ParticleManager:SetParticleControlEnt(self:GetParent().ray, 1, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_fx", self:GetParent():GetAbsOrigin(), true)
  end





