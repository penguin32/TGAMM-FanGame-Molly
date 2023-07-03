MollyRoom = ExplorableArea:extend()--Name of the room, but it holds the floor sprites.

function MollyRoom:new(x,y,ll,rl,scale)
	MollyRoom.super.new(self,x,y,ll,rl,scale)
	self.floor = love.graphics.newImage("sprites/places/mollyRoom/floor.png")
	self.floor_ox = self.floor:getWidth()/2 - 40 -- - 110*game.scale  	November 10 2022 : Lesson Learned! if its a variable that is being
	self.floor_oy = self.floor:getHeight()		--			used by a scale already, like love.graphics.draw(,,,self.scale,,)
							--			Donuts ! scale the tranlation constant just to get scaled again
							--			by a function, smh.
	self.walls = love.graphics.newImage("sprites/places/mollyRoom/walls.png")
	self.walls_ox = self.walls:getWidth()/2 - 100 -- - 285*game.scale
	self.walls_oy = self.walls:getHeight() + 200 -- + 550*game.scale
	table.insert(Environment.objects,Isometric(self.x-100*game.scale,self.y+250*game.scale,1200,300))--bottom left
	table.insert(Environment.objects,Isometric(self.x+10*game.scale,self.y+250*game.scale,300,1300))--bottom right
	table.insert(Environment.objects,Isometric(self.x2-350*game.scale,self.y2+160*game.scale,300,1500))--top left
	table.insert(Environment.objects,Isometric(self.x3+240*game.scale,self.y3+160*game.scale,1300,300))--top right sides
	table.insert(Environment.objects,AtticDoor(self.x+130*game.scale,self.y-220*game.scale))
end

function MollyRoom:update(dt)
end

function MollyRoom:draw()
--	love.graphics.setColor(255,255,255,0.3)
	love.graphics.draw(self.walls,self.x,self.y,nil,self.scale,self.scale,self.walls_ox,self.walls_oy)
	love.graphics.draw(self.floor,self.x,self.y,nil,self.scale,self.scale,self.floor_ox,self.floor_oy)
	MollyRoom.super.draw(self)
end
