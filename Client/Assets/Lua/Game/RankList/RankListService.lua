--region *.lua
--Date
local GameService = require("FrameWork/Game/GameService")
local RankListHandler = require("Game/RankList/RankListHandler")
local RankListManage = require("Game/RankList/RankListManage");

RankListService = class("RankListService",GameService)

function RankListService:ctor()
    RankListService._instance = self;
    RankListService.super.ctor(self, RankListManage.new(), RankListHandler.new());  
end

-- 单例
function RankListService:Instance()
    return RankListService._instance;
end

function RankListService:GetRankListInfo(rankListType)
     return self._logic:GetRankListInfo(rankListType);
end

function RankListService:GetMyRank(rankListType,id)
    return self._logic:GetMyRank(rankListType,id);
end

return RankListService