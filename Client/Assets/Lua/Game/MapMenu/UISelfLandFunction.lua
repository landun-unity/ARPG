--[[
    扫荡，驻守，屯田，练兵界面
--]]

    local UIBase= require("Game/UI/UIBase");
    local UISelfLandFunction=class("UISelfLandFunction",UIBase);        
    local UIService=require("Game/UI/UIService");
    local UIType=require("Game/UI/UIType");
    local SelfLand = require("Game/MapMenu/SelfLand");    
    local ArmySlotType = require("Game/Army/ArmySlotType");
    local ArmyManage = require("Game/Army/ArmyManage");
    local EnterType =require("Game/Hero/HeroCardPart/UIEnterType")

--构造方法
function UISelfLandFunction:ctor()
    UISelfLandFunction.super.ctor(self)
    self.troopsListPanel = nil
    self.buildGrid = nil;
    self.cityListParent = nil;
    self.cityListMaskt = nil;
    -- 扫荡出征调动练兵驻守屯田
    self.troopType = nil
    -- 终点格子
    self.targetTiledId = nil
    -- 部队UI列表缓存
    self.troopList = {}
    self.troopBgList = {};
    -- 出征建筑UI列表缓存
    self.buildingList = {};
    -- 所有有部队可出征的建筑列表
    self._allBuilding = {};
    self.mainCity = nil;
    self.curChoosedBuildIndex = 0;

    --以下是虚拟箭头相关
    self._cacheArrowTable = {};
    self.lineParent = nil;
    self.arrowAngle = 0;    --箭头角度
end

--注册控件
function UISelfLandFunction:DoDataExchange()
    self.troopsListPanel = self:RegisterController(UnityEngine.Transform,"OneselfLandFunction/oneselfLandTroopsImage")
    self.buildGrid = self:RegisterController(UnityEngine.Transform,"OneselfLandFunction/Panel/Troop/ArmyGrid");
    self.cityListParent = self:RegisterController(UnityEngine.Transform,"OneselfLandFunction/Panel/bgImage");
    self.cityListMaskt = self:RegisterController(UnityEngine.Transform,"OneselfLandFunction/Panel/Troop");
end

--注册控件点击事件
function UISelfLandFunction:DoEventAdd()
    self:AddListener(self.transform:GetComponent(typeof(UnityEngine.UI.Button)), self.OnClickBtn);
end

-- 点击隐藏本界面
function UISelfLandFunction:OnClickBtn()
    UIService:Instance():HideUI(UIType.UISelfLandFunction)
    UIService:Instance():ShowUI(UIType.UIGameMainView)
end

-- 当界面隐藏的时候调用
function UISelfLandFunction:OnHide(param)
	self.curChoosedBuildIndex = 0;
    self:ShowImaginaryLine(false);
end

-- 当界面显示的时候调用
function UISelfLandFunction:OnShow(param)
    -- 主城分城未配置任何部队时提示（放在外边判断）
    local mainCityTiledId = PlayerService:Instance():GetMainCityTiledId();
    local mainCityId = BuildingService:Instance():GetBuildingByTiledId(mainCityTiledId)._id;
    self.mainCity = BuildingService:Instance():GetBuilding(mainCityId);

    self.troopType = param.troopType;
    self.targetTiledId = param.tiledIndex;

    self:DoVerdict(self.troopType);
    self:AddAllBuilding();
    if GuideServcice:Instance():GetIsFinishGuide() == true then
        MapService:Instance():ScanTiledMark(param.tiledIndex);
    end
    self:ShowImaginaryLine(true);
end

