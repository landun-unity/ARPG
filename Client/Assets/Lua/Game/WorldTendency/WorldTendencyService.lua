-- region *.lua
-- Date
-- 此文件由[BabeLua]插件自动生成


local GameService = require("FrameWork/Game/GameService");
local WorldTendencyHandler = require("Game/WorldTendency/WorldTendencyHandler");
local WorldTendencyManage = require("Game/WorldTendency/WorldTendencyManage");
WorldTendencyService = class("WorldTendencyService", GameService);


function WorldTendencyService:ctor()


    WorldTendencyService._instance = self;

    WorldTendencyService.super.ctor(self, WorldTendencyManage.new(), WorldTendencyHandler.new());
end

-- 单例
function WorldTendencyService:Instance()
    return WorldTendencyService._instance;
end

--清空数据
function WorldTendencyService:Clear()
    self._logic:ctor()
end

function WorldTendencyService:GetWorldEventList()

    return self._logic:GetWorldEventList()

end

function WorldTendencyService:SendWorldTendencyMessage()

    return self._logic:SendWorldTendencyMessage()

end

function WorldTendencyService:SendGetAwardMessage(tableId)

    return self._logic:SendGetAwardMessage(tableId)

end

function WorldTendencyService:SetCanShow(args)
    
    self._logic:SetCanShow(args)
        
end 

function WorldTendencyService:GetCanShow()
    return self._logic:GetCanShow()
end

return WorldTendencyService
-- endregion
