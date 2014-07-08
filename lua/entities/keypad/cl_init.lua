include "sh_init.lua"

surface.CreateFont("KeypadAbort", {font = "Roboto", size = 45, weight = 900})
surface.CreateFont("KeypadOK", {font = "Roboto", size = 60, weight = 900})
surface.CreateFont("KeypadNumber", {font = "Roboto", size = 70, weight = 600})
surface.CreateFont("KeypadEntry", {font = "Roboto", size = 120, weight = 900})

local mat = CreateMaterial("keypad_aaaaabasea", "VertexLitGeneric", {
	["$basetexture"] = "white",
	["$color"] = "{ 38 38 38 }",
})

ENT.TraceX = 0
ENT.TraceY = 0

ENT.Scale = 0.02

function ENT:Think()
	local ply = LocalPlayer()

	if not IsValid(ply) then
		return
	end

	local pos = self:GetRenderPos()
	local ang = self:GetAngles():Forward()

	local scale = self.Scale

	local intersect = util.IntersectRayWithPlane(ply:EyePos(), ply:GetAimVector(), pos, ang)
	
	if intersect then
		intersect:Mul(-1)
		intersect:Add(pos)

		local x = intersect.x / scale
		local y = intersect.z / scale

		self.TraceX, self.TraceY = x, y
	end


	self:NextThink(CurTime() + 0.1)
end

function ENT:GetRenderPos()
	local pos = self:GetPos()
		pos:Add(self:GetForward() * self.Maxs.x) -- Translate to front
		pos:Add(self:GetRight() * self.Maxs.y) -- Translate to left
		pos:Add(self:GetUp() * self.Maxs.z) -- Translate to top

		pos:Add(self:GetForward() * 0.05) -- Pop out of front to stop culling


	local ang = self:GetAngles()
		ang:RotateAroundAxis(ang:Right(), -90)
		ang:RotateAroundAxis(ang:Up(), 90)	

	return pos, ang
end

function ENT:Draw()


	render.SetMaterial(mat)

	render.DrawBox(self:GetPos(), self:GetAngles(), self.Mins, self.Maxs, color_white, true)

	local pos, ang = self:GetRenderPos()

	local w, h = self.Maxs.y - self.Mins.y , self.Maxs.z - self.Mins.z

	local scale = self.Scale -- A high scale avoids surface call integerising from ruining aesthetics

	cam.Start3D2D(pos, ang, scale)
		self:Paint(math.floor(w / scale), math.floor(h / scale), self.TraceX, self.TraceY)
	cam.End3D2D()
end

local elements = {
	{ -- Screen
		x = 0.075,
		y = 0.04,
		w = 0.85,
		h = 0.25,
		color = Color(50, 75, 50, 255),
		render = function(self, x, y)
			surface.SetFont("KeypadEntry")

			local text = self:GetText()

			local textw, texth = surface.GetTextSize(text)			

			surface.SetTextColor(color_white)
			surface.SetTextPos(x - textw / 2, y - texth / 2)
			surface.DrawText(text)
		end,
	},
	{ -- ABORT
		x = 0.075,
		y = 0.04 + 0.25 + 0.03,
		w = 0.85 / 2 - 0.04 / 2 + 0.05,
		h = 0.125,
		color = Color(120, 25, 25),
		hovercolor = Color(180, 25, 25),
		text = "ABORT",
		font = "KeypadAbort"
	},
	{ -- OK
		x = 0.5 + 0.04 / 2 + 0.05,
		y = 0.04 + 0.25 + 0.03,
		w = 0.85 / 2 - 0.04 / 2 - 0.05,
		h = 0.125,
		color = Color(25, 120, 25),
		hovercolor = Color(25, 180, 25),
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
			hovercolor = Color(180, 180, 180),
			text = tostring(i)
		}

		table.insert(elements, element)
	end
end

function ENT:Paint(w, h, x, y)

	for k, element in ipairs(elements) do
		surface.SetDrawColor(element.color)

		local element_x = w * element.x
		local element_y = h * element.y
		local element_w = w * element.w
		local element_h = h * element.h

		if element.hovercolor then
			if 
				element_x < x and element_x + element_w > x and
				element_y < y and element_y + element_h > y 
			then
				surface.SetDrawColor(element.hovercolor)
			end
		end

		surface.DrawRect(
			element_x, 
			element_y,
			element_w,
			element_h
		)

		local cx = element_x + element_w / 2
		local cy = element_y + element_h / 2

		if element.text then
			surface.SetFont(element.font or "KeypadNumber")

			local textw, texth = surface.GetTextSize(element.text)

			surface.SetTextColor(color_black)
			surface.SetTextPos(cx - textw / 2, cy - texth / 2)
			surface.DrawText(element.text)
		end

		if element.render then
			element.render(self, cx, cy)
		end

	end

end