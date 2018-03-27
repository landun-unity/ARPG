local GamePart = require("FrameWork/Game/GamePart")

local TiledManage = require("Game/Map/TiledManage")
local MapManage = class("MapManage", GamePart)

local UIWildernes = require("Game/MapMenu/UIWildernes");
local EaseType = require("Game/Common/EaseType")
local PhysicTileType = require("Game/Map/PhysicTileType");
local EffectsType = require("Game/Effects/EffectsType");
local tween = require("common/tween")
local GridType = require("Game/MapMenu/GridType");
local TouchType = require("Game/Map/TouchType")
local Extension = require("Game/MapMenu/Extension");
local EventType = require("Game/Util/EventType");
local EventService = require("Game/Util/EventService");
local landParent = nil;
local changeViewRotation = UnityEngine.Vector3(15, 0, 0)
local BiggerView = 315
local BiggerViewer = 70
local SmallerView = 0
local MapScaleTime = 0.3;
local MapMoveTime = 0.3;
local MapScanTime = 1;
local state = false;
local inputState = 0;

local UpdateTimes = 4;

local CubeDistancex = 300;
local CubeDistancey = 200;

-- 设置地图块宽高
local CubeEdgeWidth = 2000;
local CubeEdgeHight = 1300;
-- 拖动敏感度
local MoveSensitiveX = 1;
local MoveSensitiveY = 1;
local TileMoveOpen = false;
local OpenJump = false;
-- 限速阀值
local limitSpeedX = 160;
local limitSpeedY = 80;
-- 限速阀门
local SPOposition = { };
--
local ProtectShowX = 0;
local ProtectShowY = 0;

local MoveMouseLock = false;
local MiniMapShortJump = false;

-- 移动

local UIposition = 0;
local XDistance = 0;
local YDistance = 0;
local LXDistance = 0;
local LYDistance = 0;
function MapManage:ctor()
    self._tiledManage = require("Game/Map/TiledManage").new();
    self._mapObject = nil;
    self._lightImage = nil;
    self._tiledMap = nil;
    self._eventObject = nil;
    self._lastPosition = Vector3.New(0, 0, 0);
    self.landCamera = UnityEngine.GameObject.Find("LandCamera");
    self._canvas = nil;
    self.minMapObj = nil;
    self._backTransform = nil;
    self._edgeLength = 13;
    self._lastcenterX = 0;
    self._lastcenterY = 0;
    self._curcenterX = 0;
    self._curcenterY = 0;
    self._SourceEventParent = nil;

    self._operatorManage = require("Game/Map/Operator/OperatorManage").new();
    self.requestMapInfoTimer = nil;
    self._lastFollowCenterX = 0;
    self._lastFollowCenterY = 0;
    self._canFollow = false;
    self._needTiledCount = 1;
    self.canvas = nil;

    self._refresh = false;

    self.CallBackObj = nil;
    self.ClickCityCallBack = nil;
    self.OutCityCallBack = nil;
    self.showQueue = require("common/Queue").new();
    -- 分帧队列
    self.TMQueue = require("common/Queue").new();

    self.op1 = Vector2.zero;
    self.op2 = Vector2.zero;
    self.sp1 = Vector2.zero;
    self.sp2 = Vector2.zero;
    self._mapCount = 0;
    self.isChanging = false;
    self.lightImageDis = Vector3.New(0, 0, 0);
    --
    self.FZqueuetm = { };
    self.FZUIposition = { };
    -- 格子信息分帧同步
--    self.syncTiledInfoQueue = Queue.new();
--    -- 每帧同步最大的格子信息数量
--    self.maxSyncTiledInfoCount = 10;

    -- 放大地图后的回调（暂时任务跳转用到）
    self.changeBiggerCallBack = nil;

    self._landBasePos = Vector3.zero;
    self._landPicWidth = 0;
    self._landPicHeight = 0;
    self._landPicMap = { };
    self._leftLandIndex = 0;
    self._RightLandIndex = 0;
    self._TopLandIndex = 0;
    self._BottomLandIndex = 0;
end

function MapManage:_OnInit()
    self._operatorManage:RegisterAllOperator();
    self._operatorManage:RegisterCallBack(OperatorType.Move, function(...) self:OnMouseMove(...) end);
    self._operatorManage:RegisterCallBack(OperatorType.Click, function(...) self:OnMouseClick(...) end);
    self._operatorManage:RegisterCallBack(OperatorType.CancleClick, function(...) self:CancleMouseClick(...) end);
    self._operatorManage:RegisterCallBack(OperatorType.ExtensionClick, function(...) self:ExtensionClick(...) end);
    self._operatorManage:RegisterCallBack(OperatorType.ClickBuilding, function(...) self:ClickBuilding(...) end);
    self._operatorManage:RegisterCallBack(OperatorType.EndMove, function(...) self:EndMove(...) end);
end

function MapManage:_OnHeartBeat()
    -- 格子信息同步分帧处理
--    if self.syncTiledInfoQueue:Count() > 0 then
--        local syncCount = math.min(self.syncTiledInfoQueue:Count(), self.maxSyncTiledInfoCount);
--        for i = 1, syncCount do
--            local tiledInfo = self.syncTiledInfoQueue:Pop();
--            if tiledInfo ~= nil then
--                self:SyncTiledInfo(tiledInfo);
--            end
--        end
--        if self.syncTiledInfoQueue:Count() <= 0 then
--            self:RefreshRelatedUIMsg();
--        end
--    end

    if self._backTransform ~= nil and self._lightImage ~= nil then
        if self._backTransform.position - self._lightImage.position ~= self.lightImageDis then
            self._lightImage.position = self._backTransform.position - self.lightImageDis;
        end
    end
    if landParent == nil then
    else
        if inputState == TouchType.NoFinger then
            GameResFactory.Instance():OnTwoTouch( function(position)
                inputState = TouchType.OneFinger;
                if self.landCamera == nil then
                    self.landCamera = UnityEngine.GameObject.Find("LandCamera");
                end
                if self.landCamera ~= nil then
                    if self.canvas == nil then
                        self.canvas = UGameObject.Find("Canvas");
                    end
                    EffectsService:Instance():AddEffect(self.canvas, EffectsType.PointEffect, 1, nil, self:_ScreenPoint(position));
                end
            end );
        end
        if inputState == TouchType.TwoFinger or inputState == TouchType.OneFinger then
            -- self:ONMouseDown();
            GameResFactory.Instance():CheckTouchNum( function() inputState = TouchType.NoFinger end);
        end
        if inputState == TouchType.NoFinger or inputState == TouchType.OneFinger then
            GameResFactory.Instance():OnOneTouch( function() inputState = TouchType.TwoFinger end);
        end
        if inputState == TouchType.TwoFinger and self.isChanging == false and landParent.transform.localPosition.z > 200 then
            GameResFactory.Instance():OnTouch(
            function()
                self.isChanging = true
                self:ChangeMapScaleBig(
                function()
                    self.isChanging = false
                end )
            end
            );
        end
        if inputState == TouchType.TwoFinger and self.isChanging == false and landParent.transform.localPosition.z > 200 then
            GameResFactory.Instance():OnTouchSmall(
            function()
                self:ChangeMapScaleSmall(
                function()
                end )
            end );
        end
        if MapService:Instance():GetLayerParent(LayerType.Flag) ~= nil and MapService:Instance():GetLayerParent(LayerType.ArmyWalkSlider) ~= nil then
            if self.landCamera ~= nil then
                if self.landCamera.transform.localPosition.z < 10 and MapService:Instance():GetLayerParent(LayerType.Flag).gameObject.activeSelf == false then
                    MapService:Instance():GetLayerParent(LayerType.Flag).gameObject:SetActive(true)
                    MapService:Instance():GetLayerParent(LayerType.ArmyWalkSlider).gameObject:SetActive(true)
                end
                if self.landCamera.transform.localPosition.z > 10 and MapService:Instance():GetLayerParent(LayerType.Flag).gameObject.activeSelf then
                    MapService:Instance():GetLayerParent(LayerType.Flag).gameObject:SetActive(false)
                    MapService:Instance():GetLayerParent(LayerType.ArmyWalkSlider).gameObject:SetActive(false)
                end
            end
        end
    end
    -- 地图移动分帧
    UnityEngine.Profiler.BeginSample("FZMOVE");
    if TileMoveOpen then
        for i = 1, 20 do
            if self.TMQueue:Count() > 0 then
                self.FZqueuetm = self.TMQueue:Pop(queuetm);
                self.FZUIposition = self:TiledPositionToUIPosition(self.FZqueuetm.x, self.FZqueuetm.y);
                if math.abs(ProtectShowX - self.FZUIposition.x) <= CubeEdgeWidth and math.abs(ProtectShowY - self.FZUIposition.y) <= CubeEdgeHight then
                    self._tiledManage:ShowTiled(self.FZqueuetm.x, self.FZqueuetm.y);
                end
            else
                TileMoveOpen = false;
                break;
            end
        end
    end
    UnityEngine.Profiler.EndSample();
