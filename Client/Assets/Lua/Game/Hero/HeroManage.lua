-- Anchor:Dr
-- Date: 16/9/13
-- 英雄管理类

local GamePart = require("FrameWork/Game/GamePart");
local HeroManage = class("HeroManage", GamePart);
local List = require("common/list");
require("Game/UI/UIService")
require("Game/Table/model/DataHero")

function HeroManage:ctor()
    HeroManage.super.ctor(self);
    -- 所有的英雄
    -- ----print(List);

    self._allOwnHeroCardData = List.new();
    -- self._allOwnHeroCardData=List.new();
    -- ----print(self._allOwnHeroCardData);
    -- table通过id找到对象
    self._allOwnHeroCardTable = { };

    self.rarityList = List.new();
    self.levelList = List.new();
    -- 兵种排序
    self.armTtpeList = List.new();
    -- 阵营排序
    self.campList = List.new();
    -- Cost排序
    self.costList = List.new();
    -- 默认排序
    self.defaultList = List.new();
    self.CardMapLightList = List.new();
    -- 拆解战法排序
    self.spliteHeroList = List.new();
    self.CleanTime = 0;
    self.sortedList = List.new();
    self.herobagLimit = nil;
end


function HeroManage:SetCardMaxLimit(args)

    self.herobagLimit = args

end

function HeroManage:GetCardMaxLimit()

    return self.herobagLimit

end


-- 设置排序后的武将卡
function HeroManage:SetSortedList(args)
    self.sortedList = args
end


function HeroManage:GetSortedList()
    return self.sortedList;
end
function HeroManage:SendCardProtect(cardId, isPro)
    local msg = require("MessageCommon/Msg/C2L/Card/ProtectCard").new();
    msg:SetMessageId(C2L_Card.ProtectCard)
    msg.cardID = cardId;
    msg.isProtect = isPro
    NetService:Instance():SendMessage(msg)
end

-- 请求卡牌信息 
function HeroManage:RequestHeroCard(page)
    if page == nil then
        return;
    end
    local msg = require("MessageCommon/Msg/C2L/Card/RequestHeroCard").new();
    msg:SetMessageId(C2L_Card.RequestHeroCard);
    msg.page = page;
    NetService:Instance():SendMessage(msg);
end

-- 根据索引得到英雄卡
function HeroManage:GetOwnHeroes(mIndex)
    if self._allOwnHeroCardData:Get(mIndex) == nil then
        return nil;
    end

    return self._allOwnHeroCardData:Get(mIndex);
end


function HeroManage:RemoveCard(id)

    self._allOwnHeroCardData:Remove(self:GetHeroById(id))

end


function HeroManage:GetHeroById(id)
    for i = 1, self:GetOwnHeroCount() do
        if self:GetOwnHeroes(i).id == id then
            return self:GetOwnHeroes(i)
        end

    end
    return nil;
end



-- 遍历list
function HeroManage:ForEachOwnHeroes()
    return self._allOwnHeroCardData:ForEach(handler(self, self.GetValue));
end

-- 发送拆解技能消息
function HeroManage:_SendExtractSkillMsg(cardId, skillId)
    local msg = require("MessageCommon/Msg/C2L/Card/ExtractSkill").new();
    msg:SetMessageId(C2L_Card.ExtractSkill)
    msg.extractCardID = cardId;
    msg.skillID = skillId
    NetService:Instance():SendMessage(msg)
end

-- 发送加点消息
function HeroManage:_SendAddPointMessage(cardId, atkPoint, defenCount, strageCount, speedCount)
    local msg = require("MessageCommon/Msg/C2L/Card/OneCardAddPoint").new();
    msg:SetMessageId(C2L_Card.OneCardAddPoint)
    msg.cardID = cardId
    msg.attackCount = atkPoint
    msg.defenCount = defenCount
    msg.strageCount = strageCount
    msg.speedCount = speedCount
    NetService:Instance():SendMessage(msg)
end

-- 发送加点消息
function HeroManage:_SendResetPointMessage(cardId)

    local msg = require("MessageCommon/Msg/C2L/Card/ResetPoint").new();
    msg:SetMessageId(C2L_Card.ResetPoint)

    msg.cardID = cardId

    NetService:Instance():SendMessage(msg)
    -- print("-- 发送洗点消息")
end

