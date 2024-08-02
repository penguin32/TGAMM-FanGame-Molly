LoadSprite = { -- List of available sprites, only png.
	-- sprites/characters/humans
	--	head
	--	torso
	--	legs
	--	items, dumbass just give it a ui,
	--	You don't want to count all the sands in the world.
	defaultTest = "sprites/characters/humans/molly"

	--sprites/objects/table  -example
}

function LoadSprite.Selection(type_of_sprite,selected_sprite)
	-- Type_of_sprite would be based on the table to be return
	if type_of_sprite == "human" then
		local human_sprite = {
			head = {},
			torso = {},
			legs = {}
		}
		if selected_sprite == "molly" then
			for i = 1,20 do
				table.insert(human_sprite.head,love.graphics.newImage(LoadSprite.defaultTest.."/head/molly_Head(Col3)."..string.format("%04d",i)..".png"))
				table.insert(human_sprite.torso,love.graphics.newImage(LoadSprite.defaultTest.."/torso/molly_Torso(Col1)."..string.format("%04d",i)..".png"))
				table.insert(human_sprite.legs,love.graphics.newImage(LoadSprite.defaultTest.."/legs/molly_Legs(Col1)."..string.format("%04d",i)..".png"))
			end
		end
		return human_sprite
	end
end
