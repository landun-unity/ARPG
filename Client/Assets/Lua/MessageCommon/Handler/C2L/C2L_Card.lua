require("MessageCommon/Util/Terminal")
require("MessageCommon/Util/MessageHandler")

local Begin = Terminal.Client * 16777216 + Terminal.Logic * 65536 + MessageHandler.Card * 256;

--
-- 客户端 --> 逻辑服务器
-- Card
-- @author czx
--
C2L_Card = 
{
    --
    -- 进阶卡牌
    --
    AdvanceOneCard = Begin + 0, 
    
    --
    -- 觉醒卡牌
    --
    AwakenOneCard = Begin + 1, 
    
    --
    -- 转换战法经验
    --
    ConversionSkillXP = Begin + 2, 
    
    --
    -- 卡牌拆解技能
    --
    ExtractSkill = Begin + 3, 
    
    --
    -- 武将图鉴请求
    --
    GeneralsAlt = Begin + 4, 
    
    --
    -- 卡牌加点
    --
    OneCardAddPoint = Begin + 5, 
    
    --
    -- 添加一张卡牌
    --
    OnePlayerAddOneCard = Begin + 6, 
    
    --
    -- 卡牌保护
    --
    ProtectCard = Begin + 7, 
    
    --
    -- 请求英雄卡牌
    --
    RequestHeroCard = Begin + 8, 
    
    --
    -- 重置卡牌
    --
    ResetCard = Begin + 9, 
    
    --
    -- 重置卡牌
    --
    ResetPoint = Begin + 10, 
}

return C2L_Card;