end
function MapManage:ChangeMapScaleBig(callBack)
    if inputState == TouchType.TwoFinger then
        if self.landCamera == nil then
            self.landCamera = UnityEngine.GameObject.Find("LandCamera");
        end
        if (self.landCamera ~= nil) then
            local ltDescr = self.landCamera.transform:DOLocalMoveZ(BiggerViewer, MapScaleTime)
            if callBack ~= nil then
                ltDescr:OnComplete(self, callBack);
            end
        end
    end
end
function MapManage:ChangeMapScaleSmall(callback)
    if inputState == TouchType.TwoFinger then
        if self.landCamera == nil then
            self.landCamera = UnityEngine.GameObject.Find("LandCamera");
        end
        if (self.landCamera ~= nil) then
            local ltDescr = self.landCamera.transform:DOLocalMoveZ(SmallerView, MapScaleTime)
            if callBack ~= nil then
                ltDescr:OnComplete(self, callBack);
            end
        end
    end
end

function MapManage:GetCurrentPos()
    local position = self._tiledMap.localPosition;
    local currentX, currentY = self._tiledManage:UIToTiledPosition(- position.x, - position.y);
    return currentX, currentY
end


function MapManage:ReSetMapScale(pos)

end

function MapManage:_OnStop()
    -- body
end

function MapManage:EnterOperator(operatorType, ...)
    self._operatorManage:EnterOperator(operatorType, ...);
end

function MapManage:_CreateMap()
    local mapObject = UGameObject.Find("MapObject");
    if mapObject ~= nil then
        return;
    end
    self._tiledManage:InitMap();
    self:_CreateMapObject();
end

function MapManage:_CreateMapObject()
    landParent = UGameObject.Find("AllLands");
    self._canvas = landParent.transform.parent.gameObject:GetComponent(typeof(UnityEngine.Canvas));
    GameResFactory.Instance():GetUIPrefab("Map/MapObject", landParent.transform, self, function(mapObject)
        self:_CreateMapObjectSuccess(mapObject)
    end );
    self:SetCallBack();
    self:ChangeRotationView();
end

function MapManage:ChangeRotationView()
    if (landParent ~= nil) then
        landParent.transform.localRotation = Vector3.zero
        local ltDescr = landParent.transform:DORotate(changeViewRotation, 2)
        ltDescr:OnComplete(self, self.ChangeRotationOver)
    end
end

function MapManage:ChangeRotationOver()

end

function MapManage:ClickWildBuilding()
    ClickService:Instance():RealShowTiled();
end

function MapManage:SetCallBack(tiledIndex)
    self:SetClickObj(tiledIndex)
    self:SetClickCityCallBack(self.MoveToCityAndBigger)
    self:SetOutCityCallBack(self.ChangeSmallerView)
end

function MapManage:MoveToCityAndBigger()
    if self.CallBackObj == nil then
        self.CallBackObj = PlayerService:Instance():GetMainCityTiledId()
    end
    self:MoveToTiledId(self.CallBackObj);
end

function MapManage:MoveToTiledId(tiledIndex)
    local scanPos = self._tiledManage:GetTiledPositionByIndex(tiledIndex);

    self:MoveToPositionAndCallBack(Vector3.New(- scanPos.x, - scanPos.y + 120, 0));
end
-- 11
function MapManage:ChangeBiggerView(callBack)
    if self.landCamera == nil then
        self.landCamera = UnityEngine.GameObject.Find("LandCamera");
    end
    if (self.landCamera ~= nil) then
        local ltDescr = self.landCamera.transform:DOLocalMoveZ(BiggerView, 1)
        if callBack ~= nil then
            ltDescr:OnComplete(self, callBack);
        end
        if self.changeBiggerCallBack ~= nil then
            ltDescr:OnComplete(self, function()
                if self.changeBiggerCallBack ~= nil then
                    self.changeBiggerCallBack();
                    self.changeBiggerCallBack = nil;
                end
            end
            );
        end
    end
    -- self:_HandlerTiled();

    state = true;
end

function MapManage:ChangeBiggerOver()
    state = true;
end

function MapManage:ChangeSmallerView()
    if self.landCamera == nil then
        self.landCamera = UnityEngine.GameObject.Find("LandCamera");
    end
    if (self.landCamera ~= nil) then
        local ltDescr = self.landCamera.transform:DOLocalMoveZ(SmallerView, 1)
        ltDescr:OnComplete(self, self.ChangeSmallerOver)
    end
end

function MapManage:ChangeSmallerOver()
    state = false;
end

function MapManage:ChangeSmallerViewNoTween()
    if self.landCamera == nil then
        self.landCamera = UnityEngine.GameObject.Find("LandCamera");
    end
    if (self.landCamera ~= nil) then
        self.landCamera.transform:DOLocalMoveZ(SmallerView, 0)
    end
end

function MapManage:_CreateMapObjectSuccess(mapObject)
    self._mapObject = mapObject;
    self.canvas = UGameObject.Find("Canvas");
    self._lightImage = mapObject.transform:Find("TiledMap/ViewPort/LightImage");
    self._tiledMap = mapObject.transform:Find("TiledMap/ViewPort");
    self._cacheTiledParent = mapObject.transform:Find("CacheTiled");
    self._cacheBuildingParent = mapObject.transform:Find("CacheBuilding");
    self._lastPosition = self._tiledMap.localPosition;
    self._mapObject.transform:SetAsFirstSibling();
    self._backTransform = mapObject.transform:Find("Back");
    self._tiledMapTransform = mapObject.transform:Find("TiledMap");
    for index = 1, 9 do
        self._landPicMap[index] = self._tiledMap:Find("LandNew/Land" .. index);
    end
    self._landPicWidth = self._landPicMap[1].rect.width;
    self._landPicHeight = self._landPicMap[1].rect.height;
    self._eventObject = self._backTransform.gameObject;
    ClickService:Instance():InitUI(self._tiledMap);

    self:_RegisterAllEvent();
    self._tiledManage:InitAllLayer(self._tiledMap, self._cacheTiledParent, self._cacheBuildingParent);

    self._SourceEventParent = self._tiledManage:GetSourceEventParent();

    LoginService:Instance():EnterState(LoginStateType.RequestResourceInfo);
end

function MapManage:_RegisterAllEvent()
    self.lua_behaviour:AddOnDrag(self._eventObject, function(...)
        return self._OnMouseDrag(self, ...)
    end );
    self.lua_behaviour:AddOnDown(self._eventObject, function(...)
        return self._OnMouseDown(self, ...)
    end );
    self.lua_behaviour:AddOnUp(self._eventObject, function(...)
        return self._OnMouseUp(self, ...)
    end );
end


local StartCenterPosx = 0;
local StartCenterPosy = 0;

local CrazyDrugProtectX = 0;
local CrazyDrugProtectY = 0;

local ProtectBool = false;
function MapManage:_OnMouseDown(obj, eventData)
    -- print("ONMouseDown");
    if MoveMouseLock == false then
        local nowPosition = self._tiledMap.localPosition;
        StartCenterPosx, StartCenterPosy = self._tiledManage:UIToTiledPosition(- nowPosition.x, - nowPosition.y);

        CrazyDrugProtectX = StartCenterPosx;
        CrazyDrugProtectY = StartCenterPosy;

        ProtectBool = true;

        self._lastPosition = self:_ScreenPointToUGUIPosition(eventData.position);
        self._operatorManage:EnterOperator(OperatorType.Begin);
        self.minMapObj = UnityEngine.GameObject.Find("MinMap");
        LineService:Instance():CancelArmyChoose();
        UIService:Instance():HideUI(UIType.UIArmyDetailGrid);
        UIService:Instance():HideUI(UIType.UIArmyBattleDetail);

        local baseClass = UIService:Instance():GetUIClass(UIType.UIGameMainView);
        local isOpen = UIService:Instance():GetOpenedUI(UIType.UIGameMainView);
        if baseClass ~= nil and isOpen == true then
            baseClass:CheckFunctionOff();
        end

        local baseClass = UIService:Instance():GetUIClass(UIType.UIGameMainView);
        local isopen = UIService:Instance():GetOpenedUI(UIType.UIGameMainView);
        if baseClass ~= nil and isopen == true then
            baseClass:HidePanel();
        end
    end
end

function MapManage:_OnMouseUp(obj, eventData)
    --    print("OnmouseUp");
    if MoveMouseLock == false then

        self:_HandlerTiledMove(StartCenterPosx, StartCenterPosy);
        self._operatorManage:EnterOperator(OperatorType.ExtensionClick, eventData);
        self._operatorManage:EnterOperator(OperatorType.ClickBuilding, eventData);
        self._operatorManage:EnterOperator(OperatorType.Click, eventData);
        self._operatorManage:EnterOperator(OperatorType.EndMove);
        self._operatorManage:EnterOperator(OperatorType.CancleClick);
        self._operatorManage:EnterOperator(OperatorType.Empty);
    end
