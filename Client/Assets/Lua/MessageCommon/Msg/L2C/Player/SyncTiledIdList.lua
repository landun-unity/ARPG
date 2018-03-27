--
-- 逻辑服务器 --> 客户端
-- 同步玩家的所有建筑物
-- @author czx
--
local List = require("common/List");

local GameMessage = require("common/Net/GameMessage");
local SyncTiledIdList = class("SyncTiledIdList", GameMessage);

--
-- 构造函数
--
function SyncTiledIdList:ctor()
    SyncTiledIdList.super.ctor(self);
    --
    -- 建筑物列表
    --
    self.tiledId = List.new();
end

--@Override
function SyncTiledIdList:_OnSerial() 
    
    local tiledIdCount = self.tiledId:Count();
    self:WriteInt32(tiledIdCount);
    for tiledIdIndex = 1, tiledIdCount, 1 do 
        self:WriteInt32(self.tiledId:Get(tiledIdIndex));
    end
end

--@Override
function SyncTiledIdList:_OnDeserialize() 
    
    local tiledIdCount = self:ReadInt32();
    for i = 1, tiledIdCount, 1 do 
        self.tiledId:Push(self:ReadInt32());
    end
end

return SyncTiledIdList;