--显示虚拟的线
function UISelfLandFunction:ShowImaginaryLine(show)
    local allArrowCount = #self._cacheArrowTable;
    if show == false then
        for j =1, allArrowCount do
            self._cacheArrowTable[j]:SetActive(false)
        end
        return;
    end
    local startBuilding = self._allBuilding[self.curChoosedBuildIndex];
    if startBuilding== nil then 
        return;
    end
    local distance = self:GetToTargetDistance(startBuilding);
    local startX, startY = MapService:Instance():GetTiledCoordinate(startBuilding._tiledId);
    local endX, endY = MapService:Instance():GetTiledCoordinate(self.targetTiledId);
    self.arrowAngle = self:GetLineAngle(startBuilding._tiledId,self.targetTiledId);
    local arrowCount = math.floor(distance/0.2);
    if allArrowCount < arrowCount or allArrowCount == 0 then
        for j =1, allArrowCount do
            self._cacheArrowTable[j]:SetActive(true)
            self:ShowArrow(self._cacheArrowTable[j],arrowCount-j,startX,startY,endX,endY,arrowCount);
        end
        for i = arrowCount - allArrowCount, 1,-1 do
            local couldBreak = self:LoadArrow(i,startX,startY,endX,endY,arrowCount);
            if couldBreak ~= nil and couldBreak == true then
                break;
            end
        end
    else
        for i =1, arrowCount do
            self._cacheArrowTable[i]:SetActive(true)
            self:ShowArrow(self._cacheArrowTable[i],arrowCount-i,startX,startY,endX,endY,arrowCount);
        end
    end
end

-- 加载箭头
function UISelfLandFunction:LoadArrow(index,startX,startY,endX,endY,arrowCount)
    if self:CheckShowArrow(index,startX,startY,endX,endY,arrowCount) == true then
        return true;
    end
    local uiBase = require("Game/Line/UIArrow").new();    
    local lineParent = self:GetLineParent();
    GameResFactory.Instance():GetUIPrefab("Map/ArrowImage", lineParent, uiBase, function(go)
        local curCount = #self._cacheArrowTable;         
        self._cacheArrowTable[curCount+1] = uiBase.gameObject;
        uiBase:Init();
        UIService:Instance():AddUI(UIType.UIArrow,uiBase);
        self:ShowArrow(uiBase.gameObject,index,startX,startY,endX,endY,arrowCount);
    end);
end

-- 显示箭头
function UISelfLandFunction:ShowArrow(arrowImage,index,startX,startY,endX,endY,arrowCount)
    if self:CheckShowArrow(index,startX,startY,endX,endY,arrowCount) == true then
        arrowImage:SetActive(false);
        return true;
    end
    arrowImage:SetActive(true);
    local x = self:GetArrowX(startX,endX,index-1,arrowCount);
    local y = self:GetArrowY(startY,endY,index-1,arrowCount);
    local postion = MapService:Instance():GetTiledPosition(x, y);
    arrowImage.transform.localPosition = Vector3.New(postion.x + 60,postion.y+20,0);
    arrowImage.transform.localRotation = Quaternion.New(0, 0, 0, 1);
    arrowImage.transform:Rotate(Vector3.New(0, 0, self.arrowAngle));
end

function UISelfLandFunction:CheckShowArrow(index,startX,startY,endX,endY,arrowCount)
    local x = self:GetArrowX(startX,endX,index-1,arrowCount);
    local y = self:GetArrowY(startY,endY,index-1,arrowCount);
    local index = MapService:Instance():GetTiledIndex(math.floor(x), math.floor(y));
    local tiled = MapService:Instance():GetTiledByIndex(index);
    if tiled == nil then
        return true;
    end
end

-- 获取箭头的父亲
function UISelfLandFunction:GetLineParent()
    if self.lineParent == nil then
        self.lineParent = MapService:Instance():GetLayerParent(LayerType.ImaginaryLine);
    end
    return self.lineParent;
end

function UISelfLandFunction:GetArrowX(startX,endX,index,arrowCount)
    return startX + 0.5 + (endX - startX) * index/arrowCount;
end

function UISelfLandFunction:GetArrowY(startY,endY,index,arrowCount)
    return startY + 0.25 + (endY - startY) * index/arrowCount;
end

-- 360度
function UISelfLandFunction:Angle_360(from, to)
	local v3 = Vector3.Cross(from, to);

	if v3.z > 0 then
		return Vector3.Angle(from, to);
	else
		return 360 - Vector3.Angle(from, to);
	end
end

-- 求线的角度
function UISelfLandFunction:GetLineAngle(startTiledId, endTiledId)
    local startPosition = MapService:Instance():GetTiledPositionByIndex(startTiledId);
    local endPosition = MapService:Instance():GetTiledPositionByIndex(endTiledId);

    return self:Angle_360(Vector3.New(1, 0, 0), endPosition - startPosition);
