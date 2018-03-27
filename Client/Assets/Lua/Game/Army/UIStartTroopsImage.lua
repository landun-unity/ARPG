--[[点击建筑物选择部队出征]]--
local UIBase= require("Game/UI/UIBase");
local UIStartTroopsImage=class("UIStartTroopsImage",UIBase);        
local UIService=require("Game/UI/UIService");
local UIType=require("Game/UI/UIType");

--构造函数
function UIStartTroopsImage:ctor()
    UIStartTroopsImage.super.ctor(self);
    self.nameText = nil;
    self.distanceText = nil;
    self.troopsCountText = nil;
    self.chooseMyselfTrans = nil;
    self._index = 0;
    -- 建筑类型
    self._buildType = BuildingType.MainCity;
    -- 玩家城市索引或要塞索引
    self._cityFortIndex = 0;
    self._parent = nil;
    self.NameImage = nil
end

--注册控件
function UIStartTroopsImage:DoDataExchange()
	self.nameText = self:RegisterController(UnityEngine.UI.Text, "NameImage/nameText");
	self.distanceText = self:RegisterController(UnityEngine.UI.Text, "DistanceImage/distanceText");
	self.troopsCountText = self:RegisterController(UnityEngine.UI.Text, "TroopsCountImage/troopsCountText");
    self.chooseMyselfTrans = self:RegisterController(UnityEngine.Transform, "PitchOnImage"); 
    self.NameImage = self:RegisterController(UnityEngine.UI.Image, "NameImage");
end

--注册控件点击事件
function UIStartTroopsImage:DoEventAdd()
    self:AddListener(self.transform:GetComponent(typeof(UnityEngine.UI.Button)), self.ChooseMyself);
end

-- 初始化
function UIStartTroopsImage:InitInfo(index, buildInfo, buildType, cityFortIndex, parent)
    if self.transform.gameObject.activeSelf == false then
        self.transform.gameObject:SetActive(true);
    end
    self._index = index;
    self._buildType = buildType;
    self._cityFortIndex = cityFortIndex;
    self._parent = parent;
    if buildType == BuildingType.WildFort then
        self.nameText.text = "要塞";
    else
        self.nameText.text = buildInfo.name;
    end
    self:marchDistance(buildInfo.targetTiledId, buildInfo.startTiledId)
	self:ArmyCount(buildInfo.canMoveArmyCount, buildInfo.allArmyCount);

    if buildType == BuildingType.MainCity or buildType == BuildingType.SubCity then
        self.NameImage:GetComponent(typeof(UnityEngine.UI.Image)).sprite = GameResFactory.Instance():GetResSprite("MainCity");
    elseif buildType == BuildingType.PlayerFort or BuildingType.WildFort then
        self.NameImage:GetComponent(typeof(UnityEngine.UI.Image)).sprite = GameResFactory.Instance():GetResSprite("fortress1");
    end
end

-- 行军距离
function UIStartTroopsImage:marchDistance(targetTiledId, startTiledId)
	 local startTiledX,startTiledY = MapService:Instance():GetTiledCoordinate(startTiledId);
	 local targetTiledX,targetTiledY = MapService:Instance():GetTiledCoordinate(targetTiledId);
	 local distances = string.format("%.1f" , math.sqrt((targetTiledX - startTiledX)*(targetTiledX - startTiledX)+(targetTiledY - startTiledY)*(targetTiledY - startTiledY)));
     --（(targetTiledX - startTiledX)*(targetTiledX - startTiledX)+(targetTiledY - startTiledY)*(targetTiledY - startTiledY) * 12960000)
     --string.format("%.1f" , math.sqrt((targetTiledX - startTiledX)*(targetTiledX - startTiledX)*12960000+(targetTiledY - startTiledY)*(targetTiledY - startTiledY)*12960000)/3600);
	 self.distanceText.text = distances;
end

-- 部队数量
function UIStartTroopsImage:ArmyCount(canMoveArmyCount, allArmyCount)
    self.troopsCountText.text = canMoveArmyCount.."/"..allArmyCount;
end

-- 选择自己的建筑
function UIStartTroopsImage:ChooseMyself()
    if self._parent ~= nil then
        self._parent:ChooseBuild(self._index);
    end
end

-- 选中或取消选中
function UIStartTroopsImage:ChooseOrCancel(isChoose)
    if self.gameObject.activeSelf == false then
        return;
    end

    if self.chooseMyselfTrans.gameObject.activeSelf ~= isChoose then
        self.chooseMyselfTrans.gameObject:SetActive(isChoose);
    end
end

-- 隐藏自己
function UIStartTroopsImage:HideMyself()
    if self.transform.gameObject.activeSelf == true then
        self.transform.gameObject:SetActive(false);
    end
    self._parent = nil;
end

function UIStartTroopsImage:GetBuildType()
    return self._buildType;
end

function UIStartTroopsImage:GetCityFortIndex()
    return self._cityFortIndex;
end

return UIStartTroopsImage