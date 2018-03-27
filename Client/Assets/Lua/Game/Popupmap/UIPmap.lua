-- region *.lua
-- Date
local MapLoad = require("Game/Map/MapLoad")
local UIBase = require("Game/UI/UIBase")
local UIPmap = class("UIPmap", UIBase);
local Canvas = UGameObject.Find("Canvas")
local MapLoad = require("Game/Map/MapLoad")
local List = require("common/List");
local MarkInfoList = List.new();
local MateInfoList = List.new();
local UIMateInfo = require("Game/Popupmap/UIMateInfo");
local UIConfigTable = require("Game/Table/model/DataUIConfig");
local DataRegion = require("Game/Table/model/DataRegion")
local DataBuilding = require("Game/Table/model/DataBuilding")
local UIPic = require("Game/Popupmap/UIPic");
local MapMoveTime = 0.2;
local ShowTime = 0.5;
local PmapPrefab = require("Game/Popupmap/PmapPrefabUI")

function UIPmap:ctor()

    UIPmap.super.ctor(self)
    self.LeagueMark = nil;
    self.CloseBtn = nil;
    self.CloseBtn2 = nil;
    self._perfabPath = UIConfigTable[UIType.UIMateInfo].ResourcePath;
    self._parentObj2 = nil;
    self._parentObj = nil;
    self._mapObject = nil;
    self.LeagueMate = nil;
    self._allMate = { }
    self._allMark = { }
    self._lastPosition = Vector3.New(0, 0, 0);
    self._width = MapLoad.width;
    self._height = MapLoad.height;
    self._tiledWidth = MapLoad.tileWidth;
    self._tiledHight = MapLoad.tileHeight;
    self.PointPicList = List.new();
    self.count = 0;

    self._edgeLength = 10;
    self._lastcenterX = 0;
    self._lastcenterY = 0;
    self._operatorManage = require("Game/Map/Operator/OperatorManage").new();
    -- self._clickManage = require("Game/Map/ClickMenu/ClickManage").new();
    self.requestMapInfoTimer = nil;
    self.BackBtn = nil;
    self.Xtext = nil;
    self.Ytext = nil;
    self.firstMap = true;
    self.JumpBtn = nil;
    self.LeagueMarkBtn = nil;
    self.LeagueMateBtn = nil;
    self.Map = nil;
    self.MapPoint = nil;
    self._tiledMap = nil;

    self._canvas = nil;
    self._tiledManage = require("Game/Map/TiledManage").new();
    self._PmapOperaterManage = require("Game/Popupmap/PmapOperaterManage").new();
    self.MapPos = nil;
    self._allPic = { }
    self._secondMapContent = nil;
    self.MapBackBtn = nil;
    self.StateType = nil;
    self._PicperfabPath = DataUIConfig[UIType.UIPic].ResourcePath;
    self.pmapscroll = nil;
    self.centerCity = nil;
    self.centerState = nil;
    self.pmapParentObj = nil;
    self.pmapPrefab = DataUIConfig[UIType.PmapPrefab].ResourcePath;
    self._allCity = { }
    self._allMapMark = { }
    self._allMember = { }
    self._allSelfPic = { }
    self.SecondList = nil;
    self.ShowArmyCity = nil;
    self.LeagueMarkContainer = nil;
    self.MapPointDot = nil;
    self.centerCityNametext1 = nil;
    self.count = nil;
    self.MarkBtnRedImage = nil;
    self.firstTime = true
end

function UIPmap:DoDataExchange(args)
    self.pmapscroll = self:RegisterController(UnityEngine.Transform, "Scroll2")
    self.centerState = self:RegisterController(UnityEngine.UI.Text, "Scroll2/CenterCity/Text (1)")
    self.centerCity = self:RegisterController(UnityEngine.UI.Text, "Scroll2/CenterCity/Text")
    self.pmapParentObj = self:RegisterController(UnityEngine.Transform, "Scroll2/Viewport/Content")
    self.passPic = self:RegisterController(UnityEngine.Transform, "Scroll2/Viewport/Content/Image")
    self.ShowArmyCity = self:RegisterController(UnityEngine.UI.Toggle, "TextObj/ShowDefendersToggle")
    self.centerCityNametext = self:RegisterController(UnityEngine.UI.Text, "Scroll2/Text")
    self.centerCityNametext1 = self:RegisterController(UnityEngine.UI.Text, "Scroll2/Text1")
    self.BackBtn = self:RegisterController(UnityEngine.UI.Button, "Back")
    self.JumpBtn = self:RegisterController(UnityEngine.UI.Button, "Jump")
    self.LeagueMarkBtn = self:RegisterController(UnityEngine.UI.Button, "MarkBtn")
    self.LeagueMateBtn = self:RegisterController(UnityEngine.UI.Button, "MateBtn")
    self.Map = self:RegisterController(UnityEngine.UI.Image, "BackGround")
    self.MapPoint = self:RegisterController(UnityEngine.UI.Image, "MapScroll/MapPoint")
    self.MapPointDot = self:RegisterController(UnityEngine.UI.Image, "MapScroll/MapPoint/MapPointDot")
    self._tiledMap = self:RegisterController(UnityEngine.RectTransform, "MapScroll/Viewport/Content/Map")
    self._tiledMapContainer = self:RegisterController(UnityEngine.RectTransform, "MapScroll/Viewport/Content/Map/Image")
    self._tiledMapSelfContainer = self:RegisterController(UnityEngine.RectTransform, "MapScroll/Viewport/Content/Map/Image1")
    self.Xtext = self:RegisterController(UnityEngine.UI.InputField, "Xtext")
    self.Ytext = self:RegisterController(UnityEngine.UI.InputField, "Ytext")
    self._secondMapContent = self:RegisterController(UnityEngine.Transform, "MapScroll/Viewport/Content")
    self.LeagueMate = self:RegisterController(UnityEngine.Transform, "Scroll")
    self.CloseBtn = self:RegisterController(UnityEngine.UI.Button, "Scroll/Close")
    self._parentObj = self:RegisterController(UnityEngine.Transform, "Scroll/Viewport/Content")
    self.LeagueMark = self:RegisterController(UnityEngine.Transform, "Scroll1")
    self._parentObj2 = self:RegisterController(UnityEngine.Transform, "Scroll1/Viewport/Content")
    self.CloseBtn2 = self:RegisterController(UnityEngine.UI.Button, "Scroll1/Close1")
    self.MapBackBtn = self:RegisterController(UnityEngine.UI.Button, "MapBackBtn")
    self.LeagueMarkContainer = self:RegisterController(UnityEngine.RectTransform, "MapScroll/Viewport/Content/Map/Image2")
    self.MarkBtnRedImage = self:RegisterController(UnityEngine.Transform, "MarkBtn/Image")
    self.LeagueMemberContainer = self:RegisterController(UnityEngine.RectTransform, "MapScroll/Viewport/Content/Map/Image3")
    -- 弹出地图的下面的显示self:RegisterController(UnityEngine.Transform, "MarkBtn/Image")
    self.secondText = self:RegisterController(UnityEngine.Transform, "TextObj")
    self.firstText = self:RegisterController(UnityEngine.Transform, "myCity")

