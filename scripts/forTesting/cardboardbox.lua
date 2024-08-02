--[[
Rules for the isometric
 1. You can change the size of the isometric box that would collide with the character,
    individually, those values are 252(your left width)
				   340(your right width)
			Those are lengths of the box facing isometric view...
 2. The Drawings cannot,
	You would have to configure how it would look like, manually...

So.. Are you planning on making a new objects but the same collide function(shape) ..hopefully?
Then just make a new file, inherit that desired shape(collider file) and then
	add the picture( manually )according to its sizes and opaque -ness

	opaqueness---well Im only adding that to the character being controlled by the player.. so maybe I could reuse that code again.
 I mean that when a character is behind a large objects, it should be opaque = 0.5 atleast
]]--

CardBoardBox = Isometric:extend()
CardBoardBox.opaque = 1

function CardBoardBox:new(x,y,scale)
	self.scale = scale or game.scale
	CardBoardBox.super.new(self,x,y,252,340,self.scale)--Put the original pixel size of the image, those values determine its image ratio.
	self.heightCoordinate = self.y - self.skin:getHeight()*self.scale
end

CardBoardBox.skin = love.graphics.newImage("sprites/forTesting/box.png")

function CardBoardBox:draw()
	love.graphics.setColor(255,255,255,1*self.opaque)
	love.graphics.draw(self.skin,self.x2 +160*self.scale,self.y,0,self.scale,self.scale,self.ll*self.cos,self.skin:getHeight())
	love.graphics.setColor(255,255,255,1)
	if self.opaque == 0.5 then
		love.graphics.polygon("line",self.x2,self.y2,self.x,self.y,self.x3,self.y3,self.x4,self.y4)
	end
end

function CardBoardBox:update()--Player) --opaqueness for the player only
			local yt = Player.SelectedCharacter.y+Player.SelectedCharacter.feetOffsetY - Player.SelectedCharacter.feetr*math.sin(1.0472)--isometric, same as humanColliderFunctions
			local blsx = self.x - ((yt - self.y)/self.ml)
			local brsx = self.x - ((yt - self.y)/self.mr)
			if Player.SelectedCharacter.x+Player.SelectedCharacter.feetOffsetX > self.x2 and Player.SelectedCharacter.x+Player.SelectedCharacter.feetOffsetX < self.x3 and Player.SelectedCharacter.x+Player.SelectedCharacter.feetOffsetX > blsx and Player.SelectedCharacter.x+Player.SelectedCharacter.feetOffsetX < brsx and Player.SelectedCharacter.y+Player.SelectedCharacter.feetOffsetY  > self.heightCoordinate and Player.SelectedCharacter.y+Player.SelectedCharacter.feetOffsetY < self.y then
				self.opaque = 1--0.5
			else
				self.opaque = 1
			end-- This block works, but if Player funcs become independent,
			-- sorting drawing is gonna be a Hell to solve.
	-- Find another way, without having to set the player:update/draw independent
	-- from the Environment.objects...
	-- November 6 2022 > I could create a public table from the main file,
	-- declare them before the strict.lua file, and
	--	put table of the character's offsetHitboxes and its positions that is
	--	being updated inside the Environment:update(dt).
	--	S O L V E D!
end
