--
-- 逻辑服务器 --> 客户端
-- 同步格子信息
-- @author czx
--
local List = require("common/List");

local TiledInfoForPower = require("MessageCommon/Msg/L2C/Map/TiledInfoForPower");

local GameMessage = require("common/Net/GameMessage");
local SyncPlayerAllTiled = class("SyncPlayerAllTiled", GameMessage);

--
-- 构造函数
--
function SyncPlayerAllTiled:ctor()
    SyncPlayerAllTiled.super.ctor(self);
    --
    -- 玩家所有的格子
    --
    self.playerAllTiledList = List.new();
end

--@Override
function SyncPlayerAllTiled:_OnSerial() 
    
    local playerAllTiledListCount = self.playerAllTiledList:Count();
    self:WriteInt32(playerAllTiledListCount);
    for playerAllTiledListIndex = 1, playerAllTiledListCount, 1 do 
        local playerAllTiledListValue = self.playerAllTiledList:Get(playerAllTiledListIndex);
        
        self:WriteInt32(playerAllTiledListValue.tiledId);
        self:WriteInt32(playerAllTiledListValue.tiledTableId);
        self:WriteInt32(playerAllTiledListValue.curDurableVal);
        self:WriteInt32(playerAllTiledListValue.maxDurableVal);
        self:WriteInt64(playerAllTiledListValue.buildingId);
        self:WriteInt32(playerAllTiledListValue.buildingTableId);
        self:WriteInt32(playerAllTiledListValue.isHaveTown);
        self:WriteInt64(playerAllTiledListValue.buildingIdForTown);
        self:WriteInt32(playerAllTiledListValue.buildingTableIdForTown);
    end
end

--@Override
function SyncPlayerAllTiled:_OnDeserialize() 
    
    local playerAllTiledListCount = self:ReadInt32();
    for i = 1, playerAllTiledListCount, 1 do 
        local playerAllTiledListValue = TiledInfoForPower.new();
        playerAllTiledListValue.tiledId = self:ReadInt32();
        playerAllTiledListValue.tiledTableId = self:ReadInt32();
        playerAllTiledListValue.curDurableVal = self:ReadInt32();
        playerAllTiledListValue.maxDurableVal = self:ReadInt32();
        playerAllTiledListValue.buildingId = self:ReadInt64();
        playerAllTiledListValue.buildingTableId = self:ReadInt32();
        playerAllTiledListValue.isHaveTown = self:ReadInt32();
        playerAllTiledListValue.buildingIdForTown = self:ReadInt64();
        playerAllTiledListValue.buildingTableIdForTown = self:ReadInt32();
        self.playerAllTiledList:Push(playerAllTiledListValue);
    end
end

return SyncPlayerAllTiled;
