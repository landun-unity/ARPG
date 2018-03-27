-- 点击管理
-- local ClickManage = class("ClickManage")
local ClickType = require("Game/Map/ClickMenu/ClickType")
local GamePart = require("FrameWork/Game/GamePart")
local BreathingFrame = require("Game/MapMenu/UIBreathingFrame")
local ClickManage = class("ClickManage", GamePart);
-- local UIMapNameService:Instance() = require("Game/MapMenu/UIMapNameService:Instance()")
local ChangeRotation = UnityEngine.Vector3(0, 0, 0) -- 大地图拍扁了 所以这个要修正回来

-- 构造函数
function ClickManage:ctor()
    ClickManage.super.ctor(self);
    -- 所有的检查
    self.allClickCheckMap = { };
    -- 所有的类
    self.allClickClassMap = { };
    -- 检查顺序
    self.allClickList = { };
    -- 所有的父亲
    self.UIparent = nil;
    -- 之前显示的UI
    self.curShowUI = nil;
    -- 点击的tiled
    self.ClickTiled = nil;
    -- 位置
    self.pos = nil;

    -- 顶端面板
    self.topPanel = require("Game/MapMenu/UIPanelTop").new()

    -- 右侧面板
    self.rightPanel = require("Game/MapMenu/UIRightPanel").new()

    -- 呼吸框
    self.breathingFrameUIList = {}

    self.breathingFrameUIQueue = Queue.new()

    self._porId = nil;
    self._curId = nil;
end

-- 初始化
function ClickManage:InitUI(UIparent)
    self.UIparent = UIparent;

    -- 所有资源公共显示
    self:RegisterClick(ClickType.PublicType, "UIPublicClick", "UIPublicClick", function(tiled) return self:IsPublic(tiled) end)
    -- 自建要塞
    self:RegisterClick(ClickType.SelfFort, "UIWildeFort", "WildeFort", function(tiled) return self:IsSelfFort(tiled) end);

    -- 在建中建筑物
    self:RegisterClick(ClickType.OnBuilding, "UIOnBuilding", "OnBuilding", function(tiled) return self:IsOnBuildingPlayerFort(tiled) end);

    -- 山川
    self:RegisterClick(ClickType.Moutain, "UIMountain", "mountains", function(tiled) return self:IsMoutain(tiled) end);
    -- 河流
    self:RegisterClick(ClickType.River, "UIRiver", "river", function(tiled) return self:IsRiver(tiled) end)

    -- 分城
    self:RegisterClick(ClickType.PlayerPointsCityBuilding, "CityShow", "UILand", function(tiled) return self:IsPlayerPointsCityBuilding(tiled) end);

    -- 主城中心
    self:RegisterClick(ClickType.PlayerBuilding, "CityShow", "UILand", function(tiled) return self:IsPlayerBuilding(tiled) end);
    -- 主城城区
    self:RegisterClick(ClickType.PlayerTown, "CityShow", "UILand", function(tiled) return self:IsPlayerTown(tiled) end);
    -- 野城中心
    self:RegisterClick(ClickType.WildBuilding, "UIWildCity", "WildCityUI", function(tiled) return self:IsWildBuilding(tiled) end);
    -- 野城城区
    self:RegisterClick(ClickType.WildTown, "UIWildCityTown", "WildCityTownUI", function(tiled) return self:IsWildTown(tiled) end);
    -- 野地
    self:RegisterClick(ClickType.Resource, "UIWildernes", "WildernesUI", function(tiled) return self:IsResource(tiled) end);
    -- 关卡
    -- self:RegisterClick(ClickType.Border, "UICustomsPass", "CustomsPass", function (tiled) return self:IsBorder(tiled) end);
    -- 野外军营
    -- self:RegisterClick(ClickType.WildBarracks, "WildeFortress", "WildeFortress", function (tiled) return self:IsWildBarracks(tiled) end);
    -- 野外要塞
    self:RegisterClick(ClickType.WildFort, "UIWildeFort", "WildeFort", function(tiled) return self:IsWildFort(tiled) end);
    -- 玩家已占领土地
    self:RegisterClick(ClickType.OwnerLand, "UIOneselfSoilObj", "OneselfSoilObj", function(tiled) return self:IsOwnerLand(tiled) end)
    -- 是否其他玩家城池
    self:RegisterClick(ClickType.OtherCity, "UIOthersCity", "OthersCityUI", function(tiled) return self:IsOthersCity(tiled) end)

    self:RegisterClick(ClickType.OtherFort, "UIOthersCity", "OthersCityUI", function(tiled) return self:IsOtherFort(tiled) end)

    self:RegisterClick(ClickType.OtherCityTown, "UIOthersCity", "OthersCityUI", function(tiled) return self:IsOthersCityTown(tiled) end)

    self:RegisterClick(ClickType.OccupyMyCityTown, "UIOthersCity", "OthersCityUI", function(tiled) return self:IsOccupyMyCityTown(tiled) end)

    self:RegisterClick(ClickType.OnSubCity, "CityShow", "UILand", function(tiled) return self:IsOnSubCity(tiled) end);
    -- 是否其他玩家占领城池
    self:RegisterClick(ClickType.OccupyOtherCityTown, "UIOccypyOtherCityTown", "OccupyOtherCityTown", function(tiled) return self:IsOccupyOtherCityTown(tiled) end)

    self:RegisterClick(ClickType.Boat, "UIWildernes", "WildernesUI", function(tiled) return self:IsBoat(tiled) end)

    -- self:RegisterClick(ClickType.CampBoat, "UIWildCity", "WildCityUI", function(tiled) return self:IsCampBoat(tiled) end)
    -- 野外军营
    self:RegisterClick(ClickType.WildMilitaryCamp, "UIWildeFort", "WildeFort", function(tiled) return self:IsWildMilitaryCamp(tiled) end);
    -- 注册顶端面板
    self:InitTopPanel()
    self:InitRightPanel()
    -- self:InitBreathingFrame();
    -- 是否是野外要塞
    self:RegisterClick(ClickType.OccupyWildFort, "UIOthersCity", "OthersCityUI", function(tiled) return self:IsOccupyFort(tiled) end)

    -- 是否是野外军营
    self:RegisterClick(ClickType.NoOccupyWildMilitaryCamp, "UIOthersCity", "OthersCityUI", function(tiled) return self:IsOccupyWildMilitaryCamp(tiled) end)

   -- self:RegisterClick(ClickType.DerelictionWildFort, "UIOthersCity", "OthersCityUI", function(tiled) return self:IsDerelictionWildFort(tiled) end)
