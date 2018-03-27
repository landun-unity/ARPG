local GamePart = require("FrameWork/Game/GamePart")

local PlayerManage = class("PlayerManage", GamePart)
local List = require("common/List");
local VariationCalc = require("Game/Util/VariationCalc")
local DecreeSystem = require("Game/Currency/DecreeSystem");
local CurrencyEnum = require("Game/Player/CurrencyEnum")
local DataGameConfig = require("Game/Table/model/DataGameConfig");
local FacilityType = require("Game/Facility/FacilityType");
local DataCharacterInitial = require("Game/Table/model/DataCharacterInitial");
local BuildingType = require("Game/Build/BuildingType");
local Marker = require("Game/Map/Marker")
local Client = require("Game/Client")
require("Game/Table/model/DataBuilding");
require("Game/Table/model/DataCharacterFame");
require("Game/Facility/FacilityProperty");
require("Game/Table/model/DataAlliesLevel");
require("Game/Table/model/DataCharacterFame");


-- 构造函数
function PlayerManage:ctor()
    PlayerManage.super.ctor(self);
    -- 货币
    self.currencyTable = { };
    self:Init();
    -- 角色Id
    self._playerId = 0;
    -- 账户Id
    self._accountId = 0;
    -- 验证码
    self._certificate = "";
    -- 名称
    self._name = "";
    -- 当前选择区名称
    self._regionId = 0;
    -- 主城索引
    self._mainCityTiledId = 0;
    -- 主城表id
    self.mainCityTableId = 0;
    -- 主城id
    self.mainCityId = 0
    -- 服务器时间
    self._localTime = 0;
    -- 计时器数字
    self._timerNum = 0;
    -- 同步服务器timer
    self._serverTimer = nil;
    -- 玩家同盟id
    self.leagueid = 0;
    -- 同盟等级
    self.leagueLevel = 0;
    --出生州
    self.spawnState = 0;
    -- 同盟名称
    self.leagueName = ""
    -- 玩家介绍
    self.profile = "";
    -- 玩家职位
    self.title = 0;
    -- 上级同盟名称
    self.superiorName = "";
    -- 玩家上级同盟id
    self.spueriorLeagueid = 0;
    -- 标记
    self.markerList = { };
    -- 标记图标键值段
    self.makrerIconMap = { }
    -- 玩家信息
    self.playerBaseInfo = nil;

    -- 玩家城市列表（包括主城和建造完成的分城）
    self._playerCityInfoList = { }

    -- 玩家所有分城（包括在建中）id列表
    self._playerSubCityIdList = {};

    self.CreateBuildingTime = { }
    -- 要塞列表
    self.PlayerFort = { };
    -- 创建要塞当前时间
    self.CurrentFortTime = { }
    -- 要塞
    self.CreateBuildingFort = { }

    -- 所有的要塞列表 （包括正在建造中的）
    self.Fort = { };
    -- 已经建设完成的要塞
    self.succeedForts = {};

    -- 野外要塞列表
    self.CreateOccupyWildFort = {}

    self._playerTiledIdList = List.new()

    --Tiledid 和 TiledDurable  Table
    self._playerTiledDurableList = {};

    self._PlayerTiledInfoList = {};  -- 个人势力用

    -- 要塞编号
    self.fortNumber = 1;
    -- 主城标记
    self.MainCitySign = { }

    self._collectionGold = 0;

    self.baseConstructQueueMax = 0;
    -- 玩家基础建造队列上限
    self.tempConstructQueueMax = 0;
    -- 玩家临时建造队列上限
    self.resourceMax = 0;

    self.createTemporaryFort = {}

    -- 所有建设完成的建筑（主城 分城 要塞）
    self.allCity = {};
    -- 税收金币
    self.ClickRevenueGold = nil;
    -- 税收次数
    self.RevenueCount = 0;
    -- 税收时间
    self.RevenuefinishTime = nil;
    -- 强增次数
    self.ForceRevenueCount = nil;

    -- 第一次征收金币
    self.oneGold = nil;
    -- 第二次征收金币
    self.twoGold = nil;
    -- 第三次征收金币
    self.threeGold = nil;
    -- 第一次征收时间
    self.oneTime = nil;
    -- 第二次征收时间
    self.twoTime = nil;
    -- 第三次征收时间
    self.threeTime = nil;
    -- 强征次数
    self.forcedCount = nil;
    -- 第二次可征收时间
    self.secondCanClaimTime = nil;
    -- 第三次可征收时间
    self.thirdCanClaimTime = nil;
    -- 征收次数
    self.surplusReceiveCount = nil;
    -- 税收说明金币
    self.revenueGold = nil;
    -- 野城城区税收金币
    self.wildCityRevenueGold = nil;
    --政令系统
    self.DecreeSystem = DecreeSystem.new();
    self.BuyDecreeDays = 0;
    self.BuyDecreeTimes = 0;
    -- 个人标记 
    self.Marker = {};

    -- 木材产量
    self.wood = 0;
    -- 铁矿
    self.iron = 0;
    -- 石料
    self.stone = 0;
    -- 粮食
    self.food = 0;

    self.FacilityWood = 0;
    self.FacilityIron = 0;
    self.FacilityStone = 0;
    self.FacilityFood = 0;

    self._WildCityWood = 0;
    self._WildCityIron = 0;
    self._WildCityStone = 0;
    self._WildCityFood = 0;

    self._WoodModifier = 0      --同盟加成
    self._IronModifier = 0
    self._StoneModifier = 0
    self._FoodModifier = 0

    self._WoodTotal = 0
    self._IronTotal = 0
    self._StoneTotal = 0
    self._FoodTotal = 0

    self.tiledList = {}
    self.tiledBuildingList = {}
    self._WoodCost = 0
    self._IronCost = 0 
    self._StoneCost = 0
    self._FoodCost = 0

    self.markerMap = {}

    self.isLogined = false;
    self.OutofGame = false;


    self.timerList = List.new()
    --同盟分组
    self.leagueChatId = 0;

    self.leagueChatName = "";

    --下次时间，用于计时
    self._nextTime=0;
    --时间变量
    self._variableTime=0;

    self.IsCanReceive = false;

    -- 玩家势力值
    self.playerInfluence = 0;

    -- 玩家聊天次数
    self.playerChatTimes = 0;

    self.LeagueRelation =  {}
end

function PlayerManage:SetPlayerChatTimes(time)
    if time == nil then
        return;
    end

    self.playerChatTimes = time;
end

function PlayerManage:GetPlayerChatTimes()
    return self.playerChatTimes;
end


function PlayerManage:SetLeagueChatId(args)
    if args == nil then
        return;
    end

    self.leagueChatId = args;
end

function PlayerManage:GetLeagueChatId()
    return self.leagueChatId;
end

function PlayerManage:SetLeagueChatName(args)
    if args == nil then
        return;
    end

    self.leagueChatName = args;
end

function PlayerManage:GetLeagueChatName()
    return self.leagueChatName;
end

function PlayerManage:AddOneTimer(args)
    self.timerList:Push(args)
end

function PlayerManage:StopAllTimers()
    for k, v in pairs(self.timerList._list) do
        v:Stop()
    end
end

function PlayerManage:SetOutofGame( )
    -- body
    self.OutofGame = true;
end

function PlayerManage:SetInGame( )
    -- body
    self.OutofGame = false;
end

function PlayerManage:GetoutofGame(  )
    -- body
    return self.OutofGame;
end

function PlayerManage:SetPlayerIsLogined( )
    -- body
    self.isLogined = true;
end

function PlayerManage:SetIsCanReceive()
    self.IsCanReceive = true;
end

function PlayerManage:SetNotCanReceive()
    self.IsCanReceive = false;
end

function PlayerManage:GetIsCanReceive()
    return self.IsCanReceive;
end


function PlayerManage:GetPlayerLoginState()
    return self.isLogined;
end

function PlayerManage:SetConstructionQueueMaxValue(baseMax, tempMax)
    self.baseConstructQueueMax = baseMax;
    self.tempConstructQueueMax = tempMax;
end

function PlayerManage:GetPlayerBaseConsMax()
    return self.baseConstructQueueMax;
end