-- 发送卡牌觉醒消息
function HeroManage:_SendAwakeMessage(awakenCard, removeOneCard, removeTwoCard)
    local msg = require("MessageCommon/Msg/C2L/Card/AwakenOneCard").new();
    msg:SetMessageId(C2L_Card.AwakenOneCard)
    msg.awakenCard = awakenCard
    msg.removeOneCard = removeOneCard;
    msg.removeTwoCard = removeTwoCard;
    NetService:Instance():SendMessage(msg)
    -- --print("-- 发送卡牌觉醒消息")
end

-- 发送卡牌进阶消息
function HeroManage:_SendAdvanceMessage(cardID, removeCardId)
    local msg = require("MessageCommon/Msg/C2L/Card/AdvanceOneCard").new();
    msg:SetMessageId(C2L_Card.AdvanceOneCard)
    msg.removeCardID = removeCardId
    msg.advanceCardID = cardID;
    NetService:Instance():SendMessage(msg)
    -- print("-- 发送卡牌进阶消息")
end

-- 发送重置小小
function HeroManage:SendResetCardMessage(cardid)

    local msg = require("MessageCommon/Msg/C2L/Card/ResetCard").new();
    msg:SetMessageId(C2L_Card.ResetCard)
    msg.cardID = cardid
    NetService:Instance():SendMessage(msg)
    -- print("-- 发送重置消息")

end

function HeroManage:GetValue(v)
    return v;
end

-- 插入卡牌
function HeroManage:InsertHeroCard(heroCard)
    if heroCard == nil then
        return;
    end

    self._allOwnHeroCardData:Push(heroCard);
    self._allOwnHeroCardTable[heroCard.id] = heroCard;
end

function HeroManage:GetOwnHeroesById(id)
    return self._allOwnHeroCardTable[id];
end

---- 获取所有的英雄卡

-- 武将数量
function HeroManage:GetOwnHeroCount()

    return self._allOwnHeroCardData:Count();

end


function HeroManage:ShowHeroInfoUI(id)

    local data = { self:GetOwnHeroesById(id), true, nil};
    UIService:Instance():ShowUI(UIType.UIHeroCardInfo, data)

end

-- 筛选新手武将引导武将（测试用）
function HeroManage:GetHeroCardByTableID(index)
    for i = 1, HeroService:Instance():GetOwnHeroCount() do
        if HeroService:Instance():GetOwnHeroes(i).tableID == index then
            return HeroService:Instance():GetOwnHeroes(i)
        end
    end

end


