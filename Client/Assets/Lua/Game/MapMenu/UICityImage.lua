local UIBase= require("Game/UI/UIBase")
local UICityImage=class("UICityImage",UIBase)

--构造函数
function UICityImage:ctor()
	UICityImage.super.ctor(self);
  --
  self._text = nil;

  self._button= nil;

  self._building = nil;

  self._tiled = nil;
end

--初始化界面
function UICityImage:OnInit()
   self:DoDataExchange();
   self:DoEventAdd();
end

--刷新
function UICityImage:RegisterAllNotice()
    --self:RegisterNotice(L2C_Facility.UpgradeFacilityRespond, self.Refresh);
end

--注册控件
function UICityImage:DoDataExchange()
   self._text = self:RegisterController(UnityEngine.UI.Text, "Text");
   self._button = self:RegisterController(UnityEngine.UI.Button, "");
end

--注册控件点击事件
function UICityImage:DoEventAdd()
   self:AddListener(self._button, self.OnClick);
end

function UICityImage:OnShow(tiled)
   self._tiled = tiled;
   self._building = tiled:GetBuilding();
   --self._text.text = tiled:GetBuilding()._dataInfo.Name;
   self:HandleImageRaycastTarget(tiled:GetBuilding());
   self:_HandleCityName(self._building)
end

function UICityImage:HandleImageRaycastTarget(building)
    if building ~= nil and building._owner == PlayerService:Instance():GetPlayerId()
    and building._dataInfo.Type ~= BuildingType.Ruins
    and building._dataInfo.Type ~= BuildingType.LevelShiYi
    and building._dataInfo.Type ~= BuildingType.Boat
    and building._dataInfo.Type ~= BuildingType.LevelBoat then
        self._button:GetComponent(typeof(UnityEngine.UI.Image)).raycastTarget = true;
    else
        self._button:GetComponent(typeof(UnityEngine.UI.Image)).raycastTarget = false;
    end
end

function UICityImage:OnHide()
end

--处理文字颜色
function UICityImage:_HandleCityName(building)
    local name = "<color=#ffffffff>"..building._dataInfo.Name.."</color>";
    if building._owner == PlayerService:Instance():GetPlayerId() then
        name = "<color=#ffffffff>"..building._dataInfo.Name.."</color>";
    elseif building._owner ~= PlayerService:Instance():GetPlayerId() and building._leagueId ~= 0 and building._leagueId == PlayerService:Instance():GetLeagueId() then
        name = "<color=#599ba9>"..building._dataInfo.Name.."</color>";
    elseif building._owner ~= PlayerService:Instance():GetPlayerId() and building._leagueId ~= 0 and building._leagueId ~= PlayerService:Instance():GetLeagueId() then
        name = "<color=#AA5252>"..building._dataInfo.Name.."</color>";
    end
    self._text.text = name;
end

function UICityImage:OnClick()
	if self._building._dataInfo.Type == BuildingType.WildBuilding then
		print("野城太守功能");
	elseif self._building._dataInfo.Type == BuildingType.WildFort or self._building._dataInfo.Type == BuildingType.WildGarrisonBuilding then
    --ClickService:Instance():ShowTiled(self._tiled, MapService:Instance():GetTiledPositionByIndex(self._building._tiledId));
    ClickService:Instance():HideTiled();
    MapService:Instance():SetCallBack(self._building:GetIndex());
    MapService:Instance():ClickCityCallBack();
    MapService:Instance():EnterOperator(OperatorType.ZoomOut);
    local param = {};
    param[0] = self._building
    UIService:Instance():ShowUI(UIType.UIMainCity, param);
    UIService:Instance():HideUI(UIType.UIGameMainView);
    end
end

return UICityImage;