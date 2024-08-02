Rectangle = Object:extend()

function Rectangle:new(x,y,w,h,scale)
	self.scale = scale or game.scale
	self.x = x or 0
	self.y = y or 0
	self.w = (w or 100)*self.scale
	self.h = (h or 100)*-self.scale
end

function Rectangle:update(dt)--Exist to stay consistent with Environment.update(dt) loops
end

function Rectangle:draw()
	-- Just for testing... see collision shape.
	love.graphics.rectangle("line", self.x, self.y, self.w, self.h)
end
