local EsoBR = {}
EsoBR.Flags = { "en", "br" }
EsoBR.Version = "1.3.0"
EsoBR.Name = "EsoBR"
EsoBR.Defaults = {
	Anchor = { BOTTOMRIGHT, BOTTOMRIGHT, 0, 7 },
	ShowNPC = "Somente Português",
	ShowLocations = "Somente Português",
	IsFirstLaunchGlobal = true,
}
EsoBR.DefaultsCharacter = {
	IsFirstLaunch = true
}
EsoBR.Settings = EsoBR.Defaults
EsoBR.SettingsCharacter = EsoBR.DefaultsCharacter

local panelData = {
	type = "panel",
	name = "EsoBR",
	displayName = "Tradução Brasileira não-oficial do ESO.",
	author = "Mestre Frooke e Skrybowie Tamriel ",
	version = EsoBR.Version,
	slashCommand = "/esobr",
	registerForRefresh = true,
	registerForDefaults = true,
	website = "http:/www.universoeso.com.br"
}

function EsoBR_Change(lang)
	zo_callLater(function()
		SetCVar("language.2", lang)
		ReloadUI()
	end, 500)
end

function EsoBR:RefreshUI()
	local flagControl
	local count = 0
	local flagTexture
	for _, flagCode in pairs(EsoBR.Flags) do
		flagTexture = "EsoBR/textures/"..flagCode..".dds"
		flagControl = GetControl("EsoBR_FlagControl_"..tostring(flagCode))
		if flagControl == nil then
			flagControl = CreateControlFromVirtual("EsoBR_FlagControl_", EsoBRUI, "EsoBR_FlagControl", tostring(flagCode))
			GetControl("EsoBR_FlagControl_"..flagCode.."Texture"):SetTexture(flagTexture)
			if EsoBR:GetLanguage() ~= flagCode then
				flagControl:SetAlpha(0.3)
				if flagControl:GetHandler("OnMouseDown") == nil then flagControl:SetHandler("OnMouseDown", function() EsoBR_Change(flagCode) end) end
			end
		end
		flagControl:ClearAnchors()
		flagControl:SetAnchor(LEFT, EsoBRUI, LEFT, 14 +count*34, 0)
		count = count + 1
	end
	EsoBRUI:SetDimensions(25 +count*34, 50)
	EsoBRUI:SetMouseEnabled(true)
end

function EsoBR:GetLanguage()
	local lang = GetCVar("language.2")
	
	if(lang == "br") then return lang end
	return "en"
end

function EsoBR:SCTFix()
	if EsoBR:GetLanguage() == "br" then
		SetSCTKeyboardFont("EsoBR/fonts/univers67.otf|29|soft-shadow-thick")
		SetNameplateKeyboardFont("EsoBR/fonts/univers67.otf", 4)
	end
end

function EsoBR:StartupMessage()
	local AddOnManager = GetAddOnManager()
	
	for addonIndex = 1, AddOnManager:GetNumAddOns() do
		local addonName, _, _, _, _, _, isOutOfDate = AddOnManager:GetAddOnInfo(addonIndex)
		if addonName == "EsoBR" and isOutOfDate == true then
			EsoBR:ShowMsgBox("Atualização Necessária", "\n\n\n|ac|t256:256:EsoBR/Textures/logo.dds|t\n\n\n\n\n|al |ceeeeeeSua versão|r EsoBR |ceeeeeeestá desatualizada. \nRecomendamos baixar a nova versão do site oficial:|r\n\nhttp://www.universoeso.com.br/traducao. \n\nUsar a versão antiga pode resultar em partes ausentes do texto ou outros problemas.", 3)
		end
	end
	
	EVENT_MANAGER:UnregisterForEvent("EsoBR_StartupMessage", EVENT_PLAYER_ACTIVATED)
end

function EsoBR:MapNameStyle()		
	if EsoBR.Settings.ShowLocations == "Português+Inglês" or EsoBR.Settings.ShowLocations == "Inglês+Português" then
		ZO_WorldMapCornerTitle:SetFont("ZoFontWinH3")
	else
		ZO_WorldMapCornerTitle:SetFont("ZoFontWinH1")
	end
	
	local scrollData = ZO_ScrollList_GetDataList(ZO_WorldMapLocationsList)
	ZO_ClearNumericallyIndexedTable(scrollData)
	WORLD_MAP_LOCATIONS_DATA:RefreshLocationList()
	WORLD_MAP_LOCATIONS:BuildLocationList()
