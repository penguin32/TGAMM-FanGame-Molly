Character = CharacterSprite:extend()
--To tell if the object is a character. Yes, CharacterSprite is not exclusive to character's only, sorry for bad coding skills. :P
--Used for Environment.SortObjects(a,b)
--Why? My current temporary solution for now (November 7 2022) for dealing with characters drawing order,
--	kinda worried about how I might deal with larger character like a beast monsters...
--	Maybe "Character" ---generally used for simple characters, but for anything else, I may have to make another class that act like this one.
--				HEll NAH! Or I could just separate them in individual pieces.
--function Character:new(base_x,base_y,base_v,type_of_sprite,selected_sprite,scale)
--	Character.super.new(self,base_x,base_y,base_v,type_of_sprite,selected_sprite,scale)
--end

function Character:new(base_x,base_y,base_v,type_of_sprite,selected_sprite,scale)
	Character.super.new(self,base_x,base_y,base_v,type_of_sprite,selected_sprite,scale)

	self.isChangingPlace = false
	self.setCollider = true
	---I'm experimenting for changing character position with a panning a camera-like thing... :D
					--while they're also invisible, automatically, like changing levels
	self.current_velocity = self.base_v
	self.temporary_velocity = 80
end

function Character:update(dt,animal_x,animal_y,food_x,food_y)
	Character.super.update(self,dt,animal_x,animal_y,food_x,food_y)
end
--[[
function Character:MoveAt(dt,timer,direction)
--November 15 2022 FUCKK YEAH it WOOORKs! Continue at gaming scaling(Zooming out) during moving that character at different place!

	--automate moving while making manual moving unable. atX,atY just means the last position of that base_x/y before leaving
	if timer > 0 then
		self.isChangingPlace = true
		self.setCollider = false
		self.base_v = self.temporary_velocity
	cursor.x,cursor.y = game.middleX+Joystick.biggerCircle.r*Joystick.jscale*math.cos(direction),game.middleY+Joystick.biggerCircle.r*Joystick.jscale*math.sin(direction)
	else
		self.isChangingPlace = false
		self.setCollider = true
		self.base_v = self.current_velocity
		Player.Keyboard.z = false					--Player.Keyboard
	end
end
]]--

