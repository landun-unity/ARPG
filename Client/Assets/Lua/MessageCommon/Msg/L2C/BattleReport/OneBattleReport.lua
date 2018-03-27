--
-- 逻辑服务器 --> 客户端
-- 战报
-- @author czx
--
local GameMessage = require("common/Net/GameMessage");
local OneBattleReport = class("OneBattleReport", GameMessage);

--
-- 构造函数
--
function OneBattleReport:ctor()
    OneBattleReport.super.ctor(self);
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

--@Override
function OneBattleReport:_OnSerial() 
    self:WriteInt64(self.iD);
    self:WriteInt32(self.battleType);
    self:WriteInt32(self.placeType);
    self:WriteInt32(self.tileIndex);
    self:WriteInt64(self.fightTime);
    self:WriteInt32(self.aCardTableID);
    self:WriteInt32(self.aCardLevel);
    self:WriteInt32(self.aAdvanceStar);
    self:WriteInt32(self.dCardTableID);
    self:WriteInt32(self.dCardLevel);
    self:WriteInt32(self.dAdvanceStar);
    self:WriteString(self.aPlayerName);
    self:WriteString(self.aleagueName);
    self:WriteString(self.dPlayerName);
    self:WriteString(self.dleagueName);
    self:WriteInt32(self.aTroopNum);
    self:WriteInt32(self.dTroopNum);
    self:WriteInt32(self.resultType);
    self:WriteBoolean(self.isRead);
    self:WriteInt32(self.reportType);
    self:WriteInt32(self.drawTimes);
end

--@Override
function OneBattleReport:_OnDeserialize() 
    self.iD = self:ReadInt64();
    self.battleType = self:ReadInt32();
    self.placeType = self:ReadInt32();
    self.tileIndex = self:ReadInt32();
    self.fightTime = self:ReadInt64();
    self.aCardTableID = self:ReadInt32();
    self.aCardLevel = self:ReadInt32();
    self.aAdvanceStar = self:ReadInt32();
    self.dCardTableID = self:ReadInt32();
    self.dCardLevel = self:ReadInt32();
    self.dAdvanceStar = self:ReadInt32();
    self.aPlayerName = self:ReadString();
    self.aleagueName = self:ReadString();
    self.dPlayerName = self:ReadString();
    self.dleagueName = self:ReadString();
    self.aTroopNum = self:ReadInt32();
    self.dTroopNum = self:ReadInt32();
    self.resultType = self:ReadInt32();
    self.isRead = self:ReadBoolean();
    self.reportType = self:ReadInt32();
    self.drawTimes = self:ReadInt32();
end

return OneBattleReport;