end

function MapManage:_OnMouseDrag(obj, eventData)
    if MoveMouseLock == false then

        -- print("OnMOuseDrag");
        GameResFactory.Instance():CheckMapDrag( function()
            self._tiledManage:HideMapUI();
            self._operatorManage:EnterOperator(OperatorType.Move, eventData);
        end );
    end

end
function MapManage:OnMouseMove(eventData)

    if MoveMouseLock == false then
        -- print("进入拖拽方法里面");
        local position = self._tiledMap.localPosition;
        local x, y = self._tiledManage:UIToTiledPosition(- position.x, - position.y);
        local movedistancex = x - StartCenterPosx;
        local movedistancey = y - StartCenterPosy;
        if math.abs(movedistancex) >= MoveSensitiveX or math.abs(movedistancey) >= MoveSensitiveY then
            StartCenterPosx, StartCenterPosy = self:_HandlerTiledMove(StartCenterPosx, StartCenterPosy);
        end

        self:StopChangeScreenCenter();
        local position = UnityEngine.Input.mousePosition;
        if position.x < 0 or position.y < 0 or position.x > UnityEngine.Screen.width or position.y > UnityEngine.Screen.height then
            return;
        end

        local clickPosition = self:_ScreenPointToUGUIPosition(position);

        self:ScanPosition(self._tiledMap.localPosition + clickPosition - self._lastPosition);

        self._lastPosition = self:_ScreenPointToUGUIPosition(position);
    end
end

function MapManage:_ScreenPoint(position)
    local mposition = self.landCamera:GetComponent(typeof(UnityEngine.Camera)):ScreenToViewportPoint(position);
    mposition.x = mposition.x * 1280 - 1280 / 2;
    mposition.y = mposition.y * 720 - 720 / 2;
    mposition.z = 0;
    return mposition;
end

function MapManage:OnMouseClick(eventData)
    if MoveMouseLock == false then
        -- print("OnMouseClick");
        local position = self:_ScreenPointToUGUIPosition(eventData.position);
        local x, y = self._tiledManage:UIToTiledPosition(position.x, position.y);
        local tiledIndex = self._tiledManage:GetTiledIndex(x, y);
        local tiled = self._tiledManage:GetTiledByIndex(tiledIndex);
        ClickService:Instance():ShowTiled(tiled, self._tiledManage:GetTiledPositionByIndex(tiledIndex));
        UIService:Instance():HideUI(UIType.UIBuild);
        local isopen = UIService:Instance():GetOpenedUI(UIType.UISelfLandFunction);
        if isopen ~= true then
            UIService:Instance():HideUI(UIType.UISelfLandFunction);
        else
            MapService:Instance():HideTiled()
        end

        self:CheckTiledArmys(tiledIndex);
    end
end

function MapManage:CheckTiledArmys(tiledIndex)
    local uiArmyDetailGrid = UIService:Instance():GetUIClass(UIType.UIArmyDetailGrid);
    if uiArmyDetailGrid == nil then
        UIService:Instance():ShowUI(UIType.UIArmyDetailGrid, tiledIndex);
    else
        local haveArmys = uiArmyDetailGrid:CheckTiledArmys(tiledIndex);
        if haveArmys == true then
            UIService:Instance():ShowUI(UIType.UIArmyDetailGrid, tiledIndex);
        else
            if UIService:Instance():GetOpenedUI(UIType.UIArmyDetailGrid) == true then
                UIService:Instance():HideUI(UIType.UIArmyDetailGrid);
            end
        end
    end
end

function MapManage:CancleMouseClick()

end

function MapManage:ExtensionClick(eventData)
    local position = eventData.position;
    if position.x < 0 or position.y < 0 or position.x > UnityEngine.Screen.width or position.y > UnityEngine.Screen.height then
        return;
    end

    local clickPosition = self:_ScreenPointToUGUIPosition(position);
    local x, y = self._tiledManage:UIToTiledPosition(clickPosition.x, clickPosition.y);
    local tiledIndex = self._tiledManage:GetTiledIndex(x, y);
    Extension:Instance():ExtendTiled(tiledIndex);
end

function MapManage:ClickBuilding(eventData)
    local position = eventData.position;
    if position.x < 0 or position.y < 0 or position.x > UnityEngine.Screen.width or position.y > UnityEngine.Screen.height then
        return;
    end

    local clickPosition = self:_ScreenPointToUGUIPosition(position);
    local x, y = self._tiledManage:UIToTiledPosition(clickPosition.x, clickPosition.y);
    local tiledIndex = self._tiledManage:GetTiledIndex(x, y);
    local tiled = self._tiledManage:GetTiledByIndex(tiledIndex);

end

function MapManage:EndMove()
    ClickService:Instance():HideTiled();
    self._tiledManage:ShowMapUI();
    self:StartTimeToChangeScreenCenter();
    local bassClass = UIService:Instance():GetUIClass(UIType.UIMinMap)
    if bassClass ~= nil then
        bassClass:RefreashWildCity()
    end
end

function MapManage:StartTimeToChangeScreenCenter()
    if self.requestMapInfoTimer ~= nil then
        return;
    end
    self.requestMapInfoTimer = Timer.New( function()
        local position = self._tiledMap.localPosition;
        local x, y = self._tiledManage:UIToTiledPosition(- position.x, - position.y);
        local centerIndex = self._tiledManage:GetTiledIndex(x, y);
        self:ChangeScreenCenter(centerIndex);
    end , 1, 1, false)
    self.requestMapInfoTimer:Start();
end

function MapManage:ChangeScreenCenter(index)
    self:StopChangeScreenCenter();
    local msg = require("MessageCommon/Msg/C2L/Player/ScreenCenter").new();
    msg:SetMessageId(C2L_Player.ScreenCenter);
    msg.screenCenter = index;
    NetService:Instance():SendMessage(msg);
end

function MapManage:StopChangeScreenCenter()
    if self.requestMapInfoTimer == nil then
        return;
    end

    self.requestMapInfoTimer:Stop();
    self.requestMapInfoTimer = nil;
end

function MapManage:_ScreenPointToUGUIPosition(position)
    local isInRect, convertPosition = UnityEngine.RectTransformUtility.ScreenPointToLocalPointInRectangle(self._tiledMap, position, self._canvas.worldCamera);
    return Vector3.New(convertPosition.x, convertPosition.y, 0);
end

function MapManage:ScanTiledByUGUIPositionDelay(x, y)
    if self._canFollow == false then
        return;
    end
    self:ScanPosition(Vector3.New(- x, - y, 0));
    local position = self._tiledMap.localPosition;
    local x, y = self._tiledManage:UIToTiledPosition(- position.x, - position.y);
    if math.abs(x - self._lastFollowCenterX) >= self._needTiledCount or math.abs(y - self._lastFollowCenterY) >= self._needTiledCount then
        self:Z_ShowTiledMove(x, y, self._lastcenterX, self._lastcenterY);
        self._lastFollowCenterX = x;
        self._lastFollowCenterY = y;
        local centerIndex = self._tiledManage:GetTiledIndex(x, y);
        MapService:Instance():ChangeScreenCenter(centerIndex);
    end
end

-- 限速阀泄压,跳转时要调用一次
function MapManage:LimitSpeedRelease()
    SPOposition.x = nil;
    SPOposition.y = nil;
    SPOposition.z = nil;
end

function MapManage:TiledPositionToUIPosition(x, y)

    local UIX =(y - x) * 200;
    local UIY =((- x - y) * 400) / 4 - 32;
    return Vector3.New(UIX, UIY, 0);
end

function MapManage:ScanTiledByUGUIPositionNotDelay(x, y)
    if MoveMouseLock == false then
        self:LimitSpeedRelease();
        local centerX, centerY = self._tiledManage:UIToTiledPosition(x, y);
        local lastPosition = self._tiledMap.localPosition;
        local lastcenterX, lastcenterY = self._tiledManage:UIToTiledPosition(- lastPosition.x, - lastPosition.y);
        local centerIndex = self._tiledManage:GetTiledIndex(centerX, centerY);
        if centerX ~= lastcenterX or centerY ~= lastcenterY then
            self:ScanTiled(centerIndex, function()
                MapService:Instance():ChangeScreenCenter(centerIndex);
            end , 0, true);
        else
            MapService:Instance():ChangeScreenCenter(centerIndex);
        end
    end
end

