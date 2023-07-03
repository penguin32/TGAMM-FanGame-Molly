Direction = {}
--Attributes used for characterSprite.lua : CharacterSprite:draw()
Direction.east = 0--not used by lua files on breadAndButter Directory, just added so that they're all completed, but may be used on other stuff as well :)
		--I don't know yet... November 14 2022 see character.lua
Direction.west = math.pi
Direction.south_west = 3/4*math.pi
Direction.south = math.pi/2
Direction.south_east = math.pi/4
Direction.north_west = -Direction.south_west
Direction.north = -Direction.south
Direction.north_east = -Direction.south_east
Direction.deg15 = 0.261799 --just an offset for east
Direction.deg15Neg = -Direction.deg15
Direction.adjustedWestNegative = -Direction.west + Direction.deg15 --just an offset for west
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
