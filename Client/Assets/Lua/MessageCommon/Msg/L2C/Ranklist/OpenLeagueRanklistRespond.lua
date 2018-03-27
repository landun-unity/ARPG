--
-- 逻辑服务器 --> 客户端
-- 玩家打开被同盟邀请列表
-- @author czx
--
local List = require("common/List");

local LeagueModel = require("MessageCommon/Msg/L2C/Ranklist/LeagueModel");

local GameMessage = require("common/Net/GameMessage");
local OpenLeagueRanklistRespond = class("OpenLeagueRanklistRespond", GameMessage);

--
-- 构造函数
--
function OpenLeagueRanklistRespond:ctor()
    OpenLeagueRanklistRespond.super.ctor(self);
    --
    -- 同盟排行model
    --
    self.leagueList = List.new();
end

--@Override
function OpenLeagueRanklistRespond:_OnSerial() 
    
    local leagueListCount = self.leagueList:Count();
    self:WriteInt32(leagueListCount);
    for leagueListIndex = 1, leagueListCount, 1 do 
        local leagueListValue = self.leagueList:Get(leagueListIndex);
        
        self:WriteInt64(leagueListValue.leagueId);
        self:WriteInt32(leagueListValue.rankPostion);
        self:WriteString(leagueListValue.name);
        self:WriteString(leagueListValue.countryName);
        self:WriteInt32(leagueListValue.leagueLevel);
        self:WriteInt32(leagueListValue.province);
        self:WriteInt32(leagueListValue.memberNum);
        self:WriteInt32(leagueListValue.wildCityNum);
        self:WriteInt32(leagueListValue.influence);
    end
end

--@Override
function OpenLeagueRanklistRespond:_OnDeserialize() 
    
    local leagueListCount = self:ReadInt32();
    for i = 1, leagueListCount, 1 do 
        local leagueListValue = LeagueModel.new();
        leagueListValue.leagueId = self:ReadInt64();
        leagueListValue.rankPostion = self:ReadInt32();
        leagueListValue.name = self:ReadString();
        leagueListValue.countryName = self:ReadString();
        leagueListValue.leagueLevel = self:ReadInt32();
        leagueListValue.province = self:ReadInt32();
        leagueListValue.memberNum = self:ReadInt32();
        leagueListValue.wildCityNum = self:ReadInt32();
        leagueListValue.influence = self:ReadInt32();
        self.leagueList:Push(leagueListValue);
    end
end

return OpenLeagueRanklistRespond;