function MapManage:CloudMove(MoveType)
    local cloud = UnityEngine.GameObject.Find("cloud");
    if MoveType == 1 then
        if cloud then
            cloud.transform.localPosition = Vector3.New(-1100, 0, 250)
            local lt = cloud.transform:DOLocalMove(Vector3.New(1100, 0, 250), 1.5);
            lt:SetEase(self, EaseType.InOutCirc);
        end
    end
    if MoveType == 2 then
        if cloud then
            cloud.transform.localPosition = Vector3.New(1100, 0, 250)
            local lt = cloud.transform:DOLocalMove(Vector3.New(-1100, 0, 250), 1.5);
            lt:SetEase(self, EaseType.InOutCirc);
        end
    end
    if MoveType == 3 then
        if cloud then
            cloud.transform.localPosition = Vector3.New(0, -700, 500)
            local lt = cloud.transform:DOLocalMove(Vector3.New(0, 700, 500), 1.5);
            lt:SetEase(self, EaseType.InOutCirc);
        end
    end
    if MoveType == 4 then
        if cloud then
            cloud.transform.localPosition = Vector3.New(0, 700, 500)
            local lt = cloud.transform:DOLocalMove(Vector3.New(0, -700, 500), 1.5);
            lt:SetEase(self, EaseType.InOutCirc);
        end
    end
end


-- 跳转显示隐藏方法
function MapManage:JumpShowTiledAndHideTiled(CenterX, CenterY, LastCenterX, LastCenterY)
    local Sposition = self:TiledPositionToUIPosition(CenterX, CenterY);
    local LstartX = LastCenterX - self._edgeLength;
    local LstartY = LastCenterY - self._edgeLength;
    local StartX = CenterX - self._edgeLength;
    local StartY = CenterY - self._edgeLength;
    for x = 0, self._edgeLength * 2, 1 do
        for y = 0, self._edgeLength * 2, 1 do
            self._tiledManage:HideTiled(LstartX + x, LstartY + y);
        end
    end
    for x = 0, self._edgeLength * 2, 1 do
        for y = 0, self._edgeLength * 2, 1 do
            local UIposition = self:TiledPositionToUIPosition(StartX + x, StartY + y);
            if math.abs(UIposition.x - Sposition.x) <= CubeEdgeWidth and math.abs(UIposition.y - Sposition.y + 150) <= CubeEdgeHight then
                self._tiledManage:ShowTiled(StartX + x, StartY + y);
            end
        end
    end
end
-- 33
local SortJump = false;
local SortJumpX = 0;
local SortJumpY = 0;
-- 跳转方法
function MapManage:ScanTiledMark(tiledIndex)
    -- print("SCANTILEDMARK");
    -- MoveMouseLock = true;
    self:LimitSpeedRelease();
    self._canFollow = false;
    local tx, ty = MapService:Instance():GetTiledCoordinate(tiledIndex)
    local num = 1;
    local lastPosition = self._tiledMap.localPosition;
    local centerX, centerY = self._tiledManage:UIToTiledPosition(- lastPosition.x, - lastPosition.y);
    -- if centerX ~= tx and centerY ~= ty then
    local pos1x = centerX + num *((tx - centerX) / math.abs(centerX - tx));
    local pos1y = centerY + num *((ty - centerY) / math.abs(centerY - ty));
    local tiledId1 = MapService:Instance():GetTiledIndex(pos1x, pos1y);

    local position = self._tiledMap.localPosition;
    local currentX, currentY = self._tiledManage:UIToTiledPosition(- position.x, - position.y);
    local startX = currentX - self._edgeLength;
    local startY = currentY - self._edgeLength;

    local Sposition = self:TiledPositionToUIPosition(tx, ty);
    pos1x = tx - num *((tx - centerX) / math.abs(centerX - tx));
    pos1y = ty - num *((ty - centerY) / math.abs(centerY - ty));
    local tiledId2 = MapService:Instance():GetTiledIndex(pos1x, pos1y);
    if math.abs(centerX - tx) > 7 or math.abs(centerY - ty) > 4 then
        OpenJump = true;
        MoveMouseLock = true;
        self:ScanTiled(tiledId1, function()
            MoveMouseLock = true;
            self:ScanTiled(tiledId2, function()
                MoveMouseLock = true;
                for x = 0, self._edgeLength * 2, 1 do
                    for y = 0, self._edgeLength * 2, 1 do
                        self._tiledManage:HideTiled(startX + x, startY + y);
                    end
                end
                -- 88
                local SstartX = tx - self._edgeLength;
                local SstartY = ty - self._edgeLength;
                for x = 0, self._edgeLength * 2, 1 do
                    for y = 0, self._edgeLength * 2, 1 do
                        local UIposition = self:TiledPositionToUIPosition((SstartX + x),(SstartY + y));
                        if math.abs(UIposition.x - Sposition.x) <= CubeEdgeWidth and math.abs(UIposition.y - Sposition.y + 150) <= CubeEdgeHight then
                            self._tiledManage:ShowTiled(SstartX + x, SstartY + y);
                        end
                    end
                end
                self:ScanTiled(tiledIndex, function()
                    MoveMouseLock = true;
                    MapService:Instance():ChangeScreenCenter(tiledIndex);
                    OpenJump = false;
                    self._canFollow = true;
                    self:LimitSpeedRelease();
                    MoveMouseLock = false;
                end , 0.3)
            end , 0)
        end , 0.3)

    else
        MoveMouseLock = true;
        SortJumpX = tx;
        SortJumpY = ty;
        local Cposition = self:TiledPositionToUIPosition(centerX, centerY);
        local Tposition = self:TiledPositionToUIPosition(tx, ty);
        local SJdistanceX =(Cposition.x - Tposition.x);
        local SJdistanceY =(Cposition.y - Tposition.y);

        local SstartX = tx - self._edgeLength;
        local SstartY = ty - self._edgeLength;
        for x = 0, self._edgeLength * 2, 1 do
            for y = 0, self._edgeLength * 2, 1 do
                local UIposition = self:TiledPositionToUIPosition((SstartX + x),(SstartY + y));
                -- 增生块
                if SJdistanceX > 0 then
                    if SJdistanceY > 0 then
                        if UIposition.x - Sposition.x >= - CubeEdgeWidth and UIposition.x - Sposition.x <= CubeEdgeWidth + SJdistanceX and UIposition.y - Sposition.y + 150 >= - CubeEdgeHight and UIposition.y - Sposition.y + 150 <= CubeEdgeHight + SJdistanceY then
                            self._tiledManage:ShowTiled(SstartX + x, SstartY + y);
                        end
                    end
                    if SJdistanceY < 0 then
                        if UIposition.x - Sposition.x >= - CubeEdgeWidth and UIposition.x - Sposition.x <= CubeEdgeWidth + SJdistanceX and UIposition.y - Sposition.y + 150 >= - CubeEdgeHight + SJdistanceY and UIposition.y - Sposition.y + 150 <= CubeEdgeHight then
                            self._tiledManage:ShowTiled(SstartX + x, SstartY + y);
                        end
                    end
                    if SJdistanceY == 0 then
                        if UIposition.x - Sposition.x >= - CubeEdgeWidth and UIposition.x - Sposition.x <= CubeEdgeWidth + SJdistanceX and math.abs(UIposition.y - Sposition.y + 150) <= CubeEdgeHight then
                            self._tiledManage:ShowTiled(SstartX + x, SstartY + y);
                        end
                    end
                end
                if SJdistanceX < 0 then
                    if SJdistanceY > 0 then
                        if UIposition.x - Sposition.x >= - CubeEdgeWidth + SJdistanceX and UIposition.x - Sposition.x <= CubeEdgeWidth and UIposition.y - Sposition.y + 150 >= - CubeEdgeHight and UIposition.y - Sposition.y + 150 <= CubeEdgeHight + SJdistanceY then
                            self._tiledManage:ShowTiled(SstartX + x, SstartY + y);
                        end
                    end
                    if SJdistanceY < 0 then
                        if UIposition.x - Sposition.x >= - CubeEdgeWidth + SJdistanceX and UIposition.x - Sposition.x <= CubeEdgeWidth and UIposition.y - Sposition.y + 150 >= - CubeEdgeHight + SJdistanceY and UIposition.y - Sposition.y + 150 <= CubeEdgeHight then
                            self._tiledManage:ShowTiled(SstartX + x, SstartY + y);
                        end
                    end
                    if SJdistanceY == 0 then
                        if UIposition.x - Sposition.x >= - CubeEdgeWidth + SJdistanceX and UIposition.x - Sposition.x <= CubeEdgeWidth and math.abs(UIposition.y - Sposition.y + 150) <= CubeEdgeHight then
                            self._tiledManage:ShowTiled(SstartX + x, SstartY + y);
                        end
                    end
                end
                if SJdistanceX == 0 then
                    if SJdistanceY > 0 then
                        if math.abs(UIposition.x - Sposition.x) <= CubeEdgeWidth and UIposition.y - Sposition.y + 150 >= - CubeEdgeHight and UIposition.y - Sposition.y + 150 <= CubeEdgeHight + SJdistanceY then
                            self._tiledManage:ShowTiled(SstartX + x, SstartY + y);
                        end
                    end
                    if SJdistanceY < 0 then
                        if math.abs(UIposition.x - Sposition.x) <= CubeEdgeWidth and UIposition.y - Sposition.y + 150 >= - CubeEdgeHight + SJdistanceY and UIposition.y - Sposition.y + 150 <= CubeEdgeHight then
                            self._tiledManage:ShowTiled(SstartX + x, SstartY + y);
                        end
                    end
                end
            end
        end
        if SJdistanceX ~= 0 and SJdistanceY ~= 0 then
            for x = 0, self._edgeLength * 2, 1 do
                for y = 0, self._edgeLength * 2, 1 do
                    local LUIposition = self:TiledPositionToUIPosition(startX + x, startY + y);
                    if math.abs(LUIposition.x - lastPosition.x) <= CubeEdgeWidth and math.abs(LUIposition.y - lastPosition.y) <= CubeEdgeHight then
                        self._tiledManage:HideTiled(startX + x, startY + y);
                    end
                end
            end
        end
        SortJump = true;
        self:ScanTiled(tiledIndex, function()
            MapService:Instance():ChangeScreenCenter(tiledIndex);
            MoveMouseLock = false;
            self._canFollow = true;
            OpenJump = false;
        end );
    end
    -- end
    local curPos = self:TiledPositionToUIPosition(centerX, centerY);
    local targetPos = self:TiledPositionToUIPosition(tx, ty);
    if math.abs(centerX - tx) > 40 or math.abs(centerY - ty) > 40 then
        if math.abs(curPos.x - targetPos.x) > math.abs(curPos.y - targetPos.y) then
            if curPos.x - targetPos.x > 0 then
                moveType = 1
            else
                moveType = 2
            end
        else
            if curPos.y - targetPos.y > 0 then
                moveType = 3
            else
                moveType = 4
            end

        end
        self:CloudMove(moveType)
    end
