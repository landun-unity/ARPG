--
-- 客户端 --> 逻辑服务器
-- 盟主/副盟主打开申请列表
-- @author czx
--
local GameMessage = require("common/Net/GameMessage");
local OpenApplyList = class("OpenApplyList", GameMessage);

--
-- 构造函数
--
function OpenApplyList:ctor()
    OpenApplyList.super.ctor(self);
end

--@Override
function OpenApplyList:_OnSerial() 
end

--@Override
function OpenApplyList:_OnDeserialize() 
end

return OpenApplyList;
