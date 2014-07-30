
hook.Add("PlayerBindPress", "Keypad", function(ply, bind, pressed)
	if not pressed then
		return
	end

	local tr = util.TraceLine({
		start = ply:EyePos(),
		endpos = ply:EyePos() + ply:GetAimVector() * 65,
		filter = ply
	})

	local ent = tr.Entity

	if not IsValid(ent) or not ent.IsKeypad then
		return
	end

	if string.find(bind, "+use", nil, true) then
		local element = ent:GetHoveredElement()

		if not element or not element.click then
			return
		end

		element.click(ent)
	end
end)


local physical_keypad_commands = {

	[KEY_ENTER] = function(self)
		self:SendCommand(self.Command_Accept)
	end,

	[KEY_PAD_ENTER] = function(self)
		self:SendCommand(self.Command_Accept)
	end,

	[KEY_PAD_MINUS] = function(self)
		self:SendCommand(self.Command_Abort)
	end,

	[KEY_PAD_PLUS] = function(self)
		self:SendCommand(self.Command_Abort)
	end

}

for i = KEY_PAD_1, KEY_PAD_9 do
	physical_keypad_commands[i] = function(self)
		self:SendCommand(self.Command_Enter, i - KEY_PAD_1 + 1)
	end
end

local last_press = 0

hook.Add("CreateMove", "Keypad", function(cmd)
	
	if RealTime() - 0.1 < last_press then
		return
	end

	for key, handler in pairs(physical_keypad_commands) do
		if input.WasKeyPressed(key) then

			local ply = LocalPlayer()

			local tr = util.TraceLine({
				start = ply:EyePos(),
				endpos = ply:EyePos() + ply:GetAimVector() * 65,
				filter = ply
			})

			local ent = tr.Entity

			if not IsValid(ent) or not ent.IsKeypad then
				return
			end

			last_press = RealTime()
			
			handler(ent)

			return

		end
	end

end)
