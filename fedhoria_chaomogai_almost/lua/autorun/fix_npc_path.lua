
function FixNpcModelPath()
	local npcs = list.GetForEdit( "NPC")
	for k, v in pairs( npcs ) do
		local s = v["Model"]
		if s then
			local sz = string.lower(s)
			if s == sz then 
			else
				v["Model"] = sz
				print("Fixed "..k.." model "..s)
			end
		end
	end
end

timer.Simple( 1, function() FixNpcModelPath() end )
