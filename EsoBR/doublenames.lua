local function EsoBR_doubleNamesBoth(EsoBR)
	local GetGameCameraInteractableActionInfoOld = GetGameCameraInteractableActionInfo
	local prevInteractNpcEn = ""
	local prevInteractNpcBr = ""
	
	function GetGameCameraInteractableActionInfo(...)
		local action, interactableName, interactionBlocked, isOwned, additionalInteractInfo, context, contextLink, isCriminalInteract = GetGameCameraInteractableActionInfoOld()
		local newNpcName, temp1, temp2, interactionType, settingType
		
		if action == GetString(SI_GAMECAMERAACTIONTYPE2) or action == GetString(SI_GAMECAMERAACTIONTYPE21) or action == GetString(SI_GAMECAMERAACTIONTYPE1) or action == GetString(SI_GAMECAMERAACTIONTYPE7) then
			interactionType = "npc"
			settingType = EsoBR.Settings.ShowNPC
		else
			interactionType = "location"
			settingType = EsoBR.Settings.ShowLocations
		end
		
		if settingType == "Somente Português" or interactableName == nil then
			return action, ZO_CachedStrFormat(SI_ZONE_NAME, interactableName), interactionBlocked, isOwned, additionalInteractInfo, context, contextLink, isCriminalInteract
		end
		
		temp1 = prevInteractNpcBr .. " (" .. prevInteractNpcEn .. ")"
		temp2 = prevInteractNpcEn .. " (" .. prevInteractNpcBr .. ")"
		
		if interactableName == prevInteractNpcBr or interactableName == temp1 or interactableName == temp2 then
			newNpcName = prevInteractNpcEn
		elseif interactableName == prevInteractNpcEn and settingType == "Somente Inglês" then
			newNpcName = prevInteractNpcEn
		else
			if interactionType == "npc" then
				newNpcName = npcNames[zo_strlower(interactableName)]
			else
				newNpcName = locationNames[zo_strlower(interactableName)]
			end
				
			if (newNpcName ~= nil and interactableName ~= nil) then
				prevInteractNpcEn = newNpcName
				prevInteractNpcBr = interactableName
			end
		end
		
		if newNpcName ~= nil then
			if (settingType == "Português+Inglês") then
				interactableName = ZO_CachedStrFormat(SI_ZONE_NAME, interactableName) .. "\n" .. newNpcName
			elseif (settingType == "Inglês+Português") then
				interactableName = newNpcName .. "\n" .. ZO_CachedStrFormat(SI_ZONE_NAME, interactableName)
			else
				interactableName = newNpcName
			end
		end
		
		return action, interactableName, interactionBlocked, isOwned, additionalInteractInfo, context, contextLink, isCriminalInteract
	end
	
	EsoBR_doubleNamesBoth = nil
end

