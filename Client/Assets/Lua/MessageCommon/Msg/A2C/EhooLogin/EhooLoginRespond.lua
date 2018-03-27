--
-- 账号服务器 --> 客户端
-- 亿虎登录回复
-- @author czx
--
local GameMessage = require("common/Net/GameMessage");
local EhooLoginRespond = class("EhooLoginRespond", GameMessage);

--
-- 构造函数
--
function EhooLoginRespond:ctor()
    EhooLoginRespond.super.ctor(self);
    --
    -- 登录凭证
    --
    self.certificate = "";
    
    --
    -- 登录名称
    --
    self.accountName = "";
    
    --
    -- 是否SDK登录
    --
    self.isSDK = false;
    
    --
    -- 是否第一次登录
    --
    self.isReg = false;
end

--@Override
function EhooLoginRespond:_OnSerial() 
    self:WriteString(self.certificate);
    self:WriteString(self.accountName);
    self:WriteBoolean(self.isSDK);
    self:WriteBoolean(self.isReg);
end

--@Override
function EhooLoginRespond:_OnDeserialize() 
    self.certificate = self:ReadString();
    self.accountName = self:ReadString();
    self.isSDK = self:ReadBoolean();
    self.isReg = self:ReadBoolean();
end

return EhooLoginRespond;
