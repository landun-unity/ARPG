-- 登录消息处理
local IOHandler = require("FrameWork/Game/IOHandler")
require("Game/Hero/HeroCardPart/HeroSortType")
require("Game/Table/model/DataHero")
local HeroHandler = class("HeroHandler", IOHandler)
local List = require("common/List");
local DataHero = require("Game/Table/model/DataHero");
local HeroCard = require("Game/Hero/HeroCardPart/HeroCard");

-- 构造函数
function HeroHandler:ctor()
    -- body
    HeroHandler.super.ctor(self);
end

-- 注册所有消息
function HeroHandler:RegisterAllMessage()
    self:RegisterMessage(L2C_Card.AddCardsRespond, self.AddCardsRespond, require("MessageCommon/Msg/L2C/Card/AddCardsRespond"));
    self:RegisterMessage(L2C_Card.PlayerHeroCardPage, self.HandlePlayerHeroCardPage, require("MessageCommon/Msg/L2C/Card/PlayerHeroCardPage"));
    self:RegisterMessage(L2C_Card.RemoveCard, self.HandleDeletePlayerHeroCard, require("MessageCommon/Msg/L2C/Card/RemoveCard"));
    self:RegisterMessage(L2C_Card.AdvancerCardSusses, self.HandleAdvancePlayerHeroCard, require("MessageCommon/Msg/L2C/Card/AdvancerCardSusses"));
    self:RegisterMessage(L2C_Card.AwakeOneCardSusses, self.HandleAwakePlayerHeroCard, require("MessageCommon/Msg/L2C/Card/AwakeOneCardSucess"));
    --  self:RegisterMessage(L2C_Card.ExtractSkillSucess, self.HandleExtractPlayerHeroCard, require("MessageCommon/Msg/L2C/Card/ExtractSkillSucess"));
    self:RegisterMessage(L2C_Card.OneCardProperty, self.HandleAddPointPlayerHeroCard, require("MessageCommon/Msg/L2C/Card/OneCardProperty"));
    self:RegisterMessage(L2C_Card.CardMapLightList, self.HandleCardMapLightList, require("MessageCommon/Msg/L2C/Card/CardMapLightList"));
end

function HeroHandler:HandlePlayerHeroCardPage(msg)
    for index = 1, msg.list:Count() do
        local herocard = require("Game/Hero/HeroCardPart/HeroCard").new();
        local mmHerocard = msg.list:Get(index);
        herocard.id = mmHerocard.id;
        herocard.tableID = mmHerocard.tableID;
        herocard.exp = mmHerocard.exp;
        herocard.advancedTime = mmHerocard.advancedTime;
        herocard:InitPower(mmHerocard.power)
        herocard.power:SetValue(mmHerocard.power);
        -- print("   发来的体力："..mmHerocard.power.."  获取的值："..herocard.power:GetValue());
        -- print("mmHerocard.troop:" .. mmHerocard.troop)
        herocard.troop = mmHerocard.troop;
        herocard.point = mmHerocard.point;
        herocard.isProtect = mmHerocard.isProtect;
        herocard.isAwaken = mmHerocard.isAwaken;
        herocard.level = mmHerocard.level;
        herocard.attack = mmHerocard.attacktPoint;
        herocard.def = mmHerocard.defensePoint;
        herocard.strategy = mmHerocard.strategyPoint;
        herocard.speed = mmHerocard.speedPoint;
        herocard.allSkillSlotList[1] = mmHerocard.skillIDOne;
        herocard.allSkillSlotList[2] = mmHerocard.skillTwoID;
        herocard.allSkillSlotList[3] = mmHerocard.skillThreeID;
        herocard.allSkillLevelList[1] = mmHerocard.skillOneLevel;
        herocard.allSkillLevelList[2] = mmHerocard.skillTwoLevel;
        herocard.allSkillLevelList[3] = mmHerocard.skillThreeLevel;
        herocard.lastResetPointTime = mmHerocard.lastResetPointTime;
        herocard.lastResetCardTime = mmHerocard.lastResetCardTime;
        herocard.RecoverTime = mmHerocard.badlyHurtTime;
        herocard.TiredTime = mmHerocard.tiredRecoverTime;
        herocard:SetHurtTimer();
        herocard:SetTiredTimer();
        if DataHero[mmHerocard.tableID] == nil then
            -- print("Error!!!! add one card failed which tableid = " .. mmHerocard.tableID);
        else
            herocard.baseArmy = DataHero[mmHerocard.tableID].BaseArmyType;
            herocard.cost = DataHero[mmHerocard.tableID].Cost;
            herocard.star = DataHero[mmHerocard.tableID].Star;
            herocard.camp = DataHero[mmHerocard.tableID].Camp;
        end
        self._logicManage:InsertHeroCard(herocard);
    end

    if UIService:Instance():GetUIClass(UIType.UIHeroCardPackage) ~= nil then
        UIService:Instance():GetUIClass(UIType.UIHeroCardPackage):OnShow();
        UIService:Instance():GetUIClass(UIType.UIHeroCardPackage):ReShow();
    end

    if msg.curPage < msg.maxPage and msg.curPage > 0 then
        self._logicManage:RequestHeroCard(msg.curPage + 1);
    else
        LoginService:Instance():EnterState(LoginStateType.RequestSkillInfo);
    end
