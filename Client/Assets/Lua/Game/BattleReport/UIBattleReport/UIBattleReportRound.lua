local UIBase= require("Game/UI/UIBase");
local UIBattleReportRound=class("UIBattleReportRound",UIBase);
local List = require("common/List");
local UIType=require("Game/UI/UIType");
local UIConfigTable=require("Game/Table/model/DataUIConfig");
local DetailItem = require("Game/BattleReport/UIBattleReport/UIBattleReportPersionRound");
local DesItem = require("Game/BattleReport/UIBattleReport/UIBattleReportDetailItem");
local OutOfBattleReportType = require("Game/BattleReport/BattleReportFlow/OutOfBattleReportType");
local NullReportReasonType = require("Game/BattleReport/BattleReportFlow/NullReportReasonType");
local BattleFlowType = require("Game/BattleReport/BattleFlowType");
local DataHero = require("Game/Table/model/DataHero");
local CurrencyEnum = require("Game/Player/CurrencyEnum");
local List = require("common/List");
local HeroData = require("Game/Table/model/DataHero")
local Red = "<color=#ae3030>"
local Green = "<color=#2cb251>"
local colorEnd = "</color>";
local OccupyType = require("Game/BattleReport/OccupyType");
local BuildingService = require("Game/Build/BuildingService");

function UIBattleReportRound:ctor()
    UIBattleReportRound.super.ctor(self)
    self._AllRoundList = List.new();
    self._AllBeforeRoundList = List.new();
    self._AllAfterRoundList = List.new();
    self.DetailItemPrefab = UIConfigTable[UIType.UIBattleReportPersionRound].ResourcePath;
    self.DesPrefab = UIConfigTable[UIType.UIBattleReportDetailItem].ResourcePath;
    self.Title = nil;
    self.BgLayoutElement = nil;
    self.Parent = nil;
    self.BeforeParent = nil;
    self.AfterParent = nil;
    self.roundIndex = 0;
    self.Attacker = "";
    self.battletype = 0;
    self.ResultUI = nil;    --战斗结果UI
    self.HaveBattle = true;  --是否有战斗的情况

    self.CallBackObj = nil;
    self.CallbackFun = nil;
end

function UIBattleReportRound:DoDataExchange()
    self.Title = self:RegisterController(UnityEngine.UI.Text,"Text")
    self.Parent = self:RegisterController(UnityEngine.Transform,"Bg/Parent")
    self.BgLayoutElement = (self:RegisterController(UnityEngine.Transform,"Bg")).gameObject:GetComponent(typeof(UnityEngine.UI.LayoutElement))
    self.BeforeParent = self:RegisterController(UnityEngine.Transform,"Bg/BeforeRound")
    self.AfterParent = self:RegisterController(UnityEngine.Transform,"Bg/AfterRound")
end

--初始化所有战报回合前的列表
function UIBattleReportRound:InitPreparatoryStage(beforeroundList,battletype,battleResult,drawtimes)
    self.HaveBattle = true;
    self.battletype = battletype;
   self.Title.text = "";
   self:SetAllFalse();
   self.BeforeParent.gameObject:SetActive(true);
   local count = beforeroundList:Count()

   local line = HeroData[beforeroundList:Get(1).CardID];
   self:ShowNoCards(battletype,line);

   self:InitResult(battletype,battleResult,drawtimes);
   for index = 2,count do
        local beforeround = beforeroundList:Get(index)
        local mDesItem = self._AllBeforeRoundList:Get(index+1);
        if(mDesItem~=nil) then
            mDesItem.gameObject:SetActive(true);
            self:InitOnePrepare(beforeround,mDesItem)
        else
            self:AddBeforeDes(beforeround);
        end
   end
   if(self.ResultUI~=nil) then
        self.ResultUI.gameObject:SetActive(self.HaveBattle)
   end
end

