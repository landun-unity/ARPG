--
-- 客户端 --> 逻辑服务器
-- 请求所有招募列表
-- @author czx
--
local GameMessage = require("common/Net/GameMessage");
local GetAllRecruitList = class("GetAllRecruitList", GameMessage);

--
-- 构造函数
--
function GetAllRecruitList:ctor()
    GetAllRecruitList.super.ctor(self);
end

--@Override
function GetAllRecruitList:_OnSerial() 
end

--@Override
function GetAllRecruitList:_OnDeserialize() 
end

return GetAllRecruitList;
