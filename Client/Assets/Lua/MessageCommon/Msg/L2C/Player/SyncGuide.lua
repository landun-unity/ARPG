--
-- 逻辑服务器 --> 客户端
-- 同步新手引导进度
-- @author czx
--
local GameMessage = require("common/Net/GameMessage");
local SyncGuide = class("SyncGuide", GameMessage);

--
-- 构造函数
--
function SyncGuide:ctor()
    SyncGuide.super.ctor(self);
end

--@Override
function SyncGuide:_OnSerial() 
end

--@Override
function SyncGuide:_OnDeserialize() 
end

return SyncGuide;