end

-- 加载所有有部队的建筑（排序）
function UISelfLandFunction:AddAllBuilding()
    self._allBuilding = {};
    -- 添加到可出征建筑列表
    -- 主城和分城（主城有部队就显示，分城有可出征的部队才显示）
    local allCityCount = PlayerService:Instance():GetCityInfoCount();
    if allCityCount > 0 then
        for index = 1, allCityCount do
            local cityModel = PlayerService:Instance():GetCityInfoByIndex(index);
            local city = BuildingService:Instance():GetBuilding(cityModel.id);
            local armyInfoList = ArmyService:Instance():GetHaveBackArmy(cityModel.id);
            if #armyInfoList > 0 then
                if city._dataInfo.Type == BuildingType.MainCity then
                    table.insert(self._allBuilding, city);
                else
                    local tempInt = 0;
                    for i = 1, #armyInfoList do
                        if armyInfoList[i]:GetArmyState() == ArmyState.None then
                        -- 判断征兵 疲劳 重伤
                            tempInt = tempInt + 1;
                        end
                    end
                    if tempInt > 0 then
                        table.insert(self._allBuilding, city);
                    end
                end
            end
        end
    end

    -- 要塞（有可出征的部队才显示）
    local fortCount = PlayerService:Instance():GetSucceedFortsCount();
    if fortCount > 0 then
        for i = 1, fortCount do
            local fort = PlayerService:Instance():GetSucceedFort(i);
            local allArmyCount = fort:GetArmyInfoCounts();
            -- 行为是调动部队并且目的地是本要塞 则不显示本要塞
            local isTransFromThis = false;
            if self.troopType == SelfLand.transfer and self.targetTiledId == fort._tiledId then
                isTransFromThis = true;
            end
            if allArmyCount > 0 and isTransFromThis == false then
                local tempI = 0;
                for j = 1, allArmyCount do
                    if fort:GetArmyInfos(j):GetArmyState() == ArmyState.TransformArrive then
                    -- 判断征兵 疲劳 重伤
                       tempI = tempI + 1; 
                    end
                end
                if tempI > 0 then
                    table.insert(self._allBuilding, fort);
                end
            end
        end
    end

    -- 野外要塞（有可出征的部队才显示）
    local wildFortCount = PlayerService:Instance():GetOccupyWildFortCount();
    if wildFortCount > 0 then
        for i = 1, wildFortCount do
            local wildFort = PlayerService:Instance():GetOccupyWildFort(i);
            local allArmyCount = wildFort:GetWildFortArmyInfoCounts();
            -- 行为是调动部队并且目的地是本要塞 则不显示本要塞
            local isTransFromThis = false;
            if self.troopType == SelfLand.transfer and self.targetTiledId == wildFort._tiledId then
                isTransFromThis = true;
            end
            if allArmyCount > 0 and isTransFromThis == false then
                local tempI = 0;
                for j = 1, allArmyCount do
                    if wildFort:GetWildFortArmyInfos(j):GetArmyState() == ArmyState.TransformArrive then
                    -- 判断征兵 疲劳 重伤
                       tempI = tempI + 1; 
                    end
                end
                if tempI > 0 then
                    table.insert(self._allBuilding, wildFort);
                end
            end
        end
    end

    -- 排序
    table.sort(self._allBuilding, function(a, b) return self:GetToTargetDistance(a) < self:GetToTargetDistance(b) end);

    -- 创建building的UI
    for k,v in pairs(self._allBuilding) do
        if v._dataInfo.Type == BuildingType.MainCity or v._dataInfo.Type == BuildingType.SubCity then
            local index = 0;
            local allCityCount = PlayerService:Instance():GetCityInfoCount();
            if allCityCount > 0 then
                for i = 1, allCityCount do
                    local cityModel = PlayerService:Instance():GetCityInfoByIndex(i);
                    if cityModel.id == v._id then
                        index = i;
                    end
                end
            end
            if index ~= 0 then
                local mainBuildInfo = {};
                mainBuildInfo.name = v._name;
                mainBuildInfo.targetTiledId = self.targetTiledId;
                mainBuildInfo.startTiledId = v._tiledId;
                local armyInfoList = ArmyService:Instance():GetHaveBackArmy(v._id);
                local tempInt = 0;
                for i = 1, #armyInfoList do
                    if armyInfoList[i]:GetArmyState() == ArmyState.None then
                    -- 征兵 疲劳 重伤
                        tempInt = tempInt + 1;
                    end
                end
                mainBuildInfo.canMoveArmyCount = tempInt;
                mainBuildInfo.allArmyCount = #armyInfoList;
                self:CreateOneBuilding(k, mainBuildInfo, BuildingType.MainCity, index);
            end
        elseif v._dataInfo.Type == BuildingType.PlayerFort then
            local index = 0;
            local fortCount = PlayerService:Instance():GetSucceedFortsCount();
            if fortCount > 0 then
                for i = 1, fortCount do
                    local fort = PlayerService:Instance():GetSucceedFort(i);
                    if fort._id == v._id then
                        index = i;
                    end
                end
            end
            if index ~= 0 then
                local buildInfo = {};
                buildInfo.name = v._name;
                buildInfo.targetTiledId = self.targetTiledId;
                buildInfo.startTiledId = v._tiledId;
                local allArmyCount = v:GetArmyInfoCounts();
                local tempI = 0;
                for j = 1, allArmyCount do
                    if v:GetArmyInfos(j):GetArmyState() == ArmyState.TransformArrive then
                    -- 征兵 疲劳 重伤
                       tempI = tempI + 1; 
                    end
                end
                buildInfo.canMoveArmyCount = tempI;
                buildInfo.allArmyCount = allArmyCount;
                self:CreateOneBuilding(k, buildInfo, BuildingType.PlayerFort, index);
            end
        elseif v._dataInfo.Type == BuildingType.WildFort or v._dataInfo.Type == BuildingType.WildGarrisonBuilding then
            local index = 0;
            local wildFortCount = PlayerService:Instance():GetOccupyWildFortCount();
            if wildFortCount > 0 then
                for i = 1, wildFortCount do
                    local wildFort = PlayerService:Instance():GetOccupyWildFort(i);
                    if wildFort._id == v._id then
                        index = i;
                    end
                end
            end
            if index ~= 0 then
                local buildInfo = {};
                buildInfo.name = v._name;
                buildInfo.targetTiledId = self.targetTiledId;
                buildInfo.startTiledId = v._tiledId;
                local allArmyCount = v:GetWildFortArmyInfoCounts();
                local tempI = 0;
                for j = 1, allArmyCount do
                    if v:GetWildFortArmyInfos(j):GetArmyState() == ArmyState.TransformArrive then
                    -- 征兵 疲劳 重伤
                       tempI = tempI + 1; 
                    end
                end
                buildInfo.canMoveArmyCount = tempI;
                buildInfo.allArmyCount = allArmyCount;
                self:CreateOneBuilding(k, buildInfo, v._dataInfo.Type, index);
            end
        end
    end

    -- 设置背景板高
    local buidCount = #self._allBuilding;
    local height = buidCount * 100;
    if height < 100 then
        height = 100;
    elseif height > 232 then
        height = 232;
    end
    local width = self.cityListParent.rect.width;
    self.cityListParent.sizeDelta = Vector2.New(width, height + 13);
    self.cityListMaskt.sizeDelta = Vector2.New(width, height);

    -- 隐藏多余的
    if #self.buildingList > #self._allBuilding then
        for i = #self._allBuilding + 1, #self.buildingList do
            if self.buildingList[i] ~= nil then
                self.buildingList[i]:HideMyself();
            end
        end
    end
