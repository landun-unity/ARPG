--
-- 客户端 --> 逻辑服务器
-- 请求英雄卡牌
-- @author czx
--
local GameMessage = require("common/Net/GameMessage");
local GetOnePlayerSkillList = class("GetOnePlayerSkillList", GameMessage);

--
-- 构造函数
--
function GetOnePlayerSkillList:ctor()
    GetOnePlayerSkillList.super.ctor(self);
end

--@Override
function GetOnePlayerSkillList:_OnSerial() 
end

--@Override
function GetOnePlayerSkillList:_OnDeserialize() 
end

return GetOnePlayerSkillList;
