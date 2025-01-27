﻿--[[--
Lilia's configuration options.

This is meant to override Lilia's configuration options.
]]
-- @configuration Lilia
--- A list of available commands for use within the game.
-- Each command is represented by a table with fields defining its functionality.
-- @realm shared
-- @table ConfigList
-- @field WalkSpeed Controls how fast characters walk | **integer**
-- @field RunSpeed Controls how fast characters run | **integer**
-- @field WalkRatio Defines the walk speed ratio when holding the Alt key | **number**.
-- @field AllowExistNames Determines whether duplicated character names are allowed | **boolean**.
-- @field GamemodeName Specifies the name of the gamemode | **string**.
-- @field Color Sets the theme color used throughout the gamemode | **color**.
-- @field Font Specifies the core font used for UI elements | **string**.
-- @field GenericFont Specifies the secondary font used for UI elements | **string**.
-- @field MoneyModel Defines the model used for representing money in the game | **string**.
-- @field MaxCharacters Sets the maximum number of characters per player | **integer**
-- @field DataSaveInterval Time interval between data saves | **integer**
-- @field CharacterDataSaveInterval Time interval between character data saves | **integer**
-- @field MoneyLimit Sets the limit of money a player can have **[0 for infinite] | **integer**
-- @field invW Defines the width of the default inventory | **integer**
-- @field invH Defines the height of the default inventory | **integer**
-- @field DefaultMoney Specifies the default amount of money a player starts with | **integer**
-- @field MaxChatLength Sets the maximum length of chat messages | **integer**
-- @field CurrencySymbol Specifies the currency symbol used in the game | **string**.
-- @field SpawnTime Time to respawn after death | **integer**
-- @field MaxAttributes Maximum attributes a character can have | **integer**
-- @field EquipDelay Time delay between equipping items | **integer**
-- @field DropDelay Time delay between dropping items | **integer**
-- @field TakeDelay Time delay between taking items | **integer**
-- @field CurrencySingularName Singular name of the in-game currency | **string**.
-- @field CurrencyPluralName Plural name of the in-game currency | **string**.
-- @field SchemaYear Year in the gamemode's schema | **integer**
-- @field AmericanDates Determines whether to use the American date format | **boolean**.
-- @field AmericanTimeStamp Determines whether to use the American timestamp format | **boolean**.
-- @field MinDescLen Minimum length required for a character's description | **integer**
-- @field AdminConsoleNetworkLogs Specifies if the logging system should replicate to admins' consoles | **boolean**
-- @field TimeToEnterVehicle Time **[in seconds]** required to enter a vehicle | **integer**
-- @field CarEntryDelayEnabled Determines if the car entry delay is applicable | **boolean**.
-- @field Notify Contains notification sound and volume settings | **table**.
-- @field Notify.Sound Notification sound file path | **string**.
-- @field Notify.Volume Notification volume | **integer**
-- @field Notify.Pitch Notification pitch | **integer**
lia.config.WalkSpeed = 130
lia.config.RunSpeed = 235
lia.config.WalkRatio = 0.5
lia.config.AllowExistNames = true
lia.config.GamemodeName = "A Lilia Gamemode"
lia.config.Color = Color(103, 58, 183)
lia.config.Font = "Arial"
lia.config.GenericFont = "Segoe UI"
lia.config.MoneyModel = "models/props_lab/box01a.mdl"
lia.config.MaxCharacters = 2
lia.config.DataSaveInterval = 600
lia.config.CharacterDataSaveInterval = 300
lia.config.MoneyLimit = 1000
lia.config.invW = 9
lia.config.invH = 3
lia.config.DefaultMoney = 50
lia.config.MaxChatLength = 620
lia.config.CurrencySymbol = ""
lia.config.SpawnTime = 8
lia.config.MaxAttributes = 30
lia.config.EquipDelay = 0
lia.config.UnequipDelay = 0
lia.config.DropDelay = 2
lia.config.TakeDelay = 0
lia.config.CurrencySingularName = "Amerikamark"
lia.config.CurrencyPluralName = "Amerikamarks"
lia.config.SchemaYear = 1962
lia.config.AmericanDates = true
lia.config.AmericanTimeStamp = true
lia.config.MinDescLen = 16
lia.config.AdminConsoleNetworkLogs = false
lia.config.TimeToEnterVehicle = 4
lia.config.CarEntryDelayEnabled = true
lia.config.ServerWorkshopID = ""
lia.config.Notify = {"garrysmod/content_downloaded.wav", 50, 250}
