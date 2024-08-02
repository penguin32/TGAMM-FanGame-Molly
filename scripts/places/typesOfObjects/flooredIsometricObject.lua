--[[       Created to help to identify objects that can be walk-through it,
        and 2nd to the first drawn image (the floor/explorableArea.lua)
  
	Why?
      Isometric -is interactable by humanColliderFunctions, now, it does not mean its
      exclusive to human
      but any moving character(object) that has this implemented will be have the
      behavior of collisions among Isometric objects.

IsometricBeta - same field/attributes but this kinds are not affected
by humanColliderFunctions.lua

I created IsometricInteractable, since I want it to be an "implement" type of thing
among isometric that has collisions or not,

Why not combine IsometricBeta with Iso..Interactable instead?
because I also want to give Isometric kinds to have interactable options aswell,

Many objects in the game will inherit the same Class fields, hence the typOfObjects
directory has been created.

In the typeOfObjects, contains list of scripts that would be helpful for the
Environment:SortObjects() function

These class type dictates label of the objects for the function to be able to decide
in how the ordering of their drawing should be in.
]]--
FlooredIsometricObject = IsometricBeta:extend()
