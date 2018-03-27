--
-- 客户端 --> 逻辑服务器
-- 取消申请加入
-- @author czx
--
local GameMessage = require("common/Net/GameMessage");
local CancelApplyJoin = class("CancelApplyJoin", GameMessage);

--
-- 构造函数
--
function CancelApplyJoin:ctor()
    CancelApplyJoin.super.ctor(self);
    --
    -- 目标同盟
    --
    self.leagueId = 0;
end

--@Override
function CancelApplyJoin:_OnSerial() 
    self:WriteInt64(self.leagueId);
end

--@Override
function CancelApplyJoin:_OnDeserialize() 
    self.leagueId = self:ReadInt64();
end

return CancelApplyJoin;
