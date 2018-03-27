--
-- 客户端 --> 账号服务器
-- 亿虎登录请求
-- @author czx
--
local GameMessage = require("common/Net/GameMessage");
local EhooLoginRequest = class("EhooLoginRequest", GameMessage);

--
-- 构造函数
--
function EhooLoginRequest:ctor()
    EhooLoginRequest.super.ctor(self);
    --
    -- 帐户名
    --
    self.accountName = "";
    
    --
    -- 密码
    --
    self.passworldmd5 = "";
    
    --
    -- 游戏Id
    --
    self.appId = 0;
    
    --
    -- 网络地址
    --
    self.ip = "";
    
    --
    -- 签名
    --
    self.sign = "";
end

--@Override
function EhooLoginRequest:_OnSerial() 
    self:WriteString(self.accountName);
    self:WriteString(self.passworldmd5);
    self:WriteInt32(self.appId);
    self:WriteString(self.ip);
    self:WriteString(self.sign);
end

--@Override
function EhooLoginRequest:_OnDeserialize() 
    self.accountName = self:ReadString();
    self.passworldmd5 = self:ReadString();
    self.appId = self:ReadInt32();
    self.ip = self:ReadString();
    self.sign = self:ReadString();
end

return EhooLoginRequest;
