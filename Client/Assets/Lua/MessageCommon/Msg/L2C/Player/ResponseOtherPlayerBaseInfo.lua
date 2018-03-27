--
-- 逻辑服务器 --> 客户端
-- 返回其它玩家的个人信息
-- @author czx
--
local GameMessage = require("common/Net/GameMessage");
local ResponseOtherPlayerBaseInfo = class("ResponseOtherPlayerBaseInfo", GameMessage);

--
-- 构造函数
--
function ResponseOtherPlayerBaseInfo:ctor()
    ResponseOtherPlayerBaseInfo.super.ctor(self);
    --
    -- 玩家名称
    --
    self.playerName = "";
    
    --
    -- 玩家个人介绍
    --
    self.playerIntroduce = "";
    
    --
    -- 势力值
    --
    self.powerValue = 0;
    
    --
    -- 同盟Id
    --
    self.leagueId = 0;
    
    --
    -- 同盟名称
    --
    self.leagueName = "";
    
    --
    -- 同盟官位
    --
    self.leagueJobPosition = 0;
    
    --
    -- 上级盟ID
    --
    self.superiorLeagueId = 0;
    
    --
    -- 上级盟名称
    --
    self.superiorLeagueName = "";
end

--@Override
function ResponseOtherPlayerBaseInfo:_OnSerial() 
    self:WriteString(self.playerName);
    self:WriteString(self.playerIntroduce);
    self:WriteInt32(self.powerValue);
    self:WriteInt64(self.leagueId);
    self:WriteString(self.leagueName);
    self:WriteInt32(self.leagueJobPosition);
    self:WriteInt64(self.superiorLeagueId);
    self:WriteString(self.superiorLeagueName);
end

--@Override
function ResponseOtherPlayerBaseInfo:_OnDeserialize() 
    self.playerName = self:ReadString();
    self.playerIntroduce = self:ReadString();
    self.powerValue = self:ReadInt32();
    self.leagueId = self:ReadInt64();
    self.leagueName = self:ReadString();
    self.leagueJobPosition = self:ReadInt32();
    self.superiorLeagueId = self:ReadInt64();
    self.superiorLeagueName = self:ReadString();
end

return ResponseOtherPlayerBaseInfo;
