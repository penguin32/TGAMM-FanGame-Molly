Isometric = Object:extend() -- Just the shapes(attributes) and for categorizing in Env.Ordering

function Isometric:new(x,y,ll,rl,scale)
	self.sin = math.sin(0.523599)
	self.cos = math.cos(0.523599)
	self.mr = self.sin/self.cos
	self.ml = self.mr*(-1)
	self.scale = scale or game.scale
	self.ll = (ll or 15)*self.scale
	self.rl = (rl or 15)*self.scale
	self.x = x or 0
	self.y = y or 0
	self.x2 = self.x - self.ll*(self.cos)
	self.y2 = self.y - self.ll*(self.sin)
	self.x3 = self.x + self.rl*(self.cos)
	self.y3 = self.y - self.rl*(self.sin)
	self.x4 = self.x2 + self.rl*(self.cos)
	self.y4 = self.y2 - self.rl*(self.sin)
end

function Isometric:update(dt)--Exist to stay consistent with Environment.update(dt) loops
end

function Isometric:draw()
	if showOutlines == true then
	-- Just for testing... see collision shape.
		love.graphics.polygon("line",self.x2,self.y2,self.x,self.y,self.x3,self.y3,self.x4,self.y4)
	end
end

