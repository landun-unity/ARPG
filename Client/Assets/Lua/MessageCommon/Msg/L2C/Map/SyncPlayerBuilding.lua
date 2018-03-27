--
-- 逻辑服务器 --> 客户端
-- 同步建筑物信息
-- @author czx
--
local List = require("common/List");

local PlayerBuilding = require("MessageCommon/Msg/L2C/Map/PlayerBuilding");

local GameMessage = require("common/Net/GameMessage");
local SyncPlayerBuilding = class("SyncPlayerBuilding", GameMessage);

--
-- 构造函数
--
function SyncPlayerBuilding:ctor()
    SyncPlayerBuilding.super.ctor(self);
    --
    -- 所有的建筑物信息
    --
    self.allPlayerBuildingList = List.new();
end

--@Override
function SyncPlayerBuilding:_OnSerial() 
    
    local allPlayerBuildingListCount = self.allPlayerBuildingList:Count();
    self:WriteInt32(allPlayerBuildingListCount);
    for i = 1, allPlayerBuildingListCount, 1 do 
        local allPlayerBuildingListValue = self.allPlayerBuildingList:Get(i);
        
        self:WriteInt32(allPlayerBuildingListValue.tiledId);
        self:WriteInt64(allPlayerBuildingListValue.ownerId);
        self:WriteInt64(allPlayerBuildingListValue.leagueId);
        self:WriteInt32(allPlayerBuildingListValue.tableId);
    end
end

--@Override
function SyncPlayerBuilding:_OnDeserialize() 
    
    local allPlayerBuildingListCount = self:ReadInt32();
    for i = 1, allPlayerBuildingListCount, 1 do 
        local allPlayerBuildingListValue = PlayerBuilding.new();
        allPlayerBuildingListValue.tiledId = self:ReadInt32();
        allPlayerBuildingListValue.ownerId = self:ReadInt64();
        allPlayerBuildingListValue.leagueId = self:ReadInt64();
        allPlayerBuildingListValue.tableId = self:ReadInt32();
        self.allPlayerBuildingList:Push(allPlayerBuildingListValue);
    end
end

return SyncPlayerBuilding;