-- 显示防守方部队为空
function UIBattleReportRound:ShowNoCards( battletype,line )
    -- body
    local temp = "";
     if(battletype == BattleReportType.Defence) then
        temp = "【我方没有武将出战】";
    else
        temp = "【对方没有武将出战】";
    end
    -- print(self._AllBeforeRoundList);
    local mDesItem = self._AllBeforeRoundList:Get(1);
    if(mDesItem~=nil) then
        
        mDesItem:InitImageAndText(nil,temp);
        if(line==nil) then
            mDesItem.gameObject:SetActive(true);
        else
            mDesItem.gameObject:SetActive(false);
        end
    else
        mDesItem = DesItem.new();
        GameResFactory.Instance():GetUIPrefab(self.DesPrefab,self.BeforeParent,mDesItem,function (go)
            mDesItem:Init();
            self._AllBeforeRoundList:Push(mDesItem);
            mDesItem:InitImageAndText(nil,temp);
            if(line==nil) then
                mDesItem.gameObject:SetActive(true);
            else
                mDesItem.gameObject:SetActive(false);
            end
        end);
    end
end

--在回合前显示战斗结果
function UIBattleReportRound:InitResult(battletype,battleResult,drawtimes)
    local text = BattleReportService:Instance():GetResultText(battletype,battleResult,drawtimes);
    local mDesItem = self._AllBeforeRoundList:Get(2);
    if(mDesItem~=nil) then
        mDesItem.gameObject:SetActive(true);
        mDesItem:InitImageAndText(nil,text);
        self.ResultUI = mDesItem;
        self.ResultUI.gameObject:SetActive(self.HaveBattle)
    else
        local mDesItem = DesItem.new();
        GameResFactory.Instance():GetUIPrefab(self.DesPrefab,self.BeforeParent,mDesItem,function (go)
            mDesItem:Init();
            self._AllBeforeRoundList:Push(mDesItem);
            mDesItem:InitImageAndText(nil,text);
            self.ResultUI = mDesItem;
            self.ResultUI.gameObject:SetActive(self.HaveBattle)
        end);
    end
end

--初始化回合前的一行数据
function UIBattleReportRound:InitOnePrepare(info,ui)
    if(info.OutType ==OutOfBattleReportType.AddExp)then
        local isourpart = BattleReportService:Instance():isOurPart(info.IsAttackPart,self.battletype);
        local str = self:GetHeroName(info.CardID,isourpart).."获得<color=#E6CFACFF>"..info.Exp.."</color>经验";
        if(info.isUpLevel) then
            str = str.."(等级提升至<color=#E6CFACFF>"..info.cardLevel.."</color>)";
        end
        ui:InitImageAndText(BattleReportService:Instance():getAttackerOrDefenderSprite(info.IsAttackPart,isourpart),str);
    end
    if(info.OutType ==OutOfBattleReportType.TroopNum)then
        local isourpart = BattleReportService:Instance():isOurPart(info.IsAttackPart,self.battletype);
        ui:InitImageAndText(BattleReportService:Instance():getAttackerOrDefenderSprite(info.IsAttackPart,isourpart),self:GetHeroName(info.cardId,isourpart).."战斗后兵力为<color=#E6CFACFF>"..info.troopNum.."</color>，产生伤兵<color=#D94444FF>"..info.woundNum.."</color>");
    end
    if(info.OutType ==OutOfBattleReportType.ChangeDurable)then
        local x,y =  MapService:Instance():GetTiledCoordinate(info.tileIndex);
        local landandaddress = BattleReportService:Instance():GetTiledName(info.tileIndex,info.type,info.buildingID,info.name).."("..x..","..y..")"
        ui:InitImageAndText(nil,landandaddress.."的耐久下降<color=#E6CFACFF>"..info.changValue.."</color>");
    end
    if(info.OutType ==OutOfBattleReportType.GetResource)then
        ui:InitGetRescouse(self:GetResource(info))
    end
    if(info.OutType ==OutOfBattleReportType.Occupy)then
        local x,y =  MapService:Instance():GetTiledCoordinate(info.tileIndex);
        
        if(self.battletype == BattleReportType.Defence) then
            if(info.OccupyType== OccupyType.OccupyBuilding) then
                local landandaddress = BattleReportService:Instance():GetTiledName(info.tileIndex,info.OccupyType,info.buildingID,info.name).. "("..x..","..y..")"
                ui:InitImageAndText(nil,"失去建筑"..landandaddress);
            else
                local landandaddress = BattleReportService:Instance():GetTiledName(info.tileIndex,info.OccupyType,info.buildingID,info.name).. "("..x..","..y..")"
                ui:InitImageAndText(nil,"失去领地"..landandaddress);
            end
        else
            local landandaddress = BattleReportService:Instance():GetTiledName(info.tileIndex,info.OccupyType,info.buildingID,info.name).. "("..x..","..y..")"
            ui:InitImageAndText(nil,"占领领地"..landandaddress);
        end
    end
    if(info.OutType ==OutOfBattleReportType.LeagueExp)then
        ui:InitImageAndText(nil,"同盟获得<color=#E6CFACFF>"..info.exp.."</color>经验");
    end
    if(info.OutType ==OutOfBattleReportType.AddWuxun)then
        ui:InitImageAndText(nil,"获得<color=#E6CFACFF>"..info.WnxunValue.."</color>武勋");
    end
    -- if(info.OutType ==OutOfBattleReportType.LoseBuilding)then
    --     local x,y =  MapService:Instance():GetTiledCoordinate(info.tileId);
    --     local landandaddress =self:GetTiledName(info.tileId,OccupyType.OccupyBuilding,info.buildingID,info.name).. "("..x..","..y..")" --info.name.."("..x..","..y..")"
    --     ui:InitImageAndText(nil,"失去建筑"..landandaddress);
    -- end
    -- if(info.OutType ==OutOfBattleReportType.LoseLand)then
    --     local x,y =  MapService:Instance():GetTiledCoordinate(info.tiledID);
    --     local landandaddress = self:GetTiledName(info.tiledID,OccupyType.OccupyTiled,info.buildingID,info.name).."("..x..","..y..")"
    --     ui:InitImageAndText(nil,"失去领地"..landandaddress);
    -- end
    if(info.OutType ==OutOfBattleReportType.NullReportReason)then
        self.HaveBattle = false;
        if(self.CallbackFun) then
            self.CallbackFun(self.CallBackObj);
        end
        if(info.NullReportReasonType == NullReportReasonType.NoAdjacentTiled) then
            ui:InitImageAndText(nil,"【该土地周围无相邻土地】");
        end   
        if(info.NullReportReasonType == NullReportReasonType.TiledFree) then
            ui:InitImageAndText(nil,"【该土地处于免战期】");
        end 
        if(info.NullReportReasonType == NullReportReasonType.TiledStateChange) then
            ui:InitImageAndText(nil,"【该土地状态发生改变】");
        end      
    end
     if(info.OutType ==OutOfBattleReportType.FrameNotEnough)then
        ui:InitImageAndText(nil,"由于名望不足，无法占领目标");
    end
