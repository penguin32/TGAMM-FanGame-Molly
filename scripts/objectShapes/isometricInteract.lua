IsometricInteract = Object:extend()--Colliderless, interactable. November 9 2022 : Only effective for smaller spawns of isometricClick objects, for now.
				--..pretty much useless for objects like isometricClick objects with a ratio of a footlong.
		--EXPLAINED IN 
	-- scripts/places/typeOfObjects/flooredIsometricObject.lua
	--
	--
				-- Maybe just use circle dumbass.
--[[				
function IsometricClick:new(x,y,ll,rl,scale,ox,oy)
	self.ox = ox or 0			--This offsets are only used on IsometricClick.update() 	November 10 2022
	self.oy = oy or 0		-- Have not been used yet, but its purpose was to move the interactive area like from CursorHover()
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

function IsometricClick:update(dt)--Exist to stay consistent with Environment.update(dt) loops
end

function IsometricClick:draw()--just for testing... see interactable shape
--	love.graphics.setColor(0,0,0)
--	love.graphics.polygon("line",self.x2,self.y2,self.x,self.y,self.x3,self.y3,self.x4,self.y4)
--	love.graphics.setColor(255,255,255)
end
]]-- --- CHANGE OF PLAN NOVEMBER 10 2022, maybe under the function below is where I should add the offset value for interactable area
	-- of the isometric(either that works with colliders or not/isometricBeta.lua)
	-- I will be doing it this way "implent-ing kinda way" since I want to re-use sorting-order function in environment.lua for isometric
	-- that has collider with objects that is isometric that doesn't want anything to do with colliders functions on humanColldersFunctions.lua
function IsometricInteract:CursorHover()--offsetX,offsetY)
--	local offsetX = offsetX or 0
--	local offsetY = offsetY or 0
--	y-y1 = m (x-x1)
--	Player.evilCursorY-self.y = self.m*(Player.evilCursorX-self.x)
--	Player.evilCursorY = self.m*(Player.evilCursorX-self.x) + self.y

	if Player.evilCursorX ~= Player.SelectedCharacter.base_x and Player.evilCursorY ~= Player.SelectedCharacter.base_y then
		--If-statement above added so that this function won't run unless the cursor is actively being used.(Does not mean "Press" though)
		--	Unlikey scenario that it would cause problem in the game though, so this pass my vibe check.
		if Player.evilCursorY < (self.ml*(Player.evilCursorX-self.x)+self.y) and Player.evilCursorY < (self.mr*(Player.evilCursorX-self.x)+self.y) and Player.evilCursorY > (self.mr*(Player.evilCursorX-self.x4)+self.y4) and Player.evilCursorY > (self.ml*(Player.evilCursorX-self.x4)+self.y4) then
			return true
		end
	end
end

function IsometricInteract:CharacterHover()--offsetX,offsetY)
--	local offsetX = offsetX or 0
--	local offsetY = offsetY or 0
	if Player.SelectedCharacter.y < (self.ml*(Player.SelectedCharacter.x-self.x)+self.y) and Player.SelectedCharacter.y < (self.mr*(Player.SelectedCharacter.x-self.x)+self.y) and Player.SelectedCharacter.y > (self.mr*(Player.SelectedCharacter.x-self.x4)+self.y4) and Player.SelectedCharacter.y > (self.ml*(Player.SelectedCharacter.x-self.x4)+self.y4) then
		return true
	end
end
