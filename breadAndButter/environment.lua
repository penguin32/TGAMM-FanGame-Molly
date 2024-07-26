Environment = { ui={},
		objects={}}--,drawObjects={} }
--objects ordering for update doesn't matter, so I made copy, drawObjects table, that are the only table to be modified during runtime for draw() function.

--Be worried about player.lua, it uses Environment tables too.
--Also other interactable objects/ui such as main menu here, uses tables from this Environment on their updates()
function Environment.load(level)
	Environment.level = level or 0
	Environment.bool = 1
	Environment.usingAndroid = false
	Environment.touchUpdateUI = false
	Environment.DevChangeOS = false		---changed by developer only, set "true" for Android, "false" for Desktop use,
end						---also the player.lua has couple more steps to follow for this.

function Environment.update(dt)
	local selectedLevel = Environment.level
	if selectedLevel == 0 and Environment.bool == 1 then
		table.insert(Environment.ui,MainMenu())
		Environment.touchUpdateUI = Environment.DevChangeOS
		Environment.bool = 0
	elseif selectedLevel == -1 and Environment.bool == 1 then--This level Exist for testing purposes
		Player.Load(Environment.objects)
		love.mouse.setVisible(false)
		Environment.usingAndroid = Environment.DevChangeOS
		Environment.bool = 0
		for i=1,9 do
			table.insert(Environment.objects,Circle(love.math.random(0,1000) + 600,love.math.random(0,1000),love.math.random(80, 140)))
		end
		for i=1,9 do
			table.insert(Environment.objects,Rectangle(love.math.random(0,1000) - 600,love.math.random(0,1000),love.math.random(100, 340),love.math.random(100, 340)))
		end
		for i=1,9 do
			table.insert(Environment.objects,Isometric(love.math.random(0,1000),love.math.random(0,1000) + 1600,love.math.random(100, 340),love.math.random(100, 340)))
		end
		for i=1,9 do
			table.insert(Environment.objects,CardBoardBox(love.math.random(0,1000),love.math.random(0,1000) - 1600))
		end
	elseif selectedLevel == 1 and Environment.bool == 1 then
		Player.Load(Environment.objects)
		love.mouse.setVisible(false)
		Environment.usingAndroid = Environment.DevChangeOS
		Environment.bool = 0
		--Add your levels resources below
		table.insert(Environment.objects,MollyRoom(game.cartX-300*game.scale,game.cartY+200*game.scale,744,932))
		table.insert(Environment.objects,McGeeKitchen(game.cartX-1400*game.scale,game.cartY+1200*game.scale,950,837))
	end
	
	local totalObj = #Environment.objects
	if totalObj > 0 then
		Player.GetDistanceOfPointOnScreenWithRespectToPlayerBasePos()	--Responsible for CursorHover on objectShapes directory
		table.sort(Environment.objects, Environment.SortObjects)	--Looking for table sort (0 - 0) ?  They're here!
		for i,v in ipairs(Environment.objects)do
			v:update(dt)
		end
	end

	local totalUI = #Environment.ui
	if totalUI > 0 then
		for i,v in ipairs(Environment.ui)do
			v:update(dt)
		end
	end
end