function PlayerManage:GetPlayerTempConsMax()
    return self.tempConstructQueueMax;
end

function PlayerManage:SetPlayerBaseInfo(args)
    self.playerBaseInfo = args
end

function PlayerManage:GetPlayerBaseInfo(args)
    return self.playerBaseInfo
end

-- 要塞编号
function PlayerManage:SetFortNum(num)
    self.fortNumber = num
end

function PlayerManage:GetFortNum()
    return self.fortNumber
end

function PlayerManage:GetProfile()
    -- body
    return self.profile;
end

function PlayerManage:SetProfile(profile)
    self.profile = profile;
end

function PlayerManage:SetSpawnState(spawnState)
    self.spawnState = spawnState;
end

function PlayerManage:GetSpawnState()
    return self.spawnState;
end

function PlayerManage:SetCertificate(certificate)
    self._certificate = certificate
end

function PlayerManage:GetCertificate()
    return self._certificate
end

-- 初始化
function PlayerManage:Init()
    for k, v in pairs(CurrencyEnum) do
        local currencyVar = VariationCalc.new()
        self:AddCurrencyTable(v, currencyVar)
    end
    self:InitCurrencyPara()
    self:SetInitResourceMax()
    GameResFactory.Instance():SetOnGetFocusCallBack(function(go)
        if self._variableTime==0 then 
            return
        end
        self:SyncServiceTime()
    end);
end

-- 初始化资源参数
function PlayerManage:InitCurrencyPara()
    self:InitPara(CurrencyEnum.Wood)
    self:InitPara(CurrencyEnum.Iron)
    self:InitPara(CurrencyEnum.Stone)
    self:InitPara(CurrencyEnum.Grain)
end

-- 初始化参数
function PlayerManage:InitPara(currencyEnum)
    local output = self:GetResourceOutput(currencyEnum)
    local currencyVar = self:GetCurrencyVarCalcByKey(currencyEnum)
    currencyVar:SetVariationVal(output)
    currencyVar:SetVariationSpace(3600 * 1000)
end

-- 心跳 
function PlayerManage:_OnHeartBeat()
    -- body

    if self._variableTime==0 then 
        return;
    end 

    if self._nextTime<(UnityEngine.Time.realtimeSinceStartup) then 
        self._nextTime=(UnityEngine.Time.realtimeSinceStartup)+30;
        self:SyncServiceTime();
    end 

end

function PlayerManage:SyncServiceTime()
    local msg = require("MessageCommon/Msg/C2L/Player/SyncServerTimeRequest").new();
    msg:SetMessageId(C2L_Player.SyncServerTimeRequest);
    NetService:Instance():SendMessage(msg,false);
end

function PlayerManage:GetDecreeSystem( ... )
    -- body
    return self.DecreeSystem;
end

function PlayerManage:SetLocalTime(time)
    self._variableTime=time-(UnityEngine.Time.realtimeSinceStartup*1000);
    --self._localTime = time;
end

function PlayerManage:GetLocalTime()
    return self._variableTime+(UnityEngine.Time.realtimeSinceStartup*1000);
end

--判断与卡牌同tableId的卡是否已经在某个城市的队伍中
function PlayerManage:CheckSameCardInInCityArmy(cardTableId)
     for i = 1, #self._playerCityInfoList do
        if self._playerCityInfoList[i] ~= nil then
            local building = BuildingService:Instance():GetBuilding(self._playerCityInfoList[i].id);
            if building ~= nil then
                local armyInfos = building.allArmyList;
                for  j=1 ,#armyInfos do
                    local armyInfo = armyInfos[j];
                    if armyInfo ~= nil then 
                        if armyInfo:CheckCardInArmyByTableId(cardTableId) then
                            return true;
                        end
                    end
                end 
            end
        end
    end
    return false;
end

-- 判断卡牌是否在军队中
function PlayerManage:CheckCardInArmy(cardId)
    for i = 1, #self._playerCityInfoList do
        if self._playerCityInfoList[i] ~= nil then
            local building = BuildingService:Instance():GetBuilding(self._playerCityInfoList[i].id);
            if building ~= nil then
                if building:CheckCardInArmy(cardId) == true then
                    return true;
                end
            else
                return false;
            end
        end
    end
    return false;
end


--通过卡牌ID获取卡牌所在buildingId
function PlayerManage:GetCardBuilding(cardId)
     for i = 1, #self._playerCityInfoList do
        if self._playerCityInfoList[i] ~= nil then
            local building = BuildingService:Instance():GetBuilding(self._playerCityInfoList[i].id);
            if building ~= nil then
                if building:CheckCardInArmy(cardId) == true then
                    return building;
                end
            else
                return nil;
            end
        end
    end
end



--通过卡牌ID获取卡牌所在部队
function PlayerManage:GetArmyInfoByCardId(cardId)
     for i = 1, #self._playerCityInfoList do
        if self._playerCityInfoList[i] ~= nil then
            local building = BuildingService:Instance():GetBuilding(self._playerCityInfoList[i].id);
            if building ~= nil then
                if building:CheckCardInArmy(cardId) == true then
                    return building:GetArmyInfoByCardId(cardId);
                end
            else
                return nil;
            end
        end
    end
end


-- 获取卡牌所在的部队
function PlayerManage:GetCardInArmy(cardId)
    for i = 1, #self._playerCityInfoList do
        if self._playerCityInfoList[i] ~= nil then
            local building = BuildingService:Instance():GetBuilding(self._playerCityInfoList[i].id);
            if building ~= nil then
                if building:CheckCardInArmy(cardId) == true then
                    return building:GetArmyInfoByCardId(cardId);
                end
            else
                return nil;
            end
        end
    end
    return nil;
end

-- 获取所有城市中所有状态不为NONE的部队
function PlayerManage:GetAllNotNoneArmyInfos()
    local armyInfoList = { }
    for i = 1, #self._playerCityInfoList do
        if self._playerCityInfoList[i] ~= nil then
            local oneCityList = ArmyService:Instance():GetHaveBackArmy(self._playerCityInfoList[i].id);
            if oneCityList ~= nil then
                for i = 1, #oneCityList do
                    if oneCityList[i]:GetArmyState() ~= ArmyState.None then
                        table.insert(armyInfoList, oneCityList[i])
                    end
                end
            end
        end
    end
    return armyInfoList;
end

-- 判断是否有可以出征的部队
-- 主城有配置大营部队 分城有可以派遣的部队 要塞有待命部队（稍微缺点判断几率极低）
function PlayerManage:IsHaveCanSendArmy()
    local allCityCount = self:GetCityInfoCount();
    if allCityCount > 0 then
        for index = 1, allCityCount do
            local cityModel = self:GetCityInfoByIndex(index);
            local city = BuildingService:Instance():GetBuilding(cityModel.id);
            local armyInfoList = ArmyService:Instance():GetHaveBackArmy(cityModel.id);
            if #armyInfoList > 0 then
                if city._dataInfo.Type == BuildingType.MainCity then
                    return true;
                else
                    for i = 1, #armyInfoList do
                        if armyInfoList[i]:GetArmyState() == ArmyState.None then
                            return true;
                        end
                    end
                end
            end
        end
    end

    local fortCount = self:GetSucceedFortsCount();
    if fortCount > 0 then
        for i = 1, fortCount do
            local fort = self:GetSucceedFort(i);
            local allArmyCount = fort:GetArmyInfoCounts();
            if allArmyCount > 0 then
                for j = 1, allArmyCount do
                    if fort:GetArmyInfos(j):GetArmyState() == ArmyState.TransformArrive then
                        return true;
                    end
                end
            end
        end
    end

    local wildFortCount = self:GetOccupyWildFortCount();
    if wildFortCount > 0 then
        for i = 1, wildFortCount do
            local wildFort = self:GetOccupyWildFort(i);
            local allArmyCount = wildFort:GetWildFortArmyInfoCounts();
            if allArmyCount > 0 then
                for j = 1, allArmyCount do
                    if wildFort:GetWildFortArmyInfos(j):GetArmyState() == ArmyState.TransformArrive then
                        return true;
                    end
                end
            end
        end
    end

    return false;
end

