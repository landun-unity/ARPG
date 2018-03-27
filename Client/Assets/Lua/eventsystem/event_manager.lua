-- region *.lua
-- Date
-- 此文件由[BabeLua]插件自动生成
local class = require("common/middleclass")

local EventManager = class("EventManager")

--[[初始化--]]
function EventManager:Initialize()
    self._events_map = { }
end

--[[添加事件监听者--]]
function EventManager:AddEventListener(event_type, listener)
    local tmp_event = self._events_map[event_type]
    if not tmp_event then
        self._events_map[event_type] = event(event_type)
        tmp_event = self._events_map[event_type]
    end
    if tmp_event then
        tmp_event:Add(listener)
    end
end

--[[移除事件监听者--]]
function EventManager:RemoveEventListener(event_type, listener)
    local tmp_event = self._events_map[event_type]
    if tmp_event then
        tmp_event:Remove(listener)
    end
end

--[[移除所有事件监听者--]]
function EventManager:RemoveAllEventListener(event_type)
    local tmp_event = self._events_map[event_type]
    if tmp_event then
        tmp_event:Clear()
    end
end

--[[触发事件--]]
function EventManager:TriggerEvent(event_type, ...)
    local tmp_event = self._events_map[event_type]
    if tmp_event then
        local args = { ...}
        tmp_event(args)
    end
end

return EventManager