end

-- 创建建筑
function UISelfLandFunction:CreateOneBuilding(index, buildInfo, buildType, cityFortIndex)
    if self.buildingList[index] == nil then 
        local mdata = DataUIConfig[UIType.UIStartTroopsImage];
        local UIStartTroopsImage = require(mdata.ClassName).new();
        GameResFactory.Instance():GetUIPrefab(mdata.ResourcePath, self.buildGrid, UIStartTroopsImage, function (go)
                UIStartTroopsImage:Init();
                UIStartTroopsImage:InitInfo(index, buildInfo, buildType, cityFortIndex, self);
                self.buildingList[index] = UIStartTroopsImage;
                if index == #self._allBuilding then
                    self:ChooseBuild(1);
                    local parentX = self.buildGrid.localPosition.x;
                    self.buildGrid.localPosition = Vector3.New(parentX, 0, 0);
                end
        end);
    else
        if self.buildingList[index].gameObject.activeSelf == false then
            self.buildingList[index].gameObject:SetActive(true);
        end
        self.buildingList[index]:InitInfo(index, buildInfo, buildType, cityFortIndex, self);
        if index == #self._allBuilding then
            self:ChooseBuild(1);
            local parentX = self.buildGrid.localPosition.x;
            self.buildGrid.localPosition = Vector3.New(parentX, 0, 0);
        end
    end