end
-- 清理残余地块
function MapManage:Z_RecoveryTiled(CenterX, CenterY)
    -- body
    -- print("CCCC"..CenterX..CenterY);
    local Sposition = self:TiledPositionToUIPosition(CenterX, CenterY);
    local SstartX = CenterX - self._edgeLength;
    local SstartY = CenterY - self._edgeLength;
    for x = 0,(self._edgeLength + 3) * 2, 1 do
        for y = 0,(self._edgeLength + 3) * 2, 1 do
            local UIposition = self:TiledPositionToUIPosition((SstartX + x),(SstartY + y));
            if math.abs(UIposition.x - Sposition.x) > CubeEdgeWidth or math.abs(UIposition.y - Sposition.y) > CubeEdgeHight then
                self._tiledManage:HideTiled(SstartX + x, SstartY + y);
            end
        end
    end
end

function MapManage:ScanTiled(tiledIndex, fun, time, bool)
    -- print("Scantiled");
    MiniMapShortJump = bool;
    -- print("SCANTILED");
    self:LimitSpeedRelease();
    -- MapService:Instance():ChangeScreenCenter(tiledIndex);
    self:MoveToTarget(tiledIndex, fun, time)
    local x, y = self:GetTiledCoordinate(tiledIndex)
    if UIService:Instance():GetUIClass(UIType.UIPmap) ~= nil then
        UIService:Instance():GetUIClass(UIType.UIPmap):MoveToClickMateAndMark(x, y)
    end
    if UIService:Instance():GetUIClass(UIType.UIMinMap) ~= nil then
        UIService:Instance():GetUIClass(UIType.UIMinMap):ScanMinMap(tiledIndex)
    end
end


local MoveOpene = true;
function MapManage:ScanPosition(position)
    if SPOposition.x ~= nil and SPOposition.y ~= nil then
        local ReduceDistanceX = SPOposition.x - position.x;
        local ReduceDIstanceY = SPOposition.y - position.y;
        if math.abs(ReduceDistanceX) >= limitSpeedX then
            local modifyx = ReduceDistanceX / math.abs(ReduceDistanceX);
            position.x = SPOposition.x - modifyx * limitSpeedX;
        end

        if math.abs(ReduceDIstanceY) >= limitSpeedY then
            local modifyy = ReduceDIstanceY / math.abs(ReduceDIstanceY);
            position.y = SPOposition.y - modifyy * limitSpeedY;
        end
    end
    SPOposition.x = position.x;
    SPOposition.y = position.y;
    SPOposition.z = position.z;

    local lastPosition = self._tiledMap.localPosition;
    self._lastcenterX, self._lastcenterY = self._tiledManage:UIToTiledPosition(- lastPosition.x, - lastPosition.y);
    self._curcenterX, self._curcenterY = self._tiledManage:UIToTiledPosition(- position.x, - position.y);
    if self._curcenterX <= self._tiledManage:GetLimitMin() or
        self._curcenterX >= self._tiledManage:GetLimitMax() or
        self._curcenterY <= self._tiledManage:GetLimitMin() or
        self._curcenterY >= self._tiledManage:GetLimitMax() then
        local curcenterX, curcenterY = self._tiledManage:UIToLimitTiledPosition(- position.x, - position.y);
        local cur = self._tiledManage:GetTiledPosition(curcenterX, curcenterY);
        self._tiledMap.localPosition = Vector3.New(- cur.x, - cur.y, 0);
        self:ResetLandNewPosition();
        self:_HandlerTiled();
        return;
    end
    self._tiledMap.localPosition = position;
    self:ResetLandNewPosition();
    if self.minMapObj == nil then
        self.minMapObj = UnityEngine.GameObject.Find("MinMap");
    end

    if self.minMapObj then
        self.Minmap = self.minMapObj.transform;
        self.MinMapRectTransform = self.Minmap.gameObject:GetComponent(typeof(UnityEngine.RectTransform));
        PmapService:Instance():Move(self.MinMapRectTransform, self._lastcenterX, self._lastcenterY)
    end
end

function MapManage:ResetMinMapPos()
    PmapService:Instance():Move(self.MinMapRectTransform, self._lastcenterX, self._lastcenterY)
end


function MapManage:GetLastPos()

    return self._lastcenterX, self._lastcenterY

end

-- 22
local MoveToPositionAndCallBackBool = false;
function MapManage:MoveToPositionAndCallBack(position)
    -- print("MoveToPositionAndCallBack"..position.x.." "..position.y);
    if MoveMouseLock == false then

        MoveToPositionAndCallBackBool = true;
        self:LimitSpeedRelease();
        local lastPosition = self._tiledMap.localPosition;
        -- self._lastcenterX, self._lastcenterY = self._tiledManage:UIToTiledPosition(- lastPosition.x, - lastPosition.y);

        local moveTime = MapMoveTime;
        if math.abs(lastPosition.x - position.x) < 10 and math.abs(lastPosition.y - position.y) < 10 then
            MoveToPositionAndCallBackSortBool = true;
        end
        local UIpositionX, UIpositionY = self._tiledManage:UIToTiledPosition(- position.x, - position.y);
        local MtiledIndex = self._tiledManage:GetTiledIndex(UIpositionX, UIpositionY);
        self:ScanTiledMark(MtiledIndex);
        MapService:Instance():ChangeScreenCenter(MtiledIndex);
    end
end

function MapManage:_HandlerTiled(fun)
    -- print("_HandlerTiled")
    local position = self._tiledMap.localPosition;
    local lastX = self._lastcenterX;
    local lastY = self._lastcenterY;
    local x, y = self._tiledManage:UIToTiledPosition(- position.x, - position.y);

    local request = { };
    request.x = x;
    request.y = y;
    request.lastX = self._lastcenterX;
    request.lastY = self._lastcenterY;
    self.showQueue:Push(request);
    if self.showQueue:Count() == 1 then
        self:RequestResouce(request, fun);
    end
end

function MapManage:_HandlerTiledMove(StartCenterPosx, StartCenterPosy, fun)
    local position = self._tiledMap.localPosition;
    local lastX = StartCenterPosx;
    local lastY = StartCenterPosy;
    local x, y = self._tiledManage:UIToTiledPosition(- position.x, - position.y);
    local request = { };
    request.x = x;
    request.y = y;
    request.lastX = StartCenterPosx;
    request.lastY = StartCenterPosy;
    self.showQueue:Push(request);
    if self.showQueue:Count() == 1 then
        self:RequestResouce(request, fun);
    end
    return x, y;
end


function MapManage:SetCurrentPos(x, y)
    self._curcenterX = x
    self._curcenterY = y
end

function MapManage:RequestResouce(request, fun)
    -- print("RequestResouce");
    self._tiledManage:ChangeScreenCenter(request.x, request.y, function()
        self:HandlerTiledQueue();
        if fun ~= nil then
            fun();
        end
    end );