end

function ClickManage:InitBreathingFrame()
    -- GameResFactory.Instance():GetUIPrefab("Map/TileImage", self.UIparent, self.breathingframe, function(go)
    --     self.breathingframe:Init();
    --     UIService:Instance():AddUI(UIType.UIBreathingFrame,self.breathingframe);
    --     go:SetActive(false);
    -- end );
end

-- 注册检查
function ClickManage:RegisterClick(clickType, clickClass, clickPrefab, clickFunction)
    if clickType == nil or clickClass == nil then
        return;
    end
    self.allClickCheckMap[clickType + 1] = clickFunction;
    self.allClickClassMap[clickType + 1] = require("Game/MapMenu/" .. clickClass).new();
    UIService:Instance():AddClickUI(self.allClickClassMap[clickType + 1]);
    GameResFactory.Instance():GetUIPrefab("UIPrefab/" .. clickPrefab, self.UIparent, self.allClickClassMap[clickType + 1], function(go)
        self.allClickClassMap[clickType + 1]:Init();
        go:SetActive(false);
    end );

    local count = #self.allClickList;
    self.allClickList[count + 1] =(clickType + 1);

end

function ClickManage:GetTopPanel()
    return self.topPanel;
end

-- 注册顶端面板
function ClickManage:InitTopPanel()
    UIService:Instance():AddClickUI(self.topPanel);
    GameResFactory.Instance():GetUIPrefab("UIPrefab/PanelTop", self.UIparent, self.topPanel, function(go)
        self.topPanel:Init();
        -- go.transform.localPosition = Vector3.New(self.pos.x, self.pos.y + 200, 0)
        go:SetActive(false);
    end )
end

-- 注册右侧面板
function ClickManage:InitRightPanel()
    UIService:Instance():AddClickUI(self.rightPanel);
    GameResFactory.Instance():GetUIPrefab("UIPrefab/PanelRight", self.UIparent, self.rightPanel, function(go)
        self.rightPanel:Init();
        go:SetActive(false);
    end )
end