end

function EsoBR:OnInit(eventCode, addOnName)
	if zo_strlower(addOnName) ~= zo_strlower(EsoBR.Name) then return end
	EVENT_MANAGER:UnregisterForEvent("EsoBR_OnAddOnLoaded", EVENT_ADD_ON_LOADED)
	
	EsoBR.Settings = ZO_SavedVars:NewAccountWide("EsoBRVariables", 1, nil, EsoBR.Defaults)
	EsoBR.SettingsCharacter = ZO_SavedVars:New("EsoBRVariables", 1, nil, EsoBR.DefaultsCharacter)
	
	if EsoBR.SettingsCharacter.IsFirstLaunch == true then
		SetSetting(SETTING_TYPE_SUBTITLES, SUBTITLE_SETTING_ENABLED, "true")
		EsoBR.SettingsCharacter.IsFirstLaunch = false
	end
	
	if EsoBR.Settings.IsFirstLaunchGlobal == true then
		SetCVar("IgnorePatcherLanguageSetting", "1")
		
		if EsoBR:GetLanguage() == "br" then
			EsoBR.Settings.IsFirstLaunchGlobal = false
			EsoBR:ShowMsgBox("Instalação ESOBR", "\n\n\n|ac|t256:256:EsoBR/Textures/logo.dds|t\n\n\n\n\n|alAs configurações iniciais foram concluídas. Agora seu jogo será sempre executado na linguagem selecionada.\n\nPara alterar o idioma, pressione a tecla ESC e use o painel com bandeiras no canto inferior direito. Além disso, alterar o idioma pode ser atribuído à teclas de atalho nas configurações de controle.\n\nVocê pode alterar as configurações de tradução (por exemplo, ativar a exibição de nomes de personagens e lugares nas duas línguas) no menu:\nESC -> Configurações -> Add-ons -> EsoBR", 2)
		else
			EsoBR:ShowMsgBox("Instalação do ESOBR", "\n\n\n|ac|t256:256:EsoBR/Textures/logo.dds|t\n\n\n\n\n|alObrigado por instalar a tradução não-oficial para português de The Elder Scrolls Online!\n\nEsse é seu primeiro login, então você ainda não trocou o idioma para o português\n\nMudar o idioma agora?", 1)
		end
	end
	
	optionsTable = {
		[1] = {
			type = "header",
			name = "Exibição de Nomes",
			width = "full",	--or "half" (optional)
		},
		[2] = {
			type = "dropdown",
			name = "Nomes de Personagens",
			tooltip = "Essa opção permite personalizar a exibição de nome de personagens.",
			choices = {"Somente Português", "Português+Inglês", "Inglês+Português", "Somente Inglês"},
			getFunc = function() return EsoBR.Settings.ShowNPC end,
			setFunc = (function(value)
					EsoBR.Settings.ShowNPC = value
					
					if value ~= "Somente Português" and EsoBR_doubleNamesNPC then
						EsoBR_doubleNamesNPC(EsoBR)
					end
				end),
			width = "full",
		},
		[3] = {
			type = "dropdown",
			name = "Nomes de Lugares",
			tooltip = "Essa opção permite personalizar a exibição de nomes de lugares.",
			choices = {"Somente Português", "Português+Inglês", "Inglês+Português", "Somente Inglês"},
			getFunc = function() return EsoBR.Settings.ShowLocations end,
			setFunc = (function(value)
					EsoBR.Settings.ShowLocations = value
					
					if value ~= "Somente Português" and EsoBR_doubleNamesLocations then
						EsoBR_doubleNamesLocations(EsoBR)
					end
					
					FRIENDS_LIST_MANAGER:BuildMasterList()
					FRIENDS_LIST_MANAGER:OnSocialDataLoaded()
					GUILD_ROSTER_MANAGER:BuildMasterList()
					GUILD_ROSTER_MANAGER:OnGuildDataLoaded()
					
					LFGDoubleNames(EsoBR)
					
					CADWELLS_ALMANAC:RefreshList()
					CALLBACK_MANAGER:FireCallbacks("OnWorldMapChanged")
					EsoBR:MapNameStyle()
				end),
			width = "full",
		},
		[4] = {
			type = "header",
			name = "Outros",
			width = "full",	--or "half" (opcjonalne)
		},
		[5] = {
			type = "checkbox",
			name = "Manter linguagem na próxima inicialização",
			tooltip = "Quando essa opção estiver ativada, o jogo será iniciado no idioma selecionado durante o jogo anterior.",
			getFunc = function()
				if GetCVar("IgnorePatcherLanguageSetting") == "1" then
					return true
				else
					return false
				end
			return GetCVar("IgnorePatcherLanguageSetting") end,
			setFunc = function(value)
				if value == true then
					SetCVar("IgnorePatcherLanguageSetting", "1")
				else
					SetCVar("IgnorePatcherLanguageSetting", "0")
				end
			end,
		},
	}
	
	for _, flagCode in pairs(EsoBR.Flags) do
		ZO_CreateStringId("SI_BINDING_NAME_"..string.upper(flagCode), string.upper(flagCode))
	end

	EsoBR:RefreshUI()
	
	EsoBRUI:ClearAnchors()
	EsoBRUI:SetAnchor(EsoBR.Settings.Anchor[1], GuiRoot, EsoBR.Settings.Anchor[2], EsoBR.Settings.Anchor[3], EsoBR.Settings.Anchor[4])
	
	local LAM = LibStub("LibAddonMenu-2.0")
	LAM:RegisterAddonPanel("EsoBR", panelData)
	LAM:RegisterOptionControls("EsoBR", optionsTable)
	
	if EsoBR:GetLanguage() == "br" then
		ZO_CreateStringId("SI_BINDING_NAME_ESOBR_EN", "Língua inglesa")
		ZO_CreateStringId("SI_BINDING_NAME_ESOBR_BR", "Língua Portuguesa")
		
		EsoBR_init()
	else	
		ZO_CreateStringId("SI_BINDING_NAME_ESOBR_EN", "Mudou para o inglês")
		ZO_CreateStringId("SI_BINDING_NAME_ESOBR_BR", "Mudou para o português")
	end
	
	function ZO_GameMenu_OnShow(control)
		if control.OnShow then
			control.OnShow(control.gameMenu)
			EsoBRUI:SetHidden(hidden)
		end
	end
	
	function ZO_GameMenu_OnHide(control)
		if control.OnHide then
			control.OnHide(control.gameMenu)
			EsoBRUI:SetHidden(not hidden)
		end
	end
