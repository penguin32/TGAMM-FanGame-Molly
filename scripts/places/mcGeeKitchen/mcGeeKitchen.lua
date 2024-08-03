McGeeKitchen = ExplorableArea:extend() -- Name of the room, but it holds the floor sprites.

function McGeeKitchen:new(x,y,ll,rl,scale)
	McGeeKitchen.super.new(self,x,y,ll,rl,scale)
	self.floor = love.graphics.newImage("sprites/places/mcGeeKitchen/wallAndFloor.png")
	self.floor_ox = self.floor:getWidth()/2 - 40 -- Do not multiply by game.scale
	self.floor_oy = self.floor:getHeight()       -- See Molly's Room for tips.

	table.insert(Environment.objects,Isometric(self.x+50*game.scale,self.y+250*game.scale,1400,300))--bottom left
	table.insert(Environment.objects,Isometric(self.x+190*game.scale,self.y+250*game.scale,300,1300))--bottom right
	table.insert(Environment.objects,Isometric(self.x2-260*game.scale,self.y2+160*game.scale,300,1500))--top left
	table.insert(Environment.objects,Isometric(self.x3+240*game.scale,self.y3+70*game.scale,1300,300))--top right sides

	table.insert(Environment.objects,AtticDoor(self.x+130*game.scale,self.y-220*game.scale))


--To be deleted-------Just for tracing other objects
	self.forTracing = love.graphics.newImage("sprites/mollyRoom.png")
	self.temp_ox = self.forTracing:getWidth()/2  
	self.temp_oy = self.forTracing:getHeight() - 125
------------------------

end

function McGeeKitchen:update(dt)
end

function McGeeKitchen:draw()
	love.graphics.draw(self.floor,self.x,self.y,nil,self.scale,self.scale,self.floor_ox,self.floor_oy)


--To be deleted-------Just for tracing other objects
	love.graphics.setColor(1,1,1,0.2)
	love.graphics.draw(self.forTracing,self.x,self.y,nil,self.scale,self.scale,self.temp_ox,self.temp_oy)
	love.graphics.setColor(1,1,1,1)
	McGeeKitchen.super.draw(self)
----------------------------------------------------
end