-- 添加要塞
function PlayerManage:SetPlayerFort(index, fort)
    if index == nil or fort == nil then
        return
    end
    self.PlayerFort[index] = fort
end
-- 根据索引获取要塞
function PlayerManage:GetPlayerFort(index)
    return self.PlayerFort[index]
end

function PlayerManage:GetPlayerFortCount()
    return #self.PlayerFort
end

function PlayerManage:DeleteFort(tiledIndex)
    --print("DeleteFort+++++++++++++++++")
    self.PlayerFort[tiledIndex] = nil;
end

-- 添加要塞
function PlayerManage:SetFort(fort)
    if fort == nil then
        return
    end
    table.insert(self.Fort, fort)

    -- 添加要塞到建设完要塞列表
    local currentTime = self:GetLocalTime();
    if currentTime < fort._buildSuccessTime then
        return;
    end

    for i = 1, self:GetSucceedFortsCount() do
        if self:GetSucceedFort(i)._id == fort._id then
            return;
        end
    end
    --print("向已创建要塞列表添加一个要塞：" .. fort._id)
    table.insert(self.succeedForts, fort);
end

function PlayerManage:GetFort(index)
    return self.Fort[index]
end

function PlayerManage:GetFortCount()
    return #self.Fort;
end

-- 获取建设完成的要塞
function PlayerManage:GetSucceedFort(index)
    return self.succeedForts[index];
end

-- 获取建设完成要塞的数量
function PlayerManage:GetSucceedFortsCount()
    return #self.succeedForts;
end

function PlayerManage:DeletePlayerFort(fort)
    --print("lalalallalaa")
    for k, v in pairs(self.Fort) do
        if v == fort then
            --self.Fort[k] = nil;
            table.remove(self.Fort, k)
        end
    end

    -- 删除已完成要塞列表中的要塞
    if fort == nil then
        return;
    end

    for k, v in pairs(self.succeedForts) do
        if v._id == fort._id then
            --print("删除已完成要塞列表中的一个要塞：" .. fort._id);
            -- 如果当前要塞在uimaincity打开的处理
            if fort._dataInfo.Type == BuildingType.PlayerFort then
                if UIService:Instance():GetOpenedUI(UIType.UIPandectObj) == true then
                    local uiPandectObj = UIService:Instance():GetUIClass(UIType.UIPandectObj);
                    if uiPandectObj._building._id == fort._id then
                        UIService:Instance():ShowUI(UIType.UICueMessageBox, 502);
                        UIService:Instance():HideUI(UIType.UIPandectObj);
                        local uiMainCity = UIService:Instance():GetUIClass(UIType.UIMainCity);
                        uiMainCity:OnClickReturnBtn();
                    end
                elseif UIService:Instance():GetOpenedUI(UIType.UIMainCity) == true then
                    local uiMainCity = UIService:Instance():GetUIClass(UIType.UIMainCity);
                    if uiMainCity.curBuilding._id == fort._id then
                        UIService:Instance():ShowUI(UIType.UICueMessageBox, 502);
                        self:CloseUiIfOpen(UIType.UITask);
                        self:CloseUiIfOpen(UIType.ExplainPanel);
                        self:CloseUiIfOpen(UIType.UIUpgradeBuilding);
                        self:CloseUiIfOpen(UIType.MessageBox);
                        self:CloseUiIfOpen(UIType.UIDeleteFort);
                        self:CloseUiIfOpen(UIType.UIDeleteFortCancelMarchAffirm);
                        self:CloseUiIfOpen(UIType.ArmyFunctionUI);
                        self:CloseUiIfOpen(UIType.UIConscription);
                        self:CloseUiIfOpen(UIType.ConscriptionConfirmUI);
                        self:CloseUiIfOpen(UIType.ArmyAdditionUI);
                        self:CloseUiIfOpen(UIType.UIHeroCardInfo);
                        self:CloseUiIfOpen(UIType.UIHeroAdvance);
                        self:CloseUiIfOpen(UIType.UITactisDetail);
                        self:CloseUiIfOpen(UIType.UIHeroSpliteSkill);
                        self:CloseUiIfOpen(UIType.RechargeUI);
                        uiMainCity:OnClickReturnBtn();
                    end
                end
            end

            table.remove(self.succeedForts, k);
            
            if UIService:Instance():GetOpenedUI(UIType.CityObj) == true then
                local cityObj = UIService:Instance():GetUIClass(UIType.CityObj);
                cityObj:RefreshGrid();
            end

            return;
        end
    end
end




-- 获取玩家所有建设完成的建筑列表
function PlayerManage:GetAllCity()
    self:UpdateAndSortAllCityList();
    return self.allCity;
end

-- 获取玩家所有建设完成的建筑数量
function PlayerManage:GetAllCityListCount()
    return #self.allCity;
end

-- 根据当前建筑获取在排序列表中的位置
function PlayerManage:GetAllCityIndexByBuildingId(buildingId)
    local building = BuildingService:Instance():GetBuilding(buildingId);
    if building == nil then
        --print("当前建筑所在的位置为：0  1111");
        return 0;
    end

    self:UpdateAndSortAllCityList();
    for k, v in pairs(self.allCity) do
        if v._id == buildingId then
            --print("当前建筑所在的位置为：" .. k);
            return k;
        end
    end

    --print("当前建筑所在的位置为：0  2222");
    return 0;
end

-- 获取上一个建筑
function PlayerManage:GetLeftCity(buildingId)
    local index = self:GetAllCityIndexByBuildingId(buildingId);
    return self.allCity[index - 1];
end

-- 获取下一个建筑
function PlayerManage:GetRightCity(buildingId)
    local index = self:GetAllCityIndexByBuildingId(buildingId);
    return self.allCity[index + 1];
end

-- 更新玩家所有建设完成的建筑列表并排序
function PlayerManage:UpdateAndSortAllCityList()
    self.allCity = {};
    -- 主城和分城
    local allCityCount = self:GetCityInfoCount();
    for index = 1, allCityCount do
        local cityModel = self:GetCityInfoByIndex(index);
        if cityModel ~= nil then
            local city = BuildingService:Instance():GetBuilding(cityModel.id);
            if city ~= nil then
                table.insert(self.allCity, city);
            end
        end
    end
    -- 要塞
    local fortCount = self:GetSucceedFortsCount();
    for index = 1, fortCount do
        local fort = self:GetSucceedFort(index);
        if fort ~= nil then
            table.insert(self.allCity, fort);
        end
    end

    local wildFortCount = self:GetOccupyWildFortCount();
    for index=1, wildFortCount do
        local wildFort = self:GetOccupyWildFort(index)
        if wildFort ~= nil then
            table.insert(self.allCity, wildFort)
        end
    end

    for k,v in pairs(self.allCity) do
        --print("排序前：" .. k .. "   " .. v._id .. "  type:" .. v._dataInfo.Type .. "  count:" .. self:GetCanSentArmyCount(v) .. "   distance:" .. self:GetMainCityDistance(v));
    end
    self:SortAllBuilding();
    for k,v in pairs(self.allCity) do
        --print("排序后：" .. k .. "   " .. v._id .. "  type:" .. v._dataInfo.Type .. "  count:" .. self:GetCanSentArmyCount(v) .. "   distance:" .. self:GetMainCityDistance(v));
    end
end

-- 排序（主城，分城，要塞，可派遣部队数量，到主城距离）
function PlayerManage:SortAllBuilding()
    local mainCity = nil;
    local subCityTable = {};
    local fortTable = {};
    local wildFortTable = {}
    -- 第一层排序
    for k,v in pairs(self.allCity) do
        if v._dataInfo.Type == BuildingType.MainCity then
            mainCity = v;
        elseif v._dataInfo.Type == BuildingType.SubCity then
            table.insert(subCityTable, v);
        elseif v._dataInfo.Type == BuildingType.PlayerFort then
            table.insert(fortTable, v);
        elseif v._dataInfo.Type == BuildingType.WildFort or v._dataInfo.Type == BuildingType.WildGarrisonBuilding then
            table.insert(wildFortTable, v)
        end
    end
    
    self.allCity = {};
    -- 第二层排序
    if mainCity ~= nil then
        table.insert(self.allCity, mainCity);
    end

    if #subCityTable > 0 then
        subCityTable = self:SortTwice(subCityTable);
        for k, v in pairs(subCityTable) do
            table.insert(self.allCity, v);
        end
    end

    if #fortTable > 0 then
        fortTable = self:SortTwice(fortTable);
        for k, v in pairs(fortTable) do
            table.insert(self.allCity, v);
        end
    end

    if #wildFortTable > 0 then
        wildFortTable=self:SortTwice(wildFortTable)
        for k,v in pairs(wildFortTable) do
            table.insert(self.allCity, v)
        end
    end

    subCityTable = {};
    fortTable = {};
    wildFortTable = {}
