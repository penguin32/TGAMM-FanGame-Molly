--[[			Character's Sprites
	1.	"fileName.0001.png" Using opentoonz format.
	2.	Variations are: North, North-East, East, East-South, South.
	3.	The Image will be flipped in the program.
	4.	4 animation frames each of those variations. Total of 20 images for each head,torso, and legs.
	5.	The image sprites parts should have the same value of width & height and when put together like a stack of paper
			...It should form their selves like a layer.
			Unless there's some custom sizes like added scarf that goes beyong character sprites or wings, then their animation frames should
			have the same image width and height(pixels) :)

	This class uses a global variable from a table: game = {}, found at main.lua file.
	game.middleX,game.middleY referes to the middle part of the game screen.

	I mentioned colliders here, but that would be on a separate lua file.
]]--
CharacterSprite = SimpleMovement:extend()

function CharacterSprite:new(base_x,base_y,base_v,type_of_sprite,selected_sprite,scale)
	CharacterSprite.super.new(self,base_x,base_y,base_v)
	self.skin = LoadSprite.Selection(type_of_sprite,selected_sprite)
	self.scale = scale or game.scale--Affects sprite's size and its colliders, but colliders from their own lua file.
	self.x = self.base_x		--Similar to base_x,base_y but this variable are for character's sprites & colliders positions,
	self.y = self.base_y		-- that would follow the base_x,base_y.
	self.cos = 0
	self.sin = 0			--Similar to base_cos,base_sin but for character's sprites & colliders to follow base_x,base_y position.
	self.xyToBaseXY = 0		--Similar to base_cfd, but this distance represents distance of the character to the base_x,base_y position.
	self.currentFrame = 1		--Purpose:Animation, to cycle through 4 animation frames.
	self.boolCountingWhere = true	--Purpose:Animation, to cycle through 4 animation frames.
	self.dir_r = 0			--Purpose:Animation, a variable for the direction in radians of the character following base_x,base_y.
	self.scale = self.scale*game.scale
	self.isMoving = false		--Check if Character is moving, used by the child class.
end

function CharacterSprite:update(dt,animal_x,animal_y,food_x,food_y)
	CharacterSprite.super.update(self,dt,animal_x,animal_y,food_x,food_y)
--Purpose:Character follows base_x,base_y position.
	self.xyToBaseXY = Direction.GetDistance(self.x,self.y,self.base_x,self.base_y)
	self.cos,self.sin = Direction.GetVector(self.x,self.y,self.base_x,self.base_y)
	if self.xyToBaseXY > self.base_dai and self.xyToBaseXY < self.base_damv then
		self.x = self.x + self.base_v*self.cos*(self.xyToBaseXY/50)*dt
		self.y = self.y + self.base_v*self.sin*(self.xyToBaseXY/50)*dt
		self.isMoving = true
	elseif self.xyToBaseXY >= self.base_damv then
		self.x = self.x + self.base_v*self.cos*(self.base_da/50)*dt
		self.y = self.y + self.base_v*self.sin*(self.base_da/50)*dt
		self.isMoving = true 
	else
		self.isMoving = false	
	end
--Purpose:Animation.
	self.dir_r = Direction.GetRadian(self.x,self.y,self.base_x,self.base_y)
	if self.boolCountingWhere == true then
		self.currentFrame = self.currentFrame + 10*dt
		if self.currentFrame >= 4 then
			self.boolCountingWhere = false
			self.currentFrame = 3.9
		end
	else
		self.currentFrame = self.currentFrame - 10*dt
		if self.currentFrame < 1 then
			self.boolCountingWhere = true
			self.currentFrame = 1
		end
	end
			--November 5 2022 : Feels like I should put these on the simpleMovement.lua file instead.
				--But xyToBaseXY variable is also used by this characterSprite.lua, so let him cook.
--Purpose:Camera limit movements. Focus on the character.
-- The purpose of this is for the player's camera, but if an npc would be automated, this code block woudln't even matter :)
	if self.xyToBaseXY > game.middleX then	--For now June 5 2022, this is how I limit where the camera should be allowed to go,
		if self.base_x ~= self.x then	-- for the player to be able to see their character.
			self.base_x = self.base_x - self.base_v*self.base_cos*(self.base_da/50)*dt
		end
		if self.base_y ~= self.y then
			self.base_y = self.base_y - self.base_v*self.base_sin*(self.base_da/50)*dt
		end
	end
end

