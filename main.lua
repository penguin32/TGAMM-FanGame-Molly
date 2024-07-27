function love.load()
forZoomingIn = 3

--	love.window.setFullscreen(true,"exclusive")
--	love.window.setFullscreen(true,"desktop")
	window = { width = love.graphics.getWidth(), height = love.graphics.getHeight() }
--	window = { width = 411, height = 844 }--A n d r o i d  , beep boop  --- Twas portrait,
--	window = { width = 844, height = 411 }--A n d r o i d  , beep boop, didn't work... damn screen not working as I told.

	game = { width = 2048, height = 1427, cartX = 0, cartY = 0, }--Game table is used through all out lua files,
	game.scale = getScale(window.width,window.height)	     --for configuring sizes ratio... used to compensate with the devicee screen ratio.
	game.cartX,game.cartY = cartScale(game.cartX,game.cartY)     --Hope it doesn't come to that... maybe grep could help.
	game.middleX = game.cartX + game.width*(game.scale/forZoomingIn)/2
	game.middleY = game.cartY + game.height*(game.scale/forZoomingIn)/2

--Attributes for game.scale() inside game.push() on Environment:draw() in environment.lua, and for evilCursorX/Y on player.lua
--	specifically I'm talking about this lol Player.GetDistanceOfPointOnScreenWithRespectToPlayerBasePos()
-- It's too late for me to go back, unless I'm not alone for this problem :(
--[End]Attributes for game.scale() inside game.push() on environment.lua, and for evilCursorX/Y on player.lua


	cursor = { x = 0, y = 0 }
	cursor.x,cursor.y = game.middleX,game.middleY
--	love.window.setMode(window.width,window.height,{resizable=false,borderless=true}) --Beware of the ordering of this line of codees lmfao,
--											  --It messes with the mouse cursor initial position.
--										--I'm just trying to solve that Android screen issue.
	font = love.graphics.newFont(34*(game.scale/forZoomingIn))
	love.mouse.setPosition(game.middleX,game.middleY)
--	love.mouse.setRelativeMode(true)--hides mouse cursor and lock mouse inside game
	Object = require "modules.classic.classic"
	require "modules.modulesOutsideLove2d.strict"
	require "scripts.objectShapes.isometricInteract"
	require "scripts.objectShapes.isometric"
	require "scripts.objectShapes.isometricBeta"
	require "scripts.places.typesOfObjects.flooredIsometricObject"
	require "scripts.objectShapes.rectangle"
	require "scripts.objectShapes.circle"
	require "scripts.cardboardbox"		--just for testing "drawing order" the hardest part for now, atleast for me :(
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
--Level's objects scripts below.  Should I be worried about loading all of them at once, or should they be load per each level/room required.
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

	love.graphics.rectangle("fill",game.middleX,game.middleY,10,10) -- for testing middle

	love.graphics.rectangle("fill",0,0,game.cartX,window.width)
	love.graphics.rectangle("fill",game.cartX+game.width*(game.scale/forZoomingIn),0,game.cartX,window.width)--This part is fucked on android/because of button tabs
	love.graphics.rectangle("fill",0,0,window.width,game.cartY)
	love.graphics.rectangle("fill",0,game.cartY+game.height*(game.scale/forZoomingIn),game.width,game.cartY)
	love.graphics.setColor(1,1,1)
	local onAndroid = Environment.usingAndroid
	if onAndroid == true then
		Joystick:draw()
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
