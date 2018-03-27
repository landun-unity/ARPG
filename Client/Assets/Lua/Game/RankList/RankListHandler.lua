--region *.lua
--Date
local IOHandler = require("FrameWork/Game/IOHandler")
local RankListHandler = class("RankListHandler", IOHandler)

function RankListHandler:ctor() 
    RankListHandler.super.ctor(self);
end

function RankListHandler:RegisterAllMessage() 
    self:RegisterMessage(L2C_Ranklist.OpenPlayerRanklistRespond, self.GetPersoanlRankList, require("MessageCommon/Msg/L2C/Ranklist/OpenPlayerRanklistRespond"));
    self:RegisterMessage(L2C_Ranklist.OpenLeagueRanklistRespond, self.GetLeagueRankList, require("MessageCommon/Msg/L2C/Ranklist/OpenLeagueRanklistRespond"));
end

function RankListHandler:GetPersoanlRankList(msg)
    --print("个人排行榜回复 count:"..msg.playerList:Count())
    self._logicManage:SavePersoanlRankListInfo(msg);
    self:RefreshRankListUI();
end



function RankListHandler:GetLeagueRankList(msg)
    --print("同盟排行榜回复 count:"..msg.leagueList:Count())
    self._logicManage:SaveLeagueRankListInfo(msg);
    self:RefreshRankListUI();
end

function RankListHandler:RefreshRankListUI()
    local baseClass = UIService:Instance():GetUIClass(UIType.RankListUI);
    if baseClass ~= nil then
        baseClass:ShowRankListInfo();
    end
end

return RankListHandler