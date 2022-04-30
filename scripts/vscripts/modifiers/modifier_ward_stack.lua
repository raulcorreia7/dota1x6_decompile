

modifier_ward_stack = class({})


function modifier_ward_stack:IsHidden() return false end
function modifier_ward_stack:IsPurgable() return false end
function modifier_ward_stack:RemoveOnDeath() return false end

function modifier_ward_stack:OnCreated(table)
if not IsServer() then return end

self.max_charges = Observer_max
self.ward_cd = Observer_cd
self.count = 0
self:StartIntervalThink(1)

end


function modifier_ward_stack:OnIntervalThink()
if not IsServer() then return end
local ward = self:GetParent():FindItemInInventory("item_observer_stackable") 
if not ward then return end
if ward:GetCurrentCharges() >= self.max_charges then return end

if self.count >= self.ward_cd then 
	ward:SetCurrentCharges(ward:GetCurrentCharges()+1)
    self.count = 0
end

if  self.count < self.ward_cd then 
	self.count = self.count + 1
end	


end