end
function MapManage:HandlerTiledQueue()
    --   print("00000000000000");
    local request = self.showQueue:Pop();
    self:HandleTiledShow(request.x, request.y, request.lastX, request.lastY);
    if self.showQueue:Count() ~= 0 then
        local peek = self.showQueue:Peek();
        self:RequestResouce(peek);
    end
end
-- 66
function MapManage:HandleTiledShow(x, y, lastX, lastY)
    --   print("aaaaaaaaaaaa");
    if math.abs(x - lastX) * 2 >= 2 * self._edgeLength * 2 + 1 or math.abs(y - lastY) >= 2 * self._edgeLength * 2 + 1 then
        if OpenJump == false then
            --  print("走这里SHowAlltiled");
            self:_HideAllTiled();
            self:_ShowAllTiled();
        end
        return;
    end
    --  print(MiniMapShortJump);
    -- 小地图近距离跳转控制
    if MiniMapShortJump then
        --   print("MINIMAPJUMP");
        MiniMapShortJump = false;
        self:_HideAllTiled();
        self:_ShowAllTiled();
    end
    if OpenJump == false then
        --   print("ZZZSHOWTILEDMOVE");
        self:Z_ShowTiledMove(x, y, lastX, lastY);
    end
end

function MapManage:_FindModifyOrder(value, lastValue)
    local move = value - lastValue;
    if move == 0 then
        return 0, false;
    end
    local modify = math.abs(move) / move;
    local order = true;
    if modify < 0 then
        order = false;
    end

    return modify, order;
end
function MapManage:_HideAllTiled()
    local startX = self._lastcenterX - self._edgeLength;
    local startY = self._lastcenterY - self._edgeLength;
    for x = 0, self._edgeLength * 2 do
        for y = 0, self._edgeLength * 2 do
            self._tiledManage:HideTiled(startX + x, startY + y);
        end
    end
end

function MapManage:_ShowAllTiled()
    -- print("SHOWALLTILED方法里面");
    local position = self._tiledMap.localPosition;
    local currentX, currentY = self._tiledManage:UIToTiledPosition(- position.x, - position.y);
    local startX = currentX - self._edgeLength;
    local startY = currentY - self._edgeLength;
    for x = 0, self._edgeLength * 2, 1 do
        for y = 0, self._edgeLength * 2, 1 do
            local UIposition = self:TiledPositionToUIPosition(-(startX + x), -(startY + y));
            if math.abs(UIposition.x - position.x) <= CubeEdgeWidth and math.abs(UIposition.y - position.y + 150) <= CubeEdgeHight then
                self._tiledManage:ShowTiled(startX + x, startY + y);
            end
        end
    end
end

-- 地图移动显示隐藏
function MapManage:Z_ShowTiledMove(currentX, currentY, lastX, lastY)
    local position = self:TiledPositionToUIPosition(currentX, currentY);
    ProtectShowX = position.x;
    ProtectShowY = position.y;
    local lposition = self:TiledPositionToUIPosition(lastX, lastY);
    local distancex = lposition.x - position.x;
    local distancey = lposition.y - position.y;
    local startX = currentX - self._edgeLength;
    local startY = currentY - self._edgeLength;
    for x = 0, self._edgeLength * 2, 1 do
        for y = 0, self._edgeLength * 2, 1 do
            UIposition = self:TiledPositionToUIPosition((startX + x),(startY + y));
            XDistance = position.x - UIposition.x;
            YDistance = position.y - UIposition.y;
            LXDistance = lposition.x - UIposition.x;
            LYDistance = lposition.y - UIposition.y;
            if distancex > 0 then
                if XDistance <= CubeEdgeWidth and math.abs(YDistance) <= CubeEdgeHight and XDistance >= CubeEdgeWidth - distancex - 100 then
                    local queuetm = { };
                    queuetm.x = startX + x;
                    queuetm.y = startY + y;
                    self.TMQueue:Push(queuetm);
                    TileMoveOpen = true;
                end
            end
            if distancex < 0 then
                if XDistance >= - CubeEdgeWidth and math.abs(YDistance) <= CubeEdgeHight and XDistance <= - CubeEdgeWidth - distancex + 100 then
                    local queuetm = { };
                    queuetm.x = startX + x;
                    queuetm.y = startY + y;
                    self.TMQueue:Push(queuetm);
                    TileMoveOpen = true;
                end
            end
            if distancey > 0 then
                if math.abs(XDistance) <= CubeEdgeWidth and YDistance <= CubeEdgeHight and YDistance >= CubeEdgeHight - distancey - 100 then
                    local queuetm = { };
                    queuetm.x = startX + x;
                    queuetm.y = startY + y;
                    self.TMQueue:Push(queuetm);
                    TileMoveOpen = true;
                end
            end
            if distancey < 0 then
                if math.abs(XDistance) <= CubeEdgeWidth and YDistance >= - CubeEdgeHight and YDistance <= - CubeEdgeHight - distancey + 100 then
                    local queuetm = { };
                    queuetm.x = startX + x;
                    queuetm.y = startY + y;
                    self.TMQueue:Push(queuetm);
                    TileMoveOpen = true;
                end
            end
            if math.abs(LXDistance) <= CubeEdgeWidth + 100 and math.abs(LYDistance) <= CubeEdgeHight + 100 then
                if math.abs(XDistance) > CubeEdgeWidth or math.abs(YDistance) > CubeEdgeHight then
                    self._tiledManage:HideTiled(startX + x, startY + y);
                end
            end
        end
    end
end

function MapManage:GetTiledCoordinate(index)
    return TiledManage:GetTiledCoordinate(index)
end

function MapManage:GetTiledIndex(x, y)
    return TiledManage:GetTiledIndex(x, y)
end

function MapManage:UIToTiledPosition(x, y)
    return self._tiledManage:UIToTiledPosition(x, y)
end

function MapManage:HandleSingleTiled(msg)
    local count = msg.allTiledList:Count();
    for i = 1, count, 1 do
        local tiledInfo = msg.allTiledList:Get(i);
        if tiledInfo ~= nil then
            --self.syncTiledInfoQueue:Push(tiledInfo);
            self:SyncTiledInfo(tiledInfo);
        end
    end
    self:RefreshRelatedUIMsg();
end

function MapManage:HandleRegionTiled(msg)
    local count = msg.allTiledList:Count();
    for i = 1, count, 1 do
        local tiledInfo = msg.allTiledList:Get(i);
        if tiledInfo ~= nil then
            --self.syncTiledInfoQueue:Push(tiledInfo);
            self:SyncTiledInfo(tiledInfo);
        end
    end
end

-- 地块更新时刷新相关联的ui界面数据（分帧处理完所有tiledinfo后刷新一次）
function MapManage:RefreshRelatedUIMsg()
    local baseClass = UIService:Instance():GetUIClass(UIType.UIMinMap);
    if baseClass then
        baseClass:OnShow()
    end
    -- 更新主界面所有的资源产量
    local mainBaseClass = UIService:Instance():GetUIClass(UIType.UIGameMainView);
    if mainBaseClass ~= nil then
        mainBaseClass:SetResource();
    end

    local topPanelClass = ClickService:Instance():GetTopPanel()
    if topPanelClass and topPanelClass.gameObject.activeSelf == true then
        topPanelClass:SetDurableVal();
    end
end

function MapManage:SyncTiledInfo(tiledInfo)
    -- UnityEngine.Profiler.BeginSample("GetTiledByIndex");
    local tiled = self._tiledManage:GetTiledByIndex(tiledInfo.tiledId);
    if tiled == nil then
        return;
    end
    -- UnityEngine.Profiler.EndSample();
    -- UnityEngine.Profiler.BeginSample("tiledInfo");
    tiled.tiledInfo = tiledInfo;
    -- UnityEngine.Profiler.EndSample();
    -- UnityEngine.Profiler.BeginSample("RefreshTiled");
    self._tiledManage:RefreshTiled(tiled);
    -- UnityEngine.Profiler.EndSample();
    -- UnityEngine.Profiler.BeginSample("RefreshArmyBehaviorState");
    self._tiledManage:RefreshArmyBehaviorState(tiled);
    -- UnityEngine.Profiler.EndSample();
    -- UnityEngine.Profiler.BeginSample("_ShowTiledViewLayer");
    self._tiledManage:_ShowTiledViewLayer(tiled);
    -- UnityEngine.Profiler.EndSample();
    -- UnityEngine.Profiler.BeginSample("ShowGiveUpTime");
    self._tiledManage:ShowGiveUpTime(tiled);
    -- UnityEngine.Profiler.EndSample();
    -- UnityEngine.Profiler.BeginSample("InitDurableVar");
    self._tiledManage:InitDurableVar(tiledInfo);
    self:UpdateMyTiledDura(tiledInfo);
    -- UnityEngine.Profiler.EndSample();
    -- UnityEngine.Profiler.BeginSample("RefreshAvoidTiled");
    --    self._tiledManage:RefreshAvoidTiled(tiled);

    self._tiledManage:ShowTiledState(tiled);
    -- UnityEngine.Profiler.EndSample();
    --  UnityEngine.Profiler.BeginSample("RefreshFall");
    self:RefreshFall(tiled)
    --  UnityEngine.Profiler.EndSample();
