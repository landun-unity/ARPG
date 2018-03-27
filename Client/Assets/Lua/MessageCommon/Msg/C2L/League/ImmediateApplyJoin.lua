--
-- 客户端 --> 逻辑服务器
-- 直接申请入盟
-- @author czx
--
local GameMessage = require("common/Net/GameMessage");
local ImmediateApplyJoin = class("ImmediateApplyJoin", GameMessage);

--
-- 构造函数
--
function ImmediateApplyJoin:ctor()
    ImmediateApplyJoin.super.ctor(self);
    --
    -- 盟的名字
    --
    self.name = "";
end

--@Override
function ImmediateApplyJoin:_OnSerial() 
    self:WriteString(self.name);
end

--@Override
function ImmediateApplyJoin:_OnDeserialize() 
    self.name = self:ReadString();
end

return ImmediateApplyJoin;
