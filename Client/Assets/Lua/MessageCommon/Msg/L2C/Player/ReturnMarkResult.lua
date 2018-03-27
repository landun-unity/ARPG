--
-- 逻辑服务器 --> 客户端
-- 返回标记信息
-- @author czx
--
local GameMessage = require("common/Net/GameMessage");
local ReturnMarkResult = class("ReturnMarkResult", GameMessage);

--
-- 构造函数
--
function ReturnMarkResult:ctor()
    ReturnMarkResult.super.ctor(self);
    --
    -- 标记名字
    --
    self.name = "";
    
    --
    -- 返回已标记格子index
    --
    self.tiledIndex = 0;
    
    --
    -- 标记类型
    --
    self.type = 0;
end

--@Override
function ReturnMarkResult:_OnSerial() 
    self:WriteString(self.name);
    self:WriteInt32(self.tiledIndex);
    self:WriteInt32(self.type);
end

--@Override
function ReturnMarkResult:_OnDeserialize() 
    self.name = self:ReadString();
    self.tiledIndex = self:ReadInt32();
    self.type = self:ReadInt32();
end

return ReturnMarkResult;