end

function MapManage:RefreshFall(tiled)
    if tiled == nil or tiled.tiledInfo == nil then
        return
    end
    local building = tiled._building
    if building == nil then
        return
    end
    local nameItem = UIMapNameService:Instance():FindItem(building._id)
    if nameItem == nil then
        return
    end
    nameItem:OnShow(tiled)
end

function MapManage:HidePlayerBuilding(building)
    if building == nil then
        return;
    end

    local tiled = self._tiledManage:GetTiledByIndex(building._tiledId);
    if tiled == nil then
        return;
    end

    tiled._building = building;
    self._tiledManage:HidePlayerBuilding(tiled);
    self._tiledManage:RemoveBuildingByIndex(building);
    self._tiledManage:_ShowBuildingResources(building._tiledId, 1)
    self._tiledManage:DeleteSubCityEffect(building._id)
end

function MapManage:RefreshBuilding(building)
    if building == nil then
        return;
    end
    local tiled = self._tiledManage:GetTiledByIndex(building._tiledId);
    if tiled == nil then
        return;
    end
    tiled._building = building;
    self._tiledManage:RefreshBuilding(tiled);
end


function MapManage:RefreshFortBuilding(building)
    if building == nil then
        return;
    end
    -- ------print(building._tiledId)
    local tiled = self._tiledManage:GetTiledByIndex(building._tiledId)
    -- ------print(tiled)
    if tiled == nil then
        return;
    end
    tiled._building = building;
    self._tiledManage:RefreshFortBuilding(tiled);
end

function MapManage:RefreshFortHideTiled(building)
    if building == nil then
        return;
    end
    -- ------print(building._tiledId)
    local tiled = self._tiledManage:GetTiledByIndex(building._tiledId)
    -- ------print(tiled)
    if tiled == nil then
        return;
    end
    tiled._building = building;
    self._tiledManage:RefreshFortHideTiled(tiled);
end


function MapManage:HandleCreateTiled(x, y)
    return self._tiledManage:_HandleCreateTiled(x, y)
end

function MapManage:RefreshTown(building)
    self._tiledManage:_RefreshTown(building)
end

function MapManage:_RefreshSubCityCountDown(building)
    self._tiledManage:_RefreshCreateSubCityCountDown(building)
    self._tiledManage:_RefreshDeleteSubCityCountDown(building)
end

function MapManage:_GetLayerParent(layerType)
    return self._tiledManage:_GetLayerParent(layerType)
end

function MapManage:GetTiledPositionByIndex(index)
    return self._tiledManage:GetTiledPositionByIndex(index)
end

function MapManage:GetTiledPosition(x, y)
    return self._tiledManage:GetTiledPosition(x, y)
end

function MapManage:GetTiledPositionMinusHecto(x, y)
    return self._tiledManage:GetTiledPositionMinusHecto(x, y)
end

function MapManage:GetTiledPositionFortRedStart(x, y)
    return self._tiledManage:GetTiledPositionFortRedStart(x, y)
end

function MapManage:GetTiledPositionWildFortRedStart(x, y)
    return self._tiledManage:GetTiledPositionWildFortRedStart(x, y)
end

function MapManage:GetCreateFortTime(x, y)
    return self._tiledManage:GetCreateFortTime(x, y)
end


function MapManage:GetTiledByIndex(index)
    return self._tiledManage:GetTiledByIndex(index)
end

function MapManage:SetClickObj(CallBackObj)
    self.CallBackObj = CallBackObj;
end

function MapManage:SetClickCityCallBack(CallBack)
    self.ClickCityCallBack = CallBack;
end

function MapManage:SetOutCityCallBack(CallBack)
    self.OutCityCallBack = CallBack;
end

function MapManage:ClickCityCallBack()
    if (self.ClickCityCallBack and self.CallBackObj) then
        self.ClickCityCallBack(self.CallBackObj)
    end
end

function MapManage:OutCityCallBack()
    if (self.OutCityCallBack and self.CallBackObj) then
        self.OutCityCallBack(self.CallBackObj)
    end
end

function MapManage:HideTiledCommon()
    ClickService:Instance():HideTiled();
    -- self._clickManage:HideTiled();
end

function MapManage:_GetBuildingDataTile(tiled)
    return self._tiledManage:_GetBuildingDataTile(tiled)
end

function MapManage:_GetBuildingTownDataTile(tiled)
    return self._tiledManage:_GetBuildingTownDataTile(tiled)
end

function MapManage:_GetDataTiled(tiled)
    if tiled == nil then
        return nil
    end
    return self._tiledManage:_GetDataTiled(tiled);
end

function MapManage:_GetTiledDurableVal(tiled)
    -- body
    return self._tiledManage:_GetTiledDurableVal(tiled);
end

function MapManage:GetSourceEventParent()
    return self._SourceEventParent;
end

function MapManage:MoveToTargetAndCallBack(tiledIndex, callBack)
    -- print("_moveToTagetAndCallBack");
    local scanPos = self._tiledManage:GetTiledPositionByIndex(tiledIndex);
    local position = Vector3.New(- scanPos.x - 50, - scanPos.y + 80, 0);
    local lastPosition = self._tiledMap.localPosition;
    self._lastcenterX, self._lastcenterY = self._tiledManage:UIToTiledPosition(- lastPosition.x, - lastPosition.y);
    self:ScanTiledMark(tiledIndex);
    local ltDescr = self._tiledMap.transform:DOLocalMove(position, MapMoveTime)
    ltDescr:OnComplete(self,
    function()
        self:ChangeView( function()
            MapService:Instance():ChangeScreenCenter(tiledIndex);
        end
        );
        if callBack ~= nil then
            callBack();
        end
    end

    );

end

function MapManage:MoveToTarget(tiledIndex, fun, time)
    -- print("MoveToTarget");
    -- print("_MoveTOTarget");
    local scanPos = self._tiledManage:GetTiledPositionByIndex(tiledIndex);
    self:MoveToPosition(Vector3.New(- scanPos.x, - scanPos.y + 120, 0), fun, time);
end

function MapManage:MoveToPosition(position, fun, time)
    --  print("MoveToPosition");
    if time ~= nil then
        MapMoveTime = time
    else
        MapMoveTime = MapScanTime
    end
    if MoveToPositionAndCallBackSortBool then
        MoveToPositionAndCallBackSortBool = false;
        MapMoveTime = 0;
    end
    local lastPosition = self._tiledMap.localPosition;
    self._lastcenterX, self._lastcenterY = self._tiledManage:UIToTiledPosition(- lastPosition.x, - lastPosition.y);
    -- UnityEngine.Profiler.BeginSample("_MOVETOTARGET");
    local ltDescr = self._tiledMap.transform:DOLocalMove(position, MapMoveTime)
    -- UnityEngine.Profiler.EndSample();
    -- UnityEngine.Profiler.BeginSample("_MOVETOTARGETCOMPLETE");
    ltDescr:OnComplete(self, function()
        if MapMoveTime == 0 then
            self:InitLandNewPosition();
        else
            self:ResetLandNewPosition();
        end
        if SortJump then
            SortJump = false;
            self:Z_RecoveryTiled(SortJumpX, SortJumpY);
            LeanTween.delayedCall(self.minMapObj, 0.5, System.Action( function()
                self:LimitSpeedRelease();
                MoveMouseLock = false;
            end ));
        end
        if MoveToPositionAndCallBackBool then
            -- print("MoveToPositionAndCallBackBool");
            MoveToPositionAndCallBackBool = false;
            self:ChangeBiggerView();
        end
        self:ChangeView(fun)
        UIService:Instance():HideUI(UIType.LoadingUI)
    end )
    -- UnityEngine.Profiler.EndSample();
end
-- 55
function MapManage:ChangeView(fun)
    --   print("_ChangeVIew");
    if (landParent ~= nil) then

    end
    -- print(OpenJump);
    self:_HandlerTiled(fun);
end

function MapManage:_LoadTiledResource(tiled)
    self._tiledManage:_LoadTiledResource(tiled)
end
function MapManage:GetTiledPositionSign(x, y)
    return self._tiledManage:GetTiledPositionSign(x, y);
end

function MapManage:IsGiveUpTiledInterval(tiled)
    return self._tiledManage:IsGiveUpTiledInterval(tiled)
end

function MapManage:ShowFortTimeBox(time, tiled, layerType)
    self._tiledManage:ShowFortTimeBox(time, tiled, layerType);
