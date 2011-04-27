﻿--[[
	itemFrameEvents.lua
		A single event handler for the itemFrame object
--]]

local AddonName, Addon = ...
local FrameEvents = Addon:NewModule('ItemFrameEvents')
local currentPlayer = UnitName('player')
local frames = {}

--[[ Events ]]--

function FrameEvents:ITEM_LOCK_CHANGED(msg, ...)
	--print(msg, ...)
	self:UpdateSlotLock(...)
end

function FrameEvents:UNIT_QUEST_LOG_CHANGED(msg, ...)
	--print(msg, ...)
	self:UpdateBorder(...)
end

function FrameEvents:QUEST_ACCEPTED(msg, ...)
	--print(msg, ...)
	self:UpdateBorder(...)
end

function FrameEvents:ITEM_SLOT_ADD(msg, ...)
	--print(msg, ...)
	self:UpdateSlot(...)
end

function FrameEvents:ITEM_SLOT_REMOVE(msg, ...)
	--print(msg, ...)
	self:RemoveItem(...)
end

function FrameEvents:ITEM_SLOT_UPDATE(msg, ...)
	--print(msg, ...)
	self:UpdateSlot(...)
end

function FrameEvents:ITEM_SLOT_UPDATE_COOLDOWN(msg, ...)
	--print(msg, ...)
	self:UpdateSlotCooldown(...)
end

function FrameEvents:BANK_OPENED(msg, ...)
	--print(msg, ...)
	self:UpdateBankFrames(...)
end

function FrameEvents:BANK_CLOSED(msg, ...)
	--print(msg, ...)
	self:UpdateBankFrames(...)
end


--[[ Update Methods ]]--

function FrameEvents:UpdateBorder(...)
	for f in self:GetFrames() do
		if f:GetPlayer() == currentPlayer then
			f:UpdateBorder(...)
		end
	end
end

function FrameEvents:UpdateSlot(...)
	for f in self:GetFrames() do
		if f:GetPlayer() == currentPlayer then
			if f:UpdateSlot(...) then
				f:RequestLayout()
			end
		end
	end
end

function FrameEvents:RemoveItem(...)
	for f in self:GetFrames() do
		if f:GetPlayer() == currentPlayer then
			if f:RemoveItem(...) then
				f:RequestLayout()
			end
		end
	end
end

function FrameEvents:UpdateSlotLock(...)
	for f in self:GetFrames() do
		if f:GetPlayer() == currentPlayer then
			f:UpdateSlotLock(...)
		end
	end
end

function FrameEvents:UpdateSlotCooldown(...)
	for f in self:GetFrames() do
		if f:GetPlayer() == currentPlayer then
			f:UpdateSlotCooldown(...)
		end
	end
end

function FrameEvents:UpdateBankFrames()
	for f in self:GetFrames() do
		f:Regenerate()
	end
end

function FrameEvents:LayoutFrames()
	for f in self:GetFrames() do
		if f.needsLayout then
			f.needsLayout = nil
			f:Layout()
		end
	end
end

function FrameEvents:RequestLayout()
	self.Updater:Show()
end

function FrameEvents:GetFrames()
	return pairs(frames)
end

function FrameEvents:Register(f)
	frames[f] = true
end

function FrameEvents:Unregister(f)
	frames[f] = nil
end


--[[ Initialization ]]--

do
	local f = CreateFrame('Frame'); f:Hide()
	
	f:SetScript('OnEvent', function(self, event, ...)
		local method = FrameEvents[event]
		if method then
			method(FrameEvents, event, ...)
		end
	end)
	
	f:SetScript('OnUpdate', function(self, elapsed)
		FrameEvents:LayoutFrames()
		self:Hide()
	end)
	
--	f:RegisterEvent('BAG_UPDATE_COOLDOWN')
	f:RegisterEvent('ITEM_LOCK_CHANGED')
	f:RegisterEvent('UNIT_QUEST_LOG_CHANGED')
	f:RegisterEvent('QUEST_ACCEPTED')
	
	FrameEvents.Updater = f
	
	Addon('InventoryEvents'):RegisterMany(
		FrameEvents, 
		'ITEM_SLOT_ADD',
		'ITEM_SLOT_REMOVE',
		'ITEM_SLOT_UPDATE',
		'ITEM_SLOT_UPDATE_COOLDOWN',
		'BANK_OPENED',
		'BANK_CLOSED'
	)
end