end

function UIBattleReportRound:SetUnBattle(obj,fun)
    self.CallBackObj = obj;
    self.CallbackFun = fun;
end

--通过ID获取英雄卡牌名字
function UIBattleReportRound:GetHeroName(heroid,isourpart)
    local line = DataHero[heroid];
    if(line~=nil) then
        if(isourpart)then
            return Green.."【"..line.Name.."】"..colorEnd;
        else
            return Red.."【"..line.Name.."】"..colorEnd;
        end
    end
    return "";
end

--获得的资源列表
function UIBattleReportRound:GetResource(info)
    local reslist = List.new()
    reslist:Push("");
    reslist:Push("获得");
    for index = 1,info.resKey:Count() do
        local key = info.resKey:Get(index)
        local value = info.res[key];
        local res = self:GetResNameByType(key)
        reslist:Push(res);
        reslist:Push(value);
    end
    if(info.ReserveSoldiers~=0) then
        reslist:Push(self:GetResNameByType());
        reslist:Push(info.ReserveSoldiers);
    end
    return reslist
end

--通过类型获取资源名
function UIBattleReportRound:GetResNameByType(restype)
    if(restype == CurrencyEnum.Wood) then
        return "timber1";
    end
    if(restype == CurrencyEnum.Iron) then
        return "iron1";
    end
    if(restype == CurrencyEnum.Stone) then
        return "stone1";
    end
    if(restype == CurrencyEnum.Grain) then
        return "grain1";
    end
    if(restype == CurrencyEnum.Money) then
        return "Copper";
    end
    if(restype == CurrencyEnum.Jade) then
        return "Diamond";
    end
    --[[if(restype == CurrencyEnum.Rnown) then
        return "名望";
    end
    if(restype == CurrencyEnum.Decree) then
        return "政令";
    end
    if(restype == CurrencyEnum.Arms) then
        return "兵种经验";
    end
    ]]
    if(restype == CurrencyEnum.Warfare) then
        return "Tactics2";
    end
    return "troops1"
