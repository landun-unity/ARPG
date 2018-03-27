--
-- 客户端 --> 逻辑服务器
-- 创建同盟
-- @author czx
--
local GameMessage = require("common/Net/GameMessage");
local CreateLeague = class("CreateLeague", GameMessage);

--
-- 构造函数
--
function CreateLeague:ctor()
    CreateLeague.super.ctor(self);
    --
    -- 同盟名字
    --
    self.name = "";
end

--@Override
function CreateLeague:_OnSerial() 
    self:WriteString(self.name);
end

--@Override
function CreateLeague:_OnDeserialize() 
    self.name = self:ReadString();
end

return CreateLeague;
