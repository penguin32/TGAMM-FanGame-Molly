#Molly(2022)
A fan game.

July 30 2024 > Reminder, search for (problem) tag to look for unfinished work.

Game's diary-> https://mega.nz/folder/59cUwDSK#YTUPskcfkMSq6X7CSite-w    (last 2023)
                        not yet updated -August 1 2024 me

                 There, contains what I'm planning to do for this fan-game, sprites,
  UML Diagram, Apk for Android and a Desktop Executable without needing a 
  loveFramework(plug ang play), and just Love file that can be only run if love2d framework
  is installed, for the Developers.


    Developer(Note just for me):
                --Trick with Scaling and Zooming in.
Objects' coordinate-offset needs to be scaled, example.
    ObjectA(x,y,Width)
    ObjectA(game.cartX + 100*game.scale, game.cartY +25*game.scale, Width*game.scale)

Objects that you don't want to be scaled along when zooming in, like UI(main menu), example
    ObjectA(x,y,Width)
    ObjectA(game.cartX + 100*game.scale/forZoomingIn, game.cartY + 25*game.scale/forZoomingIn, Width*game.scale/forZoomingIn)

    game.scale is use for scaling objects dependent of viewport's resolutions.
    game.scale is being affected by forZoomingIn, so dividing those variables/constants with
    game.scale beside it with forZoomingIn should make them unaffected from forZoomingIn
    expected results.

August 1 2024  >  scripts/places/mollyRoom/atticDoor.lua
                    should work as Doors, but accepting different sprites.png
                    only works for player, and not other npc human objects.

                  1. Review scripts/objectShapes/isometricBeta.lua
                  2. Review scripts/objectShapes/isometricInteract.lua
                  3. scripts/characters/*
                  4. scripts/forTesting/cardboardbox.lua
                  5. breadAndButter/*

November 4 2022>  remind myself that "circle" should be an ellipse in this isometric.
                  Do I have to though?