end

function HeroHandler:AddCardsRespond(msg)
    -- print(msg.cards:Count())
    for index = 1, msg.cards:Count() do
        local herocard = require("Game/Hero/HeroCardPart/HeroCard").new();
        local mmHerocard = msg.cards:Get(index);
        herocard.id = mmHerocard.id;
        herocard.tableID = mmHerocard.tableID;
        herocard.exp = mmHerocard.exp;
        herocard.advancedTime = mmHerocard.advancedTime;
        herocard:InitPower(mmHerocard.power)
        herocard.power:SetValue(mmHerocard.power);
        herocard.troop = mmHerocard.troop;
        herocard.point = mmHerocard.point;
        herocard.isProtect = mmHerocard.isProtect;
        herocard.isAwaken = mmHerocard.isAwaken;
        herocard.level = mmHerocard.level;
        herocard.attack = mmHerocard.attacktPoint;
        herocard.def = mmHerocard.defensePoint;
        herocard.strategy = mmHerocard.strategyPoint;
        herocard.speed = mmHerocard.speedPoint;
        herocard.allSkillSlotList[1] = mmHerocard.skillIDOne;
        herocard.allSkillSlotList[2] = mmHerocard.skillTwoID;
        herocard.allSkillSlotList[3] = mmHerocard.skillThreeID;
        herocard.allSkillLevelList[1] = mmHerocard.skillOneLevel;
        herocard.allSkillLevelList[2] = mmHerocard.skillTwoLevel;
        herocard.allSkillLevelList[3] = mmHerocard.skillThreeLevel;
        herocard.lastResetPointTime = mmHerocard.lastResetPointTime;
        herocard.lastResetCardTime = mmHerocard.lastResetCardTime;
        if DataHero[mmHerocard.tableID] == nil then
            -- print("Error!!!! add one card failed which tableid = " .. mmHerocard.tableID);
            -- return;
        else
            herocard.baseArmy = DataHero[mmHerocard.tableID].BaseArmyType;
            herocard.cost = DataHero[mmHerocard.tableID].Cost;
            herocard.star = DataHero[mmHerocard.tableID].Star;
            herocard.camp = DataHero[mmHerocard.tableID].Camp;
        end
        self._logicManage:InsertHeroCard(herocard);
    end
end

function HeroHandler:HandleDeletePlayerHeroCard(msg)
    for index = 1, msg.removeCardList:Count() do
        self._logicManage:RemoveCard(msg.removeCardList:Get(index));
        if GameResFactory.Instance():GetInt(msg.removeCardList:Get(index) .. PlayerService:Instance():GetPlayerId()) ~= 0 then
            GameResFactory.Instance():ClearInt(msg.removeCardList:Get(index) .. PlayerService:Instance():GetPlayerId())
        end
    end
    if UIService:Instance():GetUIClass(UIType.UIHeroCardPackage) == nil then
        return
    end
    UIService:Instance():GetUIClass(UIType.UIHeroCardPackage):OnShow()
end


