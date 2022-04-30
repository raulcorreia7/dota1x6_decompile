

modifier_terror_illusion_incoming = class({})


function modifier_terror_illusion_incoming:IsHidden() return true end
function modifier_terror_illusion_incoming:IsPurgable() return false end



function modifier_terror_illusion_incoming:OnCreated(table)
if not IsServer() then return end
  self:SetStackCount(1)
   self.StackOnIllusion = true 
end


function modifier_terror_illusion_incoming:OnRefresh(table)
if not IsServer() then return end
  self:SetStackCount(self:GetStackCount()+1)
  
end

function modifier_terror_illusion_incoming:RemoveOnDeath() return false end