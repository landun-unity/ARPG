--
-- 客户端 --> 聊天服务器
-- 在一个频道中发送聊天
-- @author czx
--
local GameMessage = require("common/Net/GameMessage");
local SendChat = class("SendChat", GameMessage);

--
-- 构造函数
--
function SendChat:ctor()
    SendChat.super.ctor(self);
    --
    -- 频道Id
    --
    self.channelId = 0;
    
    --
    -- 玩家Id
    --
    self.playerId = 0;
    
    --
    -- 内容
    --
    self.content = "";
    
    --
    -- 类型
    --
    self.mType = 0;
    
    --
    -- 建筑名称
    --
    self.buildingName = "";
    
    --
    -- 索引
    --
    self.buildingIndex = 0;
    
    --
    -- 建筑ID
    --
    self.buildingId = 0;
    
    --
    -- 同盟名字
    --
    self.otherLeagueName = "";
    
    --
    -- 同盟州Id
    --
    self.otherLeagueState = 0;
    
    --
    -- 名字
    --
    self.otherOPlayerName = "";
    
    --
    -- 名字
    --
    self.otherTPlayerName = "";
    
    --
    -- 攻大营
    --
    self.dCardTableID = 0;
    
    --
    -- 防大营
    --
    self.aCardTableID = 0;
    
    --
    -- 格子索引
    --
    self.tileIndex = 0;
    
    --
    -- 类型
    --
    self.placeType = 0;
    
    --
    -- 个人的时候就是个人ID 同盟的时候就是同盟ID
    --
    self.iD = 0;
    
    --
    -- 类型
    --
    self.group = 0;
    
    --
    -- 战报Id
    --
    self.battleId = 0;
    
    --
    -- 下标
    --
    self.index = 0;
end

--@Override
function SendChat:_OnSerial() 
    self:WriteInt64(self.channelId);
    self:WriteInt64(self.playerId);
    self:WriteString(self.content);
    self:WriteInt32(self.mType);
    self:WriteString(self.buildingName);
    self:WriteInt64(self.buildingIndex);
    self:WriteInt64(self.buildingId);
    self:WriteString(self.otherLeagueName);
    self:WriteInt32(self.otherLeagueState);
    self:WriteString(self.otherOPlayerName);
    self:WriteString(self.otherTPlayerName);
    self:WriteInt64(self.dCardTableID);
    self:WriteInt64(self.aCardTableID);
    self:WriteInt64(self.tileIndex);
    self:WriteInt32(self.placeType);
    self:WriteInt64(self.iD);
    self:WriteInt32(self.group);
    self:WriteInt64(self.battleId);
    self:WriteInt32(self.index);
end

--@Override
function SendChat:_OnDeserialize() 
    self.channelId = self:ReadInt64();
    self.playerId = self:ReadInt64();
    self.content = self:ReadString();
    self.mType = self:ReadInt32();
    self.buildingName = self:ReadString();
    self.buildingIndex = self:ReadInt64();
    self.buildingId = self:ReadInt64();
    self.otherLeagueName = self:ReadString();
    self.otherLeagueState = self:ReadInt32();
    self.otherOPlayerName = self:ReadString();
    self.otherTPlayerName = self:ReadString();
    self.dCardTableID = self:ReadInt64();
    self.aCardTableID = self:ReadInt64();
    self.tileIndex = self:ReadInt64();
    self.placeType = self:ReadInt32();
    self.iD = self:ReadInt64();
    self.group = self:ReadInt32();
    self.battleId = self:ReadInt64();
    self.index = self:ReadInt32();
end

return SendChat;
