--
-- 客户端 --> 逻辑服务器
-- 修改个人介绍
-- @author czx
--
local GameMessage = require("common/Net/GameMessage");
local ChangePlayerProfile = class("ChangePlayerProfile", GameMessage);

--
-- 构造函数
--
function ChangePlayerProfile:ctor()
    ChangePlayerProfile.super.ctor(self);
    --
    -- 个人介绍
    --
    self.playerProfile = "";
end

--@Override
function ChangePlayerProfile:_OnSerial() 
    self:WriteString(self.playerProfile);
end

--@Override
function ChangePlayerProfile:_OnDeserialize() 
    self.playerProfile = self:ReadString();
end

return ChangePlayerProfile;