end

-- 选中建筑
function UISelfLandFunction:ChooseBuild(index)
    if self.curChoosedBuildIndex == index then
        return;
    end   
    if #self.buildingList >= index then
        self.curChoosedBuildIndex = index;
        for i = 1, #self.buildingList do
            if self.buildingList[i].gameObject.activeSelf == true then
                if i == index then
                    self.buildingList[i]:ChooseOrCancel(true);
                else
                    self.buildingList[i]:ChooseOrCancel(false);
                end
            end
        end
    end
    if self.buildingList[index] ~= nil and self.buildingList[index].gameObject.activeSelf == true then
        local buildType = self.buildingList[index]:GetBuildType();
        local cityFortIndex = self.buildingList[index]:GetCityFortIndex();
        self:LoadArmyByBuilding(buildType, cityFortIndex);
    end

    --重置虚线
    self:ShowImaginaryLine(false);
    self:ShowImaginaryLine(true);
end

-- 根据选择的城市或要塞加载部队列表
function UISelfLandFunction:LoadArmyByBuilding(buildType, cityFortIndex)
    local count = 0;
    if buildType == BuildingType.MainCity then
        local cityModel = PlayerService:Instance():GetCityInfoByIndex(cityFortIndex);
        local armyInfoList = ArmyService:Instance():GetHaveBackArmy(cityModel.id);
        count = #armyInfoList;
        if count > 0 then
            for i = 1, count do
                local armyInfo = armyInfoList[i];
                self:CreateOneArmy(i, armyInfo, true, cityModel.id, armyInfo.spawnSlotIndex);
            end
        end
    elseif buildType == BuildingType.PlayerFort then
        local fort = PlayerService:Instance():GetSucceedFort(cityFortIndex);
        if fort ~= nil then
            count = fort:GetArmyInfoCounts();
            if count > 0 then
                for i = 1, count do
                    local armyInfo = fort:GetArmyInfos(i);
                    self:CreateOneArmy(i, armyInfo, false, fort._id, i);
                end
            end
        end
    elseif buildType == BuildingType.WildFort or buildType == BuildingType.WildGarrisonBuilding then
        local wildFort = PlayerService:Instance():GetOccupyWildFort(cityFortIndex);
        if wildFort ~= nil then
            count = wildFort:GetWildFortArmyInfoCounts();
            if count > 0 then
                for i = 1, count do
                    local armyInfo = wildFort:GetWildFortArmyInfos(i);
                    self:CreateOneArmy(i, armyInfo, false, wildFort._id, i);
                end
            end
        end
    end
    
    -- 隐藏多余的
    if count < #self.troopList then
        for i = count + 1, #self.troopList do
            if self.troopList[i].gameObject.activeSelf == true then
                self.troopList[i].gameObject:SetActive(false);
            end
            if self.troopBgList[i].gameObject.activeSelf == true then
                self.troopBgList[i].gameObject:SetActive(false)
            end
        end
    end
end 