function Environment.draw()
	local totalObj = #Environment.objects
	love.graphics.push()
	love.graphics.scale(1/game.badAttemptAtScaling,1/game.badAttemptAtScaling)
	if totalObj > 0 then
		love.graphics.translate(-Player.SelectedCharacter.base_x + game.middleX*game.badAttemptAtScaling, -Player.SelectedCharacter.base_y + game.middleY*game.badAttemptAtScaling)
		for i,v in ipairs(Environment.objects)do
			if v:is(Circle) or v:is(Rectangle) or v:is(Isometric) then--To see the collider as black.
				love.graphics.setColor(0,0,0)
				v:draw()
				love.graphics.setColor(255,255,255)
			else
				v:draw()
			end
		--	love.graphics.setColor(0,255,0)					--GREEN Dots  forTesting
		--	love.graphics.circle("fill",v.x,v.y,10)				--These represents object's xy positions.
		end
	end
	love.graphics.pop()

	local selectedLevel = Environment.level
	if selectedLevel ~= 0 then
		local who = Player.Who
		if  who == "Molly" then	--November 6 2022 : Test here!
			love.graphics.setColor(0,255,0)
			love.graphics.print("CharPos: "..Player.SelectedCharacter.x,game.cartX+100*game.scale/forZoomingIn,game.cartY+120*game.scale/forZoomingIn)
			love.graphics.print("CharPos: "..Player.SelectedCharacter.y,game.cartX+100*game.scale/forZoomingIn,game.cartY+160*game.scale/forZoomingIn)
			love.graphics.print("evilCursorX: "..Player.evilCursorX,game.cartX+100*game.scale/forZoomingIn,game.cartY+200*game.scale/forZoomingIn)
			love.graphics.print("evilCursorY: "..Player.evilCursorY,game.cartX+100*game.scale/forZoomingIn,game.cartY+240*game.scale/forZoomingIn)
			love.graphics.print("char.base_x: "..Player.SelectedCharacter.base_x,game.cartX+800*game.scale/forZoomingIn,game.cartY+120*game.scale/forZoomingIn)
			love.graphics.print("char.base_y: "..Player.SelectedCharacter.base_y,game.cartX+800*game.scale/forZoomingIn,game.cartY+160*game.scale/forZoomingIn)
			love.graphics.print("Player.Keyboard.z: "..tostring(Player.Keyboard.z),game.cartX+800*game.scale/forZoomingIn,game.cartY+200*game.scale/forZoomingIn)
		end
		if not(cursor.x == game.middleX and cursor.y == game.middleY)then
			love.graphics.setColor(255,255,0)
			love.graphics.circle("fill",cursor.x,cursor.y,7.5*game.scale)
			love.graphics.setColor(255,255,255)
		end--functionality visible on Desktop only, Android left joystick is not working as intended, but you can leave it as it is. :(
	end

	local totalUI = #Environment.ui--feels like these should be running under push() and pop(), hehe "feels"
	if totalUI > 0 then
		for i,v in ipairs(Environment.ui)do
			v:draw()
		end
	end
end

--November 7 2022 : Sorting functions below did work now, but Character and Circle has to be sharing that similar "if-statements" now,
--	and that means "me not being able to use the offset hitboxes values"/"no customization"
--   I still need to fix this, because if I decided to let a character to be colliderless(ghost) That drawing order could look wonky

function Environment.SortObjects(a,b)--November 8 2022 : circle obj.r (radius), character obj.feetr+obj.feetOffsetX/Y, vs with Other Objects,
--	(giving them width)							is not Implemented yet.A
--
--
	if a:is(Isometric) and b:is(Isometric) then--just objectShapes below
		return b.y > a.y
	elseif a:is(Isometric) and b:is(Rectangle) then
		if  b.y > a.y2 and b.y > (a.ml*(b.x-a.x)+a.y) then
			return true
		elseif b.y > a.y3 and b.y > (a.mr*(b.x-a.x)+a.y) then
			return true
		else
			return false
		end
	elseif a:is(Rectangle) and b:is(Isometric) then
		if a.y > b.y2 and a.y > (b.ml*(a.x-b.x)+b.y) then
			return false
		elseif a.y > b.y3 and a.y > (b.mr*(a.x-b.x)+b.y) then
			return false
		else
			return true
		end
--												Rectangle,Circle/Character,Isometric (HEREE)
	elseif a:is(Isometric) and (b:is(Circle) or b:is(Character)) then
		if  b.y > a.y2 and b.y > (a.ml*(b.x-a.x)+a.y) then
			return true
		elseif b.y > a.y3 and b.y > (a.mr*(b.x-a.x)+a.y) then
			return true
		else
			return false
		end
	elseif (a:is(Circle) or a:is(Character)) and b:is(Isometric) then
		if a.y > b.y2 and a.y > (b.ml*(a.x-b.x)+b.y) then
			return false
		elseif a.y > b.y3 and a.y > (b.mr*(a.x-b.x)+b.y) then
			return false
		else
			return true
		end
	elseif a:is(Rectangle) and b:is(Rectangle) then
		return b.y > a.y
	elseif a:is(Rectangle) and (b:is(Circle) or b:is(Character)) then
		return b.y > a.y
	elseif (a:is(Circle) or a:is(Character)) and b:is(Rectangle) then
		return b.y > a.y
	elseif (a:is(Circle) or a:is(Character)) and (b:is(Circle) or b:is(Character)) then
		return b.y > a.y
--[[	elseif a:is(Isometric) and b:is(Character) then--just characters vs objectShapes belows
		if  b.y > a.y2 and b.y > (a.ml*(b.x-a.x)+a.y) then
			return true
		elseif b.y > a.y3 and b.y > (a.mr*(b.x-a.x)+a.y) then
			return true
		else
			return false
		end			--Well this sucks, it breaks whenever I add objectShapes asides from Isometric
	elseif a:is(Character) and b:is(Isometric) then
		if a.y > b.y2 and a.y > (b.ml*(a.x-b.x)+b.y) then
			return false
		elseif a.y > b.y3 and a.y > (b.mr*(a.x-b.x)+b.y) then
			return false
		else
			return true
		end
	elseif a:is(Rectangle) and b:is(Character) then
		return a.y > b.y
	elseif a:is(Character) and b:is(Rectangle) then
		return a.y > b.y
	elseif a:is(Circle) and b:is(Character) then
		return a.y > b.y
	elseif a:is(Character) and b:is(Circle) then
		return a.y > b.y
	elseif a:is(Character) and b:is(Character) then
		return b.y > a.y
	]]--

	--[[			--					IsometricBeta with other objects (add here) November 10 2022
				--
				--
	elseif a:is(IsometricBeta) and b:is(Isometric) then
		return b.y > a.y
	elseif a:is(Isometric) and b:is(IsometricBeta) then
		return b.y > a.y

	elseif a:is(IsometricBeta) and b:is(Rectangle) then
		return b.y > a.y
	elseif a:is(Rectangle) and b:is(IsometricBeta) then
		return b.y > a.y

	elseif a:is(IsometricBeta) and b:is(Circle) then
		return b.y > a.y
	elseif a:is(Circle) and b:is(IsometricBeta) then
		return b.y > a.y

	elseif a:is(IsometricBeta) and b:is(Character) then
		return b.y > a.y
	elseif a:is(Character) and b:is(IsometricBeta) then
		return b.y > a.y

	elseif a:is(IsometricBeta) and b:is(IsometricBeta) then
		return b.y > a.y
--HAHAHA NEVER MIND !
		]]--
	elseif a:is(FlooredIsometricObject) and b:is(FlooredIsometricObject) then--For the FlooredIsometricObject (HEREE)
		return b.y > a.y

	elseif a:is(FlooredIsometricObject) and b:is(Rectangle) then
		return true
	elseif a:is(Rectangle) and b:is(FlooredIsometricObject) then
		return false

	elseif a:is(FlooredIsometricObject) and b:is(Circle) then
		return true
	elseif a:is(Circle) and b:is(FlooredIsometricObject) then
		return false

	elseif a:is(FlooredIsometricObject) and b:is(Isometric) then
		return true
	elseif a:is(Isometric) and b:is(FlooredIsometricObject) then
		return false

	elseif a:is(FlooredIsometricObject) and b:is(Character) then
		return true
	elseif a:is(Character) and b:is(FlooredIsometricObject) then
		return false

	elseif a:is(ExplorableArea) and b:is(FlooredIsometricObject)  then	--For the floor to drawn first on the canvas   ExplorableArea (HEREE)
		return true
	elseif a:is(FlooredIsometricObject) and b:is(ExplorableArea)  then
		return false
	elseif a:is(ExplorableArea) and b:is(Isometric) then
		return true
	elseif a:is(Isometric) and b:is(ExplorableArea) then
		return false
	elseif a:is(ExplorableArea) and b:is(Rectangle) then
		return true
	elseif a:is(Rectangle) and b:is(ExplorableArea) then
		return false
	elseif a:is(ExplorableArea) and b:is(Circle) then
		return true
	elseif a:is(Circle) and b:is(ExplorableArea) then
		return false
	elseif a:is(ExplorableArea) and b:is(Character) then
		return true
	elseif a:is(Character) and b:is(ExplorableArea) then
		return false
	elseif a:is(ExplorableArea) and b:is(ExplorableArea) then
		return b.y > a.y
	end
end
