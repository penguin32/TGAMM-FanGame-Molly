HumanColliderFunctions = Object:extend()

function HumanColliderFunctions:Colliders()--testing phase November 4 2022
	local totalObj = #Environment.objects
	if totalObj > 0 then
		for i, v in ipairs(Environment.objects) do
			if v:is(Circle) then
				self:CollideFeetToCircle(v)
			end
			if v:is(Rectangle) then
				self:CollideFeetToRectangle(v)
			end
			if v:is(Isometric) then
				self:CollideFeetToIsometric(v)
			end
--			if v:is(ExplorableArea) then
--				self:CollideFeetToExplorableArea(v)
--			end
		end
	end
end

-- Let's see the colliders of the characters
function HumanColliderFunctions:DrawSelfColliders()
	love.graphics.setColor(0,255,0)
	love.graphics.circle("line", self.x+self.feetOffsetX, self.y+self.feetOffsetY,self.feetr)
	love.graphics.setColor(255,255,255)
end


--[[Functions below are for stationary objects]]--
--
--unsure if it would work for a moving objects :D
--	That's because certain functions that does more tasks, their "if's condition doesn't
--	run on real time, when called by another variable "local" within,
--	instead of calling them directly I presume... If I'm planning so, and it didn't work
--	as expected, tweaking local variables to access
--	variables directly called instead, could fix that future problem... but how?
--	-November 5 2022
function HumanColliderFunctions:CollideFeetToCircle(obj)
	local distSelfToObj = Direction.GetDistance(self.x+self.feetOffsetX, self.y+self.feetOffsetY, obj.x, obj.y)
	if self.feetr + obj.r > distSelfToObj then
		local sumRadians = obj.r + self.feetr
		local cos,sin = Direction.GetVector(self.x+self.feetOffsetX, self.y+self.feetOffsetY, obj.x, obj.y)
		self.x = obj.x - cos*sumRadians - self.feetOffsetX
		self.y = obj.y - sin*sumRadians - self.feetOffsetY
	end
end						    -- End of CollideFeetToCircle

function HumanColliderFunctions:CollideFeetToRectangle(obj)
	local leftObj = obj.x
	local rightObj = obj.x + obj.w
						    -- local topObj = obj.y
						    -- local botObj = obj.y + obj.h
	local topObj = obj.y + obj.h
	local botObj = obj.y
	local middley = obj.y + obj.h/2
	local middlex = obj.x + obj.w/2
	local cos,sin
	local cornerDist = self.feetr
	local quadrantx
	local quadranty
	if self.y + self.feetOffsetY <= middley then
		quadranty = topObj
		if self.x + self.feetOffsetX >= middlex then
			cos,sin = Direction.GetVector(self.x + self.feetOffsetX, self.y + self.feetOffsetY, rightObj, topObj)
			cornerDist = Direction.GetDistance(self.x + self.feetOffsetX, self.y + self.feetOffsetY, rightObj, topObj)
			quadrantx = rightObj
		elseif self.x + self.feetOffsetX < middlex then
			cos,sin = Direction.GetVector(self.x + self.feetOffsetX, self.y + self.feetOffsetY, leftObj, topObj)
			cornerDist = Direction.GetDistance(self.x + self.feetOffsetX, self.y + self.feetOffsetY, leftObj, topObj)
			quadrantx = leftObj
		end
	elseif self.y + self.feetOffsetY > middley then
		quadranty = botObj
		if self.x + self.feetOffsetX >= middlex then
			cos,sin = Direction.GetVector(self.x + self.feetOffsetX, self.y + self.feetOffsetY, rightObj, botObj)
			cornerDist = Direction.GetDistance(self.x + self.feetOffsetX, self.y + self.feetOffsetY, rightObj, botObj)
			quadrantx = rightObj
		elseif self.x + self.feetOffsetX < middlex then
			cos,sin = Direction.GetVector(self.x + self.feetOffsetX, self.y + self.feetOffsetY, leftObj, botObj)
			cornerDist = Direction.GetDistance(self.x + self.feetOffsetX, self.y + self.feetOffsetY, leftObj, botObj)
			quadrantx = leftObj
		end
	end
	if self.y + self.feetOffsetY > topObj and self.y + self.feetOffsetY < botObj then
		if self.x + self.feetOffsetX + self.feetr > leftObj and self.x + self.feetOffsetX < middlex then
			self.x = leftObj - self.feetr - self.feetOffsetX
		elseif self.x + self.feetOffsetX - self.feetr < rightObj and self.x > middlex then
			self.x = rightObj + self.feetr - self.feetOffsetX
		end
	elseif self.x + self.feetOffsetX > leftObj and self.x + self.feetOffsetX < rightObj then
		if self.y + self.feetOffsetY + self.feetr > topObj and self.y + self.feetOffsetY < middley then
			self.y = topObj - self.feetr - self.feetOffsetY
		elseif self.y + self.feetOffsetY - self.feetr < botObj and self.y > middley then
			self.y = botObj + self.feetr - self.feetOffsetY
		end
	elseif cornerDist < self.feetr then
		self.x = quadrantx - cos*self.feetr - self.feetOffsetX
		self.y = quadranty - sin*self.feetr - self.feetOffsetY
	end