-- 点击野城
function ClickManage:ClickWildBuilding()
    local clickType = ClickType.WildBuilding
    local clickClass = "UIWildCity"
    local clickPrefab = "WildCityUI"
    local clickFunction = function(tiled) return self:IsWildBuilding(tiled) end
    self.allClickCheckMap[clickType + 1] = clickFunction;
    self.allClickClassMap[clickType + 1] = require("Game/MapMenu/" .. clickClass).new();
    UIService:Instance():AddClickUI(self.allClickClassMap[clickType + 1]);
    GameResFactory.Instance():GetUIPrefab("UIPrefab/" .. clickPrefab, self.UIparent, self.allClickClassMap[clickType + 1], function(go)
        self.allClickClassMap[clickType + 1]:Init();
        go:SetActive(false);
    end );

    local count = #self.allClickList;
    self.allClickList[count + 1] =(clickType + 1);


end



-- 显示格子
function ClickManage:ShowTiled(tiled, postion)
    if tiled == nil or postion == nil then
        return;
    end

    self:HideUIBreathingFrame();
    self:ShowBreathingFrame(postion, tiled);

    local curTiled = tiled
    local curPosition = postion

    if self:IsChildBoat(tiled) then
        local childBoat = tiled._childBoat
        local boat = childBoat:GetBuilding()
        local index = boat._tiledId
        curTiled = MapService:Instance():GetTiledByIndex(index)
        curPosition = MapService:Instance():GetTiledPositionByIndex(index)
    end

    if self.ClickTiled ~= nil and self.ClickTiled._index ==  curTiled._index then
        return;
    end
    if self.ClickTiled ~= nil then
        CommonService:Instance():ClearLastClickTileUI();
    end
    self.ClickTiled = curTiled;

    for i, v in pairs(self.allClickList) do
        if self:CanShow(v, curTiled) then
            self:HideTiled(true);
            self.allClickClassMap[ClickType.PublicType + 1].transform.localPosition = postion;
            self.allClickClassMap[ClickType.PublicType + 1].transform.eulerAngles = ChangeRotation;
            self.allClickClassMap[ClickType.PublicType + 1].transform.gameObject:SetActive(true);
            self.allClickClassMap[ClickType.PublicType + 1]:ShowTiled(curTiled);
            if v == ClickType.PlayerBuilding + 1 or
                v == ClickType.WildBuilding + 1 or
                v == ClickType.OnBuilding + 1 or
                v == ClickType.SelfFort + 1 or
                v == ClickType.WildFort + 1 or
                v == ClickType.OtherCity + 1 or 
                v == ClickType.OtherFort + 1 or 
                v == ClickType.OtherWildFort + 1 or 
                v == ClickType.DerelictionWildFort + 1 or
                v == ClickType.OccupyWildFort + 1 or 
                v == ClickType.Boat + 1 then
                self:_ShowCityName(curTiled);
            else
                self:_HideCityName();
            end
            
            if i == 9 then
                self.pos = curPosition
                LeagueService:Instance():SendRequestOccupyLeagueInfo(curTiled:GetIndex())
                return;
            end

            self:RealShowTiled(curTiled, curPosition, v);
            return;
        end
    end
end

-- 是否可以显示
function ClickManage:CanShow(clickType, tiled)
    if clickType == nil or self.allClickCheckMap[clickType] == nil or self.allClickClassMap[clickType] == nil then
        return false;
    end
    return self.allClickCheckMap[clickType](tiled);
end