end

function UIPmap:OnShow()
    if self.firstMap == false then
        self.MapBackBtn.gameObject:SetActive(true)
        self.pmapscroll.gameObject:SetActive(true)
        self.ShowArmyCity.gameObject:SetActive(true)
        self:AddCityOnSecondMap(self.SecondList)
    else
        self.MapBackBtn.gameObject:SetActive(false)
        self.pmapscroll.gameObject:SetActive(false)
        self.ShowArmyCity.gameObject:SetActive(false)
        self:AddCityOnMap()
    end

    if self.firstTime then
        local x, y = MapService:Instance():GetTiledCoordinate(PlayerService:Instance():GetMainCityTiledId())
        local pos = self:GetUGUIPos(x, y)
        self._tiledMap.transform.localPosition = pos
        self.firstTime = false
    else
        local x, y = MapService:Instance():GetCurrentPos()
        self:MoveToClickMateAndMark(x, y)
    end

    local x, y = self:UI2MapPos(self._tiledMap.transform.localPosition.x, self._tiledMap.transform.localPosition.y)
    self.Xtext.text = x
    self.Ytext.text = y
    self.LeagueMark.gameObject:SetActive(false)
    self.LeagueMate.gameObject:SetActive(false)
    self.LeagueMateBtn.gameObject:SetActive(true)
    self.LeagueMarkBtn.gameObject:SetActive(false)
    if PlayerService:Instance():GetLeagueId() == 0 then
        self.LeagueMarkBtn.gameObject:SetActive(false)
    else
        self.LeagueMarkBtn.gameObject:SetActive(true)
    end
    self:SetPmapCityScrollFalse()
    self:SetMateInfoFalse()
    self:SetMarkInfoFalse()
    self.centerCityNametext.text = "";
    self.centerCityNametext1.text = "";
    if self.firstMap then
        self.secondText.gameObject:SetActive(false)
        self.firstText.gameObject:SetActive(true)
    else
        self.secondText.gameObject:SetActive(true)
        self.firstText.gameObject:SetActive(false)
    end

    -- 将城市列表归零
    self.pmapParentObj.localPosition = Vector3.zero

end



function UIPmap:EnterOperator(operatorType)
    self._PmapOperaterManage:EnterOperator(operatorType);
end

function UIPmap:DoEventAdd()

    self:AddListener(self.BackBtn, self.OnClickBackBtn)
    self:AddListener(self.JumpBtn, self.OnClickJumpBtn)
    self:AddListener(self.LeagueMarkBtn, self.OnClickLeagueMarkBtn)
    self:AddListener(self.LeagueMateBtn, self.OnClickLeagueMateBtn)
    self:AddListener(self.CloseBtn, self.OnClickCloseBtn)
    self:AddListener(self.CloseBtn2, self.OnClickCloseBtn1)
    self:AddListener(self.MapBackBtn, self.OnClickMapBackBtn)
    self:AddInputFieldOnValueChanged(self.Xtext, self.Checkx)
    self:AddInputFieldOnValueChanged(self.Ytext, self.Checky)
    self:_OnInit()
    self:_RegisterAllEvent()

end

function UIPmap:Checkx()
    if self.Xtext.text == "-" then
        self.Xtext.text = ""
    end
end
function UIPmap:Checky()
    if self.Ytext.text == "-" then
        self.Ytext.text = ""
    end
end
function UIPmap:OnClickBackBtn()
    UIService:Instance():HideUI(UIType.UIPmap)
    UIService:Instance():ShowUI(UIType.UIGameMainView)
    MapService:Instance():ResetMinMapPos()
    UIService:Instance():HideUI(UIType.PmapMateInfoUI)
end

