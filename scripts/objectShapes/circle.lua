Circle = Object:extend()
function Circle:new(x,y,r,scale)
	self.scale = scale or game.scale
 	self.x = x or 0
	self.y = y or 0
	self.r = (r or 20)*self.scale
end

function Circle:update(dt)--Exist to stay consistent with Environment.update(dt) loops
end

function Circle:draw()
	if showOutline == true then
	-- Just for testing... see collision shape.
		love.graphics.circle("line", self.x, self.y, self.r)
	end
end
