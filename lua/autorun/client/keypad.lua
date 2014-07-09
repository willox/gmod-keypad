local keypad_classes = {
	["keypad"] = true
}

hook.Add("PlayerBindPress", "Keypad", function(ply, bind, pressed)
	if not pressed or not string.find(bind, "+use", nil, true) then
		return
	end

	local tr = util.TraceLine({
		start = ply:EyePos(),
		endpos = ply:EyePos() + ply:GetAimVector() * 65,
		filter = ply
	})

	local ent = tr.Entity

	print(ent)

	if not IsValid(ent) or not ent.IsKeypad then
		return
	end

	local element = ent:GetHoveredElement()

	if not element or not element.click then
		return
	end

	element.click(ent)

	return
end)