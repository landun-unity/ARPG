require("MessageCommon/Util/Terminal")
require("MessageCommon/Util/MessageHandler")

local Begin = Terminal.Logic * 16777216 + Terminal.Client * 65536 + MessageHandler.Recruit * 256;

--
-- 逻辑服务器 --> 客户端
-- Recruit
-- @author czx
--
L2C_Recruit = 
{
    --
    -- 返回招募到的卡牌列表
    --
    BatchRecruitCardTableIdList = Begin + 0, 
    
    --
    -- 批量招募返回的信息
    --
    BatchRecruitModel = Begin + 1, 
    
    --
    -- 卡包关闭
    --
    PackageClose = Begin + 2, 
    
    --
    -- 招募到的卡牌列表
    --
    ReturnCardList = Begin + 3, 
    
    --
    -- 卡包列表
    --
    ReturnRecruitPackageList = Begin + 4, 
    
    --
    -- 卡包
    --
    SyncRecruitPackage = Begin + 5, 
}

return L2C_Recruit;
