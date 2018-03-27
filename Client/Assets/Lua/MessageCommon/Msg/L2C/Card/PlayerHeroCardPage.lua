--
-- 逻辑服务器 --> 客户端
-- 玩家的一页卡牌
-- @author czx
--
local List = require("common/List");

local CardModel = require("MessageCommon/Msg/L2C/Card/CardModel");

local GameMessage = require("common/Net/GameMessage");
local PlayerHeroCardPage = class("PlayerHeroCardPage", GameMessage);

--
-- 构造函数
--
function PlayerHeroCardPage:ctor()
    PlayerHeroCardPage.super.ctor(self);
    --
    -- 卡牌列表
    --
    self.list = List.new();
    
    --
    -- 当前页
    --
    self.curPage = 0;
    
    --
    -- 最大页
    --
    self.maxPage = 0;
end

--@Override
function PlayerHeroCardPage:_OnSerial() 
    
    local listCount = self.list:Count();
    self:WriteInt32(listCount);
    for listIndex = 1, listCount, 1 do 
        local listValue = self.list:Get(listIndex);
        
        self:WriteInt64(listValue.id);
        self:WriteInt32(listValue.tableID);
        self:WriteInt32(listValue.exp);
        self:WriteInt32(listValue.advancedTime);
        self:WriteInt32(listValue.power);
        self:WriteInt32(listValue.level);
        self:WriteInt32(listValue.troop);
        self:WriteInt32(listValue.point);
        self:WriteInt32(listValue.attacktPoint);
        self:WriteInt32(listValue.defensePoint);
        self:WriteInt32(listValue.strategyPoint);
        self:WriteInt32(listValue.speedPoint);
        self:WriteBoolean(listValue.isProtect);
        self:WriteBoolean(listValue.isAwaken);
        self:WriteInt32(listValue.skillIDOne);
        self:WriteInt32(listValue.skillOneLevel);
        self:WriteInt32(listValue.skillTwoID);
        self:WriteInt32(listValue.skillTwoLevel);
        self:WriteInt32(listValue.skillThreeID);
        self:WriteInt32(listValue.skillThreeLevel);
        self:WriteInt64(listValue.lastResetPointTime);
        self:WriteInt64(listValue.lastResetCardTime);
        self:WriteInt64(listValue.badlyHurtTime);
        self:WriteInt64(listValue.tiredRecoverTime);
    end
    self:WriteInt32(self.curPage);
    self:WriteInt32(self.maxPage);
end

--@Override
function PlayerHeroCardPage:_OnDeserialize() 
    
    local listCount = self:ReadInt32();
    for i = 1, listCount, 1 do 
        local listValue = CardModel.new();
        listValue.id = self:ReadInt64();
        listValue.tableID = self:ReadInt32();
        listValue.exp = self:ReadInt32();
        listValue.advancedTime = self:ReadInt32();
        listValue.power = self:ReadInt32();
        listValue.level = self:ReadInt32();
        listValue.troop = self:ReadInt32();
        listValue.point = self:ReadInt32();
        listValue.attacktPoint = self:ReadInt32();
        listValue.defensePoint = self:ReadInt32();
        listValue.strategyPoint = self:ReadInt32();
        listValue.speedPoint = self:ReadInt32();
        listValue.isProtect = self:ReadBoolean();
        listValue.isAwaken = self:ReadBoolean();
        listValue.skillIDOne = self:ReadInt32();
        listValue.skillOneLevel = self:ReadInt32();
        listValue.skillTwoID = self:ReadInt32();
        listValue.skillTwoLevel = self:ReadInt32();
        listValue.skillThreeID = self:ReadInt32();
        listValue.skillThreeLevel = self:ReadInt32();
        listValue.lastResetPointTime = self:ReadInt64();
        listValue.lastResetCardTime = self:ReadInt64();
        listValue.badlyHurtTime = self:ReadInt64();
        listValue.tiredRecoverTime = self:ReadInt64();
        self.list:Push(listValue);
    end
    self.curPage = self:ReadInt32();
    self.maxPage = self:ReadInt32();
end

return PlayerHeroCardPage;