-- 显示格子
function ClickManage:RealShowTiled(tiled, postion, clickType)   
    if tiled == nil and postion == nil and clickType == nil then
        tiled = self.ClickTiled
        postion = self.pos
        clickType = self.allClickList[9]
    end
    local clickUI = self.allClickClassMap[clickType];
    if clickUI == nil then
        return;
    end
    local issourceevent = SourceEventService:Instance():isSourceEvent(tiled._x, tiled._y);
    -- 是资源地事件
    clickUI:ShowTiled(tiled, issourceevent);
    if self:IsMoutain(tiled) == true or self:IsRiver(tiled) == true then
        clickUI.transform.localPosition = Vector3.New(postion.x, postion.y + 250, 0)
    else
        clickUI.transform.localPosition = postion;
    end
    clickUI.transform.eulerAngles = ChangeRotation;
    --clickUI.transform.gameObject:SetActive(true);
    CommonService:Instance():SetTweenAlphaGameObject(clickUI.transform.gameObject,true,tiled._index,false,0,0,0,function()end,true,1.42,1.52,0.1)

    if self:IsPlayerTown(tiled) == true or self:IsPlayerBuilding(tiled) == true or self:IsOwnerLand(tiled) == true or self:IsSelfFort(tiled) == true or self:IsWildFort(tiled) == true or self:IsWildMilitaryCamp(tiled) == true then
        self.topPanel:ShowTiled(tiled)
        self.topPanel.transform.localPosition = Vector3.New(postion.x, postion.y + 250, 0)
        self.topPanel.transform.eulerAngles = ChangeRotation;
        self.curShowUI = clickUI;
        if (issourceevent ~= nil) then
            self.topPanel.transform.gameObject:SetActive(false);
        else
            --self.topPanel.transform.gameObject:SetActive(true);
            CommonService:Instance():SetTweenAlphaGameObject(self.topPanel.transform.gameObject,true,tiled._index,false,0,0,0,function()end,true,1.42,1.52,0.1)
        end
    elseif self:IsMoutain(tiled) == true or self:IsRiver(tiled) == true then
        self.curShowUI = clickUI;
    else
        self.topPanel:ShowTiled(tiled)
        self.topPanel.transform.localPosition = Vector3.New(postion.x, postion.y + 250, 0)
        self.topPanel.transform.eulerAngles = ChangeRotation;
        --self.topPanel.transform.gameObject:SetActive(true);
        CommonService:Instance():SetTweenAlphaGameObject(self.topPanel.transform.gameObject,true,tiled._index,false,0,0,0,function()end,true,1.42,1.52,0.1)
        self.curShowUI = clickUI;
        self.rightPanel:ShowTiled(tiled)
        self.rightPanel.transform.localPosition = postion;
        self.rightPanel.transform.eulerAngles = ChangeRotation;
        --self.rightPanel.transform.gameObject:SetActive(true);
        CommonService:Instance():SetTweenAlphaGameObject(self.rightPanel.transform.gameObject,true,tiled._index,false,0,0,0,function()end,true,1.42,1.52,0.1)
    end
end

-- 显示呼吸框
function ClickManage:ShowBreathingFrame(postion, tiled)
    if self:IsChildBoat(tiled) then
        local childBoat = tiled._childBoat
        local boat = childBoat:GetBuilding()
        local index = boat._tiledId
        local boatTiled = MapService:Instance():GetTiledByIndex(index)
        local boatPosition = MapService:Instance():GetTiledPositionByIndex(index)
        self:ShowUIBreathingFrame(postion, tiled)
        self:ShowUIBreathingFrame(boatPosition, boatTiled)
    elseif self:IsBoat(tiled) or self:IsCampBoat(tiled) then
        local building = tiled._building
        local childBoat = building._childBoat
        if childBoat == nil then
            return
        end
        local index = childBoat._index
        local childBoatTiled = MapService:Instance():GetTiledByIndex(index)
        local childBoatPosition = MapService:Instance():GetTiledPositionByIndex(index)
        self:ShowUIBreathingFrame(postion, tiled)
        self:ShowUIBreathingFrame(childBoatPosition, childBoatTiled)
    else
        self:ShowUIBreathingFrame(postion, tiled)
    end
end

-- 显示呼吸框
function ClickManage:ShowUIBreathingFrame(postion, tiled)
    if self.breathingFrameUIQueue:Count() ~= 0 then
        local breathingFrameUI = self.breathingFrameUIQueue:Pop()
        table.insert(self.breathingFrameUIList, breathingFrameUI) 
        self:SetBreathingFrame(breathingFrameUI, tiled, postion)
    else
        local breathingFrameUI = BreathingFrame.new()
        GameResFactory.Instance():GetUIPrefab("Map/TileImage", self.UIparent, breathingFrameUI, function(go)
            breathingFrameUI:Init()
            UIService:Instance():AddUI(UIType.UIBreathingFrame,breathingFrameUI)
            go:SetActive(false)
        end )
        table.insert(self.breathingFrameUIList, breathingFrameUI) 
        self:SetBreathingFrame(breathingFrameUI, tiled, postion)
    end
    
end

-- 设置呼吸框
function ClickManage:SetBreathingFrame(breathingFrameUI, tiled, postion)
    breathingFrameUI.transform.localPosition = postion;
    breathingFrameUI:OnShow(tiled);
    if breathingFrameUI.transform.gameObject.activeSelf == false then
        breathingFrameUI.transform.gameObject:SetActive(true);
    end
end



function ClickManage:ShowUIBreathingFrameByIndex(tiled, index)
    -- if index ~= nil then
    --     self.breathingframe.transform.localPosition = MapService:Instance():GetTiledPositionByIndex(index)
    -- end
    -- self.breathingframe:OnShow(tiled);
    -- if self.breathingframe.transform.gameObject.activeSelf == false then
    --     self.breathingframe.transform.gameObject:SetActive(true);
    -- end
