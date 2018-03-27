local GameService = require("FrameWork/Game/GameService")

local MapHandler = require("Game/Map/MapHandler")
local MapManage = require("Game/Map/MapManage");
MapService = class("MapService", GameService)

-- 构造函数
function MapService:ctor()
    -- body
    -- --print("MapService:ctor");
    MapService._instance = self;
    MapService.super.ctor(self, MapManage.new(), MapHandler.new());
end

-- 单例
function MapService:Instance()
    return MapService._instance;
end

-- 清空数据
function MapService:Clear()
    self._logic:ctor()
end


-- 根据索引获取格子坐标
function MapService:GetTiledCoordinate(index)
    return self._logic:GetTiledCoordinate(index)
end

-- 根据X、Y获取格子的索引
function MapService:GetTiledIndex(x, y)
    return self._logic:GetTiledIndex(x, y)
end

function MapService:UIToTiledPosition(x, y)
    return self._logic:UIToTiledPosition(x, y)
end

-- 显示地图
function MapService:CreateMap()
    self._logic:_CreateMap();
end

-- 获取显示曾父亲
function MapService:GetLayerParent(layerType)
    return self._logic:_GetLayerParent(layerType)
end


-- 充值小地图位置信息
function MapService:ResetMinMapPos()
    self._logic:ResetMinMapPos();
end

function MapService:GetTiledByIndex(index)
    return self._logic:GetTiledByIndex(index)
end

-- 获取当前屏幕的中心位置
function MapService:GetCurrentPos()
    return self._logic:GetCurrentPos()
end

function MapService:SetCurrentPos(x, y)
    self._logic:SetCurrentPos(x, y)
end


function MapService:GetTiledPositionByIndex(index)
    return self._logic:GetTiledPositionByIndex(index)
end

-- 根据格子坐标获取位置
function MapService:GetTiledPosition(x, y)
    return self._logic:GetTiledPosition(x, y)
end

-- 加载预制y减少100
function MapService:GetTiledPositionMinusHecto(x, y)
    return self._logic:GetTiledPositionMinusHecto(x, y)
end

function MapService:GetTiledPositionSign(x, y)
    return self._logic:GetTiledPositionSign(x, y)
end

function MapService:GetTiledPositionFortRedStart(x, y)
    return self._logic:GetTiledPositionFortRedStart(x, y)
end

function MapService:GetCreateFortTime(x, y)
    return self._logic:GetCreateFortTime(x, y)
end

-- 进入操作
-- 必须先进入放大操作，才能进入扩建操作
-- 进入扩建操作之后才能进入扩建点击操作
-- 进入放大操作之后，才能进入点击建筑物操作 
function MapService:EnterOperator(operatorType, ...)
    self._logic:EnterOperator(operatorType, ...);
end

function MapService:HidePlayerBuilding(building)
    self._logic:HidePlayerBuilding(building);
end

function MapService:RefreshBuilding(building)
    self._logic:RefreshBuilding(building);
end

function MapService:RefreshFortBuilding(building)
    self._logic:RefreshFortBuilding(building)
end

function MapService:RefreshFortHideTiled(building)
    self._logic:RefreshFortHideTiled(building)
end

function MapService:RefreshTown(building)
    self._logic:RefreshTown(building)
end

function MapService:_RefreshSubCityCountDown(building)
    self._logic:_RefreshSubCityCountDown(building)
end

-- 移屛过去然后执行回调
function MapService:MoveToTargetAndCallBack(tiledIndex, callBack)
    self._logic:MoveToTargetAndCallBack(tiledIndex, callBack);
end

function MapService:ScanTiled(index, fun, time, bool)
    self._logic:ScanTiled(index, fun, time, bool)
end
-- 刷新格子
function MapService:HandleCreateTiled(x, y)
    return self._logic:HandleCreateTiled(x, y);
end

-- function MapService:RefreshTiled(tiled)
--     -- --print("进来了吗")
--     self._logic:RefreshTiled(tiled)
-- end


-- 放大大地图
function MapService:ChangeBiggerView(callBack)
    self._logic:ChangeBiggerView(callBack);
end

function MapService:ScanTiledByUGUIPositionDelay(x, y)
    self._logic:ScanTiledByUGUIPositionDelay(x, y)
end