end

function EsoBR:CloseMsgBox()
	ZO_Dialogs_ReleaseDialog("EsoBRDialog", false)
end

function EsoBR:ShowMsgBox(title, msg, typ)

	local callback = {}
	
	if typ == 1 then
		callback = {
			[1] = 
			{
				keybind = "DIALOG_PRIMARY",
				text = "Mudar", 
				callback =
					function ()
						EsoBR_Change("br")
					end,
				clickSound = SOUNDS.DIALOG_ACCEPT,
			},
			[2] =
			{
				keybind = "DIALOG_NEGATIVE",
				text = "Cancelar",
				clickSound = SOUNDS.DIALOG_DECLINE,
			},
		}
	elseif typ == 2 then
		callback = {
			[1] = 
			{
				keybind = "DIALOG_PRIMARY",
				text = SI_OK,
				clickSound = SOUNDS.DIALOG_ACCEPT,
			}
		}--nowy kod start
	elseif typ == 3 then
		callback = {
			[1] = 
			{
				keybind = "DIALOG_PRIMARY",
				text = "Ir para a página", 
				callback =
					function ()
						RequestOpenUnsafeURL("http://www.universoeso.com.br/traducao")
					end,
				clickSound = SOUNDS.DIALOG_ACCEPT,
			},
			[2] =
			{
				keybind = "DIALOG_NEGATIVE",
				text = "Cancelar",
				clickSound = SOUNDS.DIALOG_DECLINE,
			},
		}
	end
	
	local confirmDialog = 
	{
		canQueue = true,
		onlyQueueOnce = true,
		gamepadInfo = { dialogType = GAMEPAD_DIALOGS.BASIC },
		title = { text = title },
		mainText = { text = msg },
		buttons = callback
	}
	
	ZO_Dialogs_RegisterCustomDialog("EsoBRDialog", confirmDialog)
	EsoBR:CloseMsgBox()
	
	--if IsInGamepadPreferredMode() then
	--	zo_callLater(function()
	--		ZO_Dialogs_ShowGamepadDialog("EsoBRDialog")
	--	end, 500)
	--else
		ZO_Dialogs_ShowDialog("EsoBRDialog")
	--end