function UIPmap:OnClickJumpBtn()

    local Camera = UnityEngine.GameObject.Find("LandCamera")
    if tonumber(self.Xtext.text) == nil or tonumber(self.Ytext.text) == nil then
        UIService:Instance():ShowUI(UIType.UICueMessageBox, UICueMessageType.PositionIsWrong)
        return
    end

    if tonumber(self.Xtext.text) < 1 or tonumber(self.Ytext.text) < 1 then
        UIService:Instance():ShowUI(UIType.UICueMessageBox, UICueMessageType.PositionIsWrong)
        return
    end

    if tonumber(self.Xtext.text) > 1598 or tonumber(self.Ytext.text) > 1598 then
        UIService:Instance():ShowUI(UIType.UICueMessageBox, UICueMessageType.PositionIsWrong)
        return
    end
    self:MoveToClickMateAndMark(tonumber(self.Xtext.text), tonumber(self.Ytext.text))
    local tiledIndex = self._tiledManage:GetTiledIndex(tonumber(self.Xtext.text), tonumber(self.Ytext.text));
    local scanPos = self._tiledManage:GetTiledPositionByIndex(tiledIndex);
    local pos = Vector3.New(- scanPos.x, - scanPos.y + 200, 0)

    MapService:Instance():ScanTiledByUGUIPositionNotDelay(scanPos.x, scanPos.y - 120);
    MapService:Instance():ChangeScreenCenter(tiledIndex)
    UIService:Instance():GetUIClass(UIType.UIMinMap):ScanMinMap(tiledIndex)
    UIService:Instance():HideUI(UIType.UIPmap)
    UIService:Instance():ShowUI(UIType.UIGameMainView)
    Camera.transform:GetChild(0).gameObject:SetActive(true);


    --    MapService:Instance():PmapShowAllTiled(pos, function()
    --        MapService:Instance():ScanTiled(tiledIndex, function()
    --            MapService:Instance():ChangeScreenCenter(tiledIndex)
    --            UIService:Instance():GetUIClass(UIType.UIMinMap):ScanMinMap(tiledIndex)
    --       end , 0, true)
    --        UIService:Instance():HideUI(UIType.UIPmap)
    --        UIService:Instance():ShowUI(UIType.UIGameMainView)
    --        Camera.transform:GetChild(0).gameObject:SetActive(true);
    --    end )


    local obj = self.JumpBtn.gameObject;
    if Camera ~= nil then
        Camera.transform:GetChild(0).gameObject:SetActive(false);
    end


end

function UIPmap:OnClickLeagueMarkBtn()

    GameResFactory.Instance():SetInt("LeagueMarkNumber", LeagueService:Instance():GetLeagueMarkList():Count());
    self.MarkBtnRedImage.gameObject:SetActive(false)

    self.LeagueMark.gameObject:SetActive(true)
    self.LeagueMate.gameObject:SetActive(false)
    self.LeagueMateBtn.gameObject:SetActive(false)
    self.LeagueMarkBtn.gameObject:SetActive(false)
    local pos = self.LeagueMark.localPosition;
    self.LeagueMark.localPosition = pos - Vector3.right * 50
    self.LeagueMark.transform:DOLocalMove(pos, MapMoveTime)
    self.transform:DOLocalMoveX(-40, MapMoveTime)

end


function UIPmap:ChangeInputField(posx, posy)
    self.Xtext.text = posx
    self.Ytext.text = posy
end


function UIPmap:LeagueMarkMessageBack()

    self:AddLeagueMarkOnCity()
    local marklist = LeagueService:Instance():GetLeagueMarkList();
    -- 同盟标记数量小红点
    local leagueMarkNum = GameResFactory.Instance():GetInt("LeagueMarkNumber");
    if leagueMarkNum ~= nil then
        if leagueMarkNum < marklist:Count() then
            self.MarkBtnRedImage.gameObject:SetActive(true)
        else
            self.MarkBtnRedImage.gameObject:SetActive(false)
        end
    else
        if 0 < marklist:Count() then
            self.MarkBtnRedImage.gameObject:SetActive(true)
        else
            self.MarkBtnRedImage.gameObject:SetActive(false)
        end
    end

    for k, v in pairs(self._allMark) do
        if (v.gameObject.activeSelf == true) then
            v.gameObject:SetActive(false);
        end
    end
    if marklist:Count() ~= 0 then
        local marksize = marklist:Count();
        local GetFromOldList = true;
        for index = 1, marksize do
            local markinfo = marklist:Get(index)
            local mMarkInfo = self._allMark[index];
            if (mMarkInfo == nil) then
                GetFromOldList = false;
                mMarkInfo = UIMateInfo.new();
                GameResFactory.Instance():GetUIPrefab(self._perfabPath, self._parentObj2, mMarkInfo, function(go)
                    mMarkInfo:Init();
                    mMarkInfo:SetMarkInfo(markinfo, true);
                    if self._allMark[index] == nil then
                        self._allMark[index] = mMarkInfo;
                    end
                    MarkInfoList:Push(mMarkInfo);
                end );
            else
                self._allMark[index].gameObject:SetActive(true);
                mMarkInfo:SetMarkInfo(markinfo, true);
            end
        end
    end
end

function UIPmap:OnClickLeagueMateBtn()
    if self.LeagueMate.gameObject.activeSelf then
        return
    end
    self.LeagueMate.gameObject:SetActive(true)
    self.LeagueMark.gameObject:SetActive(false)
    self.LeagueMarkBtn.gameObject:SetActive(false)
    self.LeagueMateBtn.gameObject:SetActive(false)
    local pos = self.LeagueMate.localPosition;
    self.LeagueMate.localPosition = pos - Vector3.right * 50
    self.LeagueMate.transform:DOLocalMove(pos, MapMoveTime)
    self.transform:DOLocalMoveX(-40, MapMoveTime)
    local cityTable = PlayerService:Instance():GetPlayerCityList();
    local matelist = List.new();
    for k, v in pairs(cityTable) do
        matelist:Push(v)
    end
    for i = 1, PlayerService:Instance():GetFortCount() do
        matelist:Push(PlayerService:Instance():GetFort(i));
    end

    if matelist ~= 0 then
        for k, v in pairs(self._allMate) do
            if (v.gameObject.activeSelf == true) then
                v.gameObject:SetActive(false);
            end
        end
    end
    local size = matelist:Count();
    local getfromunvisable = true;
    for index = 1, size do
        local mateinfo = matelist:Get(index)
        local mmateinfo = self._allMate[index];
        if (mmateinfo == nil) then
            getfromunvisable = false;
            mmateinfo = UIMateInfo.new();
            GameResFactory.Instance():GetUIPrefab(self._perfabPath, self._parentObj, mmateinfo, function(go)
                mmateinfo:Init();
                mmateinfo:SetMateInfo(mateinfo, false);
                if self._allMate[index] == nil then
                    self._allMate[index] = mmateinfo;
                end
                MateInfoList:Push(mmateinfo, false);
            end );
        else
            self._allMate[index].gameObject:SetActive(true);
            mmateinfo:SetMateInfo(mateinfo);
        end
    end



