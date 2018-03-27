--
-- 逻辑服务器 --> 客户端
-- 卡包
-- @author czx
--
local RecruitPackage = require("MessageCommon/Msg/L2C/Recruit/RecruitPackage");

local GameMessage = require("common/Net/GameMessage");
local SyncRecruitPackage = class("SyncRecruitPackage", GameMessage);

--
-- 构造函数
--
function SyncRecruitPackage:ctor()
    SyncRecruitPackage.super.ctor(self);
    --
    -- 一个卡包
    --
    self.onePackageInfo = RecruitPackage.new();
end

--@Override
function SyncRecruitPackage:_OnSerial() 
    self:WriteInt64(self.onePackageInfo.recruitPackageId);
    self:WriteBoolean(self.onePackageInfo.isFree);
    self:WriteBoolean(self.onePackageInfo.isDiscount);
    self:WriteInt32(self.onePackageInfo.curRecruitTimes);
    self:WriteInt64(self.onePackageInfo.overTime);
    self:WriteInt64(self.onePackageInfo.lastFreeTime);
    self:WriteBoolean(self.onePackageInfo.openBatch);
    self:WriteInt32(self.onePackageInfo.cardLevel);
    self:WriteInt32(self.onePackageInfo.isNew);
    self:WriteInt32(self.onePackageInfo.tableId);
    self:WriteInt32(self.onePackageInfo.isMerge);
    self:WriteInt32(self.onePackageInfo.isOpen);
end

--@Override
function SyncRecruitPackage:_OnDeserialize() 
    self.onePackageInfo.recruitPackageId = self:ReadInt64();
    self.onePackageInfo.isFree = self:ReadBoolean();
    self.onePackageInfo.isDiscount = self:ReadBoolean();
    self.onePackageInfo.curRecruitTimes = self:ReadInt32();
    self.onePackageInfo.overTime = self:ReadInt64();
    self.onePackageInfo.lastFreeTime = self:ReadInt64();
    self.onePackageInfo.openBatch = self:ReadBoolean();
    self.onePackageInfo.cardLevel = self:ReadInt32();
    self.onePackageInfo.isNew = self:ReadInt32();
    self.onePackageInfo.tableId = self:ReadInt32();
    self.onePackageInfo.isMerge = self:ReadInt32();
    self.onePackageInfo.isOpen = self:ReadInt32();
end

return SyncRecruitPackage;
