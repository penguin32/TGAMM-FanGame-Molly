McGeeKitchen = ExplorableArea:extend()--Name of the room, but it holds the floor sprites.

function McGeeKitchen:new(x,y,ll,rl,scale)
	McGeeKitchen.super.new(self,x,y,ll,rl,scale)
	self.floor = love.graphics.newImage("sprites/places/mcGeeKitchen/wallAndFloor.png")
	self.floor_ox = self.floor:getWidth()/2 - 40 -- - 110*game.scale  	November 10 2022 : Lesson Learned! if its a variable that is being
	self.floor_oy = self.floor:getHeight()		--			used by a scale already, like love.graphics.draw(,,,self.scale,,)
							--			Donuts ! scale the tranlation constant just to get scaled again
							--			by a function, smh.
	table.insert(Environment.objects,Isometric(self.x+50*game.scale,self.y+250*game.scale,1400,300))--bottom left
	table.insert(Environment.objects,Isometric(self.x+190*game.scale,self.y+250*game.scale,300,1300))--bottom right
	table.insert(Environment.objects,Isometric(self.x2-260*game.scale,self.y2+160*game.scale,300,1500))--top left
	table.insert(Environment.objects,Isometric(self.x3+240*game.scale,self.y3+70*game.scale,1300,300))--top right sides

	table.insert(Environment.objects,AtticDoor(self.x+130*game.scale,self.y-220*game.scale))
end

function McGeeKitchen:update(dt)
end

function McGeeKitchen:draw()
--	love.graphics.setColor(255,255,255,0.3)
	love.graphics.draw(self.floor,self.x,self.y,nil,self.scale,self.scale,self.floor_ox,self.floor_oy)
	McGeeKitchen.super.draw(self)
end