function MapService:ScanTiledByUGUIPositionNotDelay(x, y)
    self._logic:ScanTiledByUGUIPositionNotDelay(x, y)
end

function MapService:SetCallBack(tiledIndex)
    self._logic:SetCallBack(tiledIndex)
end

function MapService:ClickCityCallBack()
    self._logic:ClickCityCallBack()
end

function MapService:OutCityCallBack()
    self._logic:OutCityCallBack()
end

-- 点击野城中心
function MapService:ClickWildBuilding()

    self._logic:ClickWildBuilding()

end

-- 隐藏格子
function MapService:HideTiled()

    self._logic:HideTiledCommon()

end

function MapService:ChangeSmallerView()
    self._logic:ChangeSmallerView()
end

function MapService:ChangeSmallerViewNoTween()
    self._logic:ChangeSmallerViewNoTween()
end

function MapService:GetLastPos(args)

    return self._logic:GetLastPos()
end


-- 获取城中心DataTile
function MapService:GetBuildingDataTile(tiled)
    return self._logic:_GetBuildingDataTile(tiled)
end

-- 获取城区DataTile
function MapService:GetBuildingTownDataTile(tiled)
    return self._logic:_GetBuildingTownDataTile(tiled)
end

function MapService:GetTiledDurableVal(tiled)
    -- body
    return self._logic:_GetTiledDurableVal(tiled);
end

function MapService:GetDataTiled(tiled)
    -- body
    return self._logic:_GetDataTiled(tiled);
end

-- 获取资源地事件父对象
function MapService:GetSourceEventParent()
    -- body
    return self._logic:GetSourceEventParent();
end

-- 加载格子资源信息
function MapService:LoadTiledResource(tiled)
    self._logic:_LoadTiledResource(tiled)
end


-- 是否在放弃土地时间内(true代表在时间内)
function MapService:IsGiveUpTiledInterval(tiled)
    return self._logic:IsGiveUpTiledInterval(tiled)
end

-- 放弃倒计时
function MapService:ShowFortTimeBox(time, tiled, layerType)
    self._logic:ShowFortTimeBox(time, tiled, layerType)
end

function MapService:HideFortTimeBox(tiledId)
    self._logic:HideFortTimeBox(tiledId)
end

-- 是否蓝色呼吸框
function MapService:IsBlueBreathingBox(tiled)
    return self._logic:IsBlueBreathingBox(tiled)
end

function MapService:ShowTiled(tiled, position)
    return self._logic:ShowTiled(tiled, position)
end

function MapService:GetTiledPositionWildFortRedStart(x, y)
    return self._logic:GetTiledPositionWildFortRedStart(x, y)
end

function MapService:ChangeScreenCenter(index)
    self._logic:ChangeScreenCenter(index);
end

function MapService:PmapShowAllTiled(args, fun)
    self._logic:PmapShowAllTiled(args, fun)
end

function MapService:ScanTiledMark(tiledIndex)
    self._logic:ScanTiledMark(tiledIndex)
end

function MapService:BuildingSort(buildingtransform, parent)
    self._logic:BuildingSort(buildingtransform, parent);
end

function MapService:IsFriendTiled(tiled)
    return self._logic:IsFriendTiled(tiled)
end

-- 获取地块屯田收益
function MapService:GetTiledFarmmingAccount(tiled, currencyEnum)
    return self._logic:GetTiledFarmmingAccount(tiled, currencyEnum)
end

function MapService:OnInit()
    self._logic:_OnInit()
end

function MapService:InitLightPos(tiledId)
    self._logic:InitLightPos(tiledId);
end

-- 大地图部队跟随点击时调用
function MapService:ScanTiledPosition(x, y)
    self._logic:ScanTiledPosition(x, y);
end

function MapService:SetChangeBiggerCallBack(callback)
    self._logic:SetChangeBiggerCallBack(callback);
end

function MapService:InitLandNewPosition()
    self._logic:InitLandNewPosition();
end

function MapService:UpdateMyTiledDura(tiledInfo)
    self._logic:UpdateMyTiledDura(tiledInfo);
end

function MapService:GetMyTiledDura(tiledIndex)
    return self._logic:GetMyTiledDura(tiledIndex);
end

function MapService:GetMyTiledMaxDura(tiledIndex)
    return self._logic:GetMyTiledMaxDura(tiledIndex);
end

return MapService;