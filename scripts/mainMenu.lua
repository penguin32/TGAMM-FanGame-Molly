MainMenu = Object:extend()
local mainMenuScale = game.scale/forZoomingIn
function MainMenu:new()
	self.directory = "sprites/title/"
	self.music = love.audio.newSource(self.directory.."001Title.ogg","stream")
	self.music:setLooping(true)
	self.music:play()
	self.titleImage = {}
	self.titleImage.i = love.graphics.newImage(self.directory.."intro title.png")
	self.titleImage.x,self.titleImage.y = game.cartX,game.cartY
	self.titleImage.w = self.titleImage.i:getWidth()*mainMenuScale
	self.titleImage.h = self.titleImage.i:getHeight()*mainMenuScale
	self.titleImage.s = mainMenuScale

	self.animation = {	love.graphics.newImage(self.directory.."intro1.png"),
				love.graphics.newImage(self.directory.."intro2.png"),
				currentFrame = 1,
				x = self.titleImage.x,
				y = self.titleImage.y,
				s = self.titleImage.s
	}
	self.btn = {}
	self.btn.freq = 0.25
	self.btn.continue = {}
	self.btn.continue.i = love.graphics.newImage(self.directory.."intro Continue.png")
	self.btn.continue.x = self.titleImage.x + self.titleImage.w*(5.8/10)
	self.btn.continue.y = self.titleImage.y + self.titleImage.h*(8/10)
	self.btn.continue.w = self.btn.continue.i:getWidth()*mainMenuScale
	self.btn.continue.h = self.btn.continue.i:getHeight()*mainMenuScale
	self.btn.continue.s = mainMenuScale
	self.btn.continue.sD= mainMenuScale
	self.btn.continue.t = 0
	self.btn.newGame = {}
	self.btn.newGame.x = self.titleImage.x + self.titleImage.w*(2.5/10)
	self.btn.newGame.y = self.titleImage.y + self.titleImage.h*(8/10)
	self.btn.newGame.i = love.graphics.newImage(self.directory.."intro NewGame.png")
	self.btn.newGame.w = self.btn.newGame.i:getWidth()*mainMenuScale
	self.btn.newGame.h = self.btn.newGame.i:getHeight()*mainMenuScale
	self.btn.newGame.s = mainMenuScale
	self.btn.newGame.sD= mainMenuScale
	self.btn.newGame.t = 0
end

function MainMenu:update(dt)
	self.animation.currentFrame = self.animation.currentFrame + 5 * dt
	if self.animation.currentFrame > 3 then self.animation.currentFrame = 1 end
	if self.btn.continue.t > 0 then
		self.btn.continue.s = self.btn.continue.s + self.btn.continue.t*0.1
		self.btn.continue.t = self.btn.continue.t - dt
		if self.btn.continue.t <= 0 then
			--table.remove(Environment.ui,#Environment.ui)
			--self.music:stop()
		end
	else
		self.btn.continue.s = self.btn.continue.sD
		self.btn.continue.t = 0
	end
	if self.btn.newGame.t > 0 then
		self.btn.newGame.s = self.btn.newGame.s + self.btn.newGame.t*0.1
		self.btn.newGame.t = self.btn.newGame.t - dt
		if self.btn.newGame.t <= 0 then
			table.remove(Environment.ui,#Environment.ui)
			Environment.level = 1
			Environment.bool = 1 
			self.music:stop()
		end
	else
		self.btn.newGame.s = self.btn.newGame.sD
		self.btn.newGame.t = 0
	end
end

function MainMenu:draw()
	love.graphics.draw(self.titleImage.i,self.titleImage.x,self.titleImage.y,0,self.titleImage.s,self.titleImage.s)
	love.graphics.draw(self.animation[math.floor(self.animation.currentFrame)],self.animation.x,self.animation.y,0,self.animation.s,self.animation.s)
	love.graphics.draw(self.btn.continue.i,self.btn.continue.x,self.btn.continue.y,0,self.btn.continue.s,self.btn.continue.s)
	love.graphics.draw(self.btn.newGame.i,self.btn.newGame.x,self.btn.newGame.y,0,self.btn.newGame.s,self.btn.newGame.s)
end

function MainMenu:mousepressed(mx,my)
	if mx > self.btn.continue.x and mx < self.btn.continue.x + self.btn.continue.w and my > self.btn.continue.y and my < self.btn.continue.y + self.btn.continue.h then
		self.btn.continue.t = self.btn.freq
	end
	if mx > self.btn.newGame.x and mx < self.btn.newGame.x + self.btn.newGame.w and my > self.btn.newGame.y and my < self.btn.newGame.y + self.btn.newGame.h then
		self.btn.newGame.t = self.btn.freq
	end
end
