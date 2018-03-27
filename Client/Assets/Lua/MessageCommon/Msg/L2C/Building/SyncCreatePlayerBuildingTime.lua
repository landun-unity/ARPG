--
-- 逻辑服务器 --> 客户端
-- 创建要塞回复
-- @author czx
--
local GameMessage = require("common/Net/GameMessage");
local SyncCreatePlayerBuildingTime = class("SyncCreatePlayerBuildingTime", GameMessage);

--
-- 构造函数
--
function SyncCreatePlayerBuildingTime:ctor()
    SyncCreatePlayerBuildingTime.super.ctor(self);
    --
    -- 要塞创建完毕时间
    --
    self.createBuildingTime = 0;

    --
    -- 当前时间
    --
    self.createTime = 0;
end

--@Override
function SyncCreatePlayerBuildingTime:_OnSerial() 
    self:WriteInt64(self.createBuildingTime);
    self:WriteInt64(self.createTime);
end

--@Override
function SyncCreatePlayerBuildingTime:_OnDeserialize() 
    self.createBuildingTime = self:ReadInt64();
    self.createTime = self:ReadInt64();
end

return SyncCreatePlayerBuildingTime;
