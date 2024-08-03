MollyRoom = ExplorableArea:extend()       --Name of the room, but it holds the floor sprites.

function MollyRoom:new(x,y,ll,rl,scale)
	MollyRoom.super.new(self,x,y,ll,rl,scale)
	self.floor = love.graphics.newImage("sprites/places/mollyRoom/floor.png")
	self.floor_ox = self.floor:getWidth()/2 - 40
	self.floor_oy = self.floor:getHeight()
	self.walls = love.graphics.newImage("sprites/places/mollyRoom/walls.png")
	self.walls_ox = self.walls:getWidth()/2 - 100
	self.walls_oy = self.walls:getHeight() + 200
					-- No need game.scale
				-- love.graphics.draw(game.scale) scales it for you.


	-- Below is where I placed the colliders
	table.insert(Environment.objects,Isometric(self.x-100*self.scale,self.y+250*self.scale,1200,300))--bottom left
	table.insert(Environment.objects,Isometric(self.x+10*self.scale,self.y+250*self.scale,300,1300))--bottom right
	table.insert(Environment.objects,Isometric(self.x2-350*self.scale,self.y2+160*self.scale,300,1500))--top left
	table.insert(Environment.objects,Isometric(self.x3+240*self.scale,self.y3+160*self.scale,1300,300))--top right sides
	table.insert(Environment.objects,AtticDoor(self.x+130*self.scale,self.y-220*self.scale))
end

function MollyRoom:update(dt)
end

function MollyRoom:draw()
	love.graphics.draw(self.walls,self.x,self.y,nil,self.scale,self.scale,self.walls_ox,self.walls_oy)
	love.graphics.draw(self.floor,self.x,self.y,nil,self.scale,self.scale,self.floor_ox,self.floor_oy)
	MollyRoom.super.draw(self)
end
