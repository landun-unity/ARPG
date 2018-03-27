--
-- 逻辑服务器 --> 客户端
-- 战报消息结构
-- @author czx
--
local BattleReportModel = class("BattleReportModel");

function BattleReportModel:ctor()
    --
    -- 唯一ID
    --
    self.iD = 0;
    
    --
    -- 战斗类型 是攻击的还是防守
    --
    self.battleType = 0;
    
    --
    -- 战斗发生位置是土地还是城池
    --
    self.placeType = 0;
    
    --
    -- 战斗位置
    --
    self.tileIndex = 0;
    
    --
    -- 战斗时间
    --
    self.fightTime = 0;
    
    --
    -- 攻击方的表ID
    --
    self.aCardTableID = 0;
    
    --
    -- 攻击方的等级
    --
    self.aCardLevel = 0;
    
    --
    -- 攻击方的进阶星级
    --
    self.aAdvanceStar = 0;
    
    --
    -- 防守的表ID
    --
    self.dCardTableID = 0;
    
    --
    -- 防守方的等级
    --
    self.dCardLevel = 0;
    
    --
    -- 防守方的进阶星级
    --
    self.dAdvanceStar = 0;
    
    --
    -- 攻击方的名字
    --
    self.aPlayerName = "";
    
    --
    -- 攻击方的联盟名字
    --
    self.aleagueName = "";
    
    --
    -- 防守的名字
    --
    self.dPlayerName = "";
    
    --
    -- 防守的联盟名字
    --
    self.dleagueName = "";
    
    --
    -- 攻击方的兵力
    --
    self.aTroopNum = 0;
    
    --
    -- 防守方的兵力
    --
    self.dTroopNum = 0;
    
    --
    -- 战斗结果： 赢  输  平
    --
    self.resultType = 0;
    
    --
    -- 战报是否已读
    --
    self.isRead = false;
    
    --
    -- 战报类型 是占领土地 失去土地 附属 被附属
    --
    self.reportType = 0;
    
    --
    -- 剩余战平次数
    --
    self.drawTimes = 0;
end

return BattleReportModel;