end
function UIPmap:OnClickCloseBtn()

    local pos = self.LeagueMate.localPosition;
    local pos1 = pos - Vector3.right * 300
    local ltDescr = self.LeagueMate.transform:DOLocalMove(pos1, MapMoveTime)
    self.transform:DOLocalMoveX(0, MapMoveTime)

    ltDescr:OnComplete(self, function()
        self.LeagueMate.gameObject:SetActive(false)
        self.LeagueMateBtn.gameObject:SetActive(true)
        if PlayerService:Instance():GetLeagueId() == 0 then
            self.LeagueMarkBtn.gameObject:SetActive(false)
        else
            self.LeagueMarkBtn.gameObject:SetActive(true)
        end
        self.LeagueMate.localPosition = pos
    end )
end

function UIPmap:OnClickCloseBtn1()

    local pos = self.LeagueMark.localPosition;
    local pos1 = pos - Vector3.right * 300
    local ltDescr = self.LeagueMark.transform:DOLocalMove(pos1, MapMoveTime)
    self.transform:DOLocalMoveX(0, MapMoveTime)

    ltDescr:OnComplete(self, function()
        self.LeagueMark.gameObject:SetActive(false)
        self.LeagueMateBtn.gameObject:SetActive(true)
        if PlayerService:Instance():GetLeagueId() == 0 then
            self.LeagueMarkBtn.gameObject:SetActive(false)
        else
            self.LeagueMarkBtn.gameObject:SetActive(true)
        end
        self.LeagueMark.localPosition = pos

    end )
end

function UIPmap:_OnInit()
    self._PmapOperaterManage:RegisterAllOperator();
    self._PmapOperaterManage:RegisterCallBack(OperatorType.Move, function(...) self:OnMouseMove(...) end);
    self._PmapOperaterManage:RegisterCallBack(OperatorType.Click, function(...) self:OnMouseClick(...) end);
    self._PmapOperaterManage:RegisterCallBack(OperatorType.CancleClick, function(...) self:CancleMouseClick(...) end);
    self._PmapOperaterManage:RegisterCallBack(OperatorType.EndMove, function(...) self:EndMove(...) end);
end


function UIPmap:_RegisterAllEvent()
    self.lua_behaviour:AddOnDrag(self.Map.gameObject, function(...)
        return self._OnMouseDrag(self, ...)
    end );
    self.lua_behaviour:AddOnDown(self.Map.gameObject, function(...)
        return self._OnMouseDown(self, ...)
    end );
    self.lua_behaviour:AddOnUp(self.Map.gameObject, function(...)
        return self._OnMouseUp(self, ...)
    end );
end

function UIPmap:OnMouseMove(eventData)
    self:StopChangeScreenCenter();
    local position = eventData.position;
    local MapPosition = self._tiledMap.transform.localPosition;
    local clickPosition = self:_ScreenPointToUGUIPosition(position);
    local nextPosition = MapPosition + clickPosition - self._lastPosition;
    local x, y = self:UI2MapPos(nextPosition.x, nextPosition.y)
    if x < 1 or y < 1 or x > 1598 or y > 1598 then
        return
    end
    local stateid = self:GetStateId(x, y)
    if self.firstMap then
        if stateid == nil then
            return;
        end
    else
        if stateid ~= self.StateType then
            return;
        end
    end
    self:ScanPosition(self._tiledMap.transform.localPosition + clickPosition - self._lastPosition);
    self._lastPosition = self:_ScreenPointToUGUIPosition(position)
    self.Xtext.text = x
    self.Ytext.text = y
    if self.centerCityNametext.text ~= "" then
        self.centerCityNametext.text = "";
        self.centerCityNametext1.text = "";
    end
end

function UIPmap:ScanPosition(position)

    local lastPosition = self._tiledMap.transform.localPosition;
    self._lastcenterX, self._lastcenterY = self._tiledManage:UIToTiledPosition(- lastPosition.x, - lastPosition.y);
    self._tiledMap.transform.localPosition = position;

end

function UIPmap:OnMouseClick(eventData)
    local position = self:_ScreenPointToUGUIPosition(eventData.position);
    local x, y = self:UI2MapPos(- position.x, - position.y);
    local stateID = self:GetStateId(x, y);
    if self.firstMap == false then
        self:MoveInSecondMap(stateID, - position)
        return;
    end
    if stateID == nil or stateID == 14 then
        return;
    end
    self.Xtext.text = x
    self.Ytext.text = y
    self.MapBackBtn.gameObject:SetActive(true)
    self.secondText.gameObject:SetActive(true)
    self.firstText.gameObject:SetActive(false)
    self.firstMap = false;
    PmapService:Instance():SetIsFirstMap(self.firstMap)
    self.ShowArmyCity.gameObject:SetActive(true)
    self.StateType = stateID;
    local allCityInList = self:GetAllCityInState(stateID);

    self.SecondList = allCityInList
    self:AddCityOnSecondMap(allCityInList)
    self:AddSelfCityOnMap()
    self:AddLeagueMemberOnMap()
    self:AddLeagueMarkOnCity()
    self:SetPmapCityScroll(stateID)
    self:SecondPmap(stateID, - position)
    self._tiledMapSelfContainer.gameObject:SetActive(true)
    self._tiledMapContainer.gameObject:SetActive(true)
    self.LeagueMarkContainer.gameObject:SetActive(true)
    self.LeagueMemberContainer.gameObject:SetActive(true)
