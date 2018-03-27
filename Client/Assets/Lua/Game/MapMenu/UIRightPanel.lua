--[[
    地块右侧面板
--]]
require("Game/MapMenu/EnumFiles/RequireClickPanelEnum")
local UIType = require("Game/UI/UIType")
local DataUIConfig = require("Game/Table/model/DataUIConfig")
local DataClickPanelType = require("Game/Table/model/DataClickPanelType")
local UnitClickPanelType = require("Game/Map/UnitClickPanelType")
local UIBase = require("Game/UI/UIBase")
local UIRightPanel = class("UIRightPanel", UIBase)

-- 构造函数
function UIRightPanel:ctor()
    UIRightPanel.super.ctor(self)
    
    -- 大图标背板
    self._bigIconBack = nil
    
    -- 按钮列表背板
    self._bottonListBack = nil

    self._buttonClassMap = {}

    self._parent = nil

    self._curLoadMap = {}

    -- 按钮创建标记
    self._btnSign = {}

    self._unitPanelType = nil

end

-- 初始化的时候
function UIRightPanel:OnInit()
    self._unitPanelType = UnitClickPanelType.new()
end

-- 注册控件
function UIRightPanel:DoDataExchange()
    self._bigIconBack = self:RegisterController(UnityEngine.RectTransform,"bigIcon")
    self._bottonListBack = self:RegisterController(UnityEngine.RectTransform,"buttonIconList")
end

-- 注册控件点击事件
function UIRightPanel:DoEventAdd()
    
end

-- 显示
function UIRightPanel:ShowTiled(tiled)
    self.gameObject.transform.localScale = Vector3.New(1.52,1.52,1.52);
    if tiled == nil then
        return
    end
    local myId = PlayerService:Instance():GetPlayerId();
    local myLeagueId = PlayerService:Instance():GetLeagueId();
    local mySuperiorLeagueId = PlayerService:Instance():GetsuperiorLeagueId();
    local tiledOwnerId = 0
    if tiled.tiledInfo ~= nil then
        tiledOwnerId = tiled.tiledInfo.ownerId
    end
    local tiledLeagueId = 0
    if tiled.tiledInfo ~= nil then
        tiledLeagueId = tiled.tiledInfo.leagueId
    end
    local tiledSuperLeagueId = 0
    if tiled.tiledInfo ~= nil then
        tiledSuperLeagueId = tiled.tiledInfo.superiorLeagueId
    end

    local playerAlliesStateType = self._unitPanelType:GetPlayerAlliesStateType(myLeagueId)
    --print(playerAlliesStateType .. "--------------------------")
    local playerOccupyStateType = self._unitPanelType:GetPlayerOccupyStateType(mySuperiorLeagueId)
    --print(playerOccupyStateType .. "--------------------------")
    local tiledOwnerType = self._unitPanelType:GetTiledOwnerType(myId, tiledOwnerId)
    --print(tiledOwnerType .. "--------------------------")
    local tiledAlliesType = self._unitPanelType:GetTiledAlliesType(myId, tiledOwnerId, myLeagueId, mySuperiorLeagueId, tiledLeagueId)
    --print(tiledAlliesType .. "--------------------------")
    local tiledSuperAlliesType = self._unitPanelType:GetTiledSuperAlliesType(myLeagueId, tiledSuperLeagueId)
    --print(tiledSuperAlliesType .. "--------------------------")
    local tiledType = self._unitPanelType:TiledType(tiled)
   
    local buttons = self._unitPanelType:GetButtonList(playerAlliesStateType, playerOccupyStateType, tiledOwnerType, tiledAlliesType, tiledSuperAlliesType, tiledType)
    for k, v in ipairs(buttons) do
        -- print(k .. "++++++++++++++++" .. v)
    end
    --print(playerAlliesStateType .."=".. playerOccupyStateType .."=".. tiledOwnerType .."=".. tiledAlliesType .."=".. tiledSuperAlliesType .."=".. tiledType)
    if buttons == nil then
        -- print(playerAlliesStateType .."=".. playerOccupyStateType .."=".. tiledOwnerType .."=".. tiledAlliesType .."=".. tiledSuperAlliesType .."=".. tiledType)
    end
    for k, v in ipairs(buttons) do
        self:AddButtonToPanel(v, tiled)
    end
