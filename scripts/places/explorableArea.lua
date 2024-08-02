ExplorableArea = Object:extend()     --They are always drawn first in-order,
				     --Environment.SortObjects()
				     --Objects inheriting this are drawn first,
				     --They're the grass, bathroom tiles, etc..
				     --  of any game levels.
				     --In a shape of Isometric Box.

function ExplorableArea:new(x,y,ll,rl,scale,floor)
	self.sin = math.sin(0.523599)
	self.cos = math.cos(0.523599)
	self.mr = self.sin/self.cos
	self.ml = self.mr*(-1)
	self.scale = scale or game.scale
	self.ll = (ll or 15)*self.scale
	self.rl = (rl or 15)*self.scale
	self.x = x or 10
	self.y = y or 10
	self.x2 = self.x - self.ll*(self.cos)
	self.y2 = self.y - self.ll*(self.sin)
	self.x3 = self.x + self.rl*(self.cos)
	self.y3 = self.y - self.rl*(self.sin)
	self.x4 = self.x2 + self.rl*(self.cos)
	self.y4 = self.y2 - self.rl*(self.sin)
end

function ExplorableArea:update(dt)--Exist to stay consistent with Environment.update(dt) loops
end

function ExplorableArea:draw()

	--To see the outline of the walkable area as an example, in level 1
	--Not really needed and they're off centered due to varying object's width,height.
	love.graphics.setColor(0,0,1)
	love.graphics.polygon("line",self.x2,self.y2,self.x,self.y,self.x3,self.y3,self.x4,self.y4)
	love.graphics.setColor(1,1,1,1)
end
