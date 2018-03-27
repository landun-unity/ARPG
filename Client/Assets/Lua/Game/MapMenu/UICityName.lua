local UIBase= require("Game/UI/UIBase")
local UICityName=class("UICityName",UIBase)

--构造函数
function UICityName:ctor()
	UICityName.super.ctor(self);
	--
	self._text = nil;

	self._button = nil;

	self._building = nil;

   self._tiled = nil;

   self._fallimage = nil;

   self._state = 0;
   self.image = nil;
end

--初始化界面
function UICityName:Init()
	self:DoDataExchange();
	self:DoEventAdd();
end

--刷新
function UICityName:RegisterAllNotice()
    --self:RegisterNotice(L2C_Facility.UpgradeFacilityRespond, self.Refresh);
end

--注册控件
function UICityName:DoDataExchange()
   self._text = self:RegisterController(UnityEngine.UI.Text, "Text");
   self._button = self:RegisterController(UnityEngine.UI.Button, "Button");
   self._fallimage = self:RegisterController(UnityEngine.UI.Image, "FallImage");
   self.image = self:RegisterController(UnityEngine.UI.Image,"Button/Image")
end

--注册控件点击事件
function UICityName:DoEventAdd()
    self:AddListener(self._button, self.OnClick);
    self:AddOnDown(self._button.gameObject, self.OnClickDown);
    self:AddOnUp(self._button.gameObject, self.OnClickUp);
    self:AddOnDrag(self._button.gameObject, self.OnClickUp);
end

function UICityName:OnShow(tiled)
   self._tiled = tiled;
   self._building = tiled:GetBuilding();
   self:_HandleCityName(tiled:GetBuilding());
   --self._text.text = tiled:GetBuilding()._name;
   self:_HandleFallImage(tiled);
   self:_HandleButton(self._tiled:GetBuilding());
   -- if building._owner ~= PlayerService:Instance():GetPlayerId() then
   -- 	   self._button.interactable = false;
   -- else
   -- 	   self._button.interactable = true;
   -- end
   if self._building._dataInfo.Type == BuildingType.MainCity or self._building._dataInfo.Type == BuildingType.SubCity then
      self.image:GetComponent(typeof(UnityEngine.UI.Image)).sprite = GameResFactory.Instance():GetResSprite("MainCity");
   elseif self._building._dataInfo.Type == BuildingType.PlayerFort then
      self.image:GetComponent(typeof(UnityEngine.UI.Image)).sprite = GameResFactory.Instance():GetResSprite("fortress1");
   end
end
--处理文字颜色
function UICityName:_HandleCityName(building)
    local name = "<color=#ffffffff>"..building._name.."</color>";
    if building._owner == PlayerService:Instance():GetPlayerId() then
        name = "<color=#ffffffff>"..building._name.."</color>";
    elseif building._owner ~= PlayerService:Instance():GetPlayerId() and building._leagueId ~= 0 and building._leagueId == PlayerService:Instance():GetLeagueId() then
        name = "<color=#599ba9>"..building._name.."</color>";
    elseif building._owner ~= PlayerService:Instance():GetPlayerId() and building._leagueId ~= PlayerService:Instance():GetLeagueId() then
        name = "<color=#AA5252>"..building._name.."</color>";
    end
    self._text.text = name;
end

function UICityName:_HandleFallImage(tiled)

   if tiled.tiledInfo == nil or tiled.tiledInfo.superiorLeagueId == 0 then
      if self._fallimage.gameObject.activeSelf == true then
         self._fallimage.gameObject:SetActive(false);
      end
   elseif tiled.tiledInfo ~= nil and tiled.tiledInfo.superiorLeagueId ~= 0 then
      if self._fallimage.gameObject.activeSelf == false then
         self._fallimage.gameObject:SetActive(true);
      end 
      self._text.text = "<color=#ffa500ff>"..self._building._name.."</color>";
   end
end

function UICityName:_HandleButton(building)
   if building ~= nil and building._owner == PlayerService:Instance():GetPlayerId() and building._subCitySuccessTime == 0 and building._buildSuccessTime == 0 then
      self._button.interactable = true;
      self._button.image.raycastTarget = true;
      self.image.raycastTarget = true
      return;
   end
   self._button.interactable = false;
   self._button.image.raycastTarget = false;
   self.image.raycastTarget = false
end

--动画
function UICityName:OnHide()
end

--城入口
function UICityName:OnClick()
    -- 新手引导期不能通过点击主城上面的名字进入主城
    if GuideServcice:Instance():GetIsFinishGuide() == false then
        return;
    end

    --ClickService:Instance():ShowTiled(self._tiled, MapService:Instance():GetTiledPositionByIndex(self._building._tiledId));
    ClickService:Instance():HideTiled();
    MapService:Instance():SetCallBack(self._building:GetIndex());
    MapService:Instance():ClickCityCallBack();
    MapService:Instance():EnterOperator(OperatorType.ZoomOut);
    local param = {};
    param[0] = self._building
    UIService:Instance():ShowUI(UIType.UIMainCity, param);
    UIService:Instance():HideUI(UIType.UIGameMainView);
    local ltDescr = self.transform:DOScale(Vector3.New(1, 1, 1), 0.05)
    ltDescr:OnComplete(self,function ()
      self._state = 0;
    end);
end

function UICityName:OnClickDown()
    -- 新手引导期不能通过点击主城上面的名字进入主城
    if GuideServcice:Instance():GetIsFinishGuide() == false then
        return;
    end
    
    if self._state ~= 0 then
      return;
    end

    self._state = 1;
      local ltDescr =self.transform:DOScale(Vector3.New(0.9, 0.9, 0.9), 0.05)
        ltDescr:OnComplete(self,function ()
      self._state = 2;
    end);
end

function UICityName:OnClickUp()
    -- 新手引导期不能通过点击主城上面的名字进入主城
    if GuideServcice:Instance():GetIsFinishGuide() == false then
        return;
    end

    if self._state ~= 2 then
      return;
    end

    self._state = 1;
          local ltDescr =self.transform:DOScale(Vector3.New(1, 1, 1), 0.05)
        ltDescr:OnComplete(self,function ()
           self._state = 0;
    end);
end

return UICityName;