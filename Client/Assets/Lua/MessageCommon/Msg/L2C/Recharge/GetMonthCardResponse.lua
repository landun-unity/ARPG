--
-- 逻辑服务器 --> 客户端
-- 领取月卡回复
-- @author czx
--
local GameMessage = require("common/Net/GameMessage");
local GetMonthCardResponse = class("GetMonthCardResponse", GameMessage);

--
-- 构造函数
--
function GetMonthCardResponse:ctor()
    GetMonthCardResponse.super.ctor(self);
    --
    -- 领取月卡得到的玉数量
    --
    self.addCount = 0;
    
    --
    -- 本次领取月卡的时间戳
    --
    self.lastGetTime = 0;
end

--@Override
function GetMonthCardResponse:_OnSerial() 
    self:WriteInt32(self.addCount);
    self:WriteInt64(self.lastGetTime);
end

--@Override
function GetMonthCardResponse:_OnDeserialize() 
    self.addCount = self:ReadInt32();
    self.lastGetTime = self:ReadInt64();
end

return GetMonthCardResponse;
