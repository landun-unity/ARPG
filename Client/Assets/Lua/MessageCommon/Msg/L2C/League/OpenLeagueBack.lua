--
-- 逻辑服务器 --> 客户端
-- 打开自己盟回复
-- @author czx
--
local GameMessage = require("common/Net/GameMessage");
local OpenLeagueBack = class("OpenLeagueBack", GameMessage);

--
-- 构造函数
--
function OpenLeagueBack:ctor()
    OpenLeagueBack.super.ctor(self);
    --
    -- 盟id
    --
    self.leagueid = 0;
    
    --
    -- 盟名字
    --
    self.leagueName = "";
    
    --
    -- 盟主id
    --
    self.leaderid = 0;
    
    --
    -- 盟主名字
    --
    self.leaderName = "";
    
    --
    -- 盟等级
    --
    self.level = 0;
    
    --
    -- 盟经验
    --
    self.exp = 0;
    
    --
    -- 成员数量
    --
    self.memberNum = 0;
    
    --
    -- 所在省份
    --
    self.province = 0;
    
    --
    -- 拥有城池数量
    --
    self.cityNum = 0;
    
    --
    -- 势力
    --
    self.influnce = 0;
    
    --
    -- 公告
    --
    self.notice = "";
    
    --
    -- 申请人数
    --
    self.applyNum = 0;
    
    --
    -- 下次禅让时间
    --
    self.nextDemiseTime = 0;
    
    --
    -- 禅让者
    --
    self.demisePlayerId = 0;
    
    --
    -- 被禅让者
    --
    self.beDemisePlayerId = 0;
    
    --
    -- 拥有城池数量
    --
    self.haveWildCityCount = 0;
    
    --
    -- 野城木材加成
    --
    self.cityWoodAdd = 0;
    
    --
    -- 野城铁矿加成
    --
    self.cityIronAdd = 0;
    
    --
    -- 野城石料加成
    --
    self.cityStoneAdd = 0;
    
    --
    -- 野城粮草加成
    --
    self.cityGrainAdd = 0;
end

--@Override
function OpenLeagueBack:_OnSerial() 
    self:WriteInt64(self.leagueid);
    self:WriteString(self.leagueName);
    self:WriteInt64(self.leaderid);
    self:WriteString(self.leaderName);
    self:WriteInt32(self.level);
    self:WriteInt32(self.exp);
    self:WriteInt32(self.memberNum);
    self:WriteInt32(self.province);
    self:WriteInt32(self.cityNum);
    self:WriteInt32(self.influnce);
    self:WriteString(self.notice);
    self:WriteInt32(self.applyNum);
    self:WriteInt64(self.nextDemiseTime);
    self:WriteInt64(self.demisePlayerId);
    self:WriteInt64(self.beDemisePlayerId);
    self:WriteInt32(self.haveWildCityCount);
    self:WriteInt32(self.cityWoodAdd);
    self:WriteInt32(self.cityIronAdd);
    self:WriteInt32(self.cityStoneAdd);
    self:WriteInt32(self.cityGrainAdd);
end

--@Override
function OpenLeagueBack:_OnDeserialize() 
    self.leagueid = self:ReadInt64();
    self.leagueName = self:ReadString();
    self.leaderid = self:ReadInt64();
    self.leaderName = self:ReadString();
    self.level = self:ReadInt32();
    self.exp = self:ReadInt32();
    self.memberNum = self:ReadInt32();
    self.province = self:ReadInt32();
    self.cityNum = self:ReadInt32();
    self.influnce = self:ReadInt32();
    self.notice = self:ReadString();
    self.applyNum = self:ReadInt32();
    self.nextDemiseTime = self:ReadInt64();
    self.demisePlayerId = self:ReadInt64();
    self.beDemisePlayerId = self:ReadInt64();
    self.haveWildCityCount = self:ReadInt32();
    self.cityWoodAdd = self:ReadInt32();
    self.cityIronAdd = self:ReadInt32();
    self.cityStoneAdd = self:ReadInt32();
    self.cityGrainAdd = self:ReadInt32();
end

return OpenLeagueBack;
