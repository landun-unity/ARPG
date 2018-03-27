--
-- 客户端 --> 逻辑服务器
-- 同盟捐献请求
-- @author czx
--
local GameMessage = require("common/Net/GameMessage");
local DonateRequest = class("DonateRequest", GameMessage);

--
-- 构造函数
--
function DonateRequest:ctor()
    DonateRequest.super.ctor(self);
    --
    -- 同盟id
    --
    self.leagueId = 0;
    
    --
    -- 捐献木头
    --
    self.wood = 0;
    
    --
    -- 捐献铁矿
    --
    self.iron = 0;
    
    --
    -- 捐献粮草
    --
    self.grain = 0;
    
    --
    -- 捐献石头
    --
    self.stone = 0;
end

--@Override
function DonateRequest:_OnSerial() 
    self:WriteInt64(self.leagueId);
    self:WriteInt32(self.wood);
    self:WriteInt32(self.iron);
    self:WriteInt32(self.grain);
    self:WriteInt32(self.stone);
end

--@Override
function DonateRequest:_OnDeserialize() 
    self.leagueId = self:ReadInt64();
    self.wood = self:ReadInt32();
    self.iron = self:ReadInt32();
    self.grain = self:ReadInt32();
    self.stone = self:ReadInt32();
end

return DonateRequest;