function LFGDoubleNames(EsoBR)
	local locs2 = ZO_ACTIVITY_FINDER_ROOT_MANAGER.sortedLocationsData[2] -- Normal Dungeons
	local locs3 = ZO_ACTIVITY_FINDER_ROOT_MANAGER.sortedLocationsData[3] -- Vet Dungeons
	
	for i = 1, #locs2 do	   
	   newLocationName = locationNames[zo_strlower(locs2[i]["rawName"])]
	   
	   if newLocationName ~= nil then
			if (EsoBR.Settings.ShowLocations == "Português+Inglês") then
				locs2[i]["nameKeyboard"] = ZO_CachedStrFormat(SI_ZONE_NAME, locs2[i]["rawName"] .. " (" .. newLocationName .. ")")
				locs2[i]["nameGamepad"] = ZO_CachedStrFormat(SI_ZONE_NAME, locs2[i]["rawName"] .. " (" .. newLocationName .. ")")
			elseif (EsoBR.Settings.ShowLocations == "Somente Português") then
				locs2[i]["nameKeyboard"] = ZO_CachedStrFormat(SI_ZONE_NAME, locs2[i]["rawName"])
				locs2[i]["nameGamepad"] = ZO_CachedStrFormat(SI_ZONE_NAME, locs2[i]["rawName"])
			elseif (EsoBR.Settings.ShowLocations == "Inglês+Português") then
				locs2[i]["nameKeyboard"] = ZO_CachedStrFormat(SI_ZONE_NAME, newLocationName .. " (" .. locs2[i]["rawName"] .. ")")
				locs2[i]["nameGamepad"] = ZO_CachedStrFormat(SI_ZONE_NAME, newLocationName .. " (" .. locs2[i]["rawName"] .. ")")
			else
				locs2[i]["nameKeyboard"] = ZO_CachedStrFormat(SI_ZONE_NAME, newLocationName)
				locs2[i]["nameGamepad"] = ZO_CachedStrFormat(SI_ZONE_NAME, newLocationName)
			end
		end
	end
	
	for i = 1, #locs3 do	   
	   newLocationName = locationNames[zo_strlower(locs3[i]["rawName"])]
	   
	   if newLocationName ~= nil then
			if (EsoBR.Settings.ShowLocations == "Português+Inglês") then
				if string.find(locs3[i]["nameKeyboard"], "target_veteranRank_icon") then
					locs3[i]["nameKeyboard"] = "|t100%:100%:EsoUI/Art/UnitFrames/target_veteranRank_icon.dds|t " .. ZO_CachedStrFormat(SI_ZONE_NAME, locs3[i]["rawName"] .. " (" .. newLocationName .. ")")
				end
				if string.find(locs3[i]["nameGamepad"], "^Loch weterana") then
					locs3[i]["nameGamepad"] = "Loch weterana " .. locs3[i]["rawName"] .. " (" .. newLocationName .. ")"
				end
			elseif (EsoBR.Settings.ShowLocations == "Somente Português") then
				if string.find(locs3[i]["nameKeyboard"], "target_veteranRank_icon") then
					locs3[i]["nameKeyboard"] = "|t100%:100%:EsoUI/Art/UnitFrames/target_veteranRank_icon.dds|t " .. ZO_CachedStrFormat(SI_ZONE_NAME, locs3[i]["rawName"])
				end
				if string.find(locs3[i]["nameGamepad"], "^Loch weterana") then
					locs3[i]["nameGamepad"] = "Loch weterana " .. locs3[i]["rawName"]
				end
			elseif (EsoBR.Settings.ShowLocations == "Inglês+Português") then
				if string.find(locs3[i]["nameKeyboard"], "target_veteranRank_icon") then
					locs3[i]["nameKeyboard"] = "|t100%:100%:EsoUI/Art/UnitFrames/target_veteranRank_icon.dds|t " .. ZO_CachedStrFormat(SI_ZONE_NAME, newLocationName .. " (" .. locs3[i]["rawName"] .. ")")
				end
				if string.find(locs3[i]["nameGamepad"], "^Loch weterana") then
					locs3[i]["nameGamepad"] = "Loch weterana " .. newLocationName .. " (" .. locs3[i]["rawName"] .. ")"
				end
			else
				if string.find(locs3[i]["nameKeyboard"], "target_veteranRank_icon") then
					locs3[i]["nameKeyboard"] = "|t100%:100%:EsoUI/Art/UnitFrames/target_veteranRank_icon.dds|t " .. ZO_CachedStrFormat(SI_ZONE_NAME, newLocationName)
				end
				if string.find(locs3[i]["nameGamepad"], "^Loch weterana") then
					locs3[i]["nameGamepad"] = "Loch weterana " .. newLocationName
				end
			end
		end
	end
end

