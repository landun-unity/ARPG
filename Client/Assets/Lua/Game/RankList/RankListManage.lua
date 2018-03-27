--region *.lua
--Date
local GamePart = require("FrameWork/Game/GamePart")
local RankListManage = class("RankListManage",GamePart)
local List = require("common/List");

function RankListManage:ctor()
    
    RankListManage.super.ctor(self)
  
    self.persoanlRankList = List.new();
    self.leagueRankList = List.new();
end

-- 初始化
function RankListManage:_OnInit()
end

-- 心跳
function RankListManage:_OnHeartBeat()
    
end


function RankListManage:GetMyRank(rankListType,id)
    if  rankListType == RankListType.PersonalRankList then        
        for i=1,self.persoanlRankList:Count() do
            if self.persoanlRankList:Get(i).playerid == id then
                return self.persoanlRankList:Get(i).rankPostion,i;
            end
        end
    else
        for i=1,self.leagueRankList:Count() do
            if self.leagueRankList:Get(i).leagueId == id then
                return self.leagueRankList:Get(i).rankPostion,i;
            end
        end
    end
    return 0,0;
end

function RankListManage:GetRankListInfo(rankListType)
    if  rankListType == RankListType.PersonalRankList then
        return self.persoanlRankList;
    else
        return self.leagueRankList;
    end
end

function RankListManage:SavePersoanlRankListInfo(msg)
    self.persoanlRankList = msg.playerList;
--    for i=1,self.persoanlRankList:Count() do
--        print(self.persoanlRankList:Get(i).name)
--        print(self.persoanlRankList:Get(i).playerid)
--    end
end

function RankListManage:SaveLeagueRankListInfo(msg)
    self.leagueRankList = msg.leagueList;
end

return RankListManage