end

--初始化每回合
function UIBattleReportRound:InitRound(index,roundinfo,battletype)
    self.battletype = battletype;
    self.Parent.gameObject:SetActive(false);
    if(index==1) then
        self.Title.text = "战前准备回合";
    elseif(index==2) then
        self.Title.text = "指挥技能回合";
    else
        self.Title.text = "第 "..(index-2).." 回合";
    end    
    self.roundIndex = 0;
    self:SetAllFalse();
    for inde = 1,roundinfo:Count() do
        local infoList = roundinfo:Get(inde)
        if(infoList.BattleFlowType == BattleFlowType.Effect) then
            if(index<=2) then
                self:InitEffectRound(roundinfo,true);
            else
                self:InitEffectRound(roundinfo,false);
            end
            break;
        end
        if(index<=2) then
            self:InitTheRound(infoList,true);
        else
            self:InitTheRound(infoList,false);
        end
    end

end

--显示战斗结束
function UIBattleReportRound:BattleOver()
    self.Parent.gameObject:SetActive(false);
    self.Title.text = "战斗结束";
    self:SetAllFalse();
end

--初始化每一个效果行 （这个是战斗阵容）
function UIBattleReportRound:InitEffectRound(infoList,isbeforeround)
     self.Parent.gameObject:SetActive(true);
    self.roundIndex = self.roundIndex + 1;
    local mDetailItem = self._AllRoundList:Get(self.roundIndex);
    if(mDetailItem~=nil) then
        mDetailItem:initGrayBack();
        mDetailItem.gameObject:SetActive(true);
        mDetailItem:InitAllEffectRound(infoList,self.battletype,isbeforeround);
    else
        mDetailItem = DetailItem.new();
        GameResFactory.Instance():GetUIPrefab(self.DetailItemPrefab,self.Parent,mDetailItem,function (go)
            mDetailItem:Init();
            mDetailItem:InitAllEffectRound(infoList,self.battletype,isbeforeround);
            self._AllRoundList:Push(mDetailItem);
            mDetailItem.gameObject:SetActive(true);
        end);
    end
end

--处理每一个小回合的战斗步骤
function UIBattleReportRound:InitTheRound(infoList,isbeforeround)
    if(infoList.FlowList~=nil and infoList.FlowList:Count()==0) then
        return;
    else
        self.Parent.gameObject:SetActive(true);
    end

    self.roundIndex = self.roundIndex + 1;
    local mDetailItem = self._AllRoundList:Get(self.roundIndex);
    if(mDetailItem~=nil) then
        mDetailItem:initGrayBack();
        mDetailItem.gameObject:SetActive(true);
        mDetailItem:InitPersonRound(infoList.TiledHeroId,infoList.FlowList,self.battletype,isbeforeround,infoList.isgray);
    else
        mDetailItem = DetailItem.new();
        GameResFactory.Instance():GetUIPrefab(self.DetailItemPrefab,self.Parent,mDetailItem,function (go)
            mDetailItem:Init();
            mDetailItem:InitPersonRound(infoList.TiledHeroId,infoList.FlowList,self.battletype,isbeforeround,infoList.isgray);
            self._AllRoundList:Push(mDetailItem);
            mDetailItem.gameObject:SetActive(true);
        end);
    end
end

-- 加载准备一行数据并初始化 （回合前的都加在了front上边）
function UIBattleReportRound:AddBeforeDes(beforeround)
    local mDesItem = DesItem.new();
    GameResFactory.Instance():GetUIPrefab(self.DesPrefab,self.BeforeParent,mDesItem,function (go)
        mDesItem:Init();
        self._AllBeforeRoundList:Push(mDesItem);
        self:InitOnePrepare(beforeround,mDesItem)
        mDesItem.gameObject:SetActive(true);
    end);
end

--隐藏所有的列表
function UIBattleReportRound:SetAllFalse()
    for index = 1,self._AllRoundList:Count() do
        self._AllRoundList:Get(index).gameObject:SetActive(false);
    end
    for index = 1,self._AllBeforeRoundList:Count() do
        self._AllBeforeRoundList:Get(index).gameObject:SetActive(false);
    end
    for index = 1,self._AllAfterRoundList:Count() do
        self._AllAfterRoundList:Get(index).gameObject:SetActive(false);
    end
end

local index = 0;


return UIBattleReportRound