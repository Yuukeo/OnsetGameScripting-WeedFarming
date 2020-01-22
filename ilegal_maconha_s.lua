
Plantas = {}
Pacotes = {}
idplantas = 0
 
 
--[[ util ]]--
function tablelength(T)
  local count = 0
  for _ in pairs(T) do count = count + 1 end
  return count
end

function tablefind(tab, el)
	for index, value in pairs(tab) do
		if value == el then
			return index
		end
	end
end

--if position of player to plant is too close to another plant, we wont let player plant
function IsNewPlantLocationOk(player) 
	
	local xp, yp, zp = GetPlayerLocation(player)
	local r = true
	for _,v in pairs(Plantas) do
		if IsValidObject(v) then
			local xv, yv, zv = GetObjectLocation(v)
			AddPlayerChat(player,tostring(GetDistance3D(xp, yp, zp, xv, yv, zv)))
			if GetDistance3D(xp, yp, zp, xv, yv, zv) <= 30.0 then
				r = false
				break
			end
		end
	end
	
	return r

end 

function Plantar(player)
      
	local planta;
	local TIMER_PLANTAR = 3000;
	local TIMER_PLANTAR_CRESCER = 10000;
	local TIMER_PLANTAR_FLORIR = 10000;
	local BEFORE_PLANT_PICKPUS = 2;
	  
	if not IsNewPlantLocationOk(player) then  
		AddPlayerChat(player, "Too close to another plant!")
		return false
	end
	  
	  
	--Start animation
	SetPlayerAnimation(player, "PICKUP_LOWER")
	
	Delay(2000, function()
	  
	  SetPlayerAnimation(player, "PICKUP_LOWER")

	  Delay(TIMER_PLANTAR, function()

			--[[ Get position of player to set Plant , little adjustment of Z coord.
			]]--		
			
			local x, y, z = GetPlayerLocation(player)
			
			planta = CreateObject(64, x, y, z)
			
			idplantas = idplantas + 1
			
			SetObjectPropertyValue(planta, "nome", "planta"..tostring(idplantas)) 
			SetObjectPropertyValue(planta, "tipo", "planta")
			SetObjectScale(planta,0.2,0.2,0.2)
			
			local xo, yo, zo = GetObjectLocation(planta)
			
			SetObjectLocation(planta, xo, yo, zo-95.0695)
			
			--[[Second stage of plant - vegging]]--
			Delay(TIMER_PLANTAR_CRESCER, function()
				SetObjectScale(planta,0.7,0.7,0.7)
				
				--[[Third stage - flowering ]]--
				Delay(TIMER_PLANTAR_FLORIR, function()
					SetObjectScale(planta,1.3,1.3,1.3)
					
					--Plant is ready to harvest, add to Harvestable Plants array
					table.insert(Plantas, planta)
					
					--update client with remaining harvestable Plants 
					CallRemoteEvent(player, "ilegalmaconha:update", Plantas)
			
				end)
				
			end)
	  end)

	end)
	
	--[[
		First step of Plant - little one.
	]]--
	  

end
AddRemoteEvent("Plantar", Plantar)

function Colher(player, object)

	--timers
	local HARVESTING_TIME = 8000;
	
	
	
	--get plant object property and location
	local nomeplanta = GetObjectPropertyValue(object,"nome")
	local idplanta = string.gsub(nomeplanta,"planta","")
	local x, y, z = GetObjectLocation(object)

	--Player animation for harvesting
	--which better way to do it .. didnt thought too much lol
	SetPlayerAnimation(player, "PICKUP_LOWER")
	Delay(2000, function() 
		SetPlayerAnimation(player, "PICKUP_LOWER")	
		Delay(2000, function()
			SetPlayerAnimation(player, "PICKUP_LOWER")	
		end)
	end)	

	Delay(HARVESTING_TIME, function()
	
		--loop all available plants to check which one he is trying to harvest
		for _,v in pairs(Plantas) do
		
			if GetObjectPropertyValue(v,"nome") == nomeplanta then
			
				--plant found, remove from available plants, destroy object ( cut plant down )
				table.remove(Plantas, tablefind(Plantas, v))	
				CallRemoteEvent(player,"ilegalmaconha:update", Plantas)
				DestroyObject(object)
			
				--create weed bag in same position of plant 
				local pacotemaconha = CreateObject(619, x, y, z)
				SetObjectScale(pacotemaconha,0.5,0.5,0.5)
			
				--identify the packet with same id used to plant
				SetObjectPropertyValue(pacotemaconha,"nome","pacotemaconha"..idplanta)
				SetObjectPropertyValue(pacotemaconha, "tipo", "pacotemaconha")

				--update client with new packets				
				if IsValidObject(pacotemaconha) then
					table.insert(Pacotes, pacotemaconha)
					CallRemoteEvent(player, "ilegalmaconha:updatepacotes", Pacotes)
				end
				break
			end
		end
	
	
	end)	
end
AddRemoteEvent("Colher", Colher)

--function used when player pick up the packet
function Pegar(player, object) 

	local TIME_TO_PICKUP = 2000;

	--if somehow objects nos valid, exit ..
	if not(IsValidPlayer(player) and IsValidObject(object)) then
	  return true 
	end

	SetPlayerAnimation(player, "PICKUP_LOWER")

	Delay(TIME_TO_PICKUP, function ()
	
		for _,v in pairs(Pacotes) do
			if GetObjectPropertyValue(v, "nome") == GetObjectPropertyValue(object, "nome") then
				table.remove(Pacotes, tablefind(Pacotes, v))
				CallRemoteEvent(player, "ilegalmaconha:updatepacotes", Pacotes)
				DestroyObject(object)
				break
			end
		end
	end)
end
AddRemoteEvent("Pegar", Pegar)

