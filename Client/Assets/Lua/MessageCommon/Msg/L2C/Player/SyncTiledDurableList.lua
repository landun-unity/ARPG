--
-- 逻辑服务器 --> 客户端
-- 同步格子信息
-- @author czx
--
local List = require("common/List");

local TiledDurable = require("MessageCommon/Msg/L2C/Player/TiledDurable");

local GameMessage = require("common/Net/GameMessage");
local SyncTiledDurableList = class("SyncTiledDurableList", GameMessage);

--
-- 构造函数
--
function SyncTiledDurableList:ctor()
    SyncTiledDurableList.super.ctor(self);
    --
    -- 格子耐久信息
    --
    self.tiledDuarble = List.new();
end

--@Override
function SyncTiledDurableList:_OnSerial() 
    
    local tiledDuarbleCount = self.tiledDuarble:Count();
    self:WriteInt32(tiledDuarbleCount);
    for tiledDuarbleIndex = 1, tiledDuarbleCount, 1 do 
        local tiledDuarbleValue = self.tiledDuarble:Get(tiledDuarbleIndex);
        
        self:WriteInt32(tiledDuarbleValue.tiledId);
        self:WriteInt32(tiledDuarbleValue.tiledCurDurable);
        self:WriteInt32(tiledDuarbleValue.tiledMaxDurable);
    end
end

--@Override
function SyncTiledDurableList:_OnDeserialize() 
    
    local tiledDuarbleCount = self:ReadInt32();
    for i = 1, tiledDuarbleCount, 1 do 
        local tiledDuarbleValue = TiledDurable.new();
        tiledDuarbleValue.tiledId = self:ReadInt32();
        tiledDuarbleValue.tiledCurDurable = self:ReadInt32();
        tiledDuarbleValue.tiledMaxDurable = self:ReadInt32();
        self.tiledDuarble:Push(tiledDuarbleValue);
    end
end

return SyncTiledDurableList;