-- 创建出征部队
function UISelfLandFunction:CreateOneArmy(index, armyInfo, isMainCity, buildId, armySlot)
    local backHero = armyInfo:GetCard(ArmySlotType.Back)
    if backHero == nil then
        return;
    end
    local curBgParent = self.troopsListPanel:GetChild(index-1).gameObject;
    curBgParent:SetActive(true);
    local curCardParent = curBgParent.transform:Find("SmallCardParent"):GetComponent(typeof(UnityEngine.Transform));


    if self.troopList[index] == nil then
        local mdata = DataUIConfig[UIType.UISmallHeroCard];
        local UISmallHeroCard = require(mdata.ClassName).new();
        GameResFactory.Instance():GetUIPrefab(mdata.ResourcePath,curCardParent,UISmallHeroCard,function (go)
                UISmallHeroCard:Init();
                UISmallHeroCard:InitTroopInfo(self.troopType, self.targetTiledId, armyInfo.spawnSlotIndex,armyInfo);
                local stateStr, isGray = self:GetArmyStateStrAndGray(armyInfo, isMainCity, buildId);
                UISmallHeroCard:SetUISmallHeroCardMessage(backHero,isGray);
                UISmallHeroCard:AllSoldierCount(armyInfo);
                UISmallHeroCard:SetTroopUIType("behavior", armySlot, buildId);
                UISmallHeroCard:SetArmyStateText(stateStr);
                self.troopList[index] = UISmallHeroCard;
                self.troopBgList[index] = curBgParent;
        end);
    else
        if self.troopList[index].gameObject.activeSelf == false then
            self.troopList[index].gameObject:SetActive(true)
        end
        if self.troopBgList[index].gameObject.activeSelf == false then
            self.troopBgList[index].gameObject:SetActive(true)
        end
        self.troopList[index]:InitTroopInfo(self.troopType, self.targetTiledId, armyInfo.spawnSlotIndex,armyInfo);
        local stateStr, isGray = self:GetArmyStateStrAndGray(armyInfo, isMainCity, buildId);
        self.troopList[index]:SetUISmallHeroCardMessage(backHero,isGray);
        self.troopList[index]:AllSoldierCount(armyInfo);
        self.troopList[index]:SetTroopUIType("behavior", armySlot, buildId);
        self.troopList[index]:SetArmyStateText(stateStr);
    end
end

-- 获取建筑物到目标地格子的距离
function UISelfLandFunction:GetToTargetDistance(building)
    if building == nil then
        return 0;
    end
    local targetX, targetY = MapService:Instance():GetTiledCoordinate(self.targetTiledId);
    local buildX, buildY = MapService:Instance():GetTiledCoordinate(building._tiledId);
    local  distances = math.sqrt((buildX - targetX)*(buildX - targetX)*12960000+(buildY - targetY)*(buildY - targetY)*12960000)/3600;

    local troopsAddition = distances*0.03;
    return string.format("%.1f", distances);
end