--[[October 16 2022
	This function below is ran inside the draw() of the child-class.
	Example:	Festivia = CharacterSprite:extend()
			Festivia:draw()
				--blah blah specific way to draw from the update(), then now here...
				self:PosesDraw(self.skin.legs,r,sx,sy,ox,oy,kx,ky)--will be changed by Festivia:update() dt
				self:PosesDraw(self.skin.torso,r,sx,sy,ox,oy,kx,ky)
When calling it there...update()
			Festivie.Head = {
						r = 0, sx = 1, sy = 1, ox = 0, oy = 2, kx = 1, ky = 0.5
					}This table could be use to changed the properties of the Sprite parts...
	love.graphics.draw(drawable, x, y, r, sx, sy, ox, oy, kx, ky)
]]--
function CharacterSprite:PosesDraw(character_parts,x,y,r,sx,sy,ox,oy,kx,ky)
	x = x or self.x
	y = y or self.y
	r = r or 0					--orientation(radians),maybe Direction = {} on direction.lua might be helpful
							--  havent tried this one, maybe it rotate based on the x,y
	sx = sx or game.scale				--scales,if you see a -sx, or -sy that just means I flipped that image based on the direction the
							--	the character is facing.
	sy = sy or sx
	ox = ox or character_parts[1]:getWidth()/2	--offsets draw image to the left my the middle part of image
	oy = oy or character_parts[1]:getHeight()	--	  draw image upward by the length of its height
		--[[		Visually it would look like this:
					--------
					|	|
					|  :)	|
					|	|
					----*---
					    ^your self.x,self.y
		]]--
	kx = kx or 0					--shearing
	ky = ky or 0--if you change this arguement when called this function, this will also affet other sprites.
			--updater later... October 17 2022
	if self.xyToBaseXY <= self.base_dai then
		if self.dir_r > Direction.north_west and self.dir_r < Direction.north then
			love.graphics.draw(character_parts[17],x,y,r,-sx,sy,ox,oy,kx,ky)
		elseif self.dir_r >= Direction.north and self.dir_r < Direction.north_east then
			love.graphics.draw(character_parts[17],x,y,r,sx,sy,ox,oy,kx,ky)
		elseif self.dir_r >= Direction.adjustedWestNegative and self.dir_r <= Direction.north_west then
			love.graphics.draw(character_parts[13],x,y,r,sx,sy,ox,oy,kx,ky)
		elseif self.dir_r < Direction.adjustedWestNegative or self.dir_r > Direction.adjustedWestPositive then
			love.graphics.draw(character_parts[9],x,y,r,sx,sy,ox,oy,kx,ky)
		elseif self.dir_r < Direction.adjustedWestPositive and self.dir_r >= Direction.south_west then
			love.graphics.draw(character_parts[1],x,y,r,sx,sy,ox,oy,kx,ky)
		elseif self.dir_r < Direction.south_west and self.dir_r > Direction.south then
			love.graphics.draw(character_parts[5],x,y,r,sx,sy,ox,oy,kx,ky)
		elseif self.dir_r <= Direction.south and self.dir_r > Direction.south_east then
			love.graphics.draw(character_parts[5],x,y,r,-sx,sy,ox,oy,kx,ky)
		elseif self.dir_r <= Direction.south_east and self.dir_r >= Direction.deg15 then
			love.graphics.draw(character_parts[1],x,y,r,-sx,sy,ox,oy,kx,ky)
		elseif self.dir_r >= Direction.north_east and self.dir_r <= Direction.deg15Neg then
			love.graphics.draw(character_parts[13],x,y,r,-sx,sy,ox,oy,kx,ky)
		elseif self.dir_r < Direction.deg15 or self.dir_r > Direction.deg15Neg then
			love.graphics.draw(character_parts[9],x,y,r,-sx,sy,ox,oy,kx,ky)
		end
	elseif self.xyToBaseXY > self.base_dai then
		local afc--animation frame page
		if self.dir_r > Direction.north_west and self.dir_r < Direction.north then
			afc = math.floor(17+self.currentFrame)
			love.graphics.draw(character_parts[afc],x,y,r,-sx,sy,ox,oy,kx,ky)
		elseif self.dir_r >= Direction.north and self.dir_r < Direction.north_east then
			afc = math.floor(17+self.currentFrame)
			love.graphics.draw(character_parts[afc],x,y,r,sx,sy,ox,oy,kx,ky)
		elseif  self.dir_r >= Direction.adjustedWestNegative and self.dir_r <= Direction.north_west then
			afc = math.floor(13+self.currentFrame)
			love.graphics.draw(character_parts[afc],x,y,r,sx,sy,ox,oy,kx,ky)
		elseif self.dir_r < Direction.adjustedWestNegative or self.dir_r > Direction.adjustedWestPositive then
			afc = math.floor(9+self.currentFrame)
			love.graphics.draw(character_parts[afc],x,y,r,sx,sy,ox,oy,kx,ky)
		elseif self.dir_r < Direction.adjustedWestPositive and self.dir_r >= Direction.south_west then
			afc = math.floor(1+self.currentFrame)
			love.graphics.draw(character_parts[afc],x,y,r,sx,sy,ox,oy,kx,ky)
		elseif self.dir_r < Direction.south_west and self.dir_r > Direction.south then
			afc = math.floor(5+self.currentFrame)
			love.graphics.draw(character_parts[afc],x,y,r,sx,sy,ox,oy,kx,ky)
		elseif self.dir_r <= Direction.south and self.dir_r > Direction.south_east then
			afc = math.floor(5+self.currentFrame)
			love.graphics.draw(character_parts[afc],x,y,r,-sx,sy,ox,oy,kx,ky)
		elseif self.dir_r <= Direction.south_east and self.dir_r >= Direction.deg15 then
			afc = math.floor(1+self.currentFrame)
			love.graphics.draw(character_parts[afc],x,y,r,-sx,sy,ox,oy,kx,ky)
		elseif self.dir_r >= Direction.north_east and self.dir_r <= Direction.deg15Neg then
			afc = math.floor(13+self.currentFrame)
			love.graphics.draw(character_parts[afc],x,y,r,-sx,sy,ox,oy,kx,ky)
		elseif self.dir_r < Direction.deg15 or self.dir_r > Direction.deg15Neg then
			afc = math.floor(9+self.currentFrame)
			love.graphics.draw(character_parts[afc],x,y,r,-sx,sy,ox,oy,kx,ky)
		end
	end
end

