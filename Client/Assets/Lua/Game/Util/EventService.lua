local GameService = require("FrameWork/Game/GameService")

local DefaultHandler = require("FrameWork/Game/DefaultHandler")
local EventManage = require("Game/Util/EventManage");
EventService = class("EventService", GameService)

-- 同步相关的服务
function EventService:ctor( )
    EventService._instance = self;
    EventService.super.ctor(self, EventManage.new(), DefaultHandler.new());
end

-- 单例
function EventService:Instance()
    return EventService._instance;
end

--清空数据
function EventService:Clear()
    self._logic:ctor()
end

-- 添加事件监听
function EventService:AddEventListener(eventType, listener)
	self._logic:AddEventListener(eventType, listener)
end

-- 移除事件监听
function EventService:RemoveEventListener(eventType, listener)
	self._logic:RemoveEventListener(eventType, listener)
end

-- 移除所有事件监听
function EventService:RemoveAllEventListener(eventType)
	self._logic:RemoveAllEventListener(eventType)
end

-- 触发事件监听
function EventService:TriggerEvent(eventType, ...)
	self._logic:TriggerEvent(eventType, ...)
end


return EventService;