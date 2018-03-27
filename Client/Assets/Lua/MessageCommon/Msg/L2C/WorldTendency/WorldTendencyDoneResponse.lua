--
-- 逻辑服务器 --> 客户端
-- 天下大势达成返回通知
-- @author czx
--
local GameMessage = require("common/Net/GameMessage");
local WorldTendencyDoneResponse = class("WorldTendencyDoneResponse", GameMessage);

--
-- 构造函数
--
function WorldTendencyDoneResponse:ctor()
    WorldTendencyDoneResponse.super.ctor(self);
    --
    -- 天下大势的id
    --
    self.tableId = 0;
end

--@Override
function WorldTendencyDoneResponse:_OnSerial() 
    self:WriteInt32(self.tableId);
end

--@Override
function WorldTendencyDoneResponse:_OnDeserialize() 
    self.tableId = self:ReadInt32();
end

return WorldTendencyDoneResponse;