end

function EsoBR_init() 
	
	SetSCTKeyboardFont("EsoBR/fonts/univers67.otf|29|soft-shadow-thick")
	SetNameplateKeyboardFont("EsoBR/fonts/univers67.otf", 4)

	LFGDoubleNames(EsoBR)
	
	SafeAddString(SI_DIGIT_GROUP_SEPARATOR, " ", 1)
	
	local DIGIT_GROUP_REPLACER_THRESHOLD = zo_pow(10, GetDigitGroupingSize())
		
	function ZO_CommaDelimitNumber(amount)
		if amount < DIGIT_GROUP_REPLACER_THRESHOLD then
			return tostring(amount)
		end

		return FormatIntegerWithDigitGrouping(amount, " ", GetDigitGroupingSize())
	end
	
	ACHIEVEMENTS:UpdateSummary()
	
	if LibStub then
		local LMP = LibStub("LibMediaProvider-1.0", true)
		if LMP then
			LMP.MediaTable.font["Univers 67"] = nil 
			LMP.MediaTable.font["Univers 57"] = nil
			LMP.MediaTable.font["Univers 55"] = nil
			LMP.MediaTable.font["Skyrim Handwritten"] = nil
			LMP.MediaTable.font["ProseAntique"] = nil
			LMP.MediaTable.font["Trajan Pro"] = nil
			LMP:Register("font", "Univers 67", "EsoBR/fonts/univers67.otf")
			LMP:Register("font", "Univers 57", "EsoBR/fonts/univers57.otf")
			LMP:Register("font", "Univers 55", "EsoBR/fonts/univers57.otf")
			LMP:Register("font", "Skyrim Handwritten", "EsoBR/fonts/handwritten_bold.otf")
			LMP:Register("font", "ProseAntique", "EsoBR/fonts/ProseAntique.otf")
			LMP:Register("font", "Trajan Pro", "EsoBR/fonts/trajanpro-regular.otf")
			LMP:SetDefault("font", "Univers 57")
		end
	end
	
	if LWF3 then
		LWF3.data.Fonts = {
			["ESO Cartographer"] = "EsoBR/fonts/univers57.otf",
			["Fontin Bold"] = "EsoBR/fonts/univers57.otf",
			["Fontin Italic"] = "EsoBR/fonts/univers57.otf",
			["Fontin Regular"] = "EsoBR/fonts/univers57.otf",
			["Fontin SmallCaps"] = "EsoBR/fonts/univers57.otf",
			["ProseAntique"] = "EsoBR/fonts/ProseAntique.otf",
			["Skyrim Handwritten"]= "EsoBR/fonts/handwritten_bold.otf",
			["Trajan Pro"] = "EsoBR/fonts/trajanpro-regular.otf",
			["Univers 55"] = "EsoBR/fonts/univers57.otf",
			["Univers 57"] = "EsoBR/fonts/univers57.otf",
			["Univers 67"] = "EsoBR/fonts/univers67.otf",
		}
	end
	
	if LWF4 then
		LWF4.data.Fonts = {
			["ESO Cartographer"] = "EsoBR/fonts/univers57.otf",
			["Fontin Bold"] = "EsoBR/fonts/univers67.otf",
			["Fontin Italic"] = "EsoBR/fonts/univers57.otf",
			["Fontin Regular"] = "EsoBR/fonts/univers57.otf",
			["Fontin SmallCaps"] = "EsoBR/fonts/univers57.otf",
			["ProseAntique"] = "EsoBR/fonts/ProseAntique.otf",
			["Skyrim Handwritten"]= "EsoBR/fonts/handwritten_bold.otf",
			["Trajan Pro"] = "EsoBR/fonts/trajanpro-regular.otf",
			["Univers 55"] = "EsoBR/fonts/univers57.otf",
			["Univers 57"] = "EsoBR/fonts/univers57.otf",
			["Univers 67"] = "EsoBR/fonts/univers67.otf",
		}
	end
	
	ZO_ReticleContainerInteract:SetHandler("OnEffectivelyShown", function(...)
		ZO_ReticleContainerInteractContext:SetText(ZO_CachedStrFormat(SI_ZONE_NAME, ZO_ReticleContainerInteractContext:GetText()))
	end)
	
	ZO_ReticleContainerNonInteract:SetHandler("OnEffectivelyShown", function(...)
		ZO_ReticleContainerNonInteractText:SetText(zo_strformat(SI_ZONE_NAME, ZO_ReticleContainerNonInteractText:GetText()))
	end)
	
	ZO_SetClockFormat(TIME_FORMAT_PRECISION_TWENTY_FOUR_HOUR)
	
	if ZO_GuildHomeFounded ~= nil then
		local guildDate = ZO_GuildHomeFounded:GetText()
		ZO_GuildHomeFounded:SetText(dateFormat(guildDate))
	end
	
	if EsoBR.Settings.ShowLocations ~= "Somente Português" and EsoBR_doubleNamesLocations then
		EsoBR_doubleNamesLocations(EsoBR)
	else
		local GetMapLocationTooltipHeaderOld = GetMapLocationTooltipHeader
		
		function GetMapLocationTooltipHeader(...)
			return ZO_CachedStrFormat(SI_ZONE_NAME, GetMapLocationTooltipHeaderOld(...))
		end
	end
	
	if EsoBR.Settings.ShowNPC ~= "Somente Português" and EsoBR_doubleNamesNPC then
		EsoBR_doubleNamesNPC(EsoBR)
	end
	
	local GetAchievementInfoOld = GetAchievementInfo
	
	function GetAchievementInfo(...)
		local achievementName, description, points, icon, completed, date, time = GetAchievementInfoOld(...)
		return achievementName, description, points, icon, completed, dateFormat(date), time
	end
	
	local FormatAchievementLinkTimestampOld = FormatAchievementLinkTimestamp
	
	function FormatAchievementLinkTimestamp(...)
		local date, time = FormatAchievementLinkTimestampOld(...)
		return dateFormat(date), time
	end
