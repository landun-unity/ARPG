
-- 战报卡牌

local BattleReportHeroCardModel = class("BattleReportHeroCardModel");

function BattleReportHeroCardModel:ctor()

    -- 表ID
    self.heroid = 0

    -- 英雄等级
    self.cardLevel = 0

    -- 开始拥有的兵数量
    self.startTroopNum = 0

    --擦拍所在的位置
    self.position = 0

    --进阶次数
    self.advanceTimes = 0

     --是否觉醒
    self.isAwake = false

     --是否觉醒
    self.CardType = 0
end

function BattleReportHeroCardModel:_OnDeserialize(byteArray)
    self.heroid = byteArray:ReadInt32();
    self.cardLevel = byteArray:ReadInt32();
    self.startTroopNum = byteArray:ReadInt32();
    self.position = byteArray:ReadInt32();
    self.advanceTimes = byteArray:ReadInt32();
    self.isAwake = byteArray:ReadBoolean();
    self.CardType = byteArray:ReadInt32();
    --[[print("self.heroid",self.heroid)
    print("self.cardLevel",self.cardLevel)
    print("self.startTroopNum",self.startTroopNum)
    print("self.position",self.position)
    print("self.advanceTimes",self.advanceTimes)
    print("self.isAwake",self.isAwake)
    print("self.CardType",self.CardType)]]
end

return BattleReportHeroCardModel