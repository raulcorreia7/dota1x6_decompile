

modifier_terror_illusion_texture = class({})


function modifier_terror_illusion_texture:IsHidden() return true end
function modifier_terror_illusion_texture:IsPurgable() return false end



function modifier_terror_illusion_texture:OnCreated(table)
if not IsServer() then return end
  self:SetStackCount(1)
  self.StackOnIllusion = true
end


function modifier_terror_illusion_texture:OnRefresh(table)
if not IsServer() then return end
  self:SetStackCount(self:GetStackCount()+1)
  
end

function modifier_terror_illusion_texture:RemoveOnDeath() return false end