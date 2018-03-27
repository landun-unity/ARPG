--
-- 逻辑服务器 --> 客户端
-- 同步玩家信息结束
-- @author czx
--
local GameMessage = require("common/Net/GameMessage");
local SyncPlayerInfoEnd = class("SyncPlayerInfoEnd", GameMessage);

--
-- 构造函数
--
function SyncPlayerInfoEnd:ctor()
    SyncPlayerInfoEnd.super.ctor(self);
end

--@Override
function SyncPlayerInfoEnd:_OnSerial() 
end

--@Override
function SyncPlayerInfoEnd:_OnDeserialize() 
end

return SyncPlayerInfoEnd;
