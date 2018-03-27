--
-- 逻辑服务器 --> 客户端
-- 要塞升级
-- @author czx
--
local GameMessage = require("common/Net/GameMessage");
local CreateSubCityTime = class("CreateSubCityTime", GameMessage);

--
-- 构造函数
--
function CreateSubCityTime:ctor()
    CreateSubCityTime.super.ctor(self);
    --
    -- 创建时间
    --
    self.endTime = 0;
    
    --
    -- 格子索引
    --
    self.index = 0;
end

--@Override
function CreateSubCityTime:_OnSerial() 
    self:WriteInt64(self.endTime);
    self:WriteInt32(self.index);
end

--@Override
function CreateSubCityTime:_OnDeserialize() 
    self.endTime = self:ReadInt64();
    self.index = self:ReadInt32();
end

return CreateSubCityTime;