-- 获取部队显示状态字符串和是否置灰
function UISelfLandFunction:GetArmyStateStrAndGray(armyInfo, isMainCity, buildId)
    if isMainCity == true then
        if armyInfo.curBuildingId ~= buildId then
            return "<color=#808A87>调动</color>", true;
        -- 二次保护
        elseif armyInfo:GetArmyState() == ArmyState.TransformRoad or armyInfo:GetArmyState() == ArmyState.TransformArrive then
            return "<color=#808A87>调动</color>", true;
        elseif armyInfo:GetArmyState() == ArmyState.BattleRoad or
        armyInfo:GetArmyState() == ArmyState.BattleIng or
        armyInfo:GetArmyState() == ArmyState.SweepRoad or
        armyInfo:GetArmyState() == ArmyState.SweepIng or
        armyInfo:GetArmyState() == ArmyState.GarrisonRoad or
        armyInfo:GetArmyState() == ArmyState.MitaRoad or
        armyInfo:GetArmyState() == ArmyState.MitaIng or
        armyInfo:GetArmyState() == ArmyState.TrainingRoad or
        armyInfo:GetArmyState() == ArmyState.Training or
        armyInfo:GetArmyState() == ArmyState.RescueRoad or
        armyInfo:GetArmyState() == ArmyState.RescueIng then
            return "<color=#00FF00>行军</color>", true;
        elseif armyInfo:GetArmyState() == ArmyState.Back then
            return "<color=#4169E1>返回</color>", true;
        elseif armyInfo:GetArmyState() == ArmyState.GarrisonIng then
            return "<color=#00FF00>驻守</color>", true;
        elseif armyInfo:IsArmyInConscription() == true then
            return "<color=#C0C0C0>征兵</color>", true;
        elseif armyInfo:IsArmyIsBadlyHurt() == true then
            return "<color=#FF0000>重伤</color>", true;
        elseif armyInfo:IsArmyIsTired() == true then
            return "<color=#FF0000>疲劳</color>", true;
        elseif armyInfo:GetArmyState() == ArmyState.None then
            return "", false;
        else
            return "", false;
        end
    else
        if armyInfo:GetArmyState() == ArmyState.BattleRoad or
        armyInfo:GetArmyState() == ArmyState.BattleIng or
        armyInfo:GetArmyState() == ArmyState.SweepRoad or
        armyInfo:GetArmyState() == ArmyState.SweepIng or
        armyInfo:GetArmyState() == ArmyState.GarrisonRoad or
        armyInfo:GetArmyState() == ArmyState.MitaRoad or
        armyInfo:GetArmyState() == ArmyState.MitaIng or
        armyInfo:GetArmyState() == ArmyState.TrainingRoad or
        armyInfo:GetArmyState() == ArmyState.Training or
        armyInfo:GetArmyState() == ArmyState.RescueRoad or
        armyInfo:GetArmyState() == ArmyState.RescueIng or
        armyInfo:GetArmyState() == ArmyState.TransformRoad then
            return "<color=#00FF00>行军</color>", true;
        elseif armyInfo:GetArmyState() == ArmyState.Back then
            return "<color=#4169E1>返回</color>", true;
        elseif armyInfo:GetArmyState() == ArmyState.GarrisonIng then
            return "<color=#00FF00>驻守</color>", true;
        elseif armyInfo:IsArmyInConscription() == true then
            return "<color=#C0C0C0>征兵</color>", true;
        elseif armyInfo:IsArmyIsBadlyHurt() == true then
            return "<color=#FF0000>重伤</color>", true;
        elseif armyInfo:IsArmyIsTired() == true then
            return "<color=#FF0000>疲劳</color>", true;
        elseif armyInfo:GetArmyState() == ArmyState.TransformArrive then
            return "<color=#00FF00>待命</color>", false;
        else
            return "", false;
        end
    end
end

