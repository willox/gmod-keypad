ENT.Type			= "anim"
ENT.Base			= "base_gmodentity"

ENT.PrintName		= "Keypad"
ENT.Author			= "Willox"
ENT.Contact			= "Willox"
ENT.Purpose			= ""
ENT.Instructions	= ""

ENT.Spawnable		= false
ENT.AdminSpawnable	= false -- Spawned via STool

ENT.Status_None = 0
ENT.Status_Granted = 1
ENT.Status_Denied = 2

ENT.Command_Enter = 0
ENT.Command_Reset = 1
ENT.Command_Accept = 2

function ENT:SetupDataTables()
	self:NetworkVar("String", 0, "DisplayText")

	self:NetworkVar("Int", 0, "Status")

	self:NetworkVar("Bool", 0, "Secure")
end