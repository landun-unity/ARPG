--
-- 客户端 --> 账号服务器
-- 注册
-- @author czx
--
local GameMessage = require("common/Net/GameMessage");
local EhooRegisterRequest = class("EhooRegisterRequest", GameMessage);

--
-- 构造函数
--
function EhooRegisterRequest:ctor()
    EhooRegisterRequest.super.ctor(self);
    --
    -- 帐户名
    --
    self.accountName = "";
    
    --
    -- 密码
    --
    self.password = "";
    
    --
    -- 游戏Id
    --
    self.appId = 0;
    
    --
    -- 签名
    --
    self.sign = "";
end

--@Override
function EhooRegisterRequest:_OnSerial() 
    self:WriteString(self.accountName);
    self:WriteString(self.password);
    self:WriteInt32(self.appId);
    self:WriteString(self.sign);
end

--@Override
function EhooRegisterRequest:_OnDeserialize() 
    self.accountName = self:ReadString();
    self.password = self:ReadString();
    self.appId = self:ReadInt32();
    self.sign = self:ReadString();
end

return EhooRegisterRequest;
