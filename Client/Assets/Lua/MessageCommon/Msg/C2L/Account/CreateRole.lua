--
-- 客户端 --> 逻辑服务器
-- 创建角色
-- @author czx
--
local GameMessage = require("common/Net/GameMessage");
local CreateRole = class("CreateRole", GameMessage);

--
-- 构造函数
--
function CreateRole:ctor()
    CreateRole.super.ctor(self);
    --
    -- 账号Id
    --
    self.accountId = 0;
    
    --
    -- 区Id
    --
    self.regionId = 0;
    
    --
    -- 角色名字
    --
    self.roleName = "";
    
    --
    -- 出生的州
    --
    self.state = 0;
end

--@Override
function CreateRole:_OnSerial() 
    self:WriteInt64(self.accountId);
    self:WriteInt32(self.regionId);
    self:WriteString(self.roleName);
    self:WriteInt32(self.state);
end

--@Override
function CreateRole:_OnDeserialize() 
    self.accountId = self:ReadInt64();
    self.regionId = self:ReadInt32();
    self.roleName = self:ReadString();
    self.state = self:ReadInt32();
end

return CreateRole;