end

function ClickManage:HideUIBreathingFrame()
    for i = 1, #self.breathingFrameUIList do
        local breathingFrameUI = self.breathingFrameUIList[i]
        breathingFrameUI:HideTiledImage();
        if breathingFrameUI.transform.gameObject.activeSelf == true then
            breathingFrameUI.transform.gameObject:SetActive(false);
        end
        self.breathingFrameUIQueue:Push(breathingFrameUI)
    end
    self:ClearBreathingFrameList()
end

-- 清空呼吸框
function ClickManage:ClearBreathingFrameList()
    for i = #self.breathingFrameUIList , 1, -1  do
        table.remove(self.breathingFrameUIList, i)
    end
end


--返回当当前UIClass
function ClickManage:GetCurClickUI(pos)
    return self.allClickClassMap[ClickType.PublicType+1]:SetDetialPos(pos);
end


-- 隐藏
function ClickManage:HideTiled(isClear)    
    if self.curShowUI == nil then
        return;
    end
    if isClear == nil then
        self.ClickTiled = nil;
    end
    self.allClickClassMap[ClickType.PublicType + 1].transform.gameObject:SetActive(false);
    self.allClickClassMap[ClickType.PublicType + 1]:HideTiled();
    self.curShowUI.transform.gameObject:SetActive(false);
    self.topPanel.transform.gameObject:SetActive(false);
    self.rightPanel.transform.gameObject:SetActive(false);
    self.rightPanel:HideCurButton()
    self:_HideCityName();
end

-- 是否是野城
function ClickManage:IsWildBuilding(tiled)
    if tiled._building == nil or tiled._building._dataInfo == nil then
        return false;
    end
    if tiled:GetTown() ~= nil then
        return false
    end

    if tiled._building._dataInfo == nil then
        return false
    end
    
    if tiled._building._dataInfo.Type == BuildingType.WildBuilding then
        return true
    end

    if tiled._building._dataInfo.Type == BuildingType.LevelShiYi then
        return true
    end

    if tiled._building._dataInfo.Type == BuildingType.LevelBoat then
        return true
    end

    return false
end

-- 是否是野城城区
function ClickManage:IsWildTown(tiled)
    if tiled:GetTown() == nil then
        return false;
    end
    return tiled:GetTown()._building._dataInfo.Type == BuildingType.WildBuilding
end

-- 是否是野外军营
function ClickManage:IsWildBarracks(tiled)
    if tiled:GetWildBarracks() == nil or tiled:GetWildBarracks()._wildBarracks == nil then
        return false;
    end

    return tiled:GetWildBarracks()._wildBarracks._dataInfo ~= BuildingType.MainCity and tiled:GetWildBarracks()._wildBarracks._dataInfo ~= BuildingType.SubCity;
end

-- -- 是否是野外要塞
-- function ClickManage:IsWildFort(tiled)
--     if tiled:GetFort() == nil or tiled:GetFort()._fort == nil then
--         --print("11111111111111111111111")
--         return false;
--     end
-- 是否是野外要塞
function ClickManage:IsWildFort(tiled)
    if tiled:GetBuilding() == nil then
        return false;
    end

    if tiled._town ~= nil then
        return
    end
    if tiled:GetBuilding()._dataInfo.Type ~= BuildingType.WildFort then
        return false;
    end
    if tiled:GetBuilding()._owner ~= PlayerService:Instance():GetPlayerId() then
        return false
    end
    return true;
end

function ClickManage:IsWildMilitaryCamp(tiled)
    if tiled:GetBuilding() == nil then
        return false;
    end
    if tiled._town ~= nil then
        return
    end
    if tiled:GetBuilding()._dataInfo.Type ~= BuildingType.WildGarrisonBuilding then
        return false;
    end
    if tiled:GetBuilding()._owner ~= PlayerService.Instance():GetPlayerId() then
        return false
    end
    return true;
end

--     return tiled:GetFort()._fort._dataInfo ~= BuildingType.MainCity and tiled:GetFort()._fort._dataInfo ~= BuildingType.SubCity;
-- end

-- function ClickManage:( ... )
--     -- body
-- end


