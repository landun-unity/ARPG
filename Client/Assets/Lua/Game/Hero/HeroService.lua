-- Anchor:Dr
-- Date:16/9/13
-- heroservice

local GameService = require("FrameWork/Game/GameService");

local HeroHandler = require("Game/Hero/HeroHandler");
local HeroManage = require("Game/Hero/HeroManage");
local SendedMsg = false; -- 是否发送了消息
HeroService = class("HeroService", GameService);
local RequestHeroCard = require("MessageCommon/Msg/C2L/Card/RequestHeroCard");
local DataHero = require("Game/Table/model/DataHero");
function HeroService:ctor()

    ----print("HeroService:ctor");
    HeroService._instance = self;
    SendedMsg = false;
    HeroService.super.ctor(self, HeroManage.new(), HeroHandler.new());
end

-- 单例
function HeroService:Instance()
    return HeroService._instance;
end


-- 清空数据
function HeroService:Clear()
    self._logic:ctor()
end


-- 请求卡牌信息 
function HeroService:RequestHeroCard(page)
    self._logic:RequestHeroCard(page);
end

function HeroService:SendExtractSkillMsg(cardID, SkillID)
    -- 发送拆解技能ID
    self._logic:_SendExtractSkillMsg(cardID, SkillID)

end

function HeroService:SendCardProtect(cardID, _bool)
    self._logic:SendCardProtect(cardID, _bool)

end

function HeroService:SendAdvanceMessage(CardID, removeCardID)
    -- 发送拆解技能ID
    self._logic:_SendAdvanceMessage(CardID, removeCardID)

end
-- 打开卡牌信息界面
function HeroService:ShowHeroInfoUI(id)
    self._logic:ShowHeroInfoUI(id)
end

function HeroService:SendAddPointMessage(cardId, atkPoint, defenCount, strageCount, speedCount)
    -- 发送加点消息
    self._logic:_SendAddPointMessage(cardId, atkPoint, defenCount, strageCount, speedCount)

end

function HeroService:SendResetPointMessage(cardId)
    -- 发送洗点消息
    self._logic:_SendResetPointMessage(cardId)

end


function HeroService:GetCardMapLightList()
    return self._logic:GetCardMapLightList()
end


function HeroService:SendAwakeMsg(awakenCard, removeOneCard, removeTwoCard)
    -- 发送觉醒消息
    self._logic:_SendAwakeMessage(awakenCard, removeOneCard, removeTwoCard)

end

function HeroService:ShowAllHeroCards()
    self._logic:ShowAllHeroCard()
end

-- 根据索引得到英雄卡
function HeroService:GetOwnHeroes(mIndex)
    return self._logic:GetOwnHeroes(mIndex);
end

-- 武将数量
function HeroService:GetOwnHeroCount()

    return self._logic:GetOwnHeroCount();

end

--武将排序
function HeroService:sorting(_type, _list)
    return self._logic:sorting(_type, _list);
end

--武将背包排序
function HeroService:sortingInPackage(_type, _list)
    return self._logic:sortingInPackage(_type, _list);
end


function HeroService:GetOwnHeroNameById(id)
    local info = self._logic:GetOwnHeroesById(id);
    if (info ~= nil) then
        return DataHero[info.tableID].Name
    end
    return ""
end

function HeroService:GetHeroById(args)
    return self._logic:GetHeroById(args)
end

function HeroService:GetOwnHeroesById(id)
    return self._logic:GetOwnHeroesById(id);
end

-- 通过类型返回步兵弓兵骑兵等的图片
function HeroService:GetSpriteByTppe(armytype)
    if (armytype == 1) then
        -- 骑兵
        return "Cavalryman";
    end
    if (armytype == 2) then
        -- 弓兵
        return "Archer";
    end
    if (armytype == 3) then
        -- 步兵
        return "Infantry";
    end
    return "";
end

-- 通过类型返回阵营图片
function HeroService:GetCampSprite(armytype)
    local temp = "";
    if (armytype == 1) then
        -- 琴兵
        temp = "herobag_text_camp_han";
    end
    if (armytype == 2) then
        -- 弓兵
        temp = "herobag_text_camp_shu";
    end
    if (armytype == 3) then
        -- 步兵
        temp = "herobag_text_camp_wei";
    end
    if (armytype == 4) then
        -- 步兵
        temp = "herobag_text_camp_wu";
    end
    return temp;
end

function HeroService:GetCleanTime()


    return self._logic:GetCleanTime()

end

function HeroService:SetCleanTime(time)

    self._logic:SetCleanTime(time)

end

function HeroService:SendResetCardMessage(Cardid)

    self._logic:SendResetCardMessage(Cardid)

end

function HeroService:HideBtn()

    self._logic:HideBtn()

end


-- 设置排序后武将卡
function HeroService:SetSortList(a)

    self._logic:SetSortedList(a)

end


function HeroService:GetSortList()

    return self._logic:GetSortedList()

end


-- 设置卡包上限
function HeroService:SetCardMaxLimit(args)

    self._logic:SetCardMaxLimit(args)

end

function HeroService:GetCardMaxLimit()

    return self._logic:GetCardMaxLimit()

end

function HeroService:GetHeroNameById(id)
    return self._logic:GetHeroNameById(id);
end

function HeroService:InsertHeroCard(heroCard)
    -- body
    self._logic:InsertHeroCard(heroCard);
end

function HeroService:SetAllCardsActive(args)
    local isOpen = UIService:Instance():GetOpenedUI(UIType.UIHeroCardPackage)
    if isOpen then
        UIService:Instance():GetUIClass(UIType.UIHeroCardPackage):SetAllCardsAcitve(args)
    end
end


return HeroService;

-- endregion
