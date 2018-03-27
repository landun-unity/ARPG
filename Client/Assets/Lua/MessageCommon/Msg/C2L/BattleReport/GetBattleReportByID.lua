--
-- 客户端 --> 逻辑服务器
-- 通过ID和下标获取战报
-- @author czx
--
local GameMessage = require("common/Net/GameMessage");
local GetBattleReportByID = class("GetBattleReportByID", GameMessage);

--
-- 构造函数
--
function GetBattleReportByID:ctor()
    GetBattleReportByID.super.ctor(self);
    --
    -- ID 获取个人的就发送个人ID 同盟就获取同盟ID
    --
    self.id = 0;
    
    --
    -- 战报分组 1个人 2同盟
    --
    self.battleReportGroup = 0;
    
    --
    -- 战报id
    --
    self.battleReportid = 0;
    
    --
    -- 下标
    --
    self.index = 0;
end

--@Override
function GetBattleReportByID:_OnSerial() 
    self:WriteInt32(self.id);
    self:WriteInt32(self.battleReportGroup);
    self:WriteInt32(self.battleReportid);
    self:WriteInt32(self.index);
end

--@Override
function GetBattleReportByID:_OnDeserialize() 
    self.id = self:ReadInt32();
    self.battleReportGroup = self:ReadInt32();
    self.battleReportid = self:ReadInt32();
    self.index = self:ReadInt32();
end

return GetBattleReportByID;
