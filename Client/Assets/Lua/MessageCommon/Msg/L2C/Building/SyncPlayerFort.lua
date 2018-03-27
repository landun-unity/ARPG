--
-- 逻辑服务器 --> 客户端
-- 同步玩家要塞信息
-- @author czx
--
local List = require("common/List");

local PlayerFortModel = require("MessageCommon/Msg/L2C/Building/PlayerFortModel");

local GameMessage = require("common/Net/GameMessage");
local SyncPlayerFort = class("SyncPlayerFort", GameMessage);

--
-- 构造函数
--
function SyncPlayerFort:ctor()
    SyncPlayerFort.super.ctor(self);
    --
    -- 要塞列表
    --
    self.list = List.new();
end

--@Override
function SyncPlayerFort:_OnSerial() 
    
    local listCount = self.list:Count();
    self:WriteInt32(listCount);
    for listIndex = 1, listCount, 1 do 
        local listValue = self.list:Get(listIndex);
        
        self:WriteInt64(listValue.buildingId);
        self:WriteInt32(listValue.index);
        self:WriteInt32(listValue.tableId);
        self:WriteInt32(listValue.ownerId);
        self:WriteString(listValue.cityName);
        self:WriteInt64(listValue.currentTime);
        self:WriteInt64(listValue.endTime);
        self:WriteInt64(listValue.updateFortTime);
        self:WriteInt64(listValue.abandonFortTime);
        self:WriteInt32(listValue.level);
        self:WriteInt32(listValue.numName);
    end
end

--@Override
function SyncPlayerFort:_OnDeserialize() 
    
    local listCount = self:ReadInt32();
    for i = 1, listCount, 1 do 
        local listValue = PlayerFortModel.new();
        listValue.buildingId = self:ReadInt64();
        listValue.index = self:ReadInt32();
        listValue.tableId = self:ReadInt32();
        listValue.ownerId = self:ReadInt32();
        listValue.cityName = self:ReadString();
        listValue.currentTime = self:ReadInt64();
        listValue.endTime = self:ReadInt64();
        listValue.updateFortTime = self:ReadInt64();
        listValue.abandonFortTime = self:ReadInt64();
        listValue.level = self:ReadInt32();
        listValue.numName = self:ReadInt32();
        self.list:Push(listValue);
    end
end

return SyncPlayerFort;
