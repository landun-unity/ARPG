
-- 弹出地图Service

local GameService = require("FrameWork/Game/GameService")

local PmapHandler = require("Game/Popupmap/PmapHandler")
local PmapManage = require("Game/Popupmap/PmapManage");
PmapService = class("PmapService", GameService)

-- 构造函数
function PmapService:ctor()

    PmapService._instance = self;
    PmapService.super.ctor(self, PmapManage.new(), PmapHandler.new());
end

-- 单例
function PmapService:Instance()
    return PmapService._instance;
end

-- 清空数据
function PmapService:Clear()
    self._logic:ctor()
end

function PmapService:GetInfoList()
    return self._logic:GetInfoList()
end


---- 存储上次跳转的位置
function PmapService:SetLastMapPos(pos)
    self._logic:SetLastMapPos(pos)
end
function PmapService:GetLastMapPos()
    return self._logic:GetLastMapPos()
end


function PmapService:GetLeagueMarkList()

    return self._logic:GetLeagueMarkList()

end

function PmapService:SetIsFirstMap(args)
    self._logic:SetIsFirstMap(args)
end

function PmapService:GetIsFirstMap()
    return self._logic:GetIsFirstMap()
end


function PmapService:GetStateIDbyIndex(index)

    return self._logic:GetStateIdByIndex(index)

end

function PmapService:Move(rect, x, y)

    return self._logic:Move(rect, x, y)

end

-- 获取NPC城池
function PmapService:GetNPCBuildingList()

    return self._logic:GetNPCBuildingList()
end

-- 获取NPC城池数量
function PmapService:GetNPCBuildingListCount()

    return self._logic:GetNPCBuildingListCount()

end

-- NPC城池数量
function PmapService:SetNPCity()

    return self._logic:SetNPCBuildingList()

end


return PmapService