--判断界面的显示
function UISelfLandFunction:DoVerdict(param)
    --出征
    if param == SelfLand.battle then        
        local battle = self.gameObject.transform:Find("OneselfLandFunction/functionGather/oneselfLandExpeditionsImage");
        battle.gameObject:SetActive(true);
        local transfer = self.gameObject.transform:Find("OneselfLandFunction/functionGather/oneselfLandTransferImage");
        transfer.gameObject:SetActive(false);
        local loot = self.gameObject.transform:Find("OneselfLandFunction/functionGather/oneselfLandSweepImage");
        loot.gameObject:SetActive(false);        
        local garrison = self.gameObject.transform:Find("OneselfLandFunction/functionGather/oneselfLandDefendImage");
        garrison.gameObject:SetActive(false);
        local wasteland = self.gameObject.transform:Find("OneselfLandFunction/functionGather/oneselfLandTondenImage");
        wasteland.gameObject:SetActive(false);
        local training = self.gameObject.transform:Find("OneselfLandFunction/functionGather/oneselfLandTrainingImage");
        training.gameObject:SetActive(false);             
    end
    --调动
    if param == SelfLand.transfer then
        local transfer = self.gameObject.transform:Find("OneselfLandFunction/functionGather/oneselfLandTransferImage");
        transfer.gameObject:SetActive(true);
        local loot = self.gameObject.transform:Find("OneselfLandFunction/functionGather/oneselfLandSweepImage");
        loot.gameObject:SetActive(false);        
        local garrison = self.gameObject.transform:Find("OneselfLandFunction/functionGather/oneselfLandDefendImage");
        garrison.gameObject:SetActive(false);
        local wasteland = self.gameObject.transform:Find("OneselfLandFunction/functionGather/oneselfLandTondenImage");
        wasteland.gameObject:SetActive(false);
        local training = self.gameObject.transform:Find("OneselfLandFunction/functionGather/oneselfLandTrainingImage");
        training.gameObject:SetActive(false);
        local battle = self.gameObject.transform:Find("OneselfLandFunction/functionGather/oneselfLandExpeditionsImage");
        battle.gameObject:SetActive(false);
    end
    --扫荡
    if param == SelfLand.loot then
        local loot = self.gameObject.transform:Find("OneselfLandFunction/functionGather/oneselfLandSweepImage");
        loot.gameObject:SetActive(true);        
        local garrison = self.gameObject.transform:Find("OneselfLandFunction/functionGather/oneselfLandDefendImage");
        garrison.gameObject:SetActive(false);
        local wasteland = self.gameObject.transform:Find("OneselfLandFunction/functionGather/oneselfLandTondenImage");
        wasteland.gameObject:SetActive(false);
        local training = self.gameObject.transform:Find("OneselfLandFunction/functionGather/oneselfLandTrainingImage");
        training.gameObject:SetActive(false);
        local transfer = self.gameObject.transform:Find("OneselfLandFunction/functionGather/oneselfLandTransferImage");
        transfer.gameObject:SetActive(false);
        local battle = self.gameObject.transform:Find("OneselfLandFunction/functionGather/oneselfLandExpeditionsImage");
        battle.gameObject:SetActive(false);
    end
    --驻守
    if param == SelfLand.garrison then
        local garrison = self.gameObject.transform:Find("OneselfLandFunction/functionGather/oneselfLandDefendImage");
        garrison.gameObject:SetActive(true);
        local loot = self.gameObject.transform:Find("OneselfLandFunction/functionGather/oneselfLandSweepImage");
        loot.gameObject:SetActive(false);        
        local wasteland = self.gameObject.transform:Find("OneselfLandFunction/functionGather/oneselfLandTondenImage");
        wasteland.gameObject:SetActive(false);
        local training = self.gameObject.transform:Find("OneselfLandFunction/functionGather/oneselfLandTrainingImage");
        training.gameObject:SetActive(false);
        local transfer = self.gameObject.transform:Find("OneselfLandFunction/functionGather/oneselfLandTransferImage");
        transfer.gameObject:SetActive(false);
        local battle = self.gameObject.transform:Find("OneselfLandFunction/functionGather/oneselfLandExpeditionsImage");
        battle.gameObject:SetActive(false);
    end
    --屯田
    if param == SelfLand.wasteland then               
        local wasteland = self.gameObject.transform:Find("OneselfLandFunction/functionGather/oneselfLandTondenImage");
        wasteland.gameObject:SetActive(true);
        local loot = self.gameObject.transform:Find("OneselfLandFunction/functionGather/oneselfLandSweepImage");
        loot.gameObject:SetActive(false);
        local garrison = self.gameObject.transform:Find("OneselfLandFunction/functionGather/oneselfLandDefendImage");
        garrison.gameObject:SetActive(false);        
        local training = self.gameObject.transform:Find("OneselfLandFunction/functionGather/oneselfLandTrainingImage");
        training.gameObject:SetActive(false);
        local transfer = self.gameObject.transform:Find("OneselfLandFunction/functionGather/oneselfLandTransferImage");
        transfer.gameObject:SetActive(false);
        local battle = self.gameObject.transform:Find("OneselfLandFunction/functionGather/oneselfLandExpeditionsImage");
        battle.gameObject:SetActive(false);
    end
    --练兵
    if param == SelfLand.training then
        local training = self.gameObject.transform:Find("OneselfLandFunction/functionGather/oneselfLandTrainingImage");
        training.gameObject:SetActive(true);
        local loot = self.gameObject.transform:Find("OneselfLandFunction/functionGather/oneselfLandSweepImage");
        loot.gameObject:SetActive(false);   
        local garrison = self.gameObject.transform:Find("OneselfLandFunction/functionGather/oneselfLandDefendImage");
        garrison.gameObject:SetActive(false);  
        local wasteland = self.gameObject.transform:Find("OneselfLandFunction/functionGather/oneselfLandTondenImage");
        wasteland.gameObject:SetActive(false); 
        local transfer = self.gameObject.transform:Find("OneselfLandFunction/functionGather/oneselfLandTransferImage");
        transfer.gameObject:SetActive(false); 
        local battle = self.gameObject.transform:Find("OneselfLandFunction/functionGather/oneselfLandExpeditionsImage");
        battle.gameObject:SetActive(false); 
    end
end

return UISelfLandFunction;