-- 是否是自建要塞
function ClickManage:IsSelfFort(tiled)
    if tiled._building == nil or tiled._building._dataInfo == nil then
        return false;
    end
    if tiled:GetTown() ~= nil then
        return false
    end
    if tiled.tiledInfo == nil then
        return false
    end
    -- --print(tiled.tiledInfo.ownerId .. "=====================" .. PlayerService:Instance():GetPlayerId())
    if tiled.tiledInfo.ownerId ~= PlayerService:Instance():GetPlayerId() then
        return false
    end
    -- if tiled._building._dataInfo.Type == BuildingType.WildBuilding or tiled._building._dataInfo.Type == BuildingType.MainCity or tiled._building._dataInfo.Type == BuildingType.SubCity then
    --     return false
    -- end
    if tiled._building._dataInfo.Type ~= BuildingType.PlayerFort then
        return false
    end
    -- print("我看这里是不是空 == " .. PlayerService:Instance():GetLocalTime() .. "=====" .. tiled._building._buildSuccessTime)
    if tiled:GetBuilding()._buildSuccessTime >= PlayerService:Instance():GetLocalTime() then
        return false
    end
    -- --print("这里是要塞。。。。。")
    return tiled._building._dataInfo.Type == BuildingType.PlayerFort;
end

-- 是否其他玩家要塞
function ClickManage:IsOtherFort(tiled)
    if tiled._building == nil or tiled._building._dataInfo == nil then
        return false;
    end

    if tiled.tiledInfo == nil then
        return;
    end

    if tiled.tiledInfo.ownerId == PlayerService:Instance():GetPlayerId() then
        return false
    end
    -- if tiled._building._dataInfo.Type == BuildingType.WildBuilding or tiled._building._dataInfo.Type == BuildingType.MainCity or tiled._building._dataInfo.Type == BuildingType.SubCity then
    --     return false
    -- end
    return tiled._building._dataInfo.Type == BuildingType.PlayerFort
end

-- 是否是资源
function ClickManage:IsResource(tiled)
    if tiled._building ~= nil then
        return false;
    end
    if tiled:GetTown() ~= nil then
        return false;
    end
    if tiled.tiledInfo == nil or tiled.tiledInfo.ownerId ~= PlayerService:Instance():GetPlayerId() then
        return(tiled:GetResource() ~= nil);
    end
    return false;
end

-- 是否是山
function ClickManage:IsMoutain(tiled)
    local moutainImage = tiled:GetImageId(LayerType.Moutain);
    if moutainImage == nil or type(moutainImage) ~= "number" or moutainImage <= 0 then
        return false;
    end
    return true;
end

-- 是否是边界
function ClickManage:IsBorder(tiled)
    return true;
end

-- 是否是可同盟标记位置
function ClickManage:IsPublic(tiled)

    if self:IsMoutain(tiled) == true or self:IsRiver(tiled) == true then
        return false
    end

    return false

end


-- 是否是河流
function ClickManage:IsRiver(tiled)
    if tiled._childBoat ~= nil or tiled._building ~= nil then
        return false
    end
    local riverImage = tiled:GetImageId(LayerType.Land);
    -- --print(moutainImage);
    -- if moutainImage == nil or type(moutainImage) ~= "number" or (moutainImage ~= 24 and moutainImage ~= 25 ) then
    --     return false;
    -- end
    if riverImage == nil or type(riverImage) ~= "number" then
        return false
    end
    if riverImage < 6 or riverImage > 25 then
        return false
    end
    return true;
end

-- 是否是玩家建筑物
function ClickManage:IsPlayerBuilding(tiled)
    if tiled._building == nil or tiled._building._dataInfo == nil then
        return false;
    end
    if tiled:GetTown() ~= nil then
        return false
    end
    if tiled.tiledInfo == nil then
        return false
    end
    -- --print(tiled.tiledInfo.ownerId .. "=====================" .. PlayerService:Instance():GetPlayerId())
    if tiled.tiledInfo.ownerId ~= PlayerService:Instance():GetPlayerId() then
        return false
    end
    if tiled._building._dataInfo.Type == BuildingType.WildBuilding then
        return false
    end
    if tiled._building._dataInfo.Type == BuildingType.PlayerFort then
        return false
    end
    -- --print("这里是万家城。。。。。")
    return tiled._building._dataInfo.Type == BuildingType.MainCity or tiled._building._dataInfo.Type == BuildingType.SubCity;
end