end


function UIPmap:GetStateType()
    return self.StateType
end



-- 在二级地图中移动
function UIPmap:MoveInSecondMap(stateID, position)
    if stateID == self.StateType then
        self._tiledMap.transform:DOLocalMove(Vector3.New(position.x, position.y, 0), 0.03)
    end
end

function UIPmap:OnClickMapBackBtn()
    self.pmapParentObj.localPosition = Vector3.zero
    self.centerCityNametext.text = "";
    self.centerCityNametext1.text = "";
    self.firstMap = true;
    self.pmapscroll.gameObject:SetActive(false)
    PmapService:Instance():SetIsFirstMap(self.firstMap)
    self.MapBackBtn.gameObject:SetActive(false)
    self.secondText.gameObject:SetActive(false)
    self.firstText.gameObject:SetActive(true)
    self.ShowArmyCity.gameObject:SetActive(false)
    for i = 1, self._tiledMap.childCount do
        self._tiledMap:GetChild(i - 1).gameObject:SetActive(true)
    end
    self.StateType = nil;
    self._secondMapContent.transform:DOScale(Vector3.New(.7, .7, 1), MapMoveTime)
    self:SetPmapCityScroll(stateID)
    self:AddSelfCityOnMap()
    self:AddLeagueMemberOnMap()
    self:AddLeagueMarkOnCity()
    self:AddCityOnSecondMap(self.PointPicList)
end



function UIPmap:SecondPmap(stateId, position)
    if self._secondMapContent.localScale.x > 1 then
        return;
    end
    for i = 1, self._tiledMap.transform.childCount do
        if i == stateId then
            self._tiledMap.transform:GetChild(i - 1).gameObject:SetActive(true)
        else
            self._tiledMap.transform:GetChild(i - 1).gameObject:SetActive(false)
        end
    end
    self._tiledMap.transform:GetChild(self._tiledMap.transform.childCount - 1).gameObject:SetActive(true)
    self._tiledMap.transform.localPosition = Vector3.New(position.x, position.y, 0)
    self._secondMapContent.transform:DOScale(Vector3.New(2, 2, 1), MapMoveTime)

end

function UIPmap:CancleMouseClick()

end


function UIPmap:EndMove()
    local position = self._tiledMap.transform.localPosition;
    local x, y = self:UI2MapPos(position.x, position.y)

    self.Xtext.text = x
    self.Ytext.text = y
    self.requestMapInfoTimer = Timer.New( function()
    end , 1, 1, false)
    self.requestMapInfoTimer:Start();
end


function UIPmap:_OnMouseDown(obj, eventData)

    self._lastPosition = self:_ScreenPointToUGUIPosition(eventData.position);
    self._PmapOperaterManage:EnterOperator(OperatorType.Begin);
end

function UIPmap:_OnMouseUp(obj, eventData)

    self._PmapOperaterManage:EnterOperator(OperatorType.ExtensionClick, eventData);
    self._PmapOperaterManage:EnterOperator(OperatorType.ClickBuilding, eventData);
    self._PmapOperaterManage:EnterOperator(OperatorType.Click, eventData);
    self._PmapOperaterManage:EnterOperator(OperatorType.EndMove);
    self._PmapOperaterManage:EnterOperator(OperatorType.CancleClick);
    self._PmapOperaterManage:EnterOperator(OperatorType.Empty);
end


function UIPmap:_OnMouseDrag(obj, eventData)

    self._PmapOperaterManage:EnterOperator(OperatorType.Move, eventData);
end


function UIPmap:_ScreenPointToUGUIPosition(position)
    self._canvas = Canvas:GetComponent(typeof(UnityEngine.Canvas));
    local isInRect, convertPosition = UnityEngine.RectTransformUtility.ScreenPointToLocalPointInRectangle(self._tiledMap.transform, position, self._canvas.worldCamera);
    return Vector3.New(convertPosition.x, convertPosition.y, 0);
end

function UIPmap:StopChangeScreenCenter()
    if self.requestMapInfoTimer == nil then
        return;
    end
    self.requestMapInfoTimer:Stop();
    self.requestMapInfoTimer = nil;
end

function UIPmap:UI2MapPos(x, y)
    local UIPosX = - x;
    local UIPosY = - y - self._tiledMap.rect.height / 2;

    local WorldX = UIPosX * MapLoad:GetWidth() * MapLoad:GetTiledWidth() / self._tiledMap.rect.width;
    local WorldY = UIPosY * MapLoad:GetHeight() * MapLoad:GetTiledHeight() / self._tiledMap.rect.height;
    local Tx, Ty = self:UIToTiledPosition(WorldX, WorldY)
    return Tx, Ty
end

function UIPmap:UIToTiledPosition(positionX, positionY)
    local x = self:_GetIntPart(- positionX / MapLoad:GetTiledWidth() - positionY / MapLoad:GetTiledHeight() -0.5);
    local y = self:_GetIntPart(positionX / MapLoad:GetTiledWidth() - positionY / MapLoad:GetTiledHeight() -0.5);
    return x, y;
end

function UIPmap:MapPos2UI(x, y)

    local UIPosX = self._tiledMap.rect.width / 2 - self._tiledMap.rect.width * MapLoad:GetWidth() / x
    local UIPosY = self._tiledMap.rect.height / 2 - self._tiledMap.rect.width * MapLoad:GetHeight() / y
    return Vector3.New(UIPosX, UIPosY, 0)

