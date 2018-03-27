--[[
    事件管理
--]]
local GamePart = require("FrameWork/Game/GamePart")

local EventManage = class("EventManage", GamePart)

-- 构造函数
function EventManage:ctor( )
    EventManage.super.ctor(self)
    self._eventsMap = {}
end

-- 初始化
function EventManage:_OnInit()
end

-- 心跳
function EventManage:_OnHeartBeat()
end

-- 停止
function EventManage:_OnStop()
end

-- 添加事件监听    listener   事件监听回调
function EventManage:AddEventListener(eventType, listener)
	local tempEvent = self._eventsMap[eventType]
	if not tempEvent then
		-- event(eventType)初始化一个事件 添加到_eventsMap中
		self._eventsMap[eventType] = event(eventType)
		tempEvent = self._eventsMap[eventType]
	end
	if tempEvent then
		tempEvent:Add(listener)
	end
end

-- 移除事件监听
function EventManage:RemoveEventListener(eventType, listener)
	local tempEvent = self._eventsMap[eventType]
	if tempEvent then
		tempEvent:Remove(listener)
	end
end

-- 移除所有监听
function EventManage:RemoveAllEventListener(eventType)
	local tempEvent = self._eventsMap[eventType]
	if tempEvent then
		tempEvent:Clear()
	end
end

-- 触发事件监听
function EventManage:TriggerEvent(eventType, ...)
	local tempEvent = self._eventsMap[eventType]
	if tempEvent then
		local args = {...}
		tempEvent(args)
	end
end

return EventManage;
