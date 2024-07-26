AtticDoor = FlooredIsometricObject:extend()
AtticDoor:implement(IsometricInteract)

--[[
--Plan:
--	How am I going to implement character vs item/door interaction?
--	Character has to be near the said object.
--		I'm going to implement that by having the object stand in a specific position.
--	Player's cursor also has to be pointing at what object.
--		looking back at isometricInteract that I have created already,
--		I don't mind creating different shapes for each interact, the rest of those are rectangle and circle are left.
--		They will be implement on the class object only what is needed.
--	Can an object have multiple shapesInteract?
--		WHy? Because I am planning of adding space where the character should be standing in (isometricInteract w/ CharacterHover())
--			and some other shapes for the mouseHover()
--
--	What can I do?
--		I think it is possible to implement an offset on characterHover()
--]]--
function AtticDoor:new(x,y,ll,rl,scale)
	self.atticDoor = love.graphics.newImage("sprites/places/mollyRoom/atticDoor.png")
	self.atticDoorH = love.graphics.newImage("sprites/places/mollyRoom/atticDoorLitUp.png")
	self.atticDoor_ox = self.atticDoor:getWidth()/2+10*game.scale
	self.atticDoor_oy = self.atticDoor:getHeight()-30*game.scale
	self.atticDoor_opac = 0
	AtticDoor.super.new(self,x,y,180,180,scale)--Offset at the end, can be left empty.
	self.timer = 0
	self.atticDoor_opacOutOfReach = 0
	self.atticDoor_showOutOfReachMessage = 0
	self.boolMoveAtIsClicked = false  -- July 27 2024, this thing turns out to be pretty fucking important during changing that player's place
end




				-- July 27 2024
--	local forZoomingOut = forZoomingIn - 2 -- i should turn that 2 into a variable later
--	local forZoomingInitial = forZoomingIn
--	discard ^ to exchange for local tick(replacing badAttemptAtScaling variable)
	local tick = 1
	--huh didn't work, it must have something to do with player.lua joystick


function AtticDoor:update(dt)--Don't repeat yourself: November 16 2022, fix in the future.
	if self:CursorHover() then-- and self:CharacterHover() and Player.Keyboard.z then
		if Player.Keyboard.z then
			self.boolMoveAtIsClicked = Player.Keyboard.z
			if self:CharacterHover() then
				self.timer = 1.4 --July 27 2024,version of myself, oh so that's just an example time given for testing, that value should varies depending on where it should put the character at some different places.
				Player.SelectedCharacter.base_x,Player.SelectedCharacter.base_y = self.xMiddle,self.yMiddle
			else
				self.atticDoor_opacOutOfReach = 1
				self.atticDoor_showOutOfReachMessage = 2
			end
		end
		self.atticDoor_opac = 1
	else
		self.atticDoor_opac = 0
	end
	self:MoveAt(dt)
	if self.atticDoor_showOutOfReachMessage > 0 then
		self.atticDoor_showOutOfReachMessage = self.atticDoor_showOutOfReachMessage - dt
		self.atticDoor_opacOutOfReach = self.atticDoor_opacOutOfReach - dt/2
	end
--	Player.SelectedCharacter:MoveAt(dt,self.timer,Direction.south_west)
end

function AtticDoor:draw()
	if self.atticDoor_showOutOfReachMessage > 0 then
		love.graphics.setColor(0.2,0.2,1,1*self.atticDoor_opacOutOfReach)
		love.graphics.print("Out of reach!",self.x,self.y)
	end
	love.graphics.setColor(255,255,255,1*self.atticDoor_opac)
	love.graphics.draw(self.atticDoorH,self.x,self.y,nil,self.scale,self.scale,self.atticDoor_ox,self.atticDoor_oy)
	love.graphics.setColor(255,255,255,1)
	love.graphics.draw(self.atticDoor,self.x,self.y,nil,self.scale,self.scale,self.atticDoor_ox,self.atticDoor_oy)
	AtticDoor.super.draw(self)
end

function AtticDoor:MoveAt(dt)
	if self.timer > 0 then
		Player.SelectedCharacter.isChangingPlace = true
		Player.SelectedCharacter.setCollider = false
		Player.SelectedCharacter.base_v = Player.SelectedCharacter.temporary_velocity
		-- July 27 2024, im going to try changing for Zooming in while moving places.
		-- badAttemptAtScaling is you guessed it, for Scaling Everything, 1 as its initial value.
		-- I think i understand why it doesn't work about when changing "forZoomingIn" variable, that's because the distance it takes for an entity to change position get larger,
		-- and this function MoveAt(dt), is based on time! I must change time proportional to the "forZoomingIn" ratio!
	--NO it has to do with joystick, and I get it now, A joystick shouldnt be affected by 'forZoomingIn', so i should divide it by that variable!!!! A joystick should remain the same ratio for the cellphone screen!
--		if game.badAttemptAtScaling < 2 then
--			game.badAttemptAtScaling = game.badAttemptAtScaling + dt
--		end
		if tick < 2 then
			tick = tick + dt
		end

	cursor.x,cursor.y = game.middleX+Joystick.biggerCircle.r*Joystick.jscale*math.cos(Direction.south_west),game.middleY+Joystick.biggerCircle.r*Joystick.jscale*math.sin(Direction.south_west)
		self.timer = self.timer - dt
	elseif self.boolMoveAtIsClicked then
		Player.SelectedCharacter.isChangingPlace = false
		Player.SelectedCharacter.setCollider = true
		Player.SelectedCharacter.base_v = Player.SelectedCharacter.current_velocity
--		if game.badAttemptAtScaling > 1 then
--			game.badAttemptAtScaling = game.badAttemptAtScaling - dt
--		else
--			self.boolMoveAtIsClicked = false
--		end
		if tick > 1 then
			tick = tick - dt
		else
			self.boolMoveAtIsClicked = false
		end
	end
end