function EsoBR_doubleNamesNPC(EsoBR)

	if EsoBR_doubleNamesBoth then
		EsoBR_doubleNamesBoth(EsoBR)
	end

	local GetUnitNameOld = GetUnitName

	function GetUnitName(target)
		
		local currentNpcName = GetUnitNameOld(target)
		local newNpcName
		
		if (target == "player" or EsoBR.Settings.ShowNPC == "Somente Português" or currentNpcName == nil) then
			return currentNpcName
		end
		
		if (target == "reticleover") then
			if (not DoesUnitExist("reticleover") or IsUnitPlayer("reticleover")) then return currentNpcName end
		end
		
		newNpcName = npcNames[zo_strlower(currentNpcName)]
			
		if newNpcName ~= nil then
			if (EsoBR.Settings.ShowNPC == "Português+Inglês") then
				currentNpcName = currentNpcName .. " (" .. newNpcName .. ")"
			elseif (EsoBR.Settings.ShowNPC == "Inglês+Português") then
				currentNpcName = newNpcName .. " (" .. currentNpcName .. ")"
			else
				currentNpcName = newNpcName
			end
		end
			
		return currentNpcName
	end
	
	local GetMapLocationTooltipLineInfoOld = GetMapLocationTooltipLineInfo
	
	function GetMapLocationTooltipLineInfo(...)
		local icon, name, groupingId, categoryName = GetMapLocationTooltipLineInfoOld(...)
		
		if (name == nil or EsoBR.Settings.ShowNPC == "Somente Português") then
			return icon, name, groupingId, categoryName
		end
		
		newNpcName = npcNames[zo_strlower(name)]
			
		if newNpcName ~= nil then
			if (EsoBR.Settings.ShowNPC == "Português+Inglês") then
				name = name .. "\n|ca99e83" .. newNpcName .. "|r"
			elseif (EsoBR.Settings.ShowNPC == "Inglês+Português") then
				name = newNpcName .. "\n|ca99e83" .. name .. "|r"
			else
				name = newNpcName
			end
		end
			
		return icon, name, groupingId, categoryName
	end
	
	EsoBR_doubleNamesNPC = nil
end

