AtticDoor = FlooredIsometricObject:extend()
AtticDoor:implement(IsometricInteract)

function AtticDoor:new(x,y,ll,rl,scale)
	self.atticDoor = love.graphics.newImage("sprites/places/mollyRoom/atticDoor.png")
	self.atticDoorH = love.graphics.newImage("sprites/places/mollyRoom/atticDoorLitUp.png")
	self.atticDoor_ox = self.atticDoor:getWidth()/2+10
	self.atticDoor_oy = self.atticDoor:getHeight()-30
	self.atticDoor_opac = 0
	AtticDoor.super.new(self,x,y,180,180,scale)
	self.timer = 0
	self.atticDoor_opacOutOfReach = 0
	self.atticDoor_showOutOfReachMessage = 0
	self.boolMoveAtIsClicked = false
	self.wasInsideIsometricBox = false
end

function AtticDoor:update(dt)
	if self:CursorHover() and Player.Keyboard.z then
		self.boolMoveAtIsClicked = Player.Keyboard.z
		if self.boolMoveAtIsClicked and self:CharacterHover() then
			self.wasInsideIsometricBox = true
			self.timer = 1.2
			Player.SelectedCharacter.base_x,Player.SelectedCharacter.base_y = self.xMiddle,self.yMiddle
		else
			self.wasInsideIsometricBox = false
			self.atticDoor_opacOutOfReach = 1
			self.atticDoor_showOutOfReachMessage = 2
		end
		self.atticDoor_opac = 1
	elseif self:CursorHover() then
		self.atticDoor_opac = 1
	else
		self.atticDoor_opac = 0
	end
	if self.atticDoor_showOutOfReachMessage > 0 then
		self.atticDoor_showOutOfReachMessage = self.atticDoor_showOutOfReachMessage - dt
		self.atticDoor_opacOutOfReach = self.atticDoor_opacOutOfReach - dt
	end

	self:MoveAt(dt)
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
	cursor.x,cursor.y,cursor.visible = game.middleX+Joystick.biggerCircle.r*Joystick.jscale*math.cos(Direction.south_west),game.middleY+Joystick.biggerCircle.r*Joystick.jscale*math.sin(Direction.south_west),false
		self.timer = self.timer - dt
	elseif self.boolMoveAtIsClicked  and self.wasInsideIsometricBox then
		cursor.x,cursor.y,cursor.visible = game.middleX,game.middleY,true
		Player.SelectedCharacter.isChangingPlace = false
		Player.SelectedCharacter.setCollider = true
		Player.SelectedCharacter.base_v = Player.SelectedCharacter.current_velocity
		self.boolMoveAtIsClicked = false
	end
end
