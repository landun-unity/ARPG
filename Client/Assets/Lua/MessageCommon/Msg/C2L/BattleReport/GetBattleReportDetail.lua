--
-- 客户端 --> 逻辑服务器
-- 获取战报详情
-- @author czx
--
local GameMessage = require("common/Net/GameMessage");
local GetBattleReportDetail = class("GetBattleReportDetail", GameMessage);

--
-- 构造函数
--
function GetBattleReportDetail:ctor()
    GetBattleReportDetail.super.ctor(self);
    --
    -- 个人的时候就是个人ID 同盟的时候就是同盟ID 
    --
    self.id = 0;
    
    --
    -- 战报分组 1个人 2同盟
    --
    self.battleReportGroup = 0;
    
    --
    -- 战报Id
    --
    self.battleReportID = 0;
    
    --
    -- 下标
    --
    self.index = 0;
end

--@Override
function GetBattleReportDetail:_OnSerial() 
    self:WriteInt64(self.id);
    self:WriteInt32(self.battleReportGroup);
    self:WriteInt64(self.battleReportID);
    self:WriteInt32(self.index);
end

--@Override
function GetBattleReportDetail:_OnDeserialize() 
    self.id = self:ReadInt64();
    self.battleReportGroup = self:ReadInt32();
    self.battleReportID = self:ReadInt64();
    self.index = self:ReadInt32();
end

return GetBattleReportDetail;
