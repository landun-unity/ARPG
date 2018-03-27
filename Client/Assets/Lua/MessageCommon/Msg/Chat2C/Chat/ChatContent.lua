--
-- 聊天服务器 --> 客户端
-- 一条聊天信息
-- @author czx
--
local ChatContent = class("ChatContent");

function ChatContent:ctor()
    --
    -- 频道Id
    --
    self.channelId = 0;
    
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
    -- 玩家名字
    --
    self.playerId = 0;
    
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
    
    --
    -- 内容
    --
    self.content = "";
    
    --
    -- 发送时间
    --
    self.sendTime = 0;
    
    --
    -- 类型
    --
    self.mType = 0;
    
    --
    -- 建筑名字
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

return ChatContent;
