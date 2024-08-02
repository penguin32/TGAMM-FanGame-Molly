Molly = Character:extend()
Molly:implement(HumanColliderFunctions)

function Molly:new()
	Molly.super.new(self,self.base_x,self.base_y,35,"human","molly",0.3)
	self.directory = "sprites/characters/humans/molly/"
	self.footstep_on_wood = love.audio.newSource(self.directory.."sounds/footstep_on_wood.ogg","stream")
	self.footstep_on_wood:setLooping(true)

	-- November 4 2022 : Attempt at collider, Has to manually add values and just
	--			multiplied it with self.scale
	-- Just a reminder that those circles should be an ellipse in isometric view,
	--	but for alpha test, circle it is :)
	-- It may be redundant though since its particularly small radius and would be not
	--	so noticable, maybe...
	--	This is not a professional fighting game like Tekken VIshnu sake! ..bruh,
	--	imagine the hitbox of that thing.
	self.headOffsetX,self.headOffsetY = 0*self.scale,0*self.scale -- notYet		
								-- Offset of those hitboxes
	self.bodyOffsetX,self.bodyOffsetY = 0*self.scale,0*self.scale-- notYet
				 -- Variables directly called on humanColliderFunctions.lua
	self.feetOffsetX,self.feetOffsetY = 0*self.scale,-80*self.scale -- Added
	self.tableOfOffsets = {	self.headOffsetX,self.headOffsetY,
				self.bodyOffsetX,self.bodyOffsetY,
				self.feetOffsetX,self.feetOffsetY}
	self.headr = 60*self.scale				-- Hitbox for	head, radius,
	self.bodyw,self.bodyh = 60*self.scale,60*self.scale	-- body, width&height,
								--  rectangle.
	self.feetr = 100*self.scale				-- feet, radius,
end

function Molly:update(dt)
	Molly.super.update(self,dt,game.middleX,game.middleY,cursor.x,cursor.y)
	if self.setCollider then
		self:Colliders()
	end
	if (self.isMoving == true) then
		self.footstep_on_wood:play()
	else
		self.footstep_on_wood:stop()
	end			-- November 3 2022 > Loop through
		-- Environment.floors()to find specific sfx to play ..it doesn't exists yet.
end

function Molly:draw()
	self:DrawSelfColliders()
	if self.isChangingPlace then
		-- Used by function MoveAt() on character.lua
		-- Leave blank for now.
	else
		self:PosesDraw(self.skin.legs,nil,nil,nil,self.scale)
		self:PosesDraw(self.skin.torso,nil,nil,nil,self.scale)
		self:PosesDraw(self.skin.head,nil,nil,nil,self.scale)
	end

	-- Below to view movement range. dai and damv specifically.
	love.graphics.setColor(0,0,0)
	love.graphics.circle("line",game.middleX,game.middleY,self.base_dai)
	love.graphics.circle("line",game.middleX,game.middleY,self.base_damv)
	love.graphics.setColor(1,1,1)

end
