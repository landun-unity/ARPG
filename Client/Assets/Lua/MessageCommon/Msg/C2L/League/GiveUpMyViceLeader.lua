--
-- 客户端 --> 逻辑服务器
-- 放弃我的副盟主
-- @author czx
--
local GameMessage = require("common/Net/GameMessage");
local GiveUpMyViceLeader = class("GiveUpMyViceLeader", GameMessage);

--
-- 构造函数
--
function GiveUpMyViceLeader:ctor()
    GiveUpMyViceLeader.super.ctor(self);
end

--@Override
function GiveUpMyViceLeader:_OnSerial() 
end

--@Override
function GiveUpMyViceLeader:_OnDeserialize() 
end

return GiveUpMyViceLeader;
