# Molly
July 30 2024 > Reminder, search for (problem) tag to look for unfinished work.

A fan game.
Game's diary-> https://mega.nz/folder/B5NklCxb#Oq8xDraLJo3iPZAoZba90g
There, contains what I'm planning to do for this fan-game, sprites, UML Diagram, Apk for Android and Desktop Executable without needing a loveFramework(plug ang play),
and just Love file that can be only run if love2d framework is installed, for the Developers.


Developer:
November 3 2022> Loop through Environment.floors()to find specific sfx to play ..it doesn't exists yet.
    molly.lua, but that sfx function,isMoving shouldBe on character.lua instead.

November 5 2022> Colliders(humanColliderFunctions.lua) involving with these has not been added yet.
    1   I want to continue at drawing order of those environment objects, maybe add sprite or sounds a bit first...
            self.headOffsetX,self.headOffsetY = 0*self.scale,0*self.scale--notYet		--Offset of those hitboxes
	        self.bodyOffsetX,self.bodyOffsetY = 0*self.scale,0*self.scale--notYet

    2   All objectShapes that I'm planning to use as a collider has been added.
            collision of circle to all objectShapes has been tested for the Human type.
                            "Human" type which isn't a thing yet, but if its necessary to segragate them from other entities, then
                            I'll just create a Human = Object:extend() then extend that again to those characters that is human.

November 4 2022> remind myself that "circle" should be an ellipse in this isometric, change cursor.x/y and objectShapes/circle

October 31 2022> player.lua -- implement "touch" for android
                    +added, TouchUpdateID , LeftJoystick love.touchreleased() not working as intended, not functioning as intended(Nov 3 2022)

signing commit test... July 2023 again.... 3rd time now....holy 4th time now...
    damn i hate ssh, maybe gpg will work!
6th time now, i have to add it to the gpg list in github site!!!!


July 25 2024> reviewing github clone add commit push ssh etc..

July 29 2024> Just Reviewing and need of signing to verify push.
 tips for dummy/me> $git commit -S -m "to sign commit"
tick off, "Keep my email address private" on Settings>Emails
removed the gpg in the settings>keys, retrying to sign commit again
git config --global user.name blah32
git config --global user.email blah@gmail.com

maybe its the capital letter instead of signingkey its Signingkey
git config --global user.Signingkey 1243234234

"upload your public signing ssh keys"


July 30 2024 > Reminder, search for (problem) tag to look for unfinished work.