-- 武将排序
function HeroManage:sortingInPackage(_type, _list)
    local _size = _list:Count()
    local _inArmList = List.new();
    local _outArmList = List.new();
    local inArmtable = { };
    local outArmtable = { };

    for i = 1, _size do
        if _list:Get(i).buildingId == nil then
            _outArmList:Push(_list:Get(i))
        else
            if PlayerService:Instance():CheckCardInArmy(_list:Get(i).id) then
                _inArmList:Push(_list:Get(i))
            else
                _outArmList:Push(_list:Get(i))
            end
        end
    end


    for i = 1, _inArmList:Count() do
        inArmtable[i] = _inArmList:Get(i)
    end
    for i = 1, _outArmList:Count() do
        outArmtable[i] = _outArmList:Get(i)
    end


    if _type == HeroSortType.default then
        self.defaultList:Clear();
        table.sort(inArmtable, function(a, b)
            if a.tableID == b.tableID then
                return a.advancedTime > b.advancedTime
            else
                return a.tableID > b.tableID
            end
        end )
        table.sort(inArmtable, function(a, b)
            if a.tableID == b.tableID then
                return a.advancedTime > b.advancedTime
            else
                return a.tableID > b.tableID
            end
        end )
        for i = 1, table.getn(inArmtable) do
            self.defaultList:Push(inArmtable[i])
        end
        for j = 1, table.getn(outArmtable) do
            self.defaultList:Push(outArmtable[j])
        end
        _list = self.defaultList;
    end


    if _type == HeroSortType.rarity then
        self.rarityList:Clear()
        table.sort(inArmtable, function(a, b)
            if (a.star == b.star) then
                if a.tableID == b.tableID then
                    return a.advancedTime > b.advancedTime
                else
                    return a.tableID > b.tableID
                end
            else
                return a.star > b.star
            end
        end )
        table.sort(outArmtable, function(a, b)
            if (a.star == b.star) then
                if a.tableID == b.tableID then
                    return a.advancedTime > b.advancedTime
                else
                    return a.tableID > b.tableID
                end
            else
                return a.star > b.star
            end
        end )

        for i = 1, table.getn(inArmtable) do
            self.rarityList:Push(inArmtable[i])
        end
        for j = 1, table.getn(outArmtable) do
            self.rarityList:Push(outArmtable[j])
        end
        _list = self.rarityList;

    end


    if _type == HeroSortType.rarityDown then
        self.rarityList:Clear()
        table.sort(inArmtable, function(a, b)
            if (a.star == b.star) then
                if a.tableID == b.tableID then
                    return a.advancedTime > b.advancedTime
                else
                    return a.tableID > b.tableID
                end
            else
                return a.star < b.star
            end
        end )
        table.sort(outArmtable, function(a, b)
            if (a.star == b.star) then
                if a.tableID == b.tableID then
                    return a.advancedTime > b.advancedTime
                else
                    return a.tableID > b.tableID
                end
            else
                return a.star < b.star
            end
        end )

        for i = 1, table.getn(inArmtable) do
            self.rarityList:Push(inArmtable[i])
        end
        for j = 1, table.getn(outArmtable) do
            self.rarityList:Push(outArmtable[j])
        end
        _list = self.rarityList;

    end


    if _type == HeroSortType.level then

        self.levelList:Clear()

        table.sort(inArmtable, function(a, b)
            if (a.level == b.level) then
                if a.tableID == b.tableID then
                    return a.advancedTime > b.advancedTime
                else
                    return a.tableID > b.tableID
                end
            else
                return a.level > b.level
            end
        end )
        table.sort(outArmtable, function(a, b)
            if (a.level == b.level) then
                if a.tableID == b.tableID then
                    return a.advancedTime > b.advancedTime
                else
                    return a.tableID > b.tableID
                end
            else
                return a.level > b.level
            end
        end )

        for i = 1, table.getn(inArmtable) do
            self.levelList:Push(inArmtable[i])
        end
        for j = 1, table.getn(outArmtable) do
            self.levelList:Push(outArmtable[j])
        end
        _list = self.levelList;

    end


    if _type == HeroSortType.camp then
        self.campList:Clear()

        table.sort(inArmtable, function(a, b)
            if (a.camp == b.camp) then
                if a.tableID == b.tableID then
                    return a.advancedTime > b.advancedTime
                else
                    return a.tableID > b.tableID
                end
            else
                return a.camp < b.camp
            end
        end )
        table.sort(outArmtable, function(a, b)
            if (a.camp == b.camp) then
                if a.tableID == b.tableID then
                    return a.advancedTime > b.advancedTime
                else
                    return a.tableID > b.tableID
                end
            else
                return a.camp < b.camp
            end
        end )
        for i = 1, table.getn(inArmtable) do
            self.campList:Push(inArmtable[i])
        end
        for j = 1, table.getn(outArmtable) do
            self.campList:Push(outArmtable[j])
        end
        _list = self.campList;

    end

    if _type == HeroSortType.cost then
        self.costList:Clear()

        table.sort(inArmtable, function(a, b)
            if (a.cost == b.cost) then
                if a.tableID == b.tableID then
                    return a.advancedTime > b.advancedTime
                else
                    return a.tableID > b.tableID
                end
            else
                return a.cost > b.cost
            end
        end )
        table.sort(outArmtable, function(a, b)
            if (a.cost == b.cost) then
                if a.tableID == b.tableID then
                    return a.advancedTime > b.advancedTime
                else
                    return a.tableID > b.tableID
                end
            else
                return a.cost > b.cost
            end
        end )

        for i = 1, table.getn(inArmtable) do
            self.costList:Push(inArmtable[i])
        end
        for j = 1, table.getn(outArmtable) do
            self.costList:Push(outArmtable[j])
        end
        _list = self.costList;

    end



    if _type == HeroSortType.armTtpe then
        self.armTtpeList:Clear()
        local protectList = List.new();
        local noProtectLsit = List.new();
        table.sort(inArmtable, function(a, b)
            if (a.baseArmy == b.baseArmy) then
                if a.tableID == b.tableID then
                    return a.advancedTime > b.advancedTime
                else
                    return a.tableID > b.tableID
                end
            else
                return a.baseArmy < b.baseArmy
            end
        end )
        table.sort(outArmtable, function(a, b)
            if (a.baseArmy == b.baseArmy) then
                if a.tableID == b.tableID then
                    return a.advancedTime > b.advancedTime
                else
                    return a.tableID > b.tableID
                end
            else
                return a.baseArmy < b.baseArmy
            end
        end )
        for i = 1, table.getn(inArmtable) do
            self.armTtpeList:Push(inArmtable[i])
        end
        for j = 1, table.getn(outArmtable) do
            self.armTtpeList:Push(outArmtable[j])
        end
        _list = self.armTtpeList;

    end


    if _type == HeroSortType.spliteHero then
        local protectList = List.new();
        local noProtectLsit = List.new();
        self.spliteHeroList:Clear()
        table.sort(inArmtable, function(a, b)
            if (a.baseArmy == b.baseArmy) then
                if a.tableID == b.tableID then
                    return a.advancedTime > b.advancedTime
                else
                    return a.tableID > b.tableID
                end
            else
                return a.baseArmy < b.baseArmy
            end
        end )
        table.sort(outArmtable, function(a, b)
            if (a.baseArmy == b.baseArmy) then
                if a.tableID == b.tableID then
                    return a.advancedTime > b.advancedTime
                else
                    return a.tableID > b.tableID
                end
            else
                return a.baseArmy < b.baseArmy
            end
        end )

        for i = 1, table.getn(inArmtable) do
            self.spliteHeroList:Push(inArmtable[i])
        end
        for j = 1, table.getn(outArmtable) do
            self.spliteHeroList:Push(outArmtable[j])
        end

        _list = self.spliteHeroList;
    end

    return _list
