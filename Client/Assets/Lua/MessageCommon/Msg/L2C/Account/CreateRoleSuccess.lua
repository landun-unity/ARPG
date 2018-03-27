--
-- 逻辑服务器 --> 客户端
-- 创建玩家成功
-- @author czx
--
local GameMessage = require("common/Net/GameMessage");
local CreateRoleSuccess = class("CreateRoleSuccess", GameMessage);

--
-- 构造函数
--
function CreateRoleSuccess:ctor()
    CreateRoleSuccess.super.ctor(self);
    --
    -- 玩家Id
    --
    self.roleId = 0;
end

--@Override
function CreateRoleSuccess:_OnSerial() 
    self:WriteInt64(self.roleId);
end

--@Override
function CreateRoleSuccess:_OnDeserialize() 
    self.roleId = self:ReadInt64();
end

return CreateRoleSuccess;