-- 是否是玩家分城
function ClickManage:IsPlayerPointsCityBuilding(tiled)
    -- if tiled._building == nil or tiled._building._dataInfo == nil then
    --     return false;
    -- end
    -- return tiled._building._dataInfo.Type == BuildingType.MainCity or tiled._building._dataInfo.Type == BuildingType.SubCity;

    -- if tiled._building == nil or tiled._building._dataInfo == nil then
    --     return false;
    -- end
    -- --print(tiled.tiledInfo.ownerId .. "=====================" .. PlayerService:Instance():GetPlayerId())
    -- return tiled._building._dataInfo.Type == BuildingType.MainCity or tiled._building._dataInfo.Type == BuildingType.SubCity;
    -- return false
end


-- 是否是玩家城区
function ClickManage:IsPlayerTown(tiled)

    if tiled:GetTown() == nil or tiled:GetTown()._building == nil then
        return false;
    end
    -- --print("IsPlayerTown...")
    -- if tiled._building == nil then
    --     return false
    -- end
    -- -- --print("IsPlayerTown...")
    -- if tiled._building._dataInfo == nil then
    --     return false;
    -- end
    -- --print("IsPlayerTown...")
    if tiled.tiledInfo == nil then
        return false
    end
    -- --print("IsPlayerTown...")
    if tiled.tiledInfo.ownerId ~= PlayerService:Instance():GetPlayerId() then
        return false
    end
    -- --print("IsPlayerTown...")
    if tiled:GetTown()._building:GetIndex() ~= PlayerService:Instance():GetMainCityTiledId() then
        -- return false
    end

    if PlayerService:Instance():IsMyCity(tiled:GetTown()._building:GetIndex()) == false then
        return false
    end

    -- --print("IsPlayerTown...")
    -- --print(tiled._building._dataInfo.Type .. "====" .. BuildingType.MainCity)
    -- --print(tiled._building._dataInfo.Type .. "====" .. BuildingType.SubCity)
    return tiled:GetTown()._building._dataInfo.Type == BuildingType.MainCity or tiled:GetTown()._building._dataInfo.Type == BuildingType.SubCity;
end

-- 是否是玩家已占领的土地
function ClickManage:IsOwnerLand(tiled)
    if tiled.tiledInfo == nil then
        return false
    end
    if tiled:GetTown() ~= nil then
        return false
    end
    if tiled:GetBuilding() ~= nil then
        return false
    end
    if tiled:GetFortStete() == true then
        return false
    end
    -- --print("IsOwnerLand")
    return tiled.tiledInfo.ownerId == PlayerService:Instance():GetPlayerId()
end

-- 是否其他玩家城池
function ClickManage:IsOthersCity(tiled)
    -- --print(tiled:GetTown())
    if tiled.tiledInfo == nil then
        return false
    end
    if tiled._building == nil then
        return false
    end
    -- --print(tiled:GetTown())
    if tiled:GetTown() ~= nil then
        return false
    end
    -- --print(tiled:GetTown())
    if tiled.tiledInfo.ownerId == PlayerService:Instance():GetPlayerId() then
        return false
    end
    if tiled._building._dataInfo == nil then
        return false
    end
    return tiled._building._dataInfo.Type == BuildingType.MainCity or tiled._building._dataInfo.Type == BuildingType.SubCity
end

-- 是否其他玩家城池
function ClickManage:IsOthersCityTown(tiled)
    if tiled.tiledInfo == nil then
        return false
    end
    if tiled.tiledInfo.ownerId == PlayerService:Instance():GetPlayerId() then
        return false
    end
    if tiled:GetTown() == nil then
        return false
    end
    if PlayerService:Instance():IsMyCity(tiled:GetTown()._building:GetIndex()) == true then
        return false
    end

    return tiled:GetTown()._building._dataInfo.Type == BuildingType.MainCity or tiled:GetTown()._building._dataInfo.Type == BuildingType.SubCity
end


-- 是否是野外要塞
function ClickManage:IsOccupyFort(tiled)

    if tiled:GetBuilding() == nil then
        return false
    end
    -- if tiled.tiledInfo == nil then
    --     return false
    -- end
    if tiled:GetBuilding()._owner == PlayerService:Instance():GetPlayerId() then
        return false
    end
    if tiled:GetBuilding()._dataInfo.Type ~= BuildingType.WildFort then
        return false
    end
    return true
end

--是否是野外军营
function ClickManage:IsOccupyWildMilitaryCamp(tiled)
    print(tiled:GetBuilding())
    print(tiled:GetBuilding()._owner   .. "@@" ..PlayerService:Instance():GetPlayerId())
    print(tiled:GetBuilding()._dataInfo.Type)
    print(BuildingType.WildGarrisonBuilding)
    if tiled:GetBuilding() == nil then
        return false
    end

    if tiled:GetBuilding()._owner == PlayerService:Instance():GetPlayerId() then
        return false
    end
    if tiled:GetBuilding()._dataInfo.Type ~= BuildingType.WildGarrisonBuilding then
        return false
    end
    return true