function EsoBR_doubleNamesLocations(EsoBR)
	
	if EsoBR_doubleNamesBoth then
		EsoBR_doubleNamesBoth(EsoBR)
	end
	
	local GetGameCameraNonInteractableNameOld = GetGameCameraNonInteractableName
	local prevNonInteractEn = ""
	local prevNonInteractBr = ""
	
	function GetGameCameraNonInteractableName(...)
		local name = GetGameCameraNonInteractableNameOld()
		local newLocName, temp1, temp2
		
		if (EsoBR.Settings.ShowLocations == "Somente Português" or name == nil) then
			return ZO_CachedStrFormat(SI_ZONE_NAME, name)
		end
		
		temp1 = prevNonInteractBr .. " (" .. prevNonInteractEn .. ")"
		temp2 = prevNonInteractEn .. " (" .. prevNonInteractBr .. ")"
		
		if name == prevNonInteractBr or name == temp1 or name == temp2 then
			newLocName = prevNonInteractEn
		elseif name == prevNonInteractEn and settingType == "Somente Inglês" then
			newLocName = prevNonInteractEn
		else
			newLocName = locationNames[zo_strlower(name)]
				
			if (newLocName ~= nil and name ~= nil) then
				prevNonInteractEn = newLocName
				prevNonInteractBr = name
			end
		end
			
		if newLocName ~= nil then
			if (EsoBR.Settings.ShowLocations == "Português+Inglês") then
				name = ZO_CachedStrFormat(SI_ZONE_NAME, name) .. "\n" .. newLocName
			elseif (EsoBR.Settings.ShowLocations == "Inglês+Português") then
				name = newLocName .. "\n" .. ZO_CachedStrFormat(SI_ZONE_NAME, name)
			else
				name = newLocName
			end
		end
		
		return name
	end
	
	local GetMapLocationTooltipHeaderOld = GetMapLocationTooltipHeader
	
	function GetMapLocationTooltipHeader(...)
		local headerText = ZO_CachedStrFormat(SI_ZONE_NAME, GetMapLocationTooltipHeaderOld(...))
		
		if (headerText == nil or EsoBR.Settings.ShowLocations == "Somente Português") then
			return headerText
		end
		
		newLocName = locationNames[zo_strlower(headerText)]
			
		if newLocName ~= nil then
			if (EsoBR.Settings.ShowLocations == "Português+Inglês") then
				headerText = headerText .. "\n|ca99e83" .. newLocName .. "|r"
			elseif (EsoBR.Settings.ShowLocations == "Inglês+Português") then
				headerText = newLocName .. "\n|ca99e83" .. headerText .. "|r"
			else
				headerText = newLocName
			end
		end
		
		return headerText
	end
	
	local GetPOIInfoOld = GetPOIInfo
	
	function GetPOIInfo(...)
		local poiName, _, poiStartDesc, poiFinishedDesc = GetPOIInfoOld(...)
		
		if (poiName == nil or EsoBR.Settings.ShowLocations == "Somente Português") then
			return ZO_CachedStrFormat(SI_ZONE_NAME, poiName), _, poiStartDesc, poiFinishedDesc
		end
		
		newLocName = locationNames[zo_strlower(poiName)]
			
		if newLocName ~= nil then
			if (EsoBR.Settings.ShowLocations == "Português+Inglês") then
				poiName = ZO_CachedStrFormat(SI_ZONE_NAME, poiName) .. " (" .. newLocName .. ")"
			elseif (EsoBR.Settings.ShowLocations == "Inglês+Português") then
				poiName = newLocName .. " (" .. zo_strformat("<<1>>", poiName) .. ")"
			else
				poiName = newLocName
			end
		end
		
		return poiName, _, poiStartDesc, poiFinishedDesc
	end
	
	local GetMapMouseoverInfoOld = GetMapMouseoverInfo
	
	function GetMapMouseoverInfo(...)
		local locationName, textureFile, widthN, heightN, locXN, locYN = GetMapMouseoverInfoOld(...)
		
		if (locationName == nil or EsoBR.Settings.ShowLocations == "Somente Português") then
			return ZO_CachedStrFormat(SI_ZONE_NAME, locationName), textureFile, widthN, heightN, locXN, locYN
		end
		
		newLocName = locationNames[zo_strlower(locationName)]
			
		if newLocName ~= nil then
			if (EsoBR.Settings.ShowLocations == "Português+Inglês") then
				locationName = ZO_CachedStrFormat(SI_ZONE_NAME, locationName) .. "\n" .. newLocName
			elseif (EsoBR.Settings.ShowLocations == "Inglês+Português") then
				locationName = newLocName .. "\n" .. ZO_CachedStrFormat(SI_ZONE_NAME, locationName)
			else
				locationName = newLocName
			end
		end
		
		return locationName, textureFile, widthN, heightN, locXN, locYN
	end
	
	local GetMapNameOld = GetMapName
	
	function GetMapName(...)
		local zoneName = GetMapNameOld(...)
		
		if (zoneName == nil or EsoBR.Settings.ShowLocations == "Somente Português") then
			return zoneName
		end
		
		newLocName = locationNames[zo_strlower(zoneName)]
			
		if newLocName ~= nil then
			if (EsoBR.Settings.ShowLocations == "Português+Inglês") then
				zoneName = ZO_CachedStrFormat(SI_ZONE_NAME, zoneName) .. "\n" .. newLocName
			elseif (EsoBR.Settings.ShowLocations == "Inglês+Português") then
				zoneName = newLocName .. "\n" .. ZO_CachedStrFormat(SI_ZONE_NAME, zoneName)
			else
				zoneName = newLocName
			end
		end
		
		return zoneName
	end
	
	local GetFastTravelNodeInfoOld = GetFastTravelNodeInfo
	
	function GetFastTravelNodeInfo(...)
		local known, name, normalizedX, normalizedY, icon, glowIcon, poiType, isLocatedInCurrentMap, linkedCollectibleIsLocked = GetFastTravelNodeInfoOld(...)
		
		if (name == nil or EsoBR.Settings.ShowLocations == "Somente Português") then
			return known, name, normalizedX, normalizedY, icon, glowIcon, poiType, isLocatedInCurrentMap, linkedCollectibleIsLocked
		end
		
		newLocName = locationNames[zo_strlower(name)]
			
		if newLocName ~= nil then
			if (EsoBR.Settings.ShowLocations == "Português+Inglês") then
				name = name .. " (" .. newLocName .. ")"
			elseif (EsoBR.Settings.ShowLocations == "Inglês+Português") then
				name = newLocName .. " (" .. name .. ")"
			else
				name = newLocName
			end
		end
		
		return known, name, normalizedX, normalizedY, icon, glowIcon, poiType, isLocatedInCurrentMap, linkedCollectibleIsLocked
	end
	
	local GetKeepNameOld = GetKeepName
	
	function GetKeepName(...)
		local name = ZO_CachedStrFormat(SI_ZONE_NAME, GetKeepNameOld(...))
		
		if (name == nil or EsoBR.Settings.ShowLocations == "Somente Português") then
			return name
		end
		
		newLocName = locationNames[zo_strlower(name)]
			
		if newLocName ~= nil then
			if (EsoBR.Settings.ShowLocations == "Português+Inglês") then
				name = name .. " (" .. newLocName .. ")"
			elseif (EsoBR.Settings.ShowLocations == "Inglês+Português") then
				name = newLocName .. " (" .. name .. ")"
			else
				name = newLocName
			end
		end
		
		return name
	end
	
	local GetMapInfoOld = GetMapInfo --не работает
	
	function GetMapInfo(...)
		local mapName, mapType, mapContentType, zoneId, description = GetMapInfoOld(...)
		
		if (mapName == nil or EsoBR.Settings.ShowLocations == "Somente Português") then
			return mapName, mapType, mapContentType, zoneId, description
		end
		
		newLocName = locationNames[zo_strlower(mapName)]
			
		if newLocName ~= nil then
			if (EsoBR.Settings.ShowLocations == "Português+Inglês") then
				mapName = mapName .. " (" .. newLocName .. ")"
			elseif (EsoBR.Settings.ShowLocations == "Inglês+Português") then
				mapName = newLocName .. " (" .. mapName .. ")"
			else
				mapName = newLocName
			end
		end
		
		return mapName, mapType, mapContentType, zoneId, description
	end
	
	local GetFriendCharacterInfoOld = GetFriendCharacterInfo
	
	function GetFriendCharacterInfo(...)
		local hasCharacter, characterName, zone, class, alliance, level, championPoints = GetFriendCharacterInfoOld(...)
		
		if (zone == nil or EsoBR.Settings.ShowLocations == "Somente Português") then
			return hasCharacter, characterName, zone, class, alliance, level, championPoints
		end
		
		newLocName = locationNames[zo_strlower(zone)]
			
		if newLocName ~= nil then
			if (EsoBR.Settings.ShowLocations == "Português+Inglês") then
				zone = zone .. " (" .. newLocName .. ")"
			elseif (EsoBR.Settings.ShowLocations == "Inglês+Português") then
				zone = newLocName .. " (" .. zone .. ")"
			else
				zone = newLocName
			end
		end
		
		return hasCharacter, characterName, zone, class, alliance, level, championPoints
	end
	
	FRIENDS_LIST_MANAGER:BuildMasterList()
	
	local GetZoneNameByIndexOld = GetZoneNameByIndex
	
	function GetZoneNameByIndex(...)
		local zone = GetZoneNameByIndexOld(...)
		
		if (zone == nil or EsoBR.Settings.ShowLocations == "Somente Português") then
			return zone
		end
		
		newLocName = locationNames[zo_strlower(zone)]
			
		if newLocName ~= nil then
			if (EsoBR.Settings.ShowLocations == "Português+Inglês") then
				zone = zone .. " (" .. newLocName .. ")"
			elseif (EsoBR.Settings.ShowLocations == "Inglês+Português") then
				zone = newLocName .. " (" .. zone .. ")"
			else
				zone = newLocName
			end
		end
		
		return zone
	end
	
	local GetActivityInfoOld = GetActivityInfo
	
	function GetActivityInfo(...)
		local name, levelMin, levelMax, championPointsMin, championPointsMax, groupType, minGroupSize, description, sortOrder = GetActivityInfoOld(...)
		
		if (name == nil or EsoBR.Settings.ShowLocations == "Somente Português") then
			return name, levelMin, levelMax, championPointsMin, championPointsMax, groupType, minGroupSize, description, sortOrder
		end
		
		newLocName = locationNames[zo_strlower(name)]
			
		if newLocName ~= nil then
			if (EsoBR.Settings.ShowLocations == "Português+Inglês") then
				name = name .. " (" .. newLocName .. ")"
			elseif (EsoBR.Settings.ShowLocations == "Inglês+Português") then
				name = newLocName .. " (" .. name .. ")"
			else
				name = newLocName
			end
		end
		
		return name, levelMin, levelMax, championPointsMin, championPointsMax, groupType, minGroupSize, description, sortOrder
	end
	
	local GetGuildMemberCharacterInfoOld = GetGuildMemberCharacterInfo
	
	function GetGuildMemberCharacterInfo(...)
		local hasCharacter, rawCharacterName, zone, class, alliance, level, championPoints = GetGuildMemberCharacterInfoOld(...)
		
		if (zone == nil or EsoBR.Settings.ShowLocations == "Somente Português") then
			return hasCharacter, rawCharacterName, zone, class, alliance, level, championPoints
		end
		
		newLocName = locationNames[zo_strlower(zone)]
			
		if newLocName ~= nil then
			if (EsoBR.Settings.ShowLocations == "Português+Inglês") then
				zone = zone .. " (" .. newLocName .. ")"
			elseif (EsoBR.Settings.ShowLocations == "Inglês+Português") then
				zone = newLocName .. " (" .. zone .. ")"
			else
				zone = newLocName
			end
		end
		
		return hasCharacter, rawCharacterName, zone, class, alliance, level, championPoints
	end
	
	GUILD_ROSTER_MANAGER:BuildMasterList()
	
	local GetCadwellZoneInfoOld = GetCadwellZoneInfo
	
	function GetCadwellZoneInfo(...)
		local zone, zoneDescription, zoneOrder = GetCadwellZoneInfoOld(...)
		
		if (zone == nil or EsoBR.Settings.ShowLocations == "Somente Português") then
			return zone, zoneDescription, zoneOrder
		end
		
		newLocName = locationNames[zo_strlower(zone)]
			
		if newLocName ~= nil then
			if (EsoBR.Settings.ShowLocations == "Português+Inglês") then
				zone = zone .. " (" .. newLocName .. ")"
			elseif (EsoBR.Settings.ShowLocations == "Inglês+Português") then
				zone = newLocName .. " (" .. zone .. ")"
			else
				zone = newLocName
			end
		end
		
		return zone, zoneDescription, zoneOrder
	end
	
	CADWELLS_ALMANAC:RefreshList()
	EsoBR:MapNameStyle()
	
	local ZO_AlertText_GetHandlersOld = ZO_AlertText_GetHandlers
	
	function ZO_AlertText_GetHandlers()
		local ALERT = UI_ALERT_CATEGORY_ALERT
		local handlers = ZO_AlertText_GetHandlersOld()
		
		handlers[EVENT_ZONE_CHANGED] = function(zoneName, subzoneName)
			if(subzoneName ~= "") then
				if (EsoBR.Settings.ShowLocations ~= "Somente Português") then
					newLocName = locationNames[zo_strlower(subzoneName)]
			
					if newLocName ~= nil then
						if (EsoBR.Settings.ShowLocations == "Português+Inglês") then
							subzoneName = subzoneName .. "\n|ca99e83" .. newLocName .. "|r"
						elseif (EsoBR.Settings.ShowLocations == "Inglês+Português") then
							subzoneName = newLocName .. "\n|ca99e83" .. ZO_CachedStrFormat(SI_ZONE_NAME, subzoneName) .. "|r"
						else
							subzoneName = newLocName
						end
					end
				end
				
				return ALERT, ZO_CachedStrFormat(SI_ALERTTEXT_LOCATION_FORMAT, subzoneName)
			elseif(zoneName ~= "") then
				if (EsoBR.Settings.ShowLocations ~= "Somente Português") then
					newLocName = locationNames[zo_strlower(zoneName)]
			
					if newLocName ~= nil then
						if (EsoBR.Settings.ShowLocations == "Português+Inglês") then
							zoneName = zoneName .. "\n|ca99e83" .. newLocName .. "|r"
						elseif (EsoBR.Settings.ShowLocations == "Inglês+Português") then
							zoneName = newLocName .. "\n|ca99e83" .. ZO_CachedStrFormat(SI_ZONE_NAME, zoneName) .. "|r"
						else
							zoneName = newLocName
						end
					end
				end
				
				return ALERT, ZO_CachedStrFormat(SI_ALERTTEXT_LOCATION_FORMAT, zoneName)
			end
		end
		
		return handlers
	end
	
	LFGDoubleNames(EsoBR)
	
	EsoBR_doubleNamesLocations = nil
end