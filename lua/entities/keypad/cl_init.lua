include "sh_init.lua"

local mat = CreateMaterial("keypad_aaaaaaaaaaaaaaaaaaaaabaaaaaaaaaasaae", "VertexLitGeneric", {
	["$basetexture"] = "white",
	["$color"] = "{ 42 42 42 }",
})

local VECTOR_X = Vector(1, 0, 0)
local VECTOR_Y = Vector(0, 1, 0)
local VECTOR_Z = Vector(0, 0, 1)

function ENT:Draw()
	render.SetMaterial(mat)

	render.DrawBox(self:GetPos(), self:GetAngles(), self.Mins, self.Maxs, color_white, true)

	local pos = self:GetPos()
		pos:Add(self:GetForward() * self.Maxs.x) -- Translate to front
		pos:Add(self:GetRight() * self.Maxs.y) -- Translate to left
		pos:Add(self:GetUp() * self.Maxs.z) -- Translate to top

		pos:Add(self:GetForward() * 0.01) -- Pop out of front to stop culling
		pos:Add(self:GetRight() * -0.03) -- Left margin

	local ang = self:GetAngles()
		ang:RotateAroundAxis(ang:Right(), -90)
		ang:RotateAroundAxis(ang:Up(), 90)

	local w, h = 130, 230 -- :(

	--print(util.IntersectRayWithPlane(EyePos(), LocalPlayer():GetAimVector(), pos, ang:Forward()))

	cam.Start3D2D(pos, ang, 0.05)
		self:Paint(w, h)
	cam.End3D2D()
end

function ENT:Paint(w, h, mousex, mousey)
	surface.SetDrawColor(Color(255, 0, 0, 20))
	surface.DrawRect(4, 4, w - 8, h - 8)
end