end

-- 点击同盟标记我方实力跳转位置
function UIPmap:MoveToClickMateAndMark(x, y)
    local tiledId = MapService:Instance():GetTiledIndex(x, y);
    local stateID = PmapService:Instance():GetStateIDbyIndex(tiledId);
    if self.StateType == stateID then
        self:MoveToClickCity(x, y)
    else
        self:OnClickMapBackBtn();
        self:MoveToClickCity(x, y);
    end
end

-- 移动到点击的城市
function UIPmap:MoveToClickCity(x, y)
    local pos = self:GetUGUIPos(x, y);
    self._tiledMap.transform:DOLocalMove(pos, MapMoveTime)
    local DotltDescr = LeanTween.delayedCall(self.MapPointDot.gameObject, MapMoveTime, System.Action( function() self:PlayPic() end))
end

function UIPmap:PlayPic()
    self.MapPointDot.gameObject:SetActive(true)
    -- 播放动画
    local ltDescr = self.MapPointDot.transform:DOScale(Vector3.zero, ShowTime)
    ltDescr:SetLoops(self, 1)
    ltDescr:OnComplete(self, function()
        self.MapPointDot.gameObject:SetActive(false)
        self.MapPointDot.transform.localScale = Vector3.one
    end )
end


-- 小地图UGUI坐标
function UIPmap:GetUGUIPos(x, y)
    local UIPosX, UIPosY;
    UIPosX =(x - y) * self._tiledMap.rect.width / MapLoad:GetWidth() / 2
    UIPosY = -(y + x + 1) * self._tiledMap.rect.height / MapLoad:GetHeight() / 2 + self._tiledMap.rect.height / 2
    return Vector3.New(UIPosX, - UIPosY, 0)
end


function UIPmap:GetTiledPosition(x, y)

    local UIPosX, UIPosY;
    UIPosX =(y - x) * self._tiledMap.rect.width / MapLoad:GetWidth() / 2
    UIPosY = -(y + 1 + x) * self._tiledMap.rect.height / MapLoad:GetHeight() / 2 + self._tiledMap.rect.height / 2
    return Vector3.New(UIPosX, UIPosY, 0)
end

function UIPmap:GetWidth()
    return MapLoad:GetWidth();
end

-- 高
function UIPmap:GetHeight()
    return MapLoad:GetHeight();
end

-- 宽
function UIPmap:GetTiledWidth()
    return MapLoad:GetTiledWidth();
end

-- 高
function UIPmap:GetTiledHeight()
    return MapLoad:GetTiledHeight();
end


function UIPmap:_GetIntPart(value)
    if value < 0 then
        value = math.ceil(value);
    end
    if math.ceil(value) ~= value then
        value = math.ceil(value) -1;
    end

    return value;
end

function UIPmap:GetTileCount()
    return MapLoad:GetTileCount();
end

function UIPmap:GetStateId(x, y)
    if x < 0 or y < 0 or x >= MapLoad:GetWidth() or y >= MapLoad:GetHeight() then
        return nil;
    end
    local tiledIndex = x * MapLoad:GetWidth() + y;
    local stateId = PmapService:Instance():GetStateIDbyIndex(tiledIndex)
    return stateId
end




-- 地图上添加城市
function UIPmap:AddCityOnMap()
    self.PointPicList:Clear();
    local allNPcity = PmapService:Instance():GetNPCBuildingList()
    for index = 1, allNPcity:Count() do
        if table.getn(allNPcity:Get(index).DisplayPosition) == 3 then
            self.PointPicList:Push(allNPcity:Get(index))
        end
    end
    self:AddCityOnSecondMap(self.PointPicList)
    self:AddSelfCityOnMap();
end


function UIPmap:AddCityOnSecondMap(secondList)
    local PointListSize = secondList:Count()
    for k, v in pairs(self._allPic) do
        v.gameObject:SetActive(false)
    end
    for index = 1, PointListSize do
        local mPic = self._allPic[index]
        if mPic == nil then
            mPic = UIPic.new()
            GameResFactory.Instance():GetUIPrefab(self._PicperfabPath, self._tiledMapContainer, mPic, function(go)
                mPic:Init();
                mPic:SetPicMessage(secondList:Get(index), self._tiledMapContainer)
                self._allPic[index] = mPic;
            end )
        else
            mPic.gameObject:SetActive(true)
            mPic:SetPicMessage(secondList:Get(index), self._tiledMapContainer)
        end
    end
end


function UIPmap:AddSelfCityOnMap()
    local tiledList = List.new();
    local tiledlistCount = PlayerService:Instance():GetTiledIdListCount()
    for i = 1, tiledlistCount do
        tiledList:Push(PlayerService:Instance():GetTiledIdByIndex(i));
    end
    local PointListSize = tiledList:Count()
    for k, v in pairs(self._allSelfPic) do
        v.gameObject:SetActive(false)
    end
    for index = 1, PointListSize do
        local mPic = self._allSelfPic[index]
        if mPic == nil then
            mPic = UIPic.new()
            if self:CheakInCurState(tiledList:Get(index)) then
            else
                return
            end
            GameResFactory.Instance():GetUIPrefab(self._PicperfabPath, self._tiledMapSelfContainer, mPic, function(go)
                mPic:Init();
                mPic:SetSelfPicMessage(tiledList:Get(index), self._tiledMapSelfContainer)
                self._allSelfPic[index] = mPic;
            end )
        else
            if self:CheakInCurState(tiledList:Get(index)) then
            else
                return
            end
            mPic.gameObject:SetActive(true)
            mPic:SetSelfPicMessage(tiledList:Get(index), self._tiledMapSelfContainer)
        end
    end
end

