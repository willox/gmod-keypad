AddCSLuaFile("cl_init.lua")
AddCSLuaFile("sh_init.lua")

include("sh_init.lua")

util.AddNetworkString("keypad_wire_command")

net.Receive("keypad_wire_command", function(len, ply)
	if(IsValid(ply)) then
		local ent = net.ReadEntity()

		if(ent:GetClass() == "keypad_wire" and ply:EyePos():Distance(ent:GetPos()) <= 50) then
			local cmd = net.ReadUInt(3)
			if(cmd == ent.Command_Enter) then
				local num = net.ReadUInt(4)

				if(num <= 9) then
					num = tostring(num)

					ent:EnterNum(num)
				end
			elseif(cmd == ent.Command_Reset) then
				ent:ResetButton()
			elseif(cmd == ent.Command_Accept) then
				ent:Submit()
			end
		end
	end
end)

util.PrecacheSound("buttons/button14.wav")
util.PrecacheSound("buttons/button9.wav")
util.PrecacheSound("buttons/button11.wav")
util.PrecacheSound("buttons/button15.wav")

AccessorFunc(ENT, "var_Input", "Input", FORCE_STRING)

function ENT:Initialize()
	if not WireLib then self:Remove() return end

	self:SetModel("models/props_lab/keypad.mdl")
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)

	local phys = self:GetPhysicsObject()

	if IsValid(phys) then
		phys:Wake()
	end

	self.Password = false

	if(not self.KeypadData) then
		self.KeypadData = {
			Password = false,

			RepeatsGranted = 0,
			RepeatsDenied = 0,

			LengthGranted = 0,
			LengthDenied = 0,

			DelayGranted = 0,
			DelayDenied = 0,

			InitDelayGranted = 0,
			InitDelayDenied = 0,

			OutputOn = 0,
			OutputOff = 0,

			Secure = false,
			Owner = NULL
		}
	end

	self:Reset()

	self.Outputs = Wire_CreateOutputs(self, {"Access Granted", "Access Denied"})
end

function ENT:SetPassword(pass)
	self.KeypadData.Password = tostring(pass)

	self:Reset()
end

function ENT:GetPassword(pass)
	return self.KeypadData.Password or ""
end

function ENT:SetData(data)
	self.KeypadData = data

	self:Reset()
end

function ENT:EnterNum(num)
	if(self:GetStatus() == self.Status_None) then
		local num = tostring(num)
		local new_input = self:GetInput()..num

		self:SetInput(new_input:sub(1, 4))

		if(self.KeypadData.Secure) then
			self:SetDisplayText(string.rep("*", #self:GetInput()))
		else
			self:SetDisplayText(self:GetInput())
		end

		self:EmitSound("buttons/button15.wav")
	end
end

function ENT:Submit()
	if(self:GetStatus() == self.Status_None) then
		local success = tostring(self:GetInput()) == tostring(self:GetPassword())

		self:Process(success)
	end
end

function ENT:ResetButton()
	if(self:GetStatus() == self.Status_None) then
		self:EmitSound("buttons/button14.wav")
		self:Reset()
	end
end

function ENT:Reset()
	self:SetDisplayText("")
	self:SetInput("")
	self:SetStatus(self.Status_None)

	self:SetSecure(self.KeypadData.Secure)
end


function ENT:Process(granted)
	local length, repeats, delay, initdelay, owner, outputKey

	if(granted) then
		self:SetStatus(self.Status_Granted)

		length = self.KeypadData.LengthGranted
		repeats = math.min(self.KeypadData.RepeatsGranted, 50)
		delay = self.KeypadData.DelayGranted
		initdelay = self.KeypadData.InitDelayGranted
		owner = self.KeypadData.Owner
		outputKey = "Access Granted"
	else
		self:SetStatus(self.Status_Denied)

		length = self.KeypadData.LengthDenied
		repeats = math.min(self.KeypadData.RepeatsDenied, 50)
		delay = self.KeypadData.DelayDenied
		initdelay = self.KeypadData.InitDelayDenied
		owner = self.KeypadData.Owner
		outputKey = "Access Denied"
	end

	timer.Simple(math.max(initdelay + length * (repeats + 1) + delay * repeats + 0.25, 2), function() -- 0.25 after last timer
		if(IsValid(self)) then
			self:Reset()
		end
	end)

	timer.Simple(initdelay, function()
		if(IsValid(self)) then
			for i = 0, repeats do
				timer.Simple(length * i + delay * i, function()
					if(IsValid(self) and IsValid(owner)) then
						Wire_TriggerOutput(self, outputKey, self.KeypadData.OutputOn)
					end
				end)

				timer.Simple(length * (i + 1) + delay * i, function()
					if(IsValid(self) and IsValid(owner)) then
						Wire_TriggerOutput(self, outputKey, self.KeypadData.OutputOff)
					end
				end)
			end
		end
	end)

	if(granted) then
		self:EmitSound("buttons/button9.wav")
	else
		self:EmitSound("buttons/button11.wav")
	end
end

local function HandleDuplication(ply, data, dupedata)
	local ent = ents.Create("keypad_wire")
	duplicator.DoGeneric(ent, dupedata)

	ent:Spawn()

	duplicator.DoGenericPhysics(ent, ply, dupedata)

	data['Owner'] = ply
	ent:SetData(data)

	if(IsValid(ply)) then
		ply:AddCount("keypads", ent)
	end
	
	return ent
end

duplicator.RegisterEntityClass("keypad_wire", HandleDuplication, "KeypadData", "Data")