--
-- 逻辑服务器 --> 客户端
-- 卡包
-- @author czx
--
local RecruitPackage = class("RecruitPackage");

function RecruitPackage:ctor()
    --
    -- 卡包ID
    --
    self.recruitPackageId = 0;
    
    --
    -- 是否免费
    --
    self.isFree = false;
    
    --
    -- 是否打折
    --
    self.isDiscount = false;
    
    --
    -- 当前领取次数
    --
    self.curRecruitTimes = 0;
    
    --
    -- 结束时间
    --
    self.overTime = 0;
    
    --
    -- 最后一次免费时间	
    --
    self.lastFreeTime = 0;
    
    --
    -- 是否开启批量招募
    --
    self.openBatch = false;
    
    --
    -- 卡包等级
    --
    self.cardLevel = 0;
    
    --
    -- 是新的卡包
    --
    self.isNew = 0;
    
    --
    -- 卡包表ID
    --
    self.tableId = 0;
    
    --
    -- 是否合并
    --
    self.isMerge = 0;
    
    --
    -- 是否开启
    --
    self.isOpen = 0;
end

return RecruitPackage;
