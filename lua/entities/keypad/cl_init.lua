include "sh_init.lua"

surface.CreateFont("KeypadAbort", {font = "Trebuchet", size = 80, weight = 900})
surface.CreateFont("KeypadOK", {font = "Trebuchet", size = 100, weight = 900})
surface.CreateFont("KeypadNumber", {font = "Trebuchet", size = 140, weight = 900})

local mat = CreateMaterial("keypad_aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaabaaaaaaaaaasaae", "VertexLitGeneric", {
	["$basetexture"] = "white",
	["$color"] = "{ 35 35 35 }",
})


function ENT:Draw()
	render.SetMaterial(mat)

	render.DrawBox(self:GetPos(), self:GetAngles(), self.Mins, self.Maxs, color_white, true)

	local pos = self:GetPos()
		pos:Add(self:GetForward() * self.Maxs.x) -- Translate to front
		pos:Add(self:GetRight() * self.Maxs.y) -- Translate to left
		pos:Add(self:GetUp() * self.Maxs.z) -- Translate to top

		pos:Add(self:GetForward() * 0.05) -- Pop out of front to stop culling

	local ang = self:GetAngles()
		ang:RotateAroundAxis(ang:Right(), -90)
		ang:RotateAroundAxis(ang:Up(), 90)	

	local w, h = self.Maxs.y - self.Mins.y, self.Maxs.z - self.Mins.z

	local scale = 0.01

	cam.Start3D2D(pos, ang, scale)
		self:Paint(math.floor(w / scale), math.floor(h / scale))
	cam.End3D2D()
end

local elements = {
	{ -- Screen
		x = 0.075,
		y = 0.04,
		w = 0.85,
		h = 0.25,
		color = Color(50, 75, 50, 255),
	},
	{ -- ABORT
		x = 0.075,
		y = 0.04 + 0.25 + 0.03,
		w = 0.85 / 2 - 0.04 / 2 + 0.05,
		h = 0.125,
		color = Color(120, 25, 25),
		text = "ABORT",
		font = "KeypadAbort"
	},
	{ -- OK
		x = 0.5 + 0.04 / 2 + 0.05,
		y = 0.04 + 0.25 + 0.03,
		w = 0.85 / 2 - 0.04 / 2 - 0.05,
		h = 0.125,
		color = Color(25, 120, 25),
		text = "OK",
		font = "KeypadOK"
	}
}

do -- Create numbers
	for i = 1, 9 do
		local column = (i - 1) % 3

		local row = math.floor((i - 1) / 3)
		
		local element = {
			x = 0.075 + (0.3 * column),
			y = 0.175 + 0.25 + 0.05 + ((0.5 / 3) * row),
			w = 0.25,
			h = 0.13,
			color = Color(120, 120, 120),
			text = tostring(i)
		}

		table.insert(elements, element)

		print(i, column, row)
	end
end

function ENT:Paint(w, h, x, y)
--	surface.SetDrawColor(Color(50, 75, 50, 255))
--	surface.DrawRect(40, 40, w - 80, h * 0.25)

	for k, element in ipairs(elements) do
		surface.SetDrawColor(element.color)
		surface.DrawRect(
			w * element.x, 
			h * element.y,
			w * element.w,
			h * element.h
		)

		if element.text then
			surface.SetFont(element.font or "KeypadNumber")

			local textw, texth = surface.GetTextSize(element.text)

			surface.SetTextColor(color_black)
			surface.SetTextPos(w * element.x + (w * element.w / 2) - textw / 2, h * element.y + (h * element.h / 2) - texth / 2)
			surface.DrawText(element.text)

		end
	end
end