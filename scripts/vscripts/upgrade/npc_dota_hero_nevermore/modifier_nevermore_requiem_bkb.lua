

modifier_nevermore_requiem_bkb = class({})


function modifier_nevermore_requiem_bkb:IsHidden() return true end
function modifier_nevermore_requiem_bkb:IsPurgable() return false end



function modifier_nevermore_requiem_bkb:OnCreated(table)
if not IsServer() then return end
  self:SetStackCount(1)
   self.StackOnIllusion = true 
end


function modifier_nevermore_requiem_bkb:OnRefresh(table)
if not IsServer() then return end
  self:SetStackCount(self:GetStackCount()+1)
  
end

function modifier_nevermore_requiem_bkb:RemoveOnDeath() return false end