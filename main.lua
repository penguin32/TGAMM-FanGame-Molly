function love.load()
	forZoomingIn = 2.5	--Is used for attributes of in game objects' like scaling & distances.
				--multiplied beside game.scale,
				--    because game.scale take care of the in game objects if the viewport is small,
				--    multiplying forZoomingIn beside it, takes care which objects we want to scale.
				--    and dividing game.scale with it, follows the scaling of the viewport,
				--      which cancels that "Zooming" effect and only
				--      follows viewport's scaling
	window = { width = love.graphics.getWidth(), height = love.graphics.getHeight() }
	game = { width = 2048, height = 1427, cartX = 0, cartY = 0, }
	game.scale = getScale(window.width,window.height)	     --Is for configuring ratios of in game objects 
	                        --dependent of the viewport's resolution.
				--Used to compensate with the devices(Android)'s screen resolution,
				--pc window/viewport's resolution.
	game.cartX,game.cartY = cartScale(game.cartX,game.cartY)     --Is used to tell where is the 
	                        --coordinate(0,0) should be,regardless of the viewport's width & height ratio.
	game.middleX = game.cartX + game.width*(game.scale/forZoomingIn)/2
	game.middleY = game.cartY + game.height*(game.scale/forZoomingIn)/2     --Is used to tell where is the 
	                        --middle coordinate of the viewport, regardless of the 
				--screen/window's width & height ratio.

--[[
                 game.Scale is use for attributes inside game.push() under Environment:draw() 
		 in file named environment.lua, and for evilCursorX/Y in file named player.lua.
    
		 My Past problem talks about (2023)Player.GetDistanceOfPointOnOnScreenWithRespectToPlayerBasePos(),                  but seems to be not a problem this time for I have fixed the general functionality 
		 without having thought of that this time this August 1 2024, if problem arised
		 I should review that function, but for now everything is working as intended
]]--

	cursor = { x = 0, y = 0 }	--"Mouse Point tool like" for the game.
	cursor.x,cursor.y = game.middleX,game.middleY
	font = love.graphics.newFont(34*(game.scale/forZoomingIn))
	love.mouse.setPosition(game.middleX,game.middleY)
--	love.mouse.setRelativeMode(true)--Hides mouse cursor and lock mouse inside game,
					--not sure if I want to make an in game mouse.
	Object = require "modules.classic.classic"
	require "modules.modulesOutsideLove2d.strict"
	require "scripts.objectShapes.isometricInteract"
	require "scripts.objectShapes.isometric"
	require "scripts.objectShapes.isometricBeta"
	require "scripts.places.typesOfObjects.flooredIsometricObject"
	require "scripts.objectShapes.rectangle"
	require "scripts.objectShapes.circle"
	require "scripts.cardboardbox"		--Just for testing "drawing order",
						--the hardest part for now, atleast for me :(  -2023 me
	require "scripts.characters.humans.humanColliderFunctions"
	require "scripts.mainMenu"
	require "breadAndButter.direction"
	require "breadAndButter.simpleMovement"
	require "breadAndButter.loadSprite"
	require "breadAndButter.characterSprite"
	require "scripts.characters.character"
	require "scripts.characters.humans.molly"
	require "scripts.places.explorableArea"
	require "breadAndButter.environment"
	require "breadAndButter.player"


--[[
		Level's objects scripts below.
		         Should I be worried about loading all of them at once,
			 or should they be load per each level/room required.
]]--
    --@Environment.Level = 1 
	require "scripts.places.mollyRoom.mollyRoom"
	require "scripts.places.mollyRoom.atticDoor"
	require "scripts.places.mcGeeKitchen.mcGeeKitchen"

	Environment.load(0)
end

function love.update(dt)
 local useTouchUpdateUI = Environment.touchUpdateUI--I'm not sure if I need this touchUpdateUI file :P
                                                        --ofcourse you need that, touchupdate tells if you're on Android or Desktop.
        if useTouchUpdateUI == true then
                TouchUpdateUI()
        end



	Environment.update(dt)
	if Player.SelectedCharacter ~= nil then	
		local onAndroid = Environment.usingAndroid
		local isChangingPlace = Player.isChangingPlace
		if onAndroid == true then
			Joystick:update()
			JoystickR:update()
		--November 14 2022, Eureka! To fix that cursor.x,cursor.y not settling at the middle, disable a code that also set a value at cursor.x/y
		else
			if Player.SelectedCharacter.isChangingPlace then
				--Disables player controls temporarily
				--Also added on those characters scripts like molly.lua to hide the sprites when changing places.
				--	but use self.isChangingPlace, so that only that specific object under control by the Player is hidden, while the
				--	rest of the spawn characters in the future are shown.
			elseif love.mouse.isDown(1) then
				cursor.x, cursor.y = love.mouse.getPosition()
			else
				cursor.x, cursor.y = game.middleX, game.middleY
			end
		end
	end
end

function love.draw()
	love.graphics.setFont(font)
	Environment.draw()
	love.graphics.setBackgroundColor(255,255,255)
	love.graphics.setColor(0,0,0)

	love.graphics.rectangle("fill",game.middleX,game.middleY,10,10) -- tells where is game.middleX and middleY
	love.graphics.rectangle("fill",game.cartX,game.cartY,10,10) -- tells where is game.cartX and cartY

	love.graphics.rectangle("fill",0,0,game.cartX,window.width)
	love.graphics.rectangle("fill",game.cartX+game.width*(game.scale/forZoomingIn),0,game.cartX,window.width)--This part is fucked on android/because of button tabs
	love.graphics.rectangle("fill",0,0,window.width,game.cartY)
	love.graphics.rectangle("fill",0,game.cartY+game.height*(game.scale/forZoomingIn),game.width,game.cartY)
	love.graphics.setColor(1,1,1)
	local onAndroid = Environment.usingAndroid
	if onAndroid == true then
		Joystick:draw()
		JoystickR:draw()
	end
end

function getScale(w,h)
	local sx,sy = w*forZoomingIn/game.width, h*forZoomingIn/game.height
	if sx <= sy then return sx else return sy end
end

function cartScale(x,y)
	local sx,sy = window.width/game.width, window.height/game.height
	if sx < sy then return x,y+(window.height - game.height*(game.scale/forZoomingIn))/2 else return x+(window.width - game.width*(game.scale/forZoomingIn))/2,y end
end