end

function EsoBR_SaveAnchor()
	local isValidAnchor, point, relativeTo, relativePoint, offsetX, offsetY = EsoBRUI:GetAnchor()
	if isValidAnchor then
		EsoBR.Settings.Anchor = { point, relativePoint, offsetX, offsetY }
	end
end

local GetGuildFoundedDateOld = GetGuildFoundedDate

function GetGuildFoundedDate(...)
	if EsoBR:GetLanguage() == "br" then
		return dateFormat(GetGuildFoundedDateOld(...))
	end
	
	return GetGuildFoundedDateOld(...)
end

function dateFormat(entry)
	if entry == nil then
		return entry
	end

	local sep, fields = "/", {}
	local pattern = string.format("([^%s]+)", sep)
	entry:gsub(pattern, function(c) fields[#fields+1] = c end)
	if fields[3] == nil then
		return entry
	end
	local dd, mm, yy = fields[2], fields[1], fields[3]
	
	if dd:len() == 1 then
		dd = "0" .. dd
	end
	
	if mm:len() == 1 then
		mm = "0" .. mm
	end
	
	return dd .. "." .. mm .. "." .. yy
end

EVENT_MANAGER:RegisterForEvent("EsoBR_OnAddOnLoaded", EVENT_ADD_ON_LOADED, function(_event, _name) EsoBR:OnInit(_event, _name) end)
EVENT_MANAGER:RegisterForEvent("EsoBR_SCTFix", EVENT_PLAYER_ACTIVATED, function(...) EsoBR:SCTFix() end)
EVENT_MANAGER:RegisterForEvent("EsoBR_StartupMessage", EVENT_PLAYER_ACTIVATED, function(...) EsoBR:StartupMessage() end)

ZO_CompassCenterOverPinLabel:SetHandler("OnTextChanged", function() 
	local pinLabelText = ZO_CompassCenterOverPinLabel:GetText()
	
	if pinLabelText ~= nil and pinLabelText ~= "" then
		ZO_CompassCenterOverPinLabel:SetText(ZO_CachedStrFormat(SI_UNIT_NAME, pinLabelText))
	end
end)