end

function ClickManage:IsOnSubCity(tiled)
    if tiled:GetBuilding() ~= nil then
        return false
    end
    if tiled:GetTown() == nil then
        return false
    end
    if tiled:GetTown()._building._dataInfo.Type ~= BuildingType.SubCity then
        return false
    end
    if tiled:GetTown()._building._subCitySuccessTime < PlayerService:Instance():GetLocalTime() then
        return false
    end
    return true
end


-- 是否是已被占领的其他玩家城区
function ClickManage:IsOccupyOtherCityTown(tiled)
    if tiled:GetTown() == nil then
        return false
    end
    if tiled:GetTown()._building:GetIndex() == PlayerService:Instance():GetMainCityTiledId() then
        return false
    end
    if tiled.tiledInfo == nil then
        return false;
    end
    return tiled.tiledInfo.ownerId == PlayerService:Instance():GetPlayerId()
end

-- 是否在建中建筑物
function ClickManage:IsOnBuildingPlayerFort(tiled)
    if tiled:GetBuilding() == nil then
        return false
    end
    if tiled:GetBuilding()._dataInfo.Type ~= BuildingType.PlayerFort then
        return false
    end
    if tiled:GetBuilding()._buildSuccessTime < PlayerService:Instance():GetLocalTime() then
        return false
    end
    -- --print("IsOnBuildingPlayerFort++++++++++++++++++++++")
    return true
end

function ClickManage:_ShowName(buildingid)
    self._porId = buildingid;
    UIMapNameService:Instance():FindItem(self._porId).gameObject:SetActive(true);
end

function ClickManage:_HideName(buildingid)
    --print("aaaaaaaaaaaaaaaaaaaaaa"..buildingid)
    self._porId = buildingid;
    -- --print("aaaaaaaaaaaaaaaaaaaaaa"..self._porId)
    local item = UIMapNameService:Instance():FindItem(self._porId)
    if item ~= nil then
        item.gameObject:SetActive(false);
    end

end

function ClickManage:_ShowCityName(tiled)
    if tiled == nil then
        return;
    end
    local building = nil;
    if tiled:GetBuilding() == nil then
        building = tiled:GetTown()._building;
    else
        building = tiled:GetBuilding();
    end

    self._curId = building._id;

    if self._porId == nil then
    else
        self:_ShowName(self._porId);
    end
    self:_HideName(self._curId);
end

function ClickManage:_HideCityName()
    if self._porId ~= nil then
        local item = UIMapNameService:Instance():FindItem(self._porId)
        if item ~= nil then
            item.gameObject:SetActive(true);
        end
        self._porId = nil;
    end
end

-- 是否是被占领的我的城区
function ClickManage:IsOccupyMyCityTown(tiled)
    if tiled:GetBuilding() ~= nil then
        return false
    end
    if tiled:GetTown() == nil then
        return false
    end
    if tiled.tiledInfo == nil then
        return false
    end
    if tiled.tiledInfo.ownerId == PlayerService:Instance():GetPlayerId() then
        return false
    end
    if PlayerService:Instance():IsMyCity(tiled:GetTown()._building:GetIndex()) == false then
        return false
    end
    return true
end

-- 是否码头
function ClickManage:IsBoat(tiled)
    -- print("isBoatOut===============")
    local building = tiled:GetBuilding()
    if building ~= nil and building._dataInfo ~= nil then
        if building._dataInfo.Type == BuildingType.Boat then
            -- print("isBoatIn===============")
            return true
        end
    end
    return false
end

-- 是否关卡码头
function ClickManage:IsCampBoat(tiled)
    -- print("isCampBoatOut===============")
    local building = tiled:GetBuilding()
    if building ~= nil and building._dataInfo ~= nil then
        if building._dataInfo.Type == BuildingType.LevelBoat then
            -- print("isCampBoatIn===============")
            return true
        end
    end
    return false
end

-- 是否子码头
function ClickManage:IsChildBoat(tiled)
    -- print("isChildBoatOut===============")
    local childBoat = tiled._childBoat
    if childBoat ~= nil then
        -- print("isChildBoatIn===============")
        return true
    end
    return false
end


return ClickManage;