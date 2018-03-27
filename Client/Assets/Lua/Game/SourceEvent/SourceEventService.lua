local GameService = require("FrameWork/Game/GameService")
local SourceEventManage = require("Game/SourceEvent/SourceEventManage")
local SourceEventHandler = require("Game/SourceEvent/SourceEventHandler")
SourceEventService = class("SourceEventService", GameService)

function SourceEventService:ctor( )
    -- body
    SourceEventService._instance = self;
    SourceEventService.super.ctor(self, SourceEventManage.new(), SourceEventHandler.new());
end


function SourceEventService:Instance()
	return SourceEventService._instance
end

--Çå¿ÕÊý¾Ý
function SourceEventService:Clear()
    self._logic:ctor()
end

function SourceEventService:GetSourceEventCount()
    return self._logic:GetSourceEventCount()
end

function SourceEventService:GetSourceEventByIndex(index)
    return self._logic:GetSourceEventByIndex(index)
end

function SourceEventService:GetSourceEventById(id)
    return self._logic:GetSourceEventById(id)
end

function SourceEventService:isSourceEvent(x,y)
    return self._logic:isSourceEvent(x,y)
end

return SourceEventService

