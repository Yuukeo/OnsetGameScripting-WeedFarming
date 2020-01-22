local PlantasIds = {}
local PacotesIds = {}
local plantas_ = {}
local pacotes_ = {}


AddRemoteEvent("ilegalmaconha:update", function(PlantaObjects)
		
		plantas_ = PlantaObjects

		--Clear array of harvestable plants
		PlantasIds = {}
		
		for _,v in pairs(plantas_) do
			if IsValidObject(v) then
				table.insert(PlantasIds, v)
			end
		end		
end)

AddRemoteEvent("ilegalmaconha:updatepacotes", function(PacoteObjects)
		
		pacotes_ = PacoteObjects

		--Clear array of pickuble weed packet
		PacotesIds = {}
		
		for _,v in pairs(pacotes_) do
			if IsValidObject(v) then
				table.insert(PacotesIds, v)
				AddPlayerChat("#####")
			end
		end	
end)

function GetNearestObjectByType(objects,DISTANCE)
		
		local x, y, z = GetPlayerLocation()
		
		if objects ~= nil then
			for _, v in pairs(objects) do
				if IsValidObject(v) then
					local xv, yv, zv = GetObjectLocation(v)
					local dist = GetDistance3D(x, y, z, xv, yv, zv)
					if dist <= DISTANCE then
						return v
					end 
				end
			end	
		end
		return 0
end

local function OnKeyPress(key)
	
	--If player is on foot. He can do some stuff
	if not(IsPlayerInVehicle()) then
	
			--Player will plant another Plant
			--CHECK FOR SEEDS IN INVENTORY,DO YOUR PART LOL
			if key == 'H' then
				
				local plant = GetNearestObjectByType(PlantasIds,300)
				if plant == 0 then 
					CallRemoteEvent("Plantar")
				else
					AddPlayerChat("Another plant is too close!")
				end 
			end

			--Player will harvest Plant
			if key == 'E' then
				local plant = GetNearestObjectByType(PlantasIds,150)
				if plant ~= 0 then
					CallRemoteEvent("Colher", plant)
				else
					AddPlayerChat("No plant near you to harvest! Get Closer!")
				end
			end
			
			--Player will pick up weed bag
			if key == 'J' then
			
				local bag = GetNearestObjectByType(PacotesIds,150)
				if bag ~= 0 then
					CallRemoteEvent("Pegar", bag)
				else
					AddPlayerChat("No bag near you to pick up! Get Closer!")
				end
			end
	end
	
end
AddEvent("OnKeyPress", OnKeyPress)
