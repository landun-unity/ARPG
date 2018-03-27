--
-- 客户端 --> 逻辑服务器
-- 删除同盟标记
-- @author czx
--
local GameMessage = require("common/Net/GameMessage");
local RemoveLeagueMark = class("RemoveLeagueMark", GameMessage);

--
-- 构造函数
--
function RemoveLeagueMark:ctor()
    RemoveLeagueMark.super.ctor(self);
    --
    -- 同盟标记index
    --
    self.markIndex = 0;
end

--@Override
function RemoveLeagueMark:_OnSerial() 
    self:WriteInt64(self.markIndex);
end

--@Override
function RemoveLeagueMark:_OnDeserialize() 
    self.markIndex = self:ReadInt64();
end

return RemoveLeagueMark;