end

-- 第二层排序（有谁请告诉我一个更简单的方法，特么的再来一层怎么办）
function PlayerManage:SortTwice(cityTable)
    local armyCount0 = {};
    local armyCount1 = {};
    local armyCount2 = {};
    local armyCount3 = {};
    local armyCount4 = {};
    local armyCount5 = {};

    for k, v in pairs(cityTable) do
        if self:GetCanSentArmyCount(v) == 5 then
            table.insert(armyCount5, v);
        elseif self:GetCanSentArmyCount(v) == 4 then
            table.insert(armyCount4, v);
        elseif self:GetCanSentArmyCount(v) == 3 then
            table.insert(armyCount3, v);
        elseif self:GetCanSentArmyCount(v) == 2 then
            table.insert(armyCount2, v);
        elseif self:GetCanSentArmyCount(v) == 1 then
            table.insert(armyCount1, v);
        elseif self:GetCanSentArmyCount(v) == 0 then
            table.insert(armyCount0, v);
        end
    end

    cityTable = {};
    -- 第三层排序
    if #armyCount5 > 0 then
        table.sort(armyCount5, function(a, b) return self:GetMainCityDistance(a) < self:GetMainCityDistance(b); end);
        for k, v in pairs(armyCount5) do
            table.insert(cityTable, v);
        end
    end
    if #armyCount4 > 0 then
        table.sort(armyCount4, function(a, b) return self:GetMainCityDistance(a) < self:GetMainCityDistance(b); end);
        for k, v in pairs(armyCount4) do
            table.insert(cityTable, v);
        end
    end
    if #armyCount3 > 0 then
        table.sort(armyCount3, function(a, b) return self:GetMainCityDistance(a) < self:GetMainCityDistance(b); end);
        for k, v in pairs(armyCount3) do
            table.insert(cityTable, v);
        end
    end
    if #armyCount2 > 0 then
        table.sort(armyCount2, function(a, b) return self:GetMainCityDistance(a) < self:GetMainCityDistance(b); end);
        for k, v in pairs(armyCount2) do
            table.insert(cityTable, v);
        end
    end
    if #armyCount1 > 0 then
        table.sort(armyCount1, function(a, b) return self:GetMainCityDistance(a) < self:GetMainCityDistance(b); end);
        for k, v in pairs(armyCount1) do
            table.insert(cityTable, v);
        end
    end
    if #armyCount0 > 0 then
        table.sort(armyCount0, function(a, b) return self:GetMainCityDistance(a) < self:GetMainCityDistance(b); end);
        for k, v in pairs(armyCount0) do
            table.insert(cityTable, v);
        end
    end

    armyCount0 = {};
    armyCount1 = {};
    armyCount2 = {};
    armyCount3 = {};
    armyCount4 = {};
    armyCount5 = {};
    return cityTable;
end

-- 获取分城或要塞内可以派遣的部队的数量
function PlayerManage:GetCanSentArmyCount(building)
    local armyCount = 0;
    if building == nil then
        return 0;
    end
    if building._dataInfo.Type == BuildingType.SubCity then
        local armyInfoList = ArmyService:Instance():GetHaveBackArmy(building.id);
        if #armyInfoList > 0 then
            for index = 1, #armyInfoList do
                if armyInfoList[index]:GetArmyState() == ArmyState.None then
                    armyCount = armyCount + 1;
                end
            end
            return armyCount;
        else
            return 0;
        end
    elseif building._dataInfo.Type == BuildingType.PlayerFort then
        local allArmyCount = building:GetArmyInfoCounts();
        if allArmyCount > 0 then
            for index = 1, allArmyCount do
                if building:GetArmyInfos(index):GetArmyState() == ArmyState.TransformArrive then
                    armyCount = armyCount + 1;
                end
            end
            return armyCount;
        else
            return 0;
        end
    elseif building._dataInfo.Type == BuildingType.WildFort or building._dataInfo.Type == BuildingType.WildGarrisonBuilding then
        local allArmyCount = building:GetWildFortArmyInfoCounts();
        if allArmyCount > 0 then
            for index = 1, allArmyCount do
                if building:GetWildFortArmyInfos(index):GetArmyState() == ArmyState.TransformArrive then
                    armyCount = armyCount + 1;
                end
            end
            return armyCount;
        else
            return 0;
        end
    else
        return 0;
    end
end

-- 获取到主城的距离
function PlayerManage:GetMainCityDistance(building)
    if building == nil then
        return 0;
    end
    local mainCityTiledId = self:GetMainCityTiledId();
    local MainCityX, MainCityY = MapService:Instance():GetTiledCoordinate(mainCityTiledId);
    local buildX, buildY = MapService:Instance():GetTiledCoordinate(building._tiledId);
    return math.sqrt((buildX - MainCityX)*(buildX - MainCityX)*12960000+(buildY - MainCityY)*(buildY - MainCityY)*12960000)/3600;
end

function PlayerManage:GetPlayerCityList()
    return self._playerCityInfoList;
end  


-- 添加货币到列表中
function PlayerManage:AddCurrencyTable(currencyEnum, varCalc)
    self.currencyTable[currencyEnum + 1] = varCalc
end
	
-- 获取varCalc
function PlayerManage:GetCurrencyVarCalcByKey(currencyEnum)
    return self.currencyTable[currencyEnum + 1]
end

-- 设置玩家roleId
function PlayerManage:SetPlayerId(roleId)
    -- print(self);
    self._playerId = roleId
end


-- 获取玩家roleId
function PlayerManage:GetPlayerId()
    return self._playerId;
end

-- 设置玩家roleId
function PlayerManage:SetAccountId(accountId)
    self._accountId = accountId
end

-- 获取玩家roleId
function PlayerManage:GetAccountId()
    return self._accountId;
end

-- 获取名称
function PlayerManage:GetName()
    return self._name;
end

-- 设置名称
function PlayerManage:SetName(name)
    self._name = name;
end

-- 设置玩家同盟id
function PlayerManage:SetLeagueId(_leagueid)

    self.leagueid = _leagueid
    --print(self.leagueid)
end

function PlayerManage:GetLeagueId()

    return self.leagueid

end

function PlayerManage:GetLeagueLevel()
    -- body
    return self.leagueLevel;
end

function PlayerManage:SetLeagueLevel(leagueLevel)
    -- body
    self.leagueLevel = leagueLevel;
end


-- 设置玩家职位
function PlayerManage:SetPlayerTitle(_title)
    self.title = _title;
end

function PlayerManage:GetPlayerTitle()

    return self.title

end

-- 玩家主城id
function PlayerManage:SetmainCityId(_mainCityId)
    self.mainCityId = _mainCityId
end

function PlayerManage:GetmainCityId()

    return self.mainCityId

end

-- 设置玩家上级盟信息
function PlayerManage:SetsuperiorLeagueId(spueriorLeagueid)
    self.spueriorLeagueid = spueriorLeagueid
end

function PlayerManage:GetsuperiorLeagueId()

    return self.spueriorLeagueid

end

-- 设置玩家同盟名称
function PlayerManage:SetLeagueName(args)

    self.leagueName = args;

end

function PlayerManage:GetLeagueName()

    return self.leagueName;
end


-- 设置主城的格子索引
function PlayerManage:SetMainCityTiledId(mainCityTiledId)
    -- print(mainCityTiledId);
    self._mainCityTiledId = mainCityTiledId;
end

-- 获取主城的格子Id
function PlayerManage:GetMainCityTiledId()
    return self._mainCityTiledId;
end

-- 开始做循环计时器
-- 每隔30秒请求一次消息