end

function MapManage:HideFortTimeBox(tiledId)
    self._tiledManage:HideFortTimeBox(tiledId)
end

function MapManage:IsBlueBreathingBox(tiled)
    return self._tiledManage:IsBlueBreathingBox(tiled)
end

function MapManage:ShowTiled(tiled, position)
    return ClickService:Instance():ShowTiled(tiled, position);
    -- return self._clickManage:ShowTiled(tiled, position);
end

function MapManage:PmapShowAllTiled(position, fun)
    local lastX = self._lastcenterX;
    local lastY = self._lastcenterY;
    local x, y = self._tiledManage:UIToTiledPosition(- position.x, - position.y);
    local request = { };
    request.x = x;
    request.y = y;
    request.lastX = self._lastcenterX;
    request.lastY = self._lastcenterY;
    self.showQueue:Push(request);
    if self.showQueue:Count() == 1 then
        self:RequestResouce(request, fun);
    end
end

function MapManage:BuildingSort(buildingtransform, parent)
    self._tiledManage:BuildingSort(buildingtransform, parent);
end

function MapManage:IsFriendTiled(tiled)
    return self._tiledManage:IsFriendTiled(tiled)
end

function MapManage:GetTiledFarmmingAccount(tiled, currencyEnum)
    return self._tiledManage:GetTiledFarmmingAccount(tiled, currencyEnum)
end

function MapManage:InitLightPos(tiledId)
    local pos = self:GetTiledPositionByIndex(tiledId);
    if self._lightImage ~= nil then
        self._lightImage.localPosition = Vector3.New(pos.x, pos.y - 120, 0);
    end
    if self._backTransform ~= nil and self._lightImage ~= nil then
        self.lightImageDis = self._backTransform.position - self._lightImage.position;
    end
end

function MapManage:SetChangeBiggerCallBack(callback)
    self.changeBiggerCallBack = callback;
end

function MapManage:InitLandNewPosition()
    self._landBasePos = self._tiledMap.localPosition;
    local indexX, indexY = self:UIToTiledPosition(- self._landBasePos.x, - self._landBasePos.y);
    local pos = self:GetTiledPosition(indexX, indexY);
    self._landPicMap[1].localPosition = Vector3.New(pos.x - self._landPicWidth, pos.y + self._landPicHeight, 0);
    self._landPicMap[2].localPosition = Vector3.New(pos.x, pos.y + self._landPicHeight, 0);
    self._landPicMap[3].localPosition = Vector3.New(pos.x + self._landPicWidth, pos.y + self._landPicHeight, 0);
    self._landPicMap[4].localPosition = Vector3.New(pos.x - self._landPicWidth, pos.y, 0);
    self._landPicMap[5].localPosition = Vector3.New(pos.x, pos.y, 0);
    self._landPicMap[6].localPosition = Vector3.New(pos.x + self._landPicWidth, pos.y, 0);
    self._landPicMap[7].localPosition = Vector3.New(pos.x - self._landPicWidth, pos.y - self._landPicHeight, 0);
    self._landPicMap[8].localPosition = Vector3.New(pos.x, pos.y - self._landPicHeight, 0);
    self._landPicMap[9].localPosition = Vector3.New(pos.x + self._landPicWidth, pos.y - self._landPicHeight, 0);
    self._leftLandIndex = 1;
    self._RightLandIndex = 3;
    self._TopLandIndex = 1;
    self._BottomLandIndex = 7;
end

function MapManage:ResetLandNewPosition()
    local newPos = self._tiledMap.localPosition;
    if newPos.x - self._landBasePos.x > self._landPicWidth / 2 then
        -- 右侧往左补
        self._landPicMap[self._RightLandIndex].localPosition = Vector3.New(self._landPicMap[self._RightLandIndex].localPosition.x - self._landPicWidth * 3, self._landPicMap[self._RightLandIndex].localPosition.y, 0);
        self._landPicMap[self._RightLandIndex + 3].localPosition = Vector3.New(self._landPicMap[self._RightLandIndex + 3].localPosition.x - self._landPicWidth * 3, self._landPicMap[self._RightLandIndex + 3].localPosition.y, 0);
        self._landPicMap[self._RightLandIndex + 6].localPosition = Vector3.New(self._landPicMap[self._RightLandIndex + 6].localPosition.x - self._landPicWidth * 3, self._landPicMap[self._RightLandIndex + 6].localPosition.y, 0);
        self._leftLandIndex = self._RightLandIndex;
        self._RightLandIndex = self._RightLandIndex - 1;
        if self._RightLandIndex == 0 then
            self._RightLandIndex = 3;
        end
        self._landBasePos = Vector3.New(self._landBasePos.x + self._landPicWidth, self._landBasePos.y, 0);
    elseif self._landBasePos.x - newPos.x > self._landPicWidth / 2 then
        -- 左侧往右补
        self._landPicMap[self._leftLandIndex].localPosition = Vector3.New(self._landPicMap[self._leftLandIndex].localPosition.x + self._landPicWidth * 3, self._landPicMap[self._leftLandIndex].localPosition.y, 0);
        self._landPicMap[self._leftLandIndex + 3].localPosition = Vector3.New(self._landPicMap[self._leftLandIndex + 3].localPosition.x + self._landPicWidth * 3, self._landPicMap[self._leftLandIndex + 3].localPosition.y, 0);
        self._landPicMap[self._leftLandIndex + 6].localPosition = Vector3.New(self._landPicMap[self._leftLandIndex + 6].localPosition.x + self._landPicWidth * 3, self._landPicMap[self._leftLandIndex + 6].localPosition.y, 0);
        self._RightLandIndex = self._leftLandIndex;
        self._leftLandIndex =(self._leftLandIndex + 1) % 3;
        if self._leftLandIndex == 0 then
            self._leftLandIndex = 3;
        end
        self._landBasePos = Vector3.New(self._landBasePos.x - self._landPicWidth, self._landBasePos.y, 0);
    end
    if newPos.y - self._landBasePos.y > self._landPicHeight / 2 then
        -- 上侧往下补
        self._landPicMap[self._TopLandIndex].localPosition = Vector3.New(self._landPicMap[self._TopLandIndex].localPosition.x, self._landPicMap[self._TopLandIndex].localPosition.y - self._landPicHeight * 3, 0);
        self._landPicMap[self._TopLandIndex + 1].localPosition = Vector3.New(self._landPicMap[self._TopLandIndex + 1].localPosition.x, self._landPicMap[self._TopLandIndex + 1].localPosition.y - self._landPicHeight * 3, 0);
        self._landPicMap[self._TopLandIndex + 2].localPosition = Vector3.New(self._landPicMap[self._TopLandIndex + 2].localPosition.x, self._landPicMap[self._TopLandIndex + 2].localPosition.y - self._landPicHeight * 3, 0);
        self._BottomLandIndex = self._TopLandIndex;
        self._TopLandIndex = self._TopLandIndex + 3;
        if self._TopLandIndex > 7 then
            self._TopLandIndex = 1;
        end
        self._landBasePos = Vector3.New(self._landBasePos.x, self._landBasePos.y + self._landPicHeight, 0);
    elseif self._landBasePos.y - newPos.y > self._landPicHeight / 2 then
        -- 下侧往上补
        self._landPicMap[self._BottomLandIndex].localPosition = Vector3.New(self._landPicMap[self._BottomLandIndex].localPosition.x, self._landPicMap[self._BottomLandIndex].localPosition.y + self._landPicHeight * 3, 0);
        self._landPicMap[self._BottomLandIndex + 1].localPosition = Vector3.New(self._landPicMap[self._BottomLandIndex + 1].localPosition.x, self._landPicMap[self._BottomLandIndex + 1].localPosition.y + self._landPicHeight * 3, 0);
        self._landPicMap[self._BottomLandIndex + 2].localPosition = Vector3.New(self._landPicMap[self._BottomLandIndex + 2].localPosition.x, self._landPicMap[self._BottomLandIndex + 2].localPosition.y + self._landPicHeight * 3, 0);
        self._TopLandIndex = self._BottomLandIndex;
        self._BottomLandIndex = self._BottomLandIndex - 3;
        if self._BottomLandIndex < 0 then
            self._BottomLandIndex = 7;
        end
        self._landBasePos = Vector3.New(self._landBasePos.x, self._landBasePos.y - self._landPicHeight, 0);
    end
end

function MapManage:UpdateMyTiledDura(tiledInfo)
    self._tiledManage:UpdateMyTiledDura(tiledInfo);
end

function MapManage:GetMyTiledDura(tiledIndex)
    return self._tiledManage:GetMyTiledDura(tiledIndex);
end

function MapManage:GetMyTiledMaxDura(tiledIndex)
    return self._tiledManage:GetMyTiledMaxDura(tiledIndex);
end

return MapManage;