--
-- 逻辑服务器 --> 客户端
-- 野城占领同盟信息
-- @author czx
--
local List = require("common/List");

local FirstOccupySiegePlayer = require("MessageCommon/Msg/L2C/League/FirstOccupySiegePlayer");
local FirstOccupyKillPlayer = require("MessageCommon/Msg/L2C/League/FirstOccupyKillPlayer");

local GameMessage = require("common/Net/GameMessage");
local WildBuildingOccupyPlayerInfo = class("WildBuildingOccupyPlayerInfo", GameMessage);

--
-- 构造函数
--
function WildBuildingOccupyPlayerInfo:ctor()
    WildBuildingOccupyPlayerInfo.super.ctor(self);
    --
    -- 首次占领同盟ID
    --
    self.firstOccupyLeagueId = 0;
    
    --
    -- 首次占领同盟Name
    --
    self.firstOccupyLeagueName = "";
    
    --
    -- 首次占领同盟盟主ID
    --
    self.firstOccupyLeagueLeaderId = 0;
    
    --
    -- 首次占领同盟盟主名字
    --
    self.firstOccupyLeagueLeaderName = "";
    
    --
    -- 当前占领同盟ID
    --
    self.curOccupyLeagueId = 0;
    
    --
    -- 当前占领同盟Name
    --
    self.curOccupyLeagueName = "";
    
    --
    -- 当前占领同盟盟主ID
    --
    self.curOccupyLeagueLeaderId = 0;
    
    --
    -- 当前占领同盟盟主名字
    --
    self.curOccupyLeagueLeaderName = "";
    
    --
    -- 攻城前三名
    --
    self.topThreeSiegePlayerList = List.new();
    
    --
    -- 杀敌前三名
    --
    self.topThreeKillPlayerList = List.new();
end

--@Override
function WildBuildingOccupyPlayerInfo:_OnSerial() 
    self:WriteInt64(self.firstOccupyLeagueId);
    self:WriteString(self.firstOccupyLeagueName);
    self:WriteInt64(self.firstOccupyLeagueLeaderId);
    self:WriteString(self.firstOccupyLeagueLeaderName);
    self:WriteInt64(self.curOccupyLeagueId);
    self:WriteString(self.curOccupyLeagueName);
    self:WriteInt64(self.curOccupyLeagueLeaderId);
    self:WriteString(self.curOccupyLeagueLeaderName);
    
    local topThreeSiegePlayerListCount = self.topThreeSiegePlayerList:Count();
    self:WriteInt32(topThreeSiegePlayerListCount);
    for topThreeSiegePlayerListIndex = 1, topThreeSiegePlayerListCount, 1 do 
        local topThreeSiegePlayerListValue = self.topThreeSiegePlayerList:Get(topThreeSiegePlayerListIndex);
        
        self:WriteInt64(topThreeSiegePlayerListValue.playerId);
        self:WriteString(topThreeSiegePlayerListValue.name);
        self:WriteInt32(topThreeSiegePlayerListValue.siegeValue);
    end
    
    local topThreeKillPlayerListCount = self.topThreeKillPlayerList:Count();
    self:WriteInt32(topThreeKillPlayerListCount);
    for topThreeKillPlayerListIndex = 1, topThreeKillPlayerListCount, 1 do 
        local topThreeKillPlayerListValue = self.topThreeKillPlayerList:Get(topThreeKillPlayerListIndex);
        
        self:WriteInt64(topThreeKillPlayerListValue.playerId);
        self:WriteString(topThreeKillPlayerListValue.name);
        self:WriteInt32(topThreeKillPlayerListValue.killValue);
    end
end

--@Override
function WildBuildingOccupyPlayerInfo:_OnDeserialize() 
    self.firstOccupyLeagueId = self:ReadInt64();
    self.firstOccupyLeagueName = self:ReadString();
    self.firstOccupyLeagueLeaderId = self:ReadInt64();
    self.firstOccupyLeagueLeaderName = self:ReadString();
    self.curOccupyLeagueId = self:ReadInt64();
    self.curOccupyLeagueName = self:ReadString();
    self.curOccupyLeagueLeaderId = self:ReadInt64();
    self.curOccupyLeagueLeaderName = self:ReadString();
    
    local topThreeSiegePlayerListCount = self:ReadInt32();
    for i = 1, topThreeSiegePlayerListCount, 1 do 
        local topThreeSiegePlayerListValue = FirstOccupySiegePlayer.new();
        topThreeSiegePlayerListValue.playerId = self:ReadInt64();
        topThreeSiegePlayerListValue.name = self:ReadString();
        topThreeSiegePlayerListValue.siegeValue = self:ReadInt32();
        self.topThreeSiegePlayerList:Push(topThreeSiegePlayerListValue);
    end
    
    local topThreeKillPlayerListCount = self:ReadInt32();
    for i = 1, topThreeKillPlayerListCount, 1 do 
        local topThreeKillPlayerListValue = FirstOccupyKillPlayer.new();
        topThreeKillPlayerListValue.playerId = self:ReadInt64();
        topThreeKillPlayerListValue.name = self:ReadString();
        topThreeKillPlayerListValue.killValue = self:ReadInt32();
        self.topThreeKillPlayerList:Push(topThreeKillPlayerListValue);
    end
end

return WildBuildingOccupyPlayerInfo;
