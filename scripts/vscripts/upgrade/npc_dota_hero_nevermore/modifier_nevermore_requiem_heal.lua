

modifier_nevermore_requiem_heal = class({})


function modifier_nevermore_requiem_heal:IsHidden() return true end
function modifier_nevermore_requiem_heal:IsPurgable() return false end



function modifier_nevermore_requiem_heal:OnCreated(table)
if not IsServer() then return end
  self:SetStackCount(1)
   self.StackOnIllusion = true 
end


function modifier_nevermore_requiem_heal:OnRefresh(table)
if not IsServer() then return end
  self:SetStackCount(self:GetStackCount()+1)
  
end

function modifier_nevermore_requiem_heal:RemoveOnDeath() return false end