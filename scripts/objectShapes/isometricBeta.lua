IsometricBeta = Object:extend()--Colliderless, interactable. November 9 2022 : Only effective for smaller spawns of isometricClick objects, for now.

--IsometricBeta:implement(IsometricInteract)--This should be implemented on specific class that needs to be interacted(like atticDoor.lua)
--	Because Isometric.lua can also have those functions but usually those objects don't need it. Just so it could be consistent.

				--..pretty much useless for objects like isometricClick objects with a ratio of a footlong.
				-- Maybe just use circle dumbass.
function IsometricBeta:new(x,y,ll,rl,scale)
--	self.ox = ox or 0			--This offsets are only used on IsometricClick.update() 	November 10 2022
--	self.oy = oy or 0		-- Have not been used yet, but its purpose was to move the interactive area like from CursorHover()
	self.sin = math.sin(0.523599)
	self.cos = math.cos(0.523599)
	self.mr = self.sin/self.cos
	self.ml = self.mr*(-1)
	self.scale = scale or game.scale
	self.ll = (ll or 15)*self.scale
	self.rl = (rl or 15)*self.scale
	self.x = x or 0
	self.y = y or 0
	self.x2 = self.x - self.ll*(self.cos)
	self.y2 = self.y - self.ll*(self.sin)
	self.x3 = self.x + self.rl*(self.cos)
	self.y3 = self.y - self.rl*(self.sin)
	self.x4 = self.x2 + self.rl*(self.cos)
	self.y4 = self.y2 - self.rl*(self.sin)

--Don't know yet, if codes below should be used among object IsometricBeta : November 16 2022
	self.middlell = self.ll/2
	self.middlerl = self.rl/2
	self.x2m = self.x - self.middlell*(self.cos)
	self.y2m = self.y - self.middlell*(self.sin)
	self.xMiddle = self.x2m + self.middlerl*(self.cos)
	self.yMiddle = self.y2m - self.middlerl*(self.sin)
end

function IsometricBeta:update(dt)--Exist to stay consistent with Environment.update(dt) loops
end

function IsometricBeta:draw()
	--just for testing... see interactable shape
	love.graphics.setColor(1,0,0)
	love.graphics.polygon("line",self.x2,self.y2,self.x,self.y,self.x3,self.y3,self.x4,self.y4)
	love.graphics.circle("line", self.xMiddle,self.yMiddle,20*game.scale)
	love.graphics.setColor(255,255,255)
end

