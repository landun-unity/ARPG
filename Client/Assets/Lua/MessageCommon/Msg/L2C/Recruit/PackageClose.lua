--
-- 逻辑服务器 --> 客户端
-- 卡包关闭
-- @author czx
--
local GameMessage = require("common/Net/GameMessage");
local PackageClose = class("PackageClose", GameMessage);

--
-- 构造函数
--
function PackageClose:ctor()
    PackageClose.super.ctor(self);
end

--@Override
function PackageClose:_OnSerial() 
end

--@Override
function PackageClose:_OnDeserialize() 
end

return PackageClose;
