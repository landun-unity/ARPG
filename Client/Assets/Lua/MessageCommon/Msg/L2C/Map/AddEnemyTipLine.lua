--
-- 逻辑服务器 --> 客户端
-- 添加一条基于线的敌方提示
-- @author czx
--
local LineInfo = require("MessageCommon/Msg/L2C/Map/LineInfo");

local GameMessage = require("common/Net/GameMessage");
local AddEnemyTipLine = class("AddEnemyTipLine", GameMessage);

--
-- 构造函数
--
function AddEnemyTipLine:ctor()
    AddEnemyTipLine.super.ctor(self);
    --
    -- 线信息
    --
    self.lineInfo = LineInfo.new();
end

--@Override
function AddEnemyTipLine:_OnSerial() 
    self:WriteInt64(self.lineInfo.lineId);
    self:WriteInt64(self.lineInfo.startTime);
    self:WriteInt64(self.lineInfo.endTime);
    self:WriteInt32(self.lineInfo.startTiled);
    self:WriteInt32(self.lineInfo.endTiled);
    self:WriteInt64(self.lineInfo.playerId);
    self:WriteString(self.lineInfo.playerName);
    self:WriteInt64(self.lineInfo.leagueId);
    self:WriteInt64(self.lineInfo.superiorLeagueId);
    self:WriteInt64(self.lineInfo.buildingId);
    self:WriteInt32(self.lineInfo.armySlotIndex);
    self:WriteBoolean(self.lineInfo.isHaveStartTiledView);
    self:WriteBoolean(self.lineInfo.isHaveEndTiledView);
    self:WriteBoolean(self.lineInfo.isHaveStartPersionalView);
    self:WriteBoolean(self.lineInfo.isHaveEndPersionalView);
end

--@Override
function AddEnemyTipLine:_OnDeserialize() 
    self.lineInfo.lineId = self:ReadInt64();
    self.lineInfo.startTime = self:ReadInt64();
    self.lineInfo.endTime = self:ReadInt64();
    self.lineInfo.startTiled = self:ReadInt32();
    self.lineInfo.endTiled = self:ReadInt32();
    self.lineInfo.playerId = self:ReadInt64();
    self.lineInfo.playerName = self:ReadString();
    self.lineInfo.leagueId = self:ReadInt64();
    self.lineInfo.superiorLeagueId = self:ReadInt64();
    self.lineInfo.buildingId = self:ReadInt64();
    self.lineInfo.armySlotIndex = self:ReadInt32();
    self.lineInfo.isHaveStartTiledView = self:ReadBoolean();
    self.lineInfo.isHaveEndTiledView = self:ReadBoolean();
    self.lineInfo.isHaveStartPersionalView = self:ReadBoolean();
    self.lineInfo.isHaveEndPersionalView = self:ReadBoolean();
end

return AddEnemyTipLine;
