
modifier_nevermore_darklord_armor = class({})


function modifier_nevermore_darklord_armor:IsHidden() return true end
function modifier_nevermore_darklord_armor:IsPurgable() return false end



function modifier_nevermore_darklord_armor:OnCreated(table)
if not IsServer() then return end
  self:SetStackCount(1)
   self.StackOnIllusion = true 
end


function modifier_nevermore_darklord_armor:OnRefresh(table)
if not IsServer() then return end
  self:SetStackCount(self:GetStackCount()+1)
  
end

function modifier_nevermore_darklord_armor:RemoveOnDeath() return false end