-- 检查是否在当前州
function UIPmap:CheakInCurState(index)
    local stateID = PmapService:Instance():GetStateIDbyIndex(index)
    if stateID ~= self.StateType and self.firstMap == false then
        return false
    end
    return true
end


function UIPmap:AddLeagueMemberOnMap()
    local list = LeagueService:Instance():GetLeagueMemberList()
    local PointListSize = list:Count()
    for k, v in pairs(self._allMember) do
        v.gameObject:SetActive(false)
    end
    for index = 1, PointListSize do
        local mPic = self._allMember[index]
        if mPic == nil then
            if self:CheakInCurState(list:Get(index).coord) then
            else
                return
            end
            mPic = UIPic.new()
            GameResFactory.Instance():GetUIPrefab(self._PicperfabPath, self.LeagueMemberContainer, mPic, function(go)
                mPic:Init();
                mPic:SetMemberPicMessage(list:Get(index), self.LeagueMemberContainer)
                self._allMember[index] = mPic;
            end )
        else
            if self:CheakInCurState(list:Get(index).coord) then
            else
                return
            end
            mPic.gameObject:SetActive(true)
            mPic:SetMemberPicMessage(list:Get(index), self.LeagueMemberContainer)
        end
    end
end


function UIPmap:AddLeagueMarkOnCity()

    local marklist = LeagueService:Instance():GetLeagueMarkList();
    local PointListSize = marklist:Count()
    for k, v in pairs(self._allMapMark) do
        v.gameObject:SetActive(false)
    end
    for index = 1, PointListSize do
        local mPic = self._allMapMark[index]
        if mPic == nil then
            if self:CheakInCurState(marklist:Get(index).coord) then
            else
                return
            end
            mPic = UIPic.new()
            GameResFactory.Instance():GetUIPrefab(self._PicperfabPath, self.LeagueMarkContainer, mPic, function(go)
                mPic:Init();
                mPic:SetMarkPicMessage(marklist:Get(index), self.LeagueMarkContainer)
                self._allMapMark[index] = mPic;
            end )
        else
            if self:CheakInCurState(marklist:Get(index).coord) then
            else
                return
            end
            mPic.gameObject:SetActive(true)
            mPic:SetMarkPicMessage(marklist:Get(index), self.LeagueMarkContainer)
        end
    end
end


function UIPmap:SetPmapCityScroll(stateid)

    if self.firstMap then
        self.pmapscroll.gameObject:SetActive(false)
        return
    else
        self.pmapscroll.gameObject:SetActive(true)
    end

    local centerCity = self:GetFirstCityInState(stateid)
    local allCityInList = self:GetAllCityInState(stateid);
    if centerCity.CityType == 6 then
        self.centerState.text = "国都"
    else
        self.centerState.text = "州府"
    end
    self.centerCity.text = centerCity.Name .. " LV." .. centerCity.level

    for k, v in pairs(self._allCity) do
        if (v.gameObject.activeSelf == true) then
            v.gameObject:SetActive(false);
        end
    end

    local Size = allCityInList:Count()
    local GetFormUnVisable = true;
    for index = 1, allCityInList:Count() do
        if allCityInList:Get(index) then
            local mPmapPrefab = self._allCity[index]
            if mPmapPrefab == nil then
                GetFormUnVisable = false
                mPmapPrefab = PmapPrefab.new()
                GameResFactory.Instance():GetUIPrefab(self.pmapPrefab, self.pmapParentObj, mPmapPrefab, function(go)
                    mPmapPrefab:Init();
                    mPmapPrefab:SetPmapPrefabMessage(allCityInList:Get(index))
                    if self._allCity[index] == nil then
                        self._allCity[index] = mPmapPrefab;
                    end
                    if index == Size then
                        self.passPic:SetSiblingIndex(self.count)
                    end
                end )
            else
                if index == Size then
                    self.passPic:SetSiblingIndex(self.count)
                end
                self._allCity[index].gameObject:SetActive(true)
                mPmapPrefab:SetPmapPrefabMessage(allCityInList:Get(index))
            end
        end
    end

end



function UIPmap:GetFirstCityInState(id)

    for k, v in pairs(DataBuilding) do
        if v.StateCN[1] == id and(v.CityType == CityBaseType.chiefcity or v.CityType == CityBaseType.country) then
            return v;
        end
    end
end