end						    -- End of CollideFeetToRectangle

function HumanColliderFunctions:CollideFeetToIsometric(obj)
	local yt = self.y + self.feetOffsetY - self.feetr*math.sin(1.0472) -- Short for y-top.
	local yb = self.y + self.feetOffsetY + self.feetr*math.sin(1.0472) -- ..yt,yb similar
						    -- to xr&xl but it describes the ordinate.
	local xr = self.x + self.feetOffsetX + self.feetr*math.cos(1.0472) -- Top right side
						    -- but 45angle,x-coordinate, treating
						    -- circle(your character feetr hitbox)
						    -- as an isometric square.
	local xl = self.x + self.feetOffsetX - self.feetr*math.cos(1.0472) -- Again just, top
						    -- left side of circle (abscissa) in
						    -- 45 angle.
	if xr > obj.x2 and yb > obj.y4 and xl < obj.x3 and yt < obj.y then --Treating
						    -- isometric obj like a box first
		local bls = obj.y - obj.ml*(xr - obj.x)  --bottom left side of the object
		local brs = obj.y - obj.mr*(xl - obj.x)
		local tls = obj.y2 - obj.mr*(xr - obj.x2)
		local trs = obj.y3 - obj.ml*(xl - obj.x3)
		local blsx = obj.x - ((yt - obj.y)/obj.ml)
		local brsx = obj.x - ((yt - obj.y)/obj.mr)
		local tlsx = obj.x2 - ((yb - obj.y2)/obj.mr)
		local trsx = obj.x3 - ((yb - obj.y3)/obj.ml)
		local opp = self.feetr*math.sin(1.0472) -- opposite side of circle from the
						    -- center
		local adj = self.feetr*math.cos(1.0472)
		if (self.y + self.feetOffsetY > tls and self.y + self.feetOffsetY < brs and self.x + self.feetOffsetX < blsx + obj.rl/2) and (yt < bls) and (xr > blsx) then -- bottom left
						    -- side of an object
			self.y = bls + opp - self.feetOffsetY
			self.x = blsx - adj - self.feetOffsetX
		elseif (self.y + self.feetOffsetY < bls and self.y + self.feetOffsetY > trs and self.x + self.feetOffsetX > brsx - obj.ll/2) and (yt < brs) and (xl < brsx) then--bottom right of an object
			self.y = brs + opp - self.feetOffsetY
			self.x = brsx + adj - self.feetOffsetX
		elseif (self.y + self.feetOffsetY < bls and self.y + self.feetOffsetY > trs and self.x + self.feetOffsetX < tlsx + obj.ll/2) and (yb > tls) and (xr > tlsx) then--top left of an object
			self.y = tls - opp - self.feetOffsetY
			self.x = tlsx - adj - self.feetOffsetX
		elseif (self.y + self.feetOffsetY > tls and self.y + self.feetOffsetY < brs and self.x + self.feetOffsetX > trsx - obj.rl/2) and (yb > trs) and (xl < trsx) then--top right of an object
			self.y = trs - opp - self.feetOffsetY
			self.x = trsx + adj - self.feetOffsetX
		end
	end
	local p1 = Direction.GetDistance(self.x + self.feetOffsetX, self.y + self.feetOffsetY, obj.x, obj.y)
	local p2 = Direction.GetDistance(self.x + self.feetOffsetX, self.y + self.feetOffsetY, obj.x2, obj.y2)
	local p3 = Direction.GetDistance(self.x + self.feetOffsetX, self.y + self.feetOffsetY, obj.x3, obj.y3)
	local p4 = Direction.GetDistance(self.x + self.feetOffsetX, self.y + self.feetOffsetY, obj.x4, obj.y4)
	local cos, sin = 0, 0
	if p1 < self.feetr then
		cos,sin = Direction.GetVector(self.x + self.feetOffsetX, self.y + self.feetOffsetY, obj.x, obj.y)
		self.x = obj.x - cos*self.feetr - self.feetOffsetX
		self.y = obj.y - sin*self.feetr - self.feetOffsetY
	elseif p2 < self.feetr then
		cos,sin = Direction.GetVector(self.x + self.feetOffsetX, self.y + self.feetOffsetY, obj.x2, obj.y2)
		self.x = obj.x2 - cos*self.feetr - self.feetOffsetX
		self.y = obj.y2 - sin*self.feetr - self.feetOffsetY
	elseif p3 < self.feetr then
		cos,sin = Direction.GetVector(self.x + self.feetOffsetX, self.y + self.feetOffsetY, obj.x3, obj.y3)
		self.x = obj.x3 - cos*self.feetr - self.feetOffsetX
		self.y = obj.y3 - sin*self.feetr - self.feetOffsetY
	elseif p4 < self.feetr then
		cos,sin = Direction.GetVector(self.x + self.feetOffsetX, self.y + self.feetOffsetY, obj.x4, obj.y4)
		self.x = obj.x4 - cos*self.feetr - self.feetOffsetX
		self.y = obj.y4 - sin*self.feetr - self.feetOffsetY
	end
end						    --end of CollideFeetToIsometric


--- November 9 2022 : Rely on 4 isometric colliders for now.   __HAS undefine!  runtime error went unnoticed cannot divide by zero, slope problem
--								y1-y/x1-x = m, seems to be not possible, just use 4 isometric objectShapes
--								NEVER FUCKING MIND, it was the cursor position is somewhat unfixed,
--								not the same accrooss files like this file.  ;_;
--
--function HumanColliderFunctions:CollideFeetToExplorableArea(obj)
	-- y-y1 = m(x-x1)						y-y1 = m(x-x1)
	-- self.y - obj.y = obj.m(self.x-obj.x)				(y-y1)/m = x-x1
	-- self.y = obj.m*(self.x-obj.x) + obj.y			(y-y1)/m + x1 = x
	-- y = m(x-x1) + y1					(self.y - obj.y)/obj.m + obj.x = self.x
--[[	if (self.y+self.feetOffsetY+self.feetr) < (obj.ml*(self.x-obj.x)-obj.y) then
		self.y = (obj.ml*(self.x-obj.x) - obj.y) - self.base_sin*self.feetr - self.feetOffsetY
	--	self.x = ((self.y-obj.y)/obj.ml + obj.x) - self.base_cos*self.feetr - self.feetOffsetX
	end
	if (self.y+self.feetOffsetY+self.feetr) < (obj.mr*(self.x-obj.x)-obj.y) then
		self.y = (obj.mr*(self.x-obj.x) - obj.y) - self.base_sin*self.feetr - self.feetOffsetY
	--	self.x = ((self.y-obj.y)/obj.mr + obj.x) - self.base_cos*self.feetr - self.feetOffsetX
	end
	if (self.y+self.feetOffsetY+self.feetr) > (math.sin(3.66519)*(self.x-obj.x4)-obj.y4) then
		self.y = (math.sin(3.66519)*(self.x-obj.x4) - obj.y4) - self.base_sin*self.feetr - self.feetOffsetY
	--	self.x = ((self.y-obj.y2)/obj.mr + obj.x2) - self.base_cos*self.feetr - self.feetOffsetX
	end
	if (self.y+self.feetOffsetY+self.feetr) > (-math.sin(3.66519)*(self.x-obj.x4)-obj.y4) then
		self.y = (-math.sin(3.66519)*(self.x-obj.x4) - obj.y4) - self.base_sin*self.feetr - self.feetOffsetY
	--	self.x = ((self.y-obj.y3)/obj.ml + obj.x3) - self.base_cos*self.feetr - self.feetOffsetX
	end
	]]--
	