end

-- 武将排序
function HeroManage:sorting(_type, _list)
    local _size = _list:Count()
    local _inArmList = List.new();
    local _outArmList = List.new();
    local inArmtable = { };
    local outArmtable = { }

    for i = 1, _size do
        if _list:Get(i).buildingId == nil then
            _outArmList:Push(_list:Get(i))
        else
            if PlayerService:Instance():CheckCardInArmy(_list:Get(i).id) then
                _inArmList:Push(_list:Get(i))
            else
                _outArmList:Push(_list:Get(i))
            end
        end
    end


    for i = 1, _inArmList:Count() do
        inArmtable[i] = _inArmList:Get(i)
    end
    for i = 1, _outArmList:Count() do
        outArmtable[i] = _outArmList:Get(i)
    end


    if _type == HeroSortType.default then
        self.defaultList:Clear();
        table.sort(inArmtable, function(a, b)
            if a.tableID == b.tableID then
                return a.advancedTime > b.advancedTime
            else
                return a.tableID > b.tableID
            end
        end )
        table.sort(inArmtable, function(a, b)
            if a.tableID == b.tableID then
                return a.advancedTime > b.advancedTime
            else
                return a.tableID > b.tableID
            end
        end )
        local protectList = List.new();
        local noProtectLsit = List.new();
        for j = 1, table.getn(outArmtable) do
            if outArmtable[j].isProtect then
                protectList:Push(outArmtable[j])
            else
                noProtectLsit:Push(outArmtable[j])
            end
        end
        for i = 1, noProtectLsit:Count() do
            self.defaultList:Push(noProtectLsit:Get(i))
        end
        for i = 1, protectList:Count() do
            self.defaultList:Push(protectList:Get(i))
        end
        for i = 1, table.getn(inArmtable) do
            self.defaultList:Push(inArmtable[i])
        end
        _list = self.defaultList;
    end


    if _type == HeroSortType.rarity then
        self.rarityList:Clear()
        table.sort(inArmtable, function(a, b)
            if (a.star == b.star) then
                if a.tableID == b.tableID then
                    return a.advancedTime > b.advancedTime
                else
                    return a.tableID > b.tableID
                end
            else
                return a.star > b.star
            end
        end )
        table.sort(outArmtable, function(a, b)
            if (a.star == b.star) then
                if a.tableID == b.tableID then
                    return a.advancedTime > b.advancedTime
                else
                    return a.tableID > b.tableID
                end
            else
                return a.star > b.star
            end
        end )
        local protectList = List.new();
        local noProtectLsit = List.new();
        for j = 1, table.getn(outArmtable) do
            if outArmtable[j].isProtect then
                protectList:Push(outArmtable[j])
            else
                noProtectLsit:Push(outArmtable[j])
            end
        end
        for i = 1, noProtectLsit:Count() do
            self.rarityList:Push(noProtectLsit:Get(i))
        end
        for i = 1, protectList:Count() do
            self.rarityList:Push(protectList:Get(i))
        end
        for i = 1, table.getn(inArmtable) do
            self.rarityList:Push(inArmtable[i])
        end
        _list = self.rarityList;

    end


    if _type == HeroSortType.rarityDown then
        self.rarityList:Clear()
        table.sort(inArmtable, function(a, b)
            if (a.star == b.star) then
                if a.tableID == b.tableID then
                    return a.advancedTime > b.advancedTime
                else
                    return a.tableID > b.tableID
                end
            else
                return a.star < b.star
            end
        end )
        table.sort(outArmtable, function(a, b)
            if (a.star == b.star) then
                if a.tableID == b.tableID then
                    return a.advancedTime > b.advancedTime
                else
                    return a.tableID > b.tableID
                end
            else
                return a.star < b.star
            end
        end )
        local protectList = List.new();
        local noProtectLsit = List.new();
        for j = 1, table.getn(outArmtable) do
            if outArmtable[j].isProtect then
                protectList:Push(outArmtable[j])
            else
                noProtectLsit:Push(outArmtable[j])
            end
        end
        for i = 1, noProtectLsit:Count() do
            self.rarityList:Push(noProtectLsit:Get(i))
        end
        for i = 1, protectList:Count() do
            self.rarityList:Push(protectList:Get(i))
        end
        for i = 1, table.getn(inArmtable) do
            self.rarityList:Push(inArmtable[i])
        end

        _list = self.rarityList;

    end


    if _type == HeroSortType.level then

        self.levelList:Clear()

        table.sort(inArmtable, function(a, b)
            if (a.level == b.level) then
                if a.tableID == b.tableID then
                    return a.advancedTime > b.advancedTime
                else
                    return a.tableID > b.tableID
                end
            else
                return a.level > b.level
            end
        end )
        table.sort(outArmtable, function(a, b)
            if (a.level == b.level) then
                if a.tableID == b.tableID then
                    return a.advancedTime > b.advancedTime
                else
                    return a.tableID > b.tableID
                end
            else
                return a.level > b.level
            end
        end )

        local protectList = List.new();
        local noProtectLsit = List.new();
        for j = 1, table.getn(outArmtable) do
            if outArmtable[j].isProtect then
                protectList:Push(outArmtable[j])
            else
                noProtectLsit:Push(outArmtable[j])
            end
        end
        for i = 1, noProtectLsit:Count() do
            self.levelList:Push(noProtectLsit:Get(i))
        end
        for i = 1, protectList:Count() do
            self.levelList:Push(protectList:Get(i))
        end
        for i = 1, table.getn(inArmtable) do
            self.levelList:Push(inArmtable[i])
        end
        _list = self.levelList;

    end


    if _type == HeroSortType.camp then
        self.campList:Clear()

        table.sort(inArmtable, function(a, b)
            if (a.camp == b.camp) then
                if a.tableID == b.tableID then
                    return a.advancedTime > b.advancedTime
                else
                    return a.tableID > b.tableID
                end
            else
                return a.camp < b.camp
            end
        end )
        table.sort(outArmtable, function(a, b)
            if (a.camp == b.camp) then
                if a.tableID == b.tableID then
                    return a.advancedTime > b.advancedTime
                else
                    return a.tableID > b.tableID
                end
            else
                return a.camp < b.camp
            end
        end )
        local protectList = List.new();
        local noProtectLsit = List.new();
        for j = 1, table.getn(outArmtable) do
            if outArmtable[j].isProtect then
                protectList:Push(outArmtable[j])
            else
                noProtectLsit:Push(outArmtable[j])
            end
        end
        for i = 1, noProtectLsit:Count() do
            self.campList:Push(noProtectLsit:Get(i))
        end
        for i = 1, protectList:Count() do
            self.campList:Push(protectList:Get(i))
        end
        for i = 1, table.getn(inArmtable) do
            self.campList:Push(inArmtable[i])
        end
        _list = self.campList;

    end

    if _type == HeroSortType.cost then
        self.costList:Clear()

        table.sort(inArmtable, function(a, b)
            if (a.cost == b.cost) then
                if a.tableID == b.tableID then
                    return a.advancedTime > b.advancedTime
                else
                    return a.tableID > b.tableID
                end
            else
                return a.cost > b.cost
            end
        end )
        table.sort(outArmtable, function(a, b)
            if (a.cost == b.cost) then
                if a.tableID == b.tableID then
                    return a.advancedTime > b.advancedTime
                else
                    return a.tableID > b.tableID
                end
            else
                return a.cost > b.cost
            end
        end )
        local protectList = List.new();
        local noProtectLsit = List.new();
        for j = 1, table.getn(outArmtable) do
            if outArmtable[j].isProtect then
                protectList:Push(outArmtable[j])
            else
                noProtectLsit:Push(outArmtable[j])
            end
        end
        for i = 1, noProtectLsit:Count() do
            self.costList:Push(noProtectLsit:Get(i))
        end
        for i = 1, protectList:Count() do
            self.costList:Push(protectList:Get(i))
        end
        for i = 1, table.getn(inArmtable) do
            self.costList:Push(inArmtable[i])
        end
        _list = self.costList;

    end

    if _type == HeroSortType.armTtpe then
        self.armTtpeList:Clear()
        local protectList = List.new();
        local noProtectLsit = List.new();
        table.sort(inArmtable, function(a, b)
            if (a.baseArmy == b.baseArmy) then
                if a.tableID == b.tableID then
                    return a.advancedTime > b.advancedTime
                else
                    return a.tableID > b.tableID
                end
            else
                return a.baseArmy < b.baseArmy
            end
        end )
        table.sort(outArmtable, function(a, b)
            if (a.baseArmy == b.baseArmy) then
                if a.tableID == b.tableID then
                    return a.advancedTime > b.advancedTime
                else
                    return a.tableID > b.tableID
                end
            else
                return a.baseArmy < b.baseArmy
            end
        end )
        for j = 1, table.getn(outArmtable) do
            if outArmtable[j].isProtect then
                protectList:Push(outArmtable[j])
            else
                noProtectLsit:Push(outArmtable[j])
            end
        end
        for i = 1, noProtectLsit:Count() do
            self.armTtpeList:Push(noProtectLsit:Get(i))
        end
        for i = 1, protectList:Count() do
            self.armTtpeList:Push(protectList:Get(i))
        end
        for i = 1, table.getn(inArmtable) do
            self.armTtpeList:Push(inArmtable[i])
        end
        _list = self.armTtpeList;
    end



    if _type == HeroSortType.spliteHero then
        local protectList = List.new();
        local noProtectLsit = List.new();
        self.spliteHeroList:Clear()
        table.sort(inArmtable, function(a, b)
            if (a.baseArmy == b.baseArmy) then
                if a.tableID == b.tableID then
                    return a.advancedTime > b.advancedTime
                else
                    return a.tableID > b.tableID
                end
            else
                return a.baseArmy < b.baseArmy
            end
        end )
        table.sort(outArmtable, function(a, b)
            if (a.baseArmy == b.baseArmy) then
                if a.tableID == b.tableID then
                    return a.advancedTime > b.advancedTime
                else
                    return a.tableID > b.tableID
                end
            else
                return a.baseArmy < b.baseArmy
            end
        end )

        for j = 1, table.getn(outArmtable) do
            if outArmtable[j].isProtect then
                protectList:Push(outArmtable[j])
            else
                noProtectLsit:Push(outArmtable[j])
            end
        end
        for i = 1, noProtectLsit:Count() do
            self.spliteHeroList:Push(noProtectLsit:Get(i))
        end
        for i = 1, protectList:Count() do
            self.spliteHeroList:Push(protectList:Get(i))
        end
        for i = 1, table.getn(inArmtable) do
            self.spliteHeroList:Push(inArmtable[i])
        end
        _list = self.spliteHeroList;
    end

    return _list
end

function HeroManage:HideBtn()

    local baseClassCardInfo = UIService:Instance():GetUIClass(UIType.UIHeroCardInfo);
    if baseClassCardInfo ~= nil then
        baseClassCardInfo:HideBtn()
    end

end

function HeroManage:SetCardMapLightList(args)
    self.CardMapLightList = args
end

function HeroManage:GetCardMapLightList()
    return self.CardMapLightList
end


function HeroManage:SetCleanTime(time)

    self.CleanTime = time

end

function HeroManage:GetCleanTime()

    return self.CleanTime

end

function HeroManage:GetHeroNameById(id)
    if id == nil then
        return "";
    end
    return DataHero[id].Name;
end


return HeroManage;

-- endregion
