--
-- 逻辑服务器 --> 客户端
-- 刷新资源信息
-- @author czx
--
local GameMessage = require("common/Net/GameMessage");
local RefreshCurrencyInfo = class("RefreshCurrencyInfo", GameMessage);

--
-- 构造函数
--
function RefreshCurrencyInfo:ctor()
    RefreshCurrencyInfo.super.ctor(self);
    --
    -- 铜币
    --
    self.money = 0;
    
    --
    -- 玉符
    --
    self.jadey = 0;
    
    --
    -- 名望
    --
    self.rnown = 0;
    
    --
    -- 政令
    --
    self.decree = 0;
    
    --
    -- 战法经验
    --
    self.warfare = 0;
    
    --
    -- 兵种经验
    --
    self.arms = 0;
end

--@Override
function RefreshCurrencyInfo:_OnSerial() 
    self:WriteInt32(self.money);
    self:WriteInt32(self.jadey);
    self:WriteInt32(self.rnown);
    self:WriteInt32(self.decree);
    self:WriteInt32(self.warfare);
    self:WriteInt32(self.arms);
end

--@Override
function RefreshCurrencyInfo:_OnDeserialize() 
    self.money = self:ReadInt32();
    self.jadey = self:ReadInt32();
    self.rnown = self:ReadInt32();
    self.decree = self:ReadInt32();
    self.warfare = self:ReadInt32();
    self.arms = self:ReadInt32();
end

return RefreshCurrencyInfo;
