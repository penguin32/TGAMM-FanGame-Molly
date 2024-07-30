Player = {}

function Player.GetDistanceOfPointOnScreenWithRespectToPlayerBasePos()
	Player.evilCursorX = cursor.x - game.middleX + Player.SelectedCharacter.base_x
	Player.evilCursorY = cursor.y - game.middleY + Player.SelectedCharacter.base_y
--Named as such due to the fact that it cannot be seen, but play a large role to the cursor function when the player is being translated along with it.
--OH fuck I'm a genius! XD
end

touches = {}

function love.touchpressed(id,x,y)
	touches[id] = {x,y}
end

function love.touchmoved(id,x,y)
	touches[id][1] = x
	touches[id][2] = y
end

function love.touchreleased(id,x,y)
	touches[id] = nil
	Joystick.jx, Joystick.jy = 0,0
	cursor.x, cursor.y = game.middleX, game.middleY
	Joystick.circle.x, Joystick.circle.y = window.width*(0.5/4), window.height*(3/4)

	JoystickR.jx, JoystickR.jy = 0,0
    --need its own cursor.x, cursor.y for interaction options
	JoystickR.cursor.x, JoystickR.cursor.y = game.middleX, game.middleY
	JoystickR.circle.x, JoystickR.circle.y = window.width*(3.5/4), window.height*(3/4)
end

--[[			October 31 2022-November 3 2022
To switch Android to Desktop,
			In this file,  uncomment
		love.mousepressed(mx,my) for Desktop version.
		then on environment.lua, set a field on environment.load(), named "dev" somthing like that , and set that one, to false.
			that's all..
]]--

function love.mousepressed(mx,my)--Desktop
	local checkUi = #Environment.ui
	if checkUi > 0 then		
		for i,v in ipairs(Environment.ui)do
			if v:is(MainMenu) then
				v:mousepressed(mx,my)
			end
		end
	end
end

Player.Keyboard = {z=false}
function love.keypressed(key)
	if key == "z" then
		Player.Keyboard.z = true
	end
end

function love.keyreleased(key)
	if key == "z" then
		Player.Keyboard.z = false
	end
end

function TouchUpdateUI()--on main.lua file, love.udpate(), mousepressed alternative for Android
	for k,t in pairs(touches) do
		local checkUi = #Environment.ui
		if checkUi > 0 then
			for i,v in ipairs(Environment.ui)do
				if v:is(MainMenu) then
					v:mousepressed(t[1],t[2])
				end
			end
		end
	end
end

function Player.Load(Table)
	Player:PlayCharacter("Molly")
	table.insert(Table,Player.SelectedCharacter)
end

function Player:PlayCharacter(who)
	if who == "Molly" then--November 6 2022 : Currently tested
		self.SelectedCharacter = Molly()
		self.Who = who
	end
end

Joystick = { biggerCircle={}, circle={}, d=0, jx=0, jy=0, jd=0, jcos=0, jsin=0, jscale=6 }

Joystick.biggerCircle = {
	x=window.width*(0.5/4),
	y=window.height*(3/4),
	r=140*game.scale/forZoomingIn
}

Joystick.circle = {
	x=window.width*(0.5/4),
	y=window.height*(3/4),
	r=114*game.scale/forZoomingIn
}


function Joystick:update()
    for k,v in pairs(touches)do
		self.jx, self.jy = v[1],v[2]
		self.jcos, self.jsin = Direction.GetVector(self.biggerCircle.x,self.biggerCircle.y,self.jx,self.jy)
		self.jd = Direction.GetDistance(self.biggerCircle.x,self.biggerCircle.y,self.jx,self.jy)
		if self.jd < self.biggerCircle.r then						--November 3 2022, I couldn't make it untouch, like damn :(
			self.circle.x,self.circle.y = v[1],v[2]
			self.d = Direction.GetDistance(self.biggerCircle.x,self.biggerCircle.y,self.circle.x,self.circle.y)
			cursor.x, cursor.y = game.middleX + self.d*self.jcos*self.jscale, game.middleY + self.d*self.jsin*self.jscale
		elseif self.jd < (self.biggerCircle.r + 300*game.scale/forZoomingIn) then
			self.circle.x,self.circle.y = self.biggerCircle.x + self.biggerCircle.r*self.jcos, self.biggerCircle.y + self.biggerCircle.r*self.jsin
			cursor.x, cursor.y = game.middleX + self.biggerCircle.r*self.jcos*self.jscale, game.middleY + self.biggerCircle.r*self.jsin*self.jscale
		end
    end
end

function Joystick:draw()
	love.graphics.setColor(0.5,0.5,0.5)
	love.graphics.circle("line",self.biggerCircle.x,self.biggerCircle.y,self.biggerCircle.r)
	love.graphics.setColor(0.8,0.8,0.8)
	love.graphics.circle("fill",self.circle.x,self.circle.y,self.circle.r)
	love.graphics.setColor(0,1,0)
	love.graphics.setColor(255,255,255)
end


JoystickR = { biggerCircle={}, circle={}, d=0, jx=0, jy=0, jd=0, jcos=0, jsin=0, jscale=6 }

JoystickR.biggerCircle = {
	x=window.width*(3.5/4),
	y=window.height*(3/4),
	r=140*game.scale/forZoomingIn
}

JoystickR.circle = {
	x=window.width*(3.5/4),
	y=window.height*(3/4),
	r=114*game.scale/forZoomingIn
}

JoystickR.cursor = {
	x=0,
	y=0
}

function JoystickR:update()
    for k,v in pairs(touches)do
		self.jx, self.jy = v[1],v[2]
		self.jcos, self.jsin = Direction.GetVector(self.biggerCircle.x,self.biggerCircle.y,self.jx,self.jy)
		self.jd = Direction.GetDistance(self.biggerCircle.x,self.biggerCircle.y,self.jx,self.jy)
		if self.jd == 0 then
            --do nothing
		elseif self.jd < self.biggerCircle.r then
			self.circle.x,self.circle.y = v[1],v[2]
			self.d = Direction.GetDistance(self.biggerCircle.x,self.biggerCircle.y,self.circle.x,self.circle.y)

			 self.cursor.x, self.cursor.y = game.middleX + self.d*self.jcos*self.jscale, game.middleY + self.d*self.jsin*self.jscale

		elseif self.jd < (self.biggerCircle.r + 300*game.scale/forZoomingIn) then
			self.circle.x,self.circle.y = self.biggerCircle.x + self.biggerCircle.r*self.jcos, self.biggerCircle.y + self.biggerCircle.r*self.jsin

			self.cursor.x, self.cursor.y = game.middleX + self.biggerCircle.r*self.jcos*self.jscale, game.middleY + self.biggerCircle.r*self.jsin*self.jscale

		end
    end
end

function JoystickR:draw()
	love.graphics.setColor(0.5,0.5,0.5)
	love.graphics.circle("line",self.biggerCircle.x,self.biggerCircle.y,self.biggerCircle.r)
	love.graphics.setColor(0.8,0.8,0.8)
	love.graphics.circle("fill",self.circle.x,self.circle.y,self.circle.r)
	love.graphics.setColor(0,1,0)
	love.graphics.setColor(255,255,255)

	love.graphics.setColor(0,1,0.26)
	love.graphics.circle("fill",self.cursor.x,self.cursor.y,40*game.scale)
	love.graphics.setColor(255,255,255)
end
