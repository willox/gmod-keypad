local keypad_classes = {
	["keypad"] = true
}

hook.Add("PlayerButtonDown", "Keypad", function(ply, button)
	if button ~= KEY_E then
		return
	end

	local tr = util.TraceLine({
		start = ply:EyePos(),
		endpos = ply:EyePos() + ply:GetAimVector() * 35,
		filter = ply
	})

	local ent = tr.Entity

	if not IsValid(ent) or not keypad_classes[ent:GetClass()] then
		return
	end

	local element = ent:GetHoveredElement()

	if not element or not element.click then
		return
	end

	element.click(ent)
end)