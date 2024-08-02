Direction = {}
		   -- Attributes used for characterSprite.lua : CharacterSprite:draw()
Direction.east = 0 -- Not used by lua files on breadAndButter Directory, just added so that
		   -- they're all completed, but may be used on other stuff as well :)
		   -- I don't know yet... November 14 2022 see character.lua
Direction.west = math.pi
Direction.south_west = 3/4*math.pi
Direction.south = math.pi/2
Direction.south_east = math.pi/4
Direction.north_west = -Direction.south_west
Direction.north = -Direction.south
Direction.north_east = -Direction.south_east
Direction.deg15 = 0.261799 					   -- Just an offset for east
Direction.deg15Neg = -Direction.deg15
Direction.adjustedWestNegative = -Direction.west + Direction.deg15 -- Just an offset for west
Direction.adjustedWestPositive = -Direction.adjustedWestNegative

function Direction.GetRadian(animal_x,animal_y,food_x,food_y)
	return math.atan2(food_y - animal_y, food_x - animal_x)
end

function Direction.GetVector(animal_x,animal_y,food_x,food_y)
	local radian = math.atan2(food_y - animal_y, food_x - animal_x)
	return math.cos(radian),math.sin(radian)
end

function Direction.GetDistance(animal_x,animal_y,food_x,food_y)
	local horizontal_difference = animal_x - food_x
	local vertical_difference = animal_y - food_y
	horizontal_difference = horizontal_difference^2
	vertical_difference = vertical_difference^2
	return math.sqrt(horizontal_difference + vertical_difference)
end

function Direction.DiscreteString(radian) -- Returns direction in discrete value(string type)
					  -- Useful for any cursor.x,cursor.y kinda like.
					  -- Indeed I could simplify this but,
  -- I need this function because,its readable and when drawing sprites, I don't have to 
  -- write == to some radian to get a conditional statement, all I had to tell is which
  -- direction it faces(in String)
	if radian > Direction.north_west and radian < Direction.north then
		return "North slightly west"
	elseif radian >= Direction.north and radian < Direction.north_east then
		return "North slightly east"
	elseif radian >= Direction.adjustedWestNegative and radian <= Direction.north_west then
		return "North west"
	elseif radian < Direction.adjustedWestNegative or radian > Direction.adjustedWestPositive then
		return "West"
	elseif radian < Direction.adjustedWestPositive and radian >= Direction.south_west then
		return "South west"
	elseif radian < Direction.south_west and radian > Direction.south then
		return "South slightly west"
	elseif radian <= Direction.south and radian > Direction.south_east then
		return "South slightly east"
	elseif radian <= Direction.south_east and radian >= Direction.deg15 then
		return "South east"
	elseif radian >= Direction.north_east and radian <= Direction.deg15Neg then
		return "North east"
	elseif radian < Direction.deg15 or radian > Direction.deg15Neg then
		return "East"
	end
end

function Direction.DiscreteNumber(radian) -- Returns direction in discrete
					  -- value(number type, a vector)
	local string = Direction.DiscreteString(radian)
	if string == "North slightly west" then
		return Direction.north
	elseif string == "North slightly east" then
		return Direction.north
	elseif string == "North west" then
		return Direction.north_west
	elseif string == "West" then
		return Direction.west
	elseif string == "South west" then
		return Direction.south_west
	elseif string == "South slightly west" then
		return Direction.south
	elseif string == "South slightly east" then
		return Direction.south
	elseif string == "South east" then
		return Direction.south_east
	elseif string == "North east" then
		return Direction.north_east
	elseif string == "East" then
		return Direction.east
	end
end