function HeroHandler:HandleAddPointPlayerHeroCard(msg)
    -- print(msg.model.advancedTime)
    local heroCard = self._logicManage:GetOwnHeroesById(msg.model.id);
    if heroCard ~= nil then
        heroCard.attack = msg.model.attacktPoint;
        heroCard.def = msg.model.defensePoint;
        heroCard.strategy = msg.model.strategyPoint;
        heroCard.speed = msg.model.speedPoint;
        heroCard.speed = msg.model.speedPoint;
        heroCard.point = msg.model.point;
        heroCard.exp = msg.model.exp;
        heroCard.advancedTime = msg.model.advancedTime
        heroCard.power:SetValue(msg.model.power);
        heroCard.isProtect = msg.model.isProtect;
        heroCard.isAwaken = msg.model.isAwaken;
        heroCard.level = msg.model.level;
        heroCard.allSkillSlotList[1] = msg.model.skillIDOne;
        heroCard.allSkillSlotList[2] = msg.model.skillTwoID;
        heroCard.allSkillSlotList[3] = msg.model.skillThreeID;
        heroCard.allSkillLevelList[1] = msg.model.skillOneLevel;
        heroCard.allSkillLevelList[2] = msg.model.skillTwoLevel;
        heroCard.allSkillLevelList[3] = msg.model.skillThreeLevel;
        heroCard.lastResetPointTime = msg.model.lastResetPointTime;
        heroCard.lastResetCardTime = msg.model.lastResetCardTime;
    end
    local data = { heroCard, true};

    local baseClassCardInfo = UIService:Instance():GetUIClass(UIType.UIHeroCardInfo);
    local baseClassOpenCardInfo = UIService:Instance():GetOpenedUI(UIType.UIHeroCardInfo);
    local baseClass = UIService:Instance():GetUIClass(UIType.UIHeroCardPackage);

    if UIService:Instance():GetOpenedUI(UIType.UITactisTransExp) then
        UIService:Instance():GetUIClass(UIType.UITactisTransExp):ShowTheBox()
    end
    if UIService:Instance():GetOpenedUI(UIType.UITactisResearch) then
        UIService:Instance():GetUIClass(UIType.UITactisResearch):ShowTheBox()
    end

    if UIService:Instance():GetOpenedUI(UIType.UIHeroSpliteHero) == false then
        UIService:Instance():HideUI(UIType.UIHeroSpliteHero)
    else
        UIService:Instance():GetUIClass(UIType.UIHeroSpliteHero):ShowTheBox()
    end

    if UIService:Instance():GetOpenedUI(UIType.UIHeroSpliteSkill) == false then
        UIService:Instance():HideUI(UIType.UIHeroSpliteSkill)
    end

    if UIService:Instance():GetOpenedUI(UIType.UIHeroAwake) then
        if baseClassOpenCardInfo == false then
            UIService:Instance():HideUI(UIType.UIHeroAwake)
        end
        if baseClassOpenCardInfo then
            baseClassCardInfo:OnShow(data)
        else
            UIService:Instance():ShowUI(UIType.UIHeroCardInfo, data)
        end
    end

    if baseClass ~= nil then
        baseClass:OnShow()
    end

    local baseClassOpen = UIService:Instance():GetOpenedUI(UIType.UIHeroCardPackage);
    local BaseClassHeroadvance = UIService:Instance():GetOpenedUI(UIType.UIHeroAdvance);

    if baseClassCardInfo ~= nil then
        baseClassCardInfo:OpenAddPoint()
    end

    if baseClassCardInfo ~= nil and baseClassOpenCardInfo and BaseClassHeroadvance == false then
        baseClassCardInfo:OnShow(data)
        baseClassCardInfo:OpenAddPoint()
    end

    if baseClassCardInfo ~= nil and BaseClassHeroadvance == true then
        --- 是否打开了进阶页面的武将详情，如果打开了，更新数据，如果没有打开进阶成功需要打开一下武将详情界面
        if baseClassOpenCardInfo == false then
            UIService:Instance():HideUI(UIType.UIHeroAdvance)
        end
        if baseClassOpenCardInfo == false then
            UIService:Instance():ShowUI(UIType.UIHeroCardInfo, data)
            baseClass:OnShow()
        else
            baseClassCardInfo:OnShow(data)
        end

    end

    if BaseClassHeroadvance then
        UIService:Instance():GetUIClass(UIType.UIHeroAdvance):OnShow(UIService:Instance():GetUIClass(UIType.UIHeroAdvance):GetData());
    end

    if UIService:Instance():GetOpenedUI(UIType.UIHeroAdvance) == false then
    else
        UIService:Instance():GetUIClass(UIType.UIHeroAdvance):ShowTheBox()
    end

    -- 配置队伍界面若打开则刷新最新数据
    -- 队伍功能界面刷新
    local baseClass = UIService:Instance():GetUIClass(UIType.ArmyFunctionUI);
    if baseClass ~= nil then
        baseClass:RefreshArmyPart();
        baseClass:RefreshUIShow(false);
    end
end

function HeroHandler:HandleAdvancePlayerHeroCard(msg)
    UIService:Instance():GetUIClass(UIType.UIHeroCardInfo):AdvanceSucessful()
end


function HeroHandler:HandleAwakePlayerHeroCard(msg)
    UIService:Instance():GetUIClass(UIType.UIHeroCardInfo):AwakeSucessful()
end

function HeroHandler:HandleExtractPlayerHeroCard(msg)

end

function HeroHandler:ReShowCardInfoUI()

end

function HeroHandler:GetMyHeroList()

    local size = HeroService:Instance():GetOwnHeroCount();
    local herolist = List:new();
    for i = 1, size do
        herolist:Push(HeroService:Instance():GetOwnHeroes(i))
    end

    return herolist;
end

function HeroHandler:GetMsgHero(id)

    local size = HeroService:Instance():GetOwnHeroCount();
    local herolist = List:new();
    local hero = nil;
    for i = 1, size do
        if HeroService:Instance():GetOwnHeroes(i).id == id then
            local hero = HeroService:Instance():GetOwnHeroes(i);
        end
    end

    return hero;

end

function HeroHandler:HandleCardMapLightList(msg)
    self._logicManage:SetCardMapLightList(msg.cardTable)
    UIService:Instance():GetUIClass(UIType.UIHeroCardPackage):GoToHeroHandBook()
end


return HeroHandler;
