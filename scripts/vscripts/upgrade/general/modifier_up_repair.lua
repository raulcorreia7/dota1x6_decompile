

modifier_up_repair = class({})


function modifier_up_repair:IsHidden() return true end
function modifier_up_repair:IsPurgable() return false end


function modifier_up_repair:OnCreated(table)
if not IsServer() then return end
  self:SetStackCount(1)
  local item = CreateItem("item_upgrade_repair", self:GetParent(), self:GetParent())
  	if self:GetParent():GetNumItemsInInventory() < 10 then
            self:GetParent():AddItem(item)
     else
     	CreateItemOnPositionSync(GetGroundPosition(self:GetParent():GetAbsOrigin(),  self:GetParent()), item)
    end
end

function modifier_up_repair:OnRefresh(table)
if not IsServer() then return end
  self:SetStackCount(self:GetStackCount()+1)
  local item = CreateItem("item_upgrade_repair", self:GetParent(), self:GetParent())
  	if self:GetParent():GetNumItemsInInventory() < 10 then
            self:GetParent():AddItem(item)
     else
     	CreateItemOnPositionSync(GetGroundPosition(self:GetParent():GetAbsOrigin(),  self:GetParent()), item)
    end
end



function modifier_up_repair:RemoveOnDeath() return false end
  