include "sh_init.lua"

local debug = CreateConVar("keypad_debug", "0")

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
		pos:Add(self:GetUp() * -0.03) -- Top margin

	local ang = self:GetAngles()
		ang:RotateAroundAxis(ang:Right(), -90)
		ang:RotateAroundAxis(ang:Up(), 90)

	local w, h = 130, 230 -- :(

	local ply = LocalPlayer()

	if not IsValid(ply) then
		return
	end

	local intersect = util.IntersectRayWithPlane(ply:EyePos(), ply:GetAimVector(), pos, (ply:EyePos() - pos):GetNormal())
	print(intersect)

	cam.Start3D2D(pos, ang, 0.05)
		self:Paint(w, h, intersect.x, intersect.y)
	cam.End3D2D()

	if debug:GetBool() then
		render.SetBlend(0.05)
			cam.IgnoreZ(true)
				self:DrawModel()
			cam.IgnoreZ(false)
		render.SetBlend(1)
	end
end

function ENT:Paint(w, h, x, y)
	surface.SetDrawColor(Color(255, 255, 255, 10))
	surface.DrawRect(0, 0, w, h * 0.2)
end