--[[
	local yt = self.y + self.feetOffsetY - self.feetr*math.sin(1.0472)  --Short for y-top.
	local yb = self.y + self.feetOffsetY + self.feetr*math.sin(1.0472)  --..yt,yb similar to xr&xl but it describes the ordinate.
	local xr = self.x + self.feetOffsetX + self.feetr*math.cos(1.0472)  --Top right side but 45angle,x-coordinate, treating circle(your character feetr hitbox) as an isometric square.
	local xl = self.x + self.feetOffsetX - self.feetr*math.cos(1.0472)  --Again just, top left side of circle (abscissa) in 45 angle.
	if xr > obj.x2 and yb > obj.y4 and xl < obj.x3 and yt < obj.y then  --Treating isometric obj like a box first
		local bls = obj.y - obj.ml*(xr - obj.x)  --bottom left side of the object
		local brs = obj.y - obj.mr*(xl - obj.x)
		local tls = obj.y2 - obj.mr*(xr - obj.x2)
		local trs = obj.y3 - obj.ml*(xl - obj.x3)
		local blsx = obj.x - ((yt - obj.y)/obj.ml)
		local brsx = obj.x - ((yt - obj.y)/obj.mr)
		local tlsx = obj.x2 - ((yb - obj.y2)/obj.mr)
		local trsx = obj.x3 - ((yb - obj.y3)/obj.ml)
		local opp = self.feetr*math.sin(1.0472) --opposite side of circle from the center
		local adj = self.feetr*math.cos(1.0472)
		if (self.y + self.feetOffsetY > tls and self.y + self.feetOffsetY < brs and self.x + self.feetOffsetX < blsx + obj.rl/2) and (yt < bls) and (xr > blsx) then--bottom left side of an object
			self.y = bls + opp - self.feetOffsetY
			self.x = blsx - adj - self.feetOffsetX
		elseif (self.y + self.feetOffsetY < bls and self.y + self.feetOffsetY > trs and self.x + self.feetOffsetX > brsx - obj.ll/2) and (yt < brs) and (xl < brsx) then--bottom right of an object
			self.y = brs + opp - self.feetOffsetY
			self.x = brsx + adj - self.feetOffsetX
		elseif (self.y + self.feetOffsetY < bls and self.y + self.feetOffsetY > trs and self.x + self.feetOffsetX < tlsx + obj.ll/2) and (yb > tls) and (xr > tlsx) then--top left of an object
			self.y = tls - opp - self.feetOffsetY
			self.x = tlsx - adj - self.feetOffsetX
		elseif (self.y + self.feetOffsetY > tls and self.y + self.feetOffsetY < brs and self.x + self.feetOffsetX > trsx - obj.rl/2) and (yb > trs) and (xl < trsx) then--top right of an object
			self.y = trs - opp - self.feetOffsetY
			self.x = trsx + adj - self.feetOffsetX
		end
	end
	local p1 = Direction.GetDistance(self.x + self.feetOffsetX, self.y + self.feetOffsetY, obj.x, obj.y)
	local p2 = Direction.GetDistance(self.x + self.feetOffsetX, self.y + self.feetOffsetY, obj.x2, obj.y2)
	local p3 = Direction.GetDistance(self.x + self.feetOffsetX, self.y + self.feetOffsetY, obj.x3, obj.y3)
	local p4 = Direction.GetDistance(self.x + self.feetOffsetX, self.y + self.feetOffsetY, obj.x4, obj.y4)
	local cos, sin = 0, 0
	if p1 < self.feetr then
		cos,sin = Direction.GetVector(self.x + self.feetOffsetX, self.y + self.feetOffsetY, obj.x, obj.y)
		self.x = obj.x - cos*self.feetr - self.feetOffsetX
		self.y = obj.y - sin*self.feetr - self.feetOffsetY
	elseif p2 < self.feetr then
		cos,sin = Direction.GetVector(self.x + self.feetOffsetX, self.y + self.feetOffsetY, obj.x2, obj.y2)
		self.x = obj.x2 - cos*self.feetr - self.feetOffsetX
		self.y = obj.y2 - sin*self.feetr - self.feetOffsetY
	elseif p3 < self.feetr then
		cos,sin = Direction.GetVector(self.x + self.feetOffsetX, self.y + self.feetOffsetY, obj.x3, obj.y3)
		self.x = obj.x3 - cos*self.feetr - self.feetOffsetX
		self.y = obj.y3 - sin*self.feetr - self.feetOffsetY
	elseif p4 < self.feetr then
		cos,sin = Direction.GetVector(self.x + self.feetOffsetX, self.y + self.feetOffsetY, obj.x4, obj.y4)
		self.x = obj.x4 - cos*self.feetr - self.feetOffsetX
		self.y = obj.y4 - sin*self.feetr - self.feetOffsetY
	end
end
]]--
