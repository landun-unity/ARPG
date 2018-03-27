--region *.lua
--Date
--此文件由[BabeLua]插件自动生成
-- Anchor:Dr
-- Date 16/9/14
-- 同盟信息类
local League = class("League");

function League:ctor()
    --t同盟id
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

    self.beDemisePlayerId = 0;
   
end



return League;


--endregion
