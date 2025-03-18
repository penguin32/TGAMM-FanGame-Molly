function love.load()
	showOutlines = true	--Show shape outlines, colliders, interact and text attributes.
				-- Environment.level(-1) will have a problem for shapes not
				-- being visible, be mindful of that.
	forZoomingIn = 2	--Is used for attributes of in game objects' like scaling
				--& distances.
				--multiplied beside game.scale,
				--    because game.scale take care of the in game objects if
				--    the viewport is small,
				--    multiplying forZoomingIn beside it, takes care which
				--    objects we want to scale.
				--    and dividing game.scale with it, follows the scaling of
				--    the viewport,
				--      which cancels that "Zooming" effect and only
				--      follows viewport's scaling
	window = { width = love.graphics.getWidth(), height = love.graphics.getHeight() }
	game = { width = 2048, height = 1427, cartX = 0, cartY = 0, }
	game.scale = getScale(window.width,window.height)     --Is for configuring
				--ratios of in game objects 
	                        --dependent of the viewport's resolution.
				--Used to compensate with the devices(Android)'s screen
				--resolution, pc window/viewport's resolution.
	game.cartX,game.cartY = cartScale(game.cartX,game.cartY)     --Is used to tell where is
				--the coordinate(0,0) should be,regardless of the viewport's
				--width & height ratio.
	game.middleX = game.cartX + game.width*(game.scale/forZoomingIn)/2
	game.middleY = game.cartY + game.height*(game.scale/forZoomingIn)/2     --Is used to
				--tell where is the middle coordinate of the viewport,
				--regardless of the screen/window's width & height ratio.

--[[
                 game.Scale is use for attributes inside game.push() under Environment:draw() 
		 in file named environment.lua, and for evilCursorX/Y in file named player.lua.
    
		 My Past problem talks about 
		 (2023)Player.GetDistanceOfPointOnOnScreenWithRespectToPlayerBasePos(),
		 but seems to be not a problem this time for I have fixed the general
		 functionality without having thought of that this time this August 1 2024,
		 if problem arised
		 I should review that function, but for now everything is working as intended
]]--

	cursor = { x = 0, y = 0, visible = true }	--"Mouse Point tool like" for the game.
	cursor.x,cursor.y = game.middleX,game.middleY
	font = love.graphics.newFont(34*(game.scale/forZoomingIn))
	love.mouse.setPosition(game.middleX,game.middleY)
--	love.mouse.setRelativeMode(true)--Hides mouse cursor and lock mouse inside window,
					--not sure if I want to make an in game mouse.
	Object = require "modules.classic.classic"
	require "modules.modulesOutsideLove2d.strict"
	require "scripts.objectShapes.isometricInteract"
	require "scripts.objectShapes.isometric"
	require "scripts.objectShapes.isometricBeta"
	require "scripts.places.typesOfObjects.flooredIsometricObject"
	require "scripts.objectShapes.rectangle"
	require "scripts.objectShapes.circle"
	require "scripts.forTesting.cardboardbox" --for testing draw order and its opaqueness
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
        if Environment.touchUpdateUI == true then  --It tells love.mousepressed(mx,my)
					  --   to use Touches table(forAndroid) 
					  --   ...mousepressed(t[1],1[2])...
                TouchUpdateUI()  -- Function found in player.lua, that holds global functions
        end --This is redundant,
	    --	because love.mousepressed(mx,my) also accepts mobile touches as well,
	    --  but I included this to make sure to use touches={x,y} for when ran in android
	    --  too, just incase love.mousepressed doesn't work anymore on android.



	Environment.update(dt)
	if Player.SelectedCharacter ~= nil then	
		local onAndroid = Environment.usingAndroid
		local isChangingPlace = Player.isChangingPlace
		if onAndroid == true then
			Joystick:update()           -- Player's Controls
			JoystickR:update()
		else
			if Player.SelectedCharacter.isChangingPlace then


				--This particular "If statements" Disables player controls
				--temporarily
				--    No need to mention this but for context, to add that,
				--    somewhere in the files,
				--     also added on those characters scripts like molly.lua
				--     to hide the sprites when changing places.
				--     but use self.isChangingPlace, so that only that
				--     specific object under control by the Player is
				--     hidden(attic.lua file aka MoveAt())
				--      player.isChangingPlace,
				--           who is changing place
				--     , while the rest of the spawned characters
				--     in the future are shown.

				-- Summary: This is the time when player doesn't have control.


			elseif love.mouse.isDown(1) then
				--  Then back to Player's Controls
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

	if showOutlines == true then
		love.graphics.setColor(0.5,0,0)
		love.graphics.rectangle("fill",game.middleX,game.middleY,10,10)
	-- tells where is game.middleX and middleY
		love.graphics.rectangle("fill",game.cartX,game.cartY,10,10)
	-- tells where is game.cartX and cartY
		love.graphics.setColor(0,0,0)
	end

		-- Four rectangles below acts as borders.
	love.graphics.rectangle("fill",0,0,game.cartX,window.width)
	love.graphics.rectangle("fill",game.cartX+game.width*(game.scale/forZoomingIn),0,game.cartX,window.width)
	love.graphics.rectangle("fill",0,0,window.width,game.cartY)
	love.graphics.rectangle("fill",0,game.cartY+game.height*(game.scale/forZoomingIn),game.width,game.cartY)

	love.graphics.setColor(1,1,1)

	if Environment.usingAndroid == true then
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
