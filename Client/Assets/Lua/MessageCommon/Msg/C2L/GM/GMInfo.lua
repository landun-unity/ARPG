--
-- 客户端 --> 逻辑服务器
-- GM
-- @author czx
--
local GameMessage = require("common/Net/GameMessage");
local GMInfo = class("GMInfo", GameMessage);

--
-- 构造函数
--
function GMInfo:ctor()
    GMInfo.super.ctor(self);
    --
    -- GM发送输入的字符串
    --
    self.gMCommand = "";
end

--@Override
function GMInfo:_OnSerial() 
    self:WriteString(self.gMCommand);
end

--@Override
function GMInfo:_OnDeserialize() 
    self.gMCommand = self:ReadString();
end

return GMInfo;