end

-- 将Button按钮添加到面板
function UIRightPanel:AddButtonToPanel(buttonNum, tiled)
    if buttonNum == 3 then--屯田
        if NewerPeriodService:Instance():CanMita() == false then
            return;
        end
    elseif buttonNum == 4 then--练兵
        if NewerPeriodService:Instance():CanTrain() == false then
            return;
        end
    elseif buttonNum == 5 then--驻守
        if NewerPeriodService:Instance():CanGarrison() == false then
            return;
        end
    end

    local uiClass = self._buttonClassMap[buttonNum]
    if uiClass == nil then
        if self._btnSign[buttonNum] ~= true then
            self:LoadPrefab(buttonNum, tiled)
        end
    else
        uiClass.transform.gameObject:SetActive(true)
        uiClass:Init()
        uiClass:ShowButton(tiled)
    end
    
end

-- 加载预制
function UIRightPanel:LoadPrefab(buttonNum, tiled)
    local buttonPath = string.format( "UIPrefab/Button%02d", buttonNum )
    local uiClassPath = self:GetButtonUIScript(buttonNum)
    if uiClassPath == nil then
        return
    end
    local uiClass = require(uiClassPath).new()
    if uiClass == nil then
        return
    end
    self:GetParent(buttonNum)
    if self._parent == nil then
        return
    end
    GameResFactory.Instance():GetUIPrefab(buttonPath, self._parent, uiClass, function (resObject)
        uiClass:Init()
        resObject:SetActive(true)
        uiClass:ShowButton(tiled)
        self._buttonClassMap[buttonNum] = uiClass
        self._btnSign[buttonNum] = true
    end)


end

-- 获取到按钮对应脚本
function UIRightPanel:GetButtonUIScript(buttonNum)
    if buttonNum == 1 then
        return DataUIConfig[UIType.UIButton_Battle].ClassName
    elseif buttonNum == 2 then
        return DataUIConfig[UIType.UIButton_Sweep].ClassName
    elseif buttonNum == 3 then
        return DataUIConfig[UIType.UIButton_HoardGrain].ClassName
    elseif buttonNum == 4 then
        return DataUIConfig[UIType.UIButton_Train].ClassName
    elseif buttonNum == 5 then
        return DataUIConfig[UIType.UIButton_Garrison].ClassName
    elseif buttonNum == 6 then
        return DataUIConfig[UIType.UIButton_Transfer].ClassName
    elseif buttonNum == 7 then
        return DataUIConfig[UIType.UIButton_BuildCity].ClassName
    elseif buttonNum == 8 then
        return DataUIConfig[UIType.UIButton_Save].ClassName
    elseif buttonNum == 9 then
        return DataUIConfig[UIType.UIButton_City].ClassName
    elseif buttonNum == 10 then
        return DataUIConfig[UIType.UIButton_Fort].ClassName
    else
        return nil
    end
end


-- 隐藏所有显示的button
function UIRightPanel:HideCurButton()
    for k, v in pairs(self._buttonClassMap) do
        v.transform.gameObject:SetActive(false)
    end
end


-- 获取父物体
function UIRightPanel:GetParent(buttonNum)
    if buttonNum == 7 or buttonNum == 9 or buttonNum == 10 then
        self._parent = self._bigIconBack
    else
        self._parent = self._bottonListBack
    end
end

-- 初始化点击面板类型
function UIRightPanel:InitDataClickPanelType()
    local count = #DataClickPanelType
    for index = 1, count do
        local record = DataClickPanelType[index]
        self:InsertRowRecord(record)
    end
end

return UIRightPanel
