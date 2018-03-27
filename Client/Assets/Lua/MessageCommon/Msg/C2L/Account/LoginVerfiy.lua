--
-- 客户端 --> 逻辑服务器
-- 登录验证
-- @author czx
--
local GameMessage = require("common/Net/GameMessage");
local LoginVerfiy = class("LoginVerfiy", GameMessage);

--
-- 构造函数
--
function LoginVerfiy:ctor()
    LoginVerfiy.super.ctor(self);
    --
    -- 验证码
    --
    self.verfiyCode = "";
    
    --
    -- 手机型号
    --
    self.mobileType = "";
    
    --
    -- 账号Id
    --
    self.accountId = 0;
    
    --
    -- 区Id
    --
    self.regionId = 0;
end

--@Override
function LoginVerfiy:_OnSerial() 
    self:WriteString(self.verfiyCode);
    self:WriteString(self.mobileType);
    self:WriteInt64(self.accountId);
    self:WriteInt32(self.regionId);
end

--@Override
function LoginVerfiy:_OnDeserialize() 
    self.verfiyCode = self:ReadString();
    self.mobileType = self:ReadString();
    self.accountId = self:ReadInt64();
    self.regionId = self:ReadInt32();
end

return LoginVerfiy;