-- 获取标记信息
function PlayerManage:GetMarkerListByIndex(index)
    return self.markerList[index]
end
-- 设置标记信息
function PlayerManage:InsertMarkerList(tiled)
    if tiled == nil then
        return
    end
    table.insert(self.markerList, tiled)
end
-- 获取标记信息长度
function PlayerManage:GetMarkerCount()
    return #self.markerList;
end
-- 删除一条标记信息
function PlayerManage:DeleteMarker(tiled)
    for i = 1, #self.markerList do
        if self.markerList[i] == tiled then
            table.remove(self.markerList, i);
        end
    end
end

-- 清空标记列表
function PlayerManage:ClearMarker()
    self.markerList = { };
end


-- 设置标记图标键值段
function PlayerManage:InsertMakrerIconMap(index, resTransform)
    if index == nil or resTransform == nil then
        return
    end
    print(#self.makrerIconMap)
    self.makrerIconMap[index] = resTransform;
end
-- 获取标记图标键值段
function PlayerManage:GetMarkerIconMap(index)
    return self.makrerIconMap[index]
end
-- 删除标记图标键值段
function PlayerManage:RemoveMarkerIconMap(index)
    self.makrerIconMap[index] = nil;
end

-- 要塞
function PlayerManage:InsertFortMap(index, resTransform)
    if index == nil or resTransform == nil then
        return
    end
    self.CreateBuildingFort[index] = resTransform
end

function PlayerManage:GetFortMap(index)
    return self.CreateBuildingFort[index]
end

function PlayerManage:RemoveFortMap(index)
    self.CreateBuildingFort[index] = nil;
end

function PlayerManage:AddCreateOccupyWildFort(building)
    if building == nil then
        return
    end
    for k,v in pairs(self.CreateOccupyWildFort) do
        if v == building then
            return;
        end
    end
    if self._playerId == building._owner then
        table.insert(self.CreateOccupyWildFort, building)
    end
end

function PlayerManage:GetOccupyWildFort(index)
    return self.CreateOccupyWildFort[index]
end

function PlayerManage:GetOccupyWildFortCount()
    return #self.CreateOccupyWildFort;
end

function PlayerManage:RemoveOccuptWildFortCount(building)
    for k, v in pairs(self.CreateOccupyWildFort) do
        if v == building then
            table.remove(self.CreateOccupyWildFort, k)
        end
    end
    if building._dataInfo.Type == BuildingType.WildFort or building._dataInfo.Type == BuildingType.WildGarrisonBuilding then
        if UIService:Instance():GetOpenedUI(UIType.UIPandectObj) == true then
            local uiPandectObj = UIService:Instance():GetUIClass(UIType.UIPandectObj);
            if uiPandectObj._building._id == building._id then
                UIService:Instance():ShowUI(UIType.UICueMessageBox, 502);
                UIService:Instance():HideUI(UIType.UIPandectObj);
                local uiMainCity = UIService:Instance():GetUIClass(UIType.UIMainCity);
                uiMainCity:OnClickReturnBtn();
            end
        elseif UIService:Instance():GetOpenedUI(UIType.UIMainCity) == true then
            local uiMainCity = UIService:Instance():GetUIClass(UIType.UIMainCity);
            if uiMainCity.curBuilding._id == building._id then
                UIService:Instance():ShowUI(UIType.UICueMessageBox, 502);
                self:CloseUiIfOpen(UIType.UITask);
                self:CloseUiIfOpen(UIType.ExplainPanel);
                --self:CloseUiIfOpen(UIType.UIUpgradeBuilding);
                self:CloseUiIfOpen(UIType.MessageBox);
                --self:CloseUiIfOpen(UIType.UIDeleteFort);
                --self:CloseUiIfOpen(UIType.UIDeleteFortCancelMarchAffirm);
                self:CloseUiIfOpen(UIType.ArmyFunctionUI);
                self:CloseUiIfOpen(UIType.UIConscription);
                self:CloseUiIfOpen(UIType.ConscriptionConfirmUI);
                self:CloseUiIfOpen(UIType.ArmyAdditionUI);
                self:CloseUiIfOpen(UIType.UIHeroCardInfo);
                self:CloseUiIfOpen(UIType.UIHeroAdvance);
                self:CloseUiIfOpen(UIType.UITactisDetail);
                self:CloseUiIfOpen(UIType.UIHeroSpliteSkill);
                self:CloseUiIfOpen(UIType.RechargeUI);

                uiMainCity:OnClickReturnBtn();
            end
        end
    end
end


function PlayerManage:SetfinallyCollectionTime(time)
    if time == nil then
        return
    end
    table.insert(self.finallyCollectionTime, time)
end

function PlayerManage:GetfinallyCollectionTimeCount()
    return #self.finallyCollectionTime
end

function PlayerManage:GetfinallyCollectionTime(index)
    return self.finallyCollectionTime[index]
end

-- 获取玩家所有分城数量（包括在建中）
function PlayerManage:GetAllSubCityCount()
    return #self._playerSubCityIdList;
end

-- 向分城列表（包括在建中）中插入分城id
function PlayerManage:InsertToSubCityList(cityId)
    for i = 1, #self._playerSubCityIdList do
        if self._playerSubCityIdList[i] == cityId then
            return;
        end
    end
    table.insert(self._playerSubCityIdList, cityId);
end

-- 移除分城列表（包括在建中）中的分城id
function PlayerManage:RemoveFromSubCityList(cityId)
    for i = 1, #self._playerSubCityIdList do
        if self._playerSubCityIdList[i] == cityId then
            table.remove(self._playerSubCityIdList, i);
            return;
        end
    end
end

function PlayerManage:GetFromSubCityList(index)
    return self._playerSubCityIdList[index]
end


-- 向玩家城市信息列表中添加主城信息（仅包括主城）
function PlayerManage:AddCityToPlayerCityInfoList(cityInfo)
    if cityInfo == nil then
        return
    end

    local tableData = DataBuilding[cityInfo.tableId];
    if tableData == nil then
        return;
    end

    if tableData.Type ~= BuildingType.MainCity then
        return;
    end

    for i = 1, self:GetCityInfoCount() do
        if self:GetCityInfoByIndex(i).id == cityInfo.id then
            table.remove(self._playerCityInfoList, i);
            table.insert(self._playerCityInfoList, cityInfo);
            return;
        end
    end

    table.insert(self._playerCityInfoList, cityInfo)
end

-- 分城加入玩家城市列表（建造完成的才加）以及玩家分城列表（仅包括分城）
function PlayerManage:AddSubCityToPlayerCityInfoList(building)
    
    if building == nil or building._dataInfo == nil then
        return;
    end
    local count = self:GetCityInfoCount() - 1;
    for i=1,self:GetCityInfoCount() do
        local buildingId = self:GetCityInfoByIndex(i).id;
        local building = BuildingService:Instance():GetBuilding(buildingId);
        if building:JudgeSubCityIsCreating() == true then
            count = count - 1;
        end
    end
    PlayerService:Instance():GetDecreeSystem():SetMaxValue(DataCharacterInitial[1].CommandLimit+(count)*DataGameConfig[324].OfficialData);
            if UIService:Instance():GetUIClass(UIType.UIGameMainView) then
                local UIGameMainView = UIService:Instance():GetUIClass(UIType.UIGameMainView);
                UIGameMainView:SetOrderTimer();
            end
    
    if self._playerId ~= building._owner or building._dataInfo.Type ~= BuildingType.SubCity then
        return;
    end

    self:InsertToSubCityList(building._id);
    
    local currentTime = self:GetLocalTime();
    if currentTime < building._subCitySuccessTime then
        return;
    end
    
    for i = 1, self:GetCityInfoCount() do
        if self:GetCityInfoByIndex(i).id == building._id then
            return;
        end
    end
    local cityModel = require("MessageCommon/Msg/L2C/Player/CityModel").new();
    cityModel.id = building._id;
    cityModel.name = building._name;
    cityModel.tableId = building._tableId;
    cityModel.tiledId = building._tiledId;
    table.insert(self._playerCityInfoList, cityModel);

    
end

-- 删除玩家分城
function PlayerManage:RemoveSubCity(building)
    if building == nil then
        return;
    end

    for k, v in pairs(self._playerCityInfoList) do
        if v.id == building._id then
            -- 如果当前分城在uimaincity打开的处理
            if building._dataInfo.Type == BuildingType.SubCity then
                if UIService:Instance():GetOpenedUI(UIType.UIPandectObj) == true then
                    local uiPandectObj = UIService:Instance():GetUIClass(UIType.UIPandectObj);
                    if uiPandectObj._building._id == building._id then
                        UIService:Instance():ShowUI(UIType.UICueMessageBox, 501);
                        UIService:Instance():HideUI(UIType.UIPandectObj);
                        local uiMainCity = UIService:Instance():GetUIClass(UIType.UIMainCity);
                        uiMainCity:OnClickReturnBtn();
                    end
                elseif UIService:Instance():GetOpenedUI(UIType.UIMainCity) == true then
                    local uiMainCity = UIService:Instance():GetUIClass(UIType.UIMainCity);
                    if uiMainCity.curBuilding._id == building._id then
                        UIService:Instance():ShowUI(UIType.UICueMessageBox, 501);
                        self:CloseUiIfOpen(UIType.UITask);
                        self:CloseUiIfOpen(UIType.ExplainPanel);
                        self:CloseUiIfOpen(UIType.UIFacility);
                        self:CloseUiIfOpen(UIType.UIFacilityProperty);
                        self:CloseUiIfOpen(UIType.MessageBox);
                        self:CloseUiIfOpen(UIType.UIFacilityCancel);
                        self:CloseUiIfOpen(UIType.ArmyFunctionUI);
                        self:CloseUiIfOpen(UIType.UIConscription);
                        self:CloseUiIfOpen(UIType.ConscriptionConfirmUI);
                        self:CloseUiIfOpen(UIType.ArmyAdditionUI);
                        self:CloseUiIfOpen(UIType.ArmySwapUI);
                        self:CloseUiIfOpen(UIType.UIHeroCardInfo);
                        self:CloseUiIfOpen(UIType.UIHeroAdvance);
                        self:CloseUiIfOpen(UIType.UITactisDetail);
                        self:CloseUiIfOpen(UIType.UITactis);
                        self:CloseUiIfOpen(UIType.UIHeroSpliteSkill);
                        self:CloseUiIfOpen(UIType.RechargeUI);
                        uiMainCity:OnClickReturnBtn();
                    end
                end
            end

            self:RemoveFromSubCityList(building._id);
            table.remove(self._playerCityInfoList, k);
            PlayerService:Instance():GetDecreeSystem():SetMaxValue(DataCharacterInitial[1].CommandLimit+(PlayerService:Instance():GetCityInfoCount()-1)*DataGameConfig[324].OfficialData);
            if UIService:Instance():GetUIClass(UIType.UIGameMainView) then
                local UIGameMainView = UIService:Instance():GetUIClass(UIType.UIGameMainView);
                UIGameMainView:SetOrderTimer();
            end
            if UIService:Instance():GetOpenedUI(UIType.CityObj) == true then
                local cityObj = UIService:Instance():GetUIClass(UIType.CityObj);
                cityObj:RefreshGrid();
            end

            return;
        end
    end
    
end

-- 判断ui是否打开 如果打开则关闭
function PlayerManage:CloseUiIfOpen(uiType)
    if UIService:Instance():GetOpenedUI(uiType) == true then
        UIService:Instance():HideUI(uiType);
    end
end

-- 获取城市信息数量
function PlayerManage:GetCityInfoCount()
    return #self._playerCityInfoList
end

-- 通过index获取城市信息
function PlayerManage:GetCityInfoByIndex(index)
    if #self._playerCityInfoList == 0 then
        return nil
    end
    return self._playerCityInfoList[index]
end

-- 创建要塞时间
function PlayerManage:InsertCreateBuildingTime(time)
    if time == nil then
        return
    end
    table.insert(self.CreateBuildingTime, time)
end
function PlayerManage:GetCreateBuildingTime(index)
    return self.CreateBuildingTime[index]
end
function PlayerManage:GetCreateBuildingTimeCount()
    return #self.CreateBuildingTime
end

function PlayerManage:AddTiledIdToPlayerTiledList(tiledId)
    -- body
    if tiledId == nil then
        return
    end
    self._playerTiledIdList:Push(tiledId);
end

function PlayerManage:RemoveTiledIdToPlayerTiledList(tiledId)
    -- body
    if tiledId == nil then
        return
    end
    self._playerTiledIdList:Remove(tiledId);
end


-- 创建要塞当前时间
function PlayerManage:InsertFortCurrentTime(time)
    if time == nil then
        return
    end
    table.insert(self.CurrentFortTime, time)
end
function PlayerManage:GetFortCurrentTime(index)
    return self.CurrentFortTime[index]
end
function PlayerManage:GetFortCurrentTimeCount()
    return #self.CurrentFortTime;
end


function PlayerManage:GetTiledIdListCount()
    -- body
    return self._playerTiledIdList:Count();
end

function PlayerManage:GetTiledIdByIndex(index)
    if self._playerTiledIdList:Count() == 0 then
        return nil
    end
    return self._playerTiledIdList:Get(index);
end

function PlayerManage:SetCollectionGold(gold)
    self._collectionGold = gold
end

function PlayerManage:GetCollectionGold()
    return self._collectionGold;
end

function PlayerManage:SetsuperiorName(args)
    self.superiorName = args
end

function PlayerManage:GetsuperiorName()
    return self.superiorName
end

function PlayerManage:SetCreateTemporaryFort(build)
    if build == nil then
        return
    end
    table.insert(self.createTemporaryFort, build);
end

function PlayerManage:GetCreateTemporaryFort(index)
    return self.createTemporaryFort[index]
end

function PlayerManage:GetCreateTemporaryFortCount()
    return #self.createTemporaryFort
end


-- 开始做循环计时器
-- 每隔30秒请求一次消息
function PlayerManage:SyncLoginServerTime(mTime)
    -- print("PlayerManage:SyncLoginServerTime:"..mTime);
    self:SetLocalTime(mTime);
    if self._serverTimer == nil then
        self._serverTimer = Timer.New( function()
            self._timerNum = self._timerNum + 1;
            self._localTime = self._localTime + 1000;
            if self._timerNum % 30 == 0 then
                local msg = require("MessageCommon/Msg/C2L/Player/SyncServerTimeRequest").new();
                msg:SetMessageId(C2L_Player.SyncServerTimeRequest);
                NetService:Instance():SendMessage(msg,false);
            end
        end , 1, -1, false)
    end
    self._serverTimer:Start();
end


function PlayerManage:ClearAllTiledIdFromTiledList(...)
    -- body
    self._playerTiledIdList:Clear();
end

function PlayerManage:GetInitResourceMax()
    -- body
    return self.resourceMax;
end

function PlayerManage:SetInitResourceMax()
    -- body
    self.resourceMax = DataCharacterInitial[1].ResourceLimit;
end

-- 是否是我的城
function PlayerManage:IsMyCity( buildingIndex )
    for i=1,#self._playerCityInfoList do
        local cityInfo = self._playerCityInfoList[i]
        if cityInfo.tiledId == buildingIndex then
            return true
        end
    end
    return false
end

function PlayerManage:AddTiledDurableInfoToList(TiledDurableInfo)
    -- body
    if TiledDurableInfo.tiledId == nil then
        return
    end
    self._playerTiledDurableList[TiledDurableInfo.tiledId] = TiledDurableInfo;

   -- table.insert(self._playerTiledDurableList, TiledDurableInfo);
end

function PlayerManage:RemoveTiledDurableInfoToList(tileId)
    -- body
    self._playerTiledDurableList[tileId] = nil;
    
end

function PlayerManage:GetTiledDurableListCount()
    -- body
    return #self._playerTiledDurableList;
end

function PlayerManage:GetTiledDurableByIndex(index)
    return self._playerTiledDurableList[index];
end


function PlayerManage:ClearAllTiledDurableFromTiledList()
    -- body
    self._playerTiledDurableList = {};
end

-- 个人势力用土地信息
function PlayerManage:AddTiledInfoToList(TiledInfo)
    -- body    
    self._PlayerTiledInfoList[TiledInfo.tiledId] = TiledInfo;

end

function PlayerManage:GetTiledInfoListCount()
    -- body
    local count = 0;
    for k,v in pairs(self._PlayerTiledInfoList) do
        if k ~= nil and v ~= nil then
            count = count + 1;
        end
    end
    return count;
end

function PlayerManage:GetTiledInfoByIndex(index)
    return self._PlayerTiledInfoList[index];
end

function PlayerManage:ClearAllTiledInfoFromTiledList()
    -- body
    self._PlayerTiledInfoList = {};
end

function PlayerManage:RemoveOneTiledInfoFromTiledList(index)
    -- body
    -- table.remove(self._PlayerTiledInfoList,index);
    -- self._PlayerTiledInfoList[index] = nil;
    -- print(self._PlayerTiledInfoList[index]);
    self._PlayerTiledInfoList = CommonService:Instance():RemoveElementByKey(self._PlayerTiledInfoList,index);
    -- print(self._PlayerTiledInfoList[index]);
end

function PlayerManage:GetAllTiledList()
    -- body
    return self._PlayerTiledInfoList;
end






--设置税收金币
function PlayerManage:SetClickRevenueGold(gold)
    if gold == nil then
        return
    end
    self.ClickRevenueGold = gold;
end
function PlayerManage:GetClickRevenueGold()
    return self.ClickRevenueGold
end

-- 设置税收次数
function PlayerManage:SetRevenueCount(count)
    if count == nil then
        return
    end
    self.RevenueCount = count
end
function PlayerManage:GetRevenueCount()
    return self.RevenueCount
end


function PlayerManage:SetRevenuefinishTime(time)
    if time == nil then
        return
    end
    self.RevenuefinishTime = time
end
function PlayerManage:GetRevenuefinishTime()
    return self.RevenuefinishTime
end

function PlayerManage:SetForceRevenueCount(count)
    if count == nil then
        return;
    end
    self.ForceRevenueCount = count
end
function PlayerManage:GetForceRevenueCount()
    return self.ForceRevenueCount
end


function PlayerManage:SetOneGold(gold)
    if gold == nil then
        return;
    end
    self.oneGold = gold;
end
function PlayerManage:GetOneGold()
    return self.oneGold
end

function PlayerManage:SetTwoGold(gold)
    if gold == nil then
        return;
    end
    self.twoGold = gold;
end
function PlayerManage:GetTwoGold()
    return self.twoGold
end

function PlayerManage:SetThreeGold(gold)
    if gold == nil then
        return
    end
    self.threeGold = gold;
end
function PlayerManage:GetThreeGold()
    return self.threeGold;
end

function PlayerManage:SetOneTime(time)
    if time == nil then
        return;
    end
    self.oneTime = time;
end
function PlayerManage:GetOneTime()
    return self.oneTime;
end

function PlayerManage:SetTwoTime(time)
    if time == nil then
        return
    end
    self.twoTime = time
end
function PlayerManage:GetTwoTime()
    return self.twoTime;
end

function PlayerManage:SetThreeTime(time)
    if time == nil then
        return
    end
    self.threeTime = time;
end
function PlayerManage:GetThreeTime()
    return self.threeTime
end

function PlayerManage:SetForcedCount(count)
    if count == nil then
        return
    end
    self.forcedCount = count
end
function PlayerManage:GetForcedCounts()
    return self.forcedCount
end

function PlayerManage:SetSecondCanClaimTime(time)
    if time == nil then
        return
    end
    self.secondCanClaimTime = time
end
function PlayerManage:GetSecondCanClaimTime()
    return self.secondCanClaimTime
end

function PlayerManage:SetthirdCanClaimTime(time)
    if time == nil then
        return
    end
    self.thirdCanClaimTime = time
end
function PlayerManage:GetThirdCanClaimTime()
    return self.thirdCanClaimTime
end

function PlayerManage:SetSurplusReceiveCount(surplusReceiveCount)
    if surplusReceiveCount == nil then
        return
    end
    self.surplusReceiveCount = surplusReceiveCount
end
function PlayerManage:GetSurplusReceiveCount()
    return self.surplusReceiveCount
end
function PlayerManage:DeleteSurplusReceiveCount()
    self.surplusReceiveCount = nil;
end

function PlayerManage:SetIntroductionsRevenueGold(gold)
    if gold == nil then
        return
    end
    self.revenueGold = gold
end
function PlayerManage:GetIntroductionsRevenueGold()
    return self.revenueGold;
end

function PlayerManage:SetWildCityRevenueGold(gold)
    if gold == nil then
        return
    end
    self.wildCityRevenueGold = gold;
end
function PlayerManage:GetWildCityRevenueGold()
    return self.wildCityRevenueGold
end

function PlayerManage:GetBuyDecreeDays()
    -- body
    return self.BuyDecreeDays;
end

function PlayerManage:SetBuyDecreeDays(value)
    -- body
    self.BuyDecreeDays = value;
end

function PlayerManage:GetBuyDecreeTimes()
    -- body
    return self.BuyDecreeTimes;
end

function PlayerManage:SetBuyDecreeTimes(value)
    -- body
    self.BuyDecreeTimes = value;
end

-- 计算领地产量
function PlayerManage:TenureYield()
    for k,v in pairs(self._PlayerTiledInfoList) do
        local building = BuildingService:Instance():GetBuilding(v.buildingId);
        if v.isHaveTown == 0 and building == nil then
            --print("^^^^^^^^^^^^^ "..v.tiledTableId)
            local dataTiled = DataTile[v.tiledTableId];
            if dataTiled ~= nil then
                self.wood = self.wood + dataTiled.Wood;
                self.iron = self.iron + dataTiled.Iron;
                self.stone =  self.stone + dataTiled.Stone;
                self.food = self.food + dataTiled.Food;
            end
        end
    end
    --LogManager:Instance():Log("self.wood:"..self.wood.." self.iron:"..self.iron.." self.stone:"..self.stone.." self.food"..self.food)
end

function PlayerManage:GetTiledListSame(tiled)
    if tiled == nil then
        return false;
    end
    for i=1, #self.tiledList do
        local tiledList = self.tiledList[i];
        if tiledList == tiled then
            return false;
        end
    end
    return true;
end

--计算刷新所有的资源产量
function PlayerManage:GetTotalResourceYield()
    self:RetRousourceCounts();
    self:TenureYield();
    self:GetLeagueInfluence();
    self:GetCurrencyProductionByLeague();
    self:GetAllFacilityProduction();
    self:GetAllArmyResourceCost();
    self:GetTotalResource();
end

function PlayerManage:FacilitiesYield(facilityProperty)
    local allProduction = 0;
    for i = 1, self:GetCityInfoCount() do
        local cityInfo = self:GetCityInfoByIndex(i);
        if cityInfo~= nil then
            local tiledId = cityInfo.tiledId;
            local building = BuildingService:Instance():GetBuildingByTiledId(tiledId);
            if building ~= nil then
                local production = FacilityService:Instance():GetCityPropertyByFacilityProperty(building._id, facilityProperty)
                production = production*(1+FacilityService:Instance():GetCityPropertyByFacilityProperty(building._id, FacilityProperty.ResourceLibrary));
                allProduction = allProduction + production;
            end
        end
    end
    return allProduction
end

-- 获取设施产量
function PlayerManage:GetAllFacilityProduction()
    self.FacilityWood = self:FacilitiesYield(FacilityProperty.Wood);
    self.FacilityIron = self:FacilitiesYield(FacilityProperty.Iron);
    self.FacilityStone = self:FacilitiesYield(FacilityProperty.Stone);
    self.FacilityFood = self:FacilitiesYield(FacilityProperty.Food);

end

-- 获取所有同盟城池加成
function PlayerManage:GetLeagueInfluence()
    local leagueInfluenceList = BuildingService:Instance():GetBeOwnedWildCityList()
    for i = 1, leagueInfluenceList:Count() do
        if self.spueriorLeagueid == 0 then
            if leagueInfluenceList:Get(i).occupyLeagueId == PlayerService:Instance():GetLeagueId() then
                local buildingId = leagueInfluenceList:Get(i).buildingId;
                local building = BuildingService:Instance():GetBuilding(buildingId);
                local buildingTableID = building._dataInfo.ID;
                if building ~= nil then
                    self._WildCityWood = self._WildCityWood + DataBuilding[buildingTableID].Wood;
                    self._WildCityIron = self._WildCityIron + DataBuilding[buildingTableID].Iron;
                    self._WildCityStone = self._WildCityStone + DataBuilding[buildingTableID].Stone;
                    self._WildCityFood = self._WildCityFood + DataBuilding[buildingTableID].Food;
                end           
            end
        end
    end
end

-- 获取同盟加成
function PlayerManage:GetCurrencyProductionByLeague()
    if self.leagueid ~= 0 and self.spueriorLeagueid == 0 then
        local leagueLevel = PlayerService:Instance():GetLeagueLevel();
        if leagueLevel == 0 then
            return;
        end
        self._WoodModifier = DataAlliesLevel[leagueLevel].WoodModifier / 10000;
        self._IronModifier = DataAlliesLevel[leagueLevel].IronModifier / 10000;
        self._StoneModifier = DataAlliesLevel[leagueLevel].StoneModifier / 10000;
        self._FoodModifier = DataAlliesLevel[leagueLevel].FoodModifier / 10000;
    end
end

function PlayerManage:GetAllArmyResourceCost()
    for i = 1, #self._playerCityInfoList do
        if self._playerCityInfoList[i] ~= nil then
            local building = BuildingService:Instance():GetBuilding(self._playerCityInfoList[i].id);
            if building ~= nil then
                self._WoodCost =  self._WoodCost + building:GetAllKeepArmyCost(CurrencyEnum.Wood);
                self._IronCost =  self._IronCost + building:GetAllKeepArmyCost(CurrencyEnum.Iron);
                self._StoneCost = self._StoneCost + building:GetAllKeepArmyCost(CurrencyEnum.Stone);
                self._FoodCost =  self._FoodCost + building:GetAllKeepArmyCost(CurrencyEnum.Grain);
            end
        end
    end
end

-- 获取所有产量之和的总产量
function PlayerManage:GetTotalResource()
    local baseProduceCount = DataCharacterInitial[1].Yield;
    self._WoodTotal = math.floor((baseProduceCount + self.wood + self.FacilityWood) * (1 + self._WoodModifier) + self._WildCityWood - self._WoodCost); 
    self._IronTotal = math.floor((baseProduceCount + self.iron + self.FacilityIron) * (1 + self._IronModifier) + self._WildCityIron - self._IronCost); 
    self._StoneTotal = math.floor((baseProduceCount + self.stone + self.FacilityStone) * (1 + self._StoneModifier) + self._WildCityStone - self._StoneCost);
    self._FoodTotal = math.floor((baseProduceCount + self.food + self.FacilityFood) * (1 + self._FoodModifier) + self._WildCityFood - self._FoodCost); 
end

--检测征兵后粮食产量是否为负数
function PlayerManage:CheckFoodIsMinus(subCount)
    local baseProduceCount = DataCharacterInitial[1].Yield;
    local oldCount = math.floor((baseProduceCount + self.food + self.FacilityFood) * (1 + self._FoodModifier) + self._WildCityFood - self._FoodCost);
    if oldCount >=0 then
        local allCount = math.floor((baseProduceCount + self.food + self.FacilityFood) * (1 + self._FoodModifier) + self._WildCityFood - self._FoodCost - subCount);
        if allCount < 0 then
            return true;
        end
    end
    return false;
end

--计算之前数据重置到初始值
function PlayerManage:RetRousourceCounts()
    self.wood =  0;
    self.iron =  0;
    self.stone = 0;
    self.food =  0;
    self._WildCityWood = 0;
    self._WildCityIron = 0;
    self._WildCityStone = 0;
    self._WildCityFood = 0;
    self._WoodCost =  0;
    self._IronCost = 0;
    self._StoneCost = 0;
    self._FoodCost =  0;
end

function PlayerManage:GetWoodYield()
    return self._WoodTotal
end

function PlayerManage:GetIronYield()
    return self._IronTotal
end

function PlayerManage:GetStoneYield()
    return self._StoneTotal
end

function PlayerManage:GetFoodYield()
    return self._FoodTotal
end

-- 获取资源产量
function PlayerManage:GetResourceOutput(currencyEnum)
    if currencyEnum == CurrencyEnum.Wood then
        return self._WoodTotal
    elseif currencyEnum == CurrencyEnum.Stone then
        return self._StoneTotal
    elseif currencyEnum == CurrencyEnum.Grain then
        return self._FoodTotal
    elseif currencyEnum == CurrencyEnum.Iron then
        return self._IronTotal
    end
end

function PlayerManage:SetMarker(Marker)
    if Marker == nil then
        return
    end
    table.insert(self.Marker, Marker)
end

function PlayerManage:GetMarker(index)
    return self.Marker[index];
end

function PlayerManage:GetMarkerCt()
    return #self.Marker;
end

function PlayerManage:DeleteMarkers(tiledIndex)
    for i = 1, #self.Marker do
        if self.Marker[i] == tiledIndex then
            table.remove(self.Marker, i);
        end
    end
end

function PlayerManage:SetMarkerMap(index,marker)
    if marker == nil or index == nil then
        return;
    end
    self.markerMap[index] = marker;
end

function PlayerManage:GetMarkerMap(index)
    return self.markerMap[index]
end

function PlayerManage:RemoveMarkerMap(index)
    self.markerMap[index] = nil;
end

function PlayerManage:AddLeagueRelation(id,type)
    if id == nil then
        return;
    end
    self.LeagueRelation[id] = type
end

function PlayerManage:GetLeagueRelation(id)
    if id == nil then
        return 
    end
    return self.LeagueRelation[id]
end

-- function PlayerManage:GetTheirAlliesCount()
--     return #self.theirAlliesLeague
-- end


-- 获取资源上限
function PlayerManage:GetResourceMax()
    local resourceMax = self:GetInitResourceMax()
    for i = 1, #self._playerCityInfoList do
        local city = BuildingService:Instance():GetBuildingByTiledId(self._playerCityInfoList[i].tiledId)
        if city ~= nil then
            resourceMax = resourceMax + city:GetCityPropertyByFacilityProperty(FacilityProperty.ResourcesMax)
        end
    end
    return resourceMax
end

-- 根据声望值和已拥有分城数判断是否可再建分城
function PlayerManage:CanCreateSubCityBaseFameValue()
    local subCityCount = #self._playerSubCityIdList;
    local fameData = self:GetFameDataBaseValue();
    if fameData ~= nil then
        if fameData.CanBuildCity > subCityCount then
            return true;
        else
            return false;
        end
    end

    return false;
end

-- 遍历DataCharacterFame获取符合当前声望的一行数据
function PlayerManage:GetFameDataBaseValue()
    local FameValue = PlayerService:Instance():GetCurrencyVarCalcByKey(CurrencyEnum.Rnown):GetValue();

    if FameValue < DataCharacterFame[1].Fame then
        return nil;
    end

    for k, v in pairs(DataCharacterFame) do
        if v ~= nil then
            if DataCharacterFame[k + 1] ~= nil then
                if FameValue >= v.Fame and FameValue < DataCharacterFame[k + 1].Fame then
                    return v;
                end
            else
                return v;
            end
        end
    end

    return nil;
end

function PlayerManage:CanCreateFortBaseFameValue()
    local fortCount = self:GetFortCount()
    local fameData = self:GetFameDataBaseValue()
    if fameData ~= nil then
        if fameData.CanBuildFortress > fortCount then
            return true
        else
            return false
        end
    end
    return false;
end

-- function PlayerManage:GetHostilityLeagueCount()
--     return #self.hostilityLeague
-- end


function PlayerManage:SetPlayerInfluence(influence)
    self.playerInfluence = influence
end

function PlayerManage:GetPlayerInfluence()
    return self.playerInfluence
end

function PlayerManage:SetRegionId(regionId)
    self._regionId = regionId
end

function PlayerManage:GetRegionId()
    return self._regionId
end



return PlayerManage;
