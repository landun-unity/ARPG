--
-- 逻辑服务器 --> 客户端
-- 删除要塞
-- @author czx
--
local GameMessage = require("common/Net/GameMessage");
local DeleteFort = class("DeleteFort", GameMessage);

--
-- 构造函数
--
function DeleteFort:ctor()
    DeleteFort.super.ctor(self);
    --
    -- 格子索引
    --
    self.index = 0;
    
    --
    -- 建筑物Id
    --
    self.building = 0;
end

--@Override
function DeleteFort:_OnSerial() 
    self:WriteInt32(self.index);
    self:WriteInt64(self.building);
end

--@Override
function DeleteFort:_OnDeserialize() 
    self.index = self:ReadInt32();
    self.building = self:ReadInt64();
end

return DeleteFort;
