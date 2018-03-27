--
-- 客户端 --> 聊天服务器
-- 注册聊天服务器
-- @author czx
--
local GameMessage = require("common/Net/GameMessage");
local RegisterChat = class("RegisterChat", GameMessage);

--
-- 构造函数
--
function RegisterChat:ctor()
    RegisterChat.super.ctor(self);
    --
    -- 所属区Id
    --
    self.zoneId = 0;
    
    --
    -- 国家
    --
    self.country = 0;
    
    --
    -- 州Id
    --
    self.state = 0;
    
    --
    -- 名字
    --
    self.playerName = "";
    
    --
    -- 同盟名字
    --
    self.leagueName = "";
    
    --
    -- 职位
    --
    self.leadership = 0;
end

--@Override
function RegisterChat:_OnSerial() 
    self:WriteInt32(self.zoneId);
    self:WriteInt64(self.country);
    self:WriteInt32(self.state);
    self:WriteString(self.playerName);
    self:WriteString(self.leagueName);
    self:WriteInt32(self.leadership);
end

--@Override
function RegisterChat:_OnDeserialize() 
    self.zoneId = self:ReadInt32();
    self.country = self:ReadInt64();
    self.state = self:ReadInt32();
    self.playerName = self:ReadString();
    self.leagueName = self:ReadString();
    self.leadership = self:ReadInt32();
end

return RegisterChat;
