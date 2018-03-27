require("MessageCommon/Util/Terminal")
require("MessageCommon/Util/MessageHandler")

local Begin = Terminal.Logic * 16777216 + Terminal.Client * 65536 + MessageHandler.Card * 256;

--
-- 逻辑服务器 --> 客户端
-- Card
-- @author czx
--
L2C_Card = 
{
    --
    -- 新增加多张卡牌
    --
    AddCardsRespond = Begin + 0, 
    
    --
    -- 进阶卡牌失败
    --
    AdvanceOneCardError = Begin + 1, 
    
    --
    -- 进阶卡牌成功
    --
    AdvancerCardSusses = Begin + 2, 
    
    --
    -- 觉醒卡牌成功
    --
    AwakeOneCardSusses = Begin + 3, 
    
    --
    -- 玩家已有的卡牌对应的图鉴点亮
    --
    CardMapLightList = Begin + 4, 
    
    --
    -- 处理卡牌错误
    --
    HandleCardError = Begin + 5, 
    
    --
    -- 同步一张卡牌的属性信息
    --
    OneCardProperty = Begin + 6, 
    
    --
    -- 玩家的一页卡牌
    --
    PlayerHeroCardPage = Begin + 7, 
    
    --
    -- 删除卡牌
    --
    RemoveCard = Begin + 8, 
}

return L2C_Card;
