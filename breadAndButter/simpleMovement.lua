SimpleMovement = Object:extend()

function SimpleMovement:new(base_x,base_y,base_v)
	self.base_x = base_x or 0	--it dictates actual position of the character
	self.base_y = base_y or 0
	self.base_v = base_v or 35  ---game.scale doesnt have to be multiplied by 'forZoomIn'
					--variable, this one is an exception because the 
					-- if statement with base_da and cfd is affected along,
					-- by multiplying it with forZoomIn variable and by doing that removes game.scale*forZoomIn/forZoomIn, forZoomIn gets cancelled thus maintaining its ratio even after getting zoomIn
	self.base_dai = (630)*(game.scale)	--Idle area.
	self.base_cfd = 0		--Use for mouse cursor to game.middleX,game.middleY distance.(forPlayer)
	self.base_damv = (710)*(game.scale)	--Max distance allowed to limit character's velocity.
	self.base_cos, self.base_sin = 0--Use to calculate for radians to vector of mouse cursor to game.middleX,game.middleY(forPlayer)
	self.base_da = self.base_damv*1.2--Max acceleration for a given distance.
end

function SimpleMovement:update(dt,animal_x,animal_y,food_x,food_y)
	self.base_cfd = Direction.GetDistance(animal_x,animal_y,food_x,food_y)*forZoomingIn
	self.base_cos,self.base_sin = Direction.GetVector(animal_x,animal_y,food_x,food_y)
	if self.base_cfd > self.base_dai and self.base_cfd < self.base_damv then
		self.base_x = self.base_x + self.base_v*self.base_cos*(self.base_cfd/50)*dt
		self.base_y = self.base_y + self.base_v*self.base_sin*(self.base_cfd/50)*dt
	elseif self.base_cfd >= self.base_damv then
		self.base_x = self.base_x + self.base_v*self.base_cos*(self.base_da/50)*dt
		self.base_y = self.base_y + self.base_v*self.base_sin*(self.base_da/50)*dt
	end
end