function UIPmap:GetAllCityInState(id)

    local j1 = List.new();
    local j2 = List.new();
    local j3 = List.new();
    local j4 = List.new();
    local j5 = List.new();
    local j6 = List.new();
    local j7 = List.new();
    local j8 = List.new();

    local jcity1 = nil;
    local jcity2 = nil;
    local jcity3 = nil;
    local jcity4 = nil;
    local jcity5 = nil;
    local jcity6 = nil;
    local jcity7 = nil;
    local jcity8 = nil;

    local StateCityList = List.new();
    for k, v in pairs(DataBuilding) do
        if v.StateCN[1] == id then
            StateCityList:Push(v)
        end
    end

    local StateCityList = List.new();
    local StateFinalList = List.new();
    for k, v in pairs(DataBuilding) do
        if v.StateCN[1] == id then
            StateCityList:Push(v)
        end
    end
    for i = 1, StateCityList:Count() do
        if StateCityList:Get(i).CityType == CityBaseType.chiefcity or StateCityList:Get(i).CityType == CityBaseType.country then
            StateFinalList:Push(StateCityList:Get(i))
        end
    end
    for i = 1, StateCityList:Count() do
        if StateCityList:Get(i).RegionCN == StateFinalList:Get(1).RegionCN and StateCityList:Get(i) ~= StateFinalList:Get(1) then
            StateFinalList:Push(StateCityList:Get(i))
        end
    end

    for i = 1, StateCityList:Count() do

        if StateCityList:Get(i).RegionCN == 1 then
            if StateCityList:Get(i).RegionCN == StateFinalList:Get(1).RegionCN then
            else
                if StateCityList:Get(i).CityType == CityBaseType.firstcity or StateCityList:Get(i).CityType == CityBaseType.chiefcity or StateCityList:Get(i).CityType == CityBaseType.country then
                    jcity1 = StateCityList:Get(i)
                else
                    j1:Push(StateCityList:Get(i))
                end
            end

        elseif StateCityList:Get(i).RegionCN == 2 then
            if StateCityList:Get(i).RegionCN == StateFinalList:Get(1).RegionCN then
            else
                if StateCityList:Get(i).CityType == CityBaseType.firstcity or StateCityList:Get(i).CityType == CityBaseType.chiefcity or StateCityList:Get(i).CityType == CityBaseType.country then
                    jcity2 = StateCityList:Get(i)
                else
                    j2:Push(StateCityList:Get(i))
                end
            end

        elseif StateCityList:Get(i).RegionCN == 3 then
            if StateCityList:Get(i).RegionCN == StateFinalList:Get(1).RegionCN then
            else
                if StateCityList:Get(i).CityType == CityBaseType.firstcity or StateCityList:Get(i).CityType == CityBaseType.chiefcity or StateCityList:Get(i).CityType == CityBaseType.country then
                    jcity3 = StateCityList:Get(i)
                else
                    j3:Push(StateCityList:Get(i))
                end
            end

        elseif StateCityList:Get(i).RegionCN == 4 then
            if StateCityList:Get(i).RegionCN == StateFinalList:Get(1).RegionCN then
            else
                if StateCityList:Get(i).CityType == CityBaseType.firstcity or StateCityList:Get(i).CityType == CityBaseType.chiefcity or StateCityList:Get(i).CityType == CityBaseType.country then
                    jcity4 = StateCityList:Get(i)
                else
                    j4:Push(StateCityList:Get(i))
                end
            end

        elseif StateCityList:Get(i).RegionCN == 5 then
            if StateCityList:Get(i).RegionCN == StateFinalList:Get(1).RegionCN then
            else
                if StateCityList:Get(i).CityType == CityBaseType.firstcity or StateCityList:Get(i).CityType == CityBaseType.chiefcity or StateCityList:Get(i).CityType == CityBaseType.country then
                    jcity5 = StateCityList:Get(i)
                else
                    j5:Push(StateCityList:Get(i))
                end
            end

        elseif StateCityList:Get(i).RegionCN == 6 then
            if StateCityList:Get(i).RegionCN == StateFinalList:Get(1).RegionCN then
            else
                if StateCityList:Get(i).CityType == CityBaseType.firstcity or StateCityList:Get(i).CityType == CityBaseType.chiefcity or StateCityList:Get(i).CityType == CityBaseType.country then
                    jcity6 = StateCityList:Get(i)
                else
                    j6:Push(StateCityList:Get(i))
                end
            end

        elseif StateCityList:Get(i).RegionCN == 7 then
            if StateCityList:Get(i).RegionCN == StateFinalList:Get(1).RegionCN then
            else
                if StateCityList:Get(i).CityType == CityBaseType.firstcity or StateCityList:Get(i).CityType == CityBaseType.chiefcity or StateCityList:Get(i).CityType == CityBaseType.country then
                    jcity7 = StateCityList:Get(i)
                else
                    j7:Push(StateCityList:Get(i))
                end
            end

        elseif StateCityList:Get(i).RegionCN == 8 then
            if StateCityList:Get(i).RegionCN == StateFinalList:Get(1).RegionCN then
            else
                if StateCityList:Get(i).CityType == CityBaseType.firstcity or StateCityList:Get(i).CityType == CityBaseType.chiefcity or StateCityList:Get(i).CityType == CityBaseType.country then
                    jcity8 = StateCityList:Get(i)
                else
                    j8:Push(StateCityList:Get(i))
                end
            end

        end
    end


    self:Inerst2List(StateFinalList, jcity1, j1)
    self:Inerst2List(StateFinalList, jcity2, j2)
    self:Inerst2List(StateFinalList, jcity3, j3)
    self:Inerst2List(StateFinalList, jcity4, j4)
    self:Inerst2List(StateFinalList, jcity5, j5)
    self:Inerst2List(StateFinalList, jcity6, j6)
    self:Inerst2List(StateFinalList, jcity7, j7)
    self:Inerst2List(StateFinalList, jcity8, j8)

    self.count = StateFinalList:Count()

    for k, v in pairs(self:GetAllPassInState(id)._list) do
        StateFinalList:Push(v)
    end

    return StateFinalList
end


function UIPmap:GetAllPassInState(StateId)
    local PassList = List.new();
    for k, v in pairs(DataBuilding) do
        if v.Type == 9 then
            if v.StateCN[1] == StateId or v.StateCN[2] == StateId then
                PassList:Push(v)
            end
        end
    end
    return PassList;
end


function UIPmap:Inerst2List(finalList, obj, _list)

    if obj ~= nil then
        finalList:Push(obj)
    end
    for i = 1, _list:Count() do
        if _list:Get(i) ~= nil then
            finalList:Push(_list:Get(i))
        end
    end

end

-- 隐藏所有的bgImage选中效果
function UIPmap:SetPmapCityScrollFalse()
    for k, v in pairs(self._allCity) do
        v:SetBgPicFalse()
    end
end

function UIPmap:SetMateInfoFalse()

    for k, v in pairs(self._allMate) do
        v:SetBgPicFalse()
    end

end

function UIPmap:SetMarkInfoFalse()

    for k, v in pairs(self._allMark) do
        v:SetBgPicFalse()
    end

end

return UIPmap




-- endregion
