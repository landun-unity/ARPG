--
-- 逻辑服务器 --> 客户端
-- 同步一个玩家视野内的所有线
-- @author czx
--
local List = require("common/List");

local LineInfo = require("MessageCommon/Msg/L2C/Map/LineInfo");

local GameMessage = require("common/Net/GameMessage");
local SynePlayerAllLine = class("SynePlayerAllLine", GameMessage);

--
-- 构造函数
--
function SynePlayerAllLine:ctor()
    SynePlayerAllLine.super.ctor(self);
    --
    -- 所有的线信息
    --
    self.allLineList = List.new();
end

--@Override
function SynePlayerAllLine:_OnSerial() 
    
    local allLineListCount = self.allLineList:Count();
    self:WriteInt32(allLineListCount);
    for allLineListIndex = 1, allLineListCount, 1 do 
        local allLineListValue = self.allLineList:Get(allLineListIndex);
        
        self:WriteInt64(allLineListValue.lineId);
        self:WriteInt64(allLineListValue.startTime);
        self:WriteInt64(allLineListValue.endTime);
        self:WriteInt32(allLineListValue.startTiled);
        self:WriteInt32(allLineListValue.endTiled);
        self:WriteInt64(allLineListValue.playerId);
        self:WriteString(allLineListValue.playerName);
        self:WriteInt64(allLineListValue.leagueId);
        self:WriteInt64(allLineListValue.superiorLeagueId);
        self:WriteInt64(allLineListValue.buildingId);
        self:WriteInt32(allLineListValue.armySlotIndex);
        self:WriteBoolean(allLineListValue.isHaveStartTiledView);
        self:WriteBoolean(allLineListValue.isHaveEndTiledView);
        self:WriteBoolean(allLineListValue.isHaveStartPersionalView);
        self:WriteBoolean(allLineListValue.isHaveEndPersionalView);
    end
end

--@Override
function SynePlayerAllLine:_OnDeserialize() 
    
    local allLineListCount = self:ReadInt32();
    for i = 1, allLineListCount, 1 do 
        local allLineListValue = LineInfo.new();
        allLineListValue.lineId = self:ReadInt64();
        allLineListValue.startTime = self:ReadInt64();
        allLineListValue.endTime = self:ReadInt64();
        allLineListValue.startTiled = self:ReadInt32();
        allLineListValue.endTiled = self:ReadInt32();
        allLineListValue.playerId = self:ReadInt64();
        allLineListValue.playerName = self:ReadString();
        allLineListValue.leagueId = self:ReadInt64();
        allLineListValue.superiorLeagueId = self:ReadInt64();
        allLineListValue.buildingId = self:ReadInt64();
        allLineListValue.armySlotIndex = self:ReadInt32();
        allLineListValue.isHaveStartTiledView = self:ReadBoolean();
        allLineListValue.isHaveEndTiledView = self:ReadBoolean();
        allLineListValue.isHaveStartPersionalView = self:ReadBoolean();
        allLineListValue.isHaveEndPersionalView = self:ReadBoolean();
        self.allLineList:Push(allLineListValue);
    end
end

return SynePlayerAllLine;
