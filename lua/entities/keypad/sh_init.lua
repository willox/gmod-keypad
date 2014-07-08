ENT.Base = "base_anim"

ENT.Model = Model("models/props_lab/keypad.mdl")

ENT.Spawnable = true

ENT.Status_None = 0
ENT.Status_Granted = 1
ENT.Status_Denied = 2

ENT.Command_Enter = 0
ENT.Command_Accept = 1
ENT.Command_Reset = 2

function ENT:Initialize()
	self:SetModel(self.Model)

	self.Mins = self:OBBMins()
	self.Maxs = self:OBBMaxs()

	if SERVER then
		self:PhysicsInit(SOLID_VPHYSICS)

		local phys = self:GetPhysicsObject()

		if IsValid(phys) then
			phys:Wake()
		end
	end

	self:SetText("123")
end

function ENT:SetupDataTables()
	self:NetworkVar( "String", 0, "Text" )

	self:NetworkVar( "Int", 0, "Status" )

	self:NetworkVar( "Bool", 0, "Secure" )
end