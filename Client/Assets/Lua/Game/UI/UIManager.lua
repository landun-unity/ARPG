

--[[
   Name:  uimanager类
   anchor:Dr
   Data:16/9/7
   注意：如果uibese文件位置变了，需要修改本类LoadPerfab函数
--]]


-- 加载表
local UIConfigTable = require("Game/Table/model/DataUIConfig");
local UIBase = require("Game/UI/UIBase");
local List = require("common/List");
local GamePart = require("FrameWork/Game/GamePart");
local UIManager = class("UIManager", GamePart);
-- local UILevelInfo=require("UI/UILevelInfo");

-- 构造函数
function UIManager:ctor()
    -- body

    UIManager.super.ctor(self);
    self.curCanvas = nil;
    self._totalParentObj = nil;
    self.commonBlackBg = { };
    self._allClickUI = { };
    self:InitConfig();
    self:Clear();
    self._AddMainUI = { };
    self.UpUI = { };
    self.ScaleDic = { };
    -- 字典 存取缩放的向量
    self.marchTimer = { };
    -- 字典 存放透明度的缩放
    self.fortImageName = { }
    self.isLogin = false
    self._allUIObject = { };
    self.allPrefabUiBase = { };
end

-- 查找Canvas
function UIManager:InitConfig()
    local ui_layer_go = UGameObject.Find("Canvas");
    self.curCanvas = ui_layer_go;
    self._totalParentObj = ui_layer_go.transform;
end

-- 获取Canvas 组件
function UIManager:GetUIRootCanvas()
    return self.curCanvas:GetComponent(typeof(UnityEngine.Canvas));
end

-- 心跳 
function UIManager:_OnHeartBeat()
    -- body
    -- print("uimanager 心跳");
    -- print("_allUIObject.size() ===== :"..#self._allUIObject);
    if (self._allUIObject ~= nil) then
        -- print("_allUIObject.size() ===== :"..#self._allUIObject);
        for i, v in pairs(self._allUIObject) do
            v:_OnHeartBeat();
            -- print("uimanager 心跳    zhe zou bu zou ");
        end
    end

    if self.allPrefabUiBase ~= nil then
        for i, v in pairs(self.allPrefabUiBase) do
            for j, k in pairs(v) do
                k:_OnHeartBeat();
            end
        end
    end
end

---- 单例
-- function UIManager:Instance()
--    -- body
--    if self._instance == nil then
--        -- body
--        self._instance = UIManager.new();
--    end

--    return self._instance;
-- end

function UIManager:SetIslogin(args)
    self.isLogin = args
end

function UIManager:GetIsLogin()
    return self.isLogin
end

-- 初始化
function UIManager:InitUI(_uiType)

    local mUIBase = nil;
    if UIConfigTable[_uiType] then
        mUIBase = UIConfigTable[_uiType];
    end

    local parentObj = self:AddUIPanel(_uiType, mUIBase.Level, mUIBase.Depth);
    if self:ExitUI(_uiType) == false then
        self:CreateInitUI(_uiType, parentObj, mUIBase);
    else
    end

end

function UIManager:ClearcommonBlackBg()
    self.commonBlackBg = { }
end

-- 初始化加载UI通用灰色背景板
function UIManager:LoadCommonBlackBg(uiType, parentObj)
    local parent = nil;
    if parentObj == nil then
        parent = self._totalParentObj;
    else
        parent = parentObj;
    end
    if self.commonBlackBg[uiType] == nil then
        GameResFactory.Instance():GetResourcesPrefab("UIPrefab/CommonBlackBackground", parent,
        function(go)
            self.commonBlackBg[uiType] = go;
            self.commonBlackBg[uiType]:SetActive(true);
        end
        );
    else
        self.commonBlackBg[uiType].transform.parent = parent;
        self.commonBlackBg[uiType]:SetActive(true);
    end
end

-- 显示ui callBack参数为打开页面放大到最大后的回调
function UIManager:ShowUI(_uiType, parem, callBack)
    local mUIBase = nil;
    if UIConfigTable[_uiType] then
        mUIBase = UIConfigTable[_uiType];
    end

    local parentObj = self:AddUIPanel(_uiType, mUIBase.Level, mUIBase.Depth);

    -- 没有就创建
    if self:ExitUI(_uiType) == false then
        self:CreateUI(_uiType, parentObj, mUIBase, parem, callBack);
    else
        self:ShowVisible(_uiType, mUIBase.Mutex, parem, callBack);
    end

    -- 需要的打开通用背景板
    if self.isLogin == true and UIConfigTable[_uiType].ShowBackground ~= 0 then
        local levelObj = self:GetLevelObject(UIConfigTable[_uiType].Level);
        local bgDepth =(UIConfigTable[_uiType].Depth - 1) > 0 and(UIConfigTable[_uiType].Depth - 1) or 0;
        local bgDepthObj = self:GetDepth(levelObj.gameObject, bgDepth);
        if bgDepthObj ~= nil then
            self:LoadCommonBlackBg(_uiType, bgDepthObj);
        end
    end

    -- 友盟统计页面
    if UIConfigTable[_uiType] then
        GA.PageBegin(UIConfigTable[_uiType].ID .. "_" .. UIConfigTable[_uiType].Name);
    end
end

-- 隐藏UI
function UIManager:HideUI(_uiType, _parem,beforDestroyCall)
    local uiClass = self:GetUIClass(_uiType);
    if uiClass ~= nil  then
        -- uiClass:SetVisible(false, parem);

        -- 通用背景板打开的需要关闭
        if self.isLogin == true then
            if self.commonBlackBg[_uiType] ~= nil and UIConfigTable[_uiType].ShowBackground ~= 0 then
                if self.commonBlackBg[_uiType] then
                   self.commonBlackBg[_uiType]:SetActive(false);
                end
            end
        end
        self:PlayHide(uiClass, _uiType, _parem,beforDestroyCall);

        -- 友盟统计页面
        if UIConfigTable[_uiType] then
            GA.PageEnd(UIConfigTable[_uiType].ID .. "_" .. UIConfigTable[_uiType].Name);
        end
    end
end

function UIManager:ShowVisible(_uiType, Mutex, parem, callBack)
    self:HideMutexUI(_uiType, Mutex);
    self:PlayShow(_uiType, parem, callBack)
end

-- 隐藏互斥界面
function UIManager:HideMutexUI(_uiType, _mutexList)
--    if _mutexList == nil then
--        -- print("UIMutexLIst is nil")
--        return;
--    end
--    for k, v in pairs(_mutexList) do
--        local mUIType = v;
--        local uiClass = self:GetUIClass(mUIType);
--        if uiClass then
--            uiClass:SetVisible(_uiType,false, parem);
--        end
--    end
end

-- 获取到lua类
function UIManager:GetUIClass(_uiType)
    if self._allUIObject[_uiType] then
        return self._allUIObject[_uiType];
    end
    return nil;
end

-- 注意，如果表头不是为classname要修改此处
function UIManager:CreateUI(_uiType, _parentObj, mUIBase, parem, callBack)

    -- --print("uitype:".._uiType);	
    local path = mUIBase.ResourcePath;
    local _className = mUIBase.ClassName;

    local mMutex = mUIBase.Mutex;

    self:LoadPerfabFile(path, _className, _parentObj, _uiType, mMutex, parem, callBack);

end

-- 注意：如果uibese文件位置变了，需要修改
-- 加载预制并初始化类
function UIManager:LoadPerfabFile(_perfabPath, _calsName, _parentObj, _uiType, mMutex, parem, callBack)
    -- 找到界面的类
    local uiBase = require(_calsName).new();
    GameResFactory.Instance():GetUIPrefab("UIPrefab/" .. _perfabPath, _parentObj.transform, uiBase, function(go)
        if self._allUIObject[_uiType] == nil then
            self._allUIObject[_uiType] = uiBase;
        end
        self:LoadPrefabCallBack(uiBase, _uiType, mMutex, parem, callBack);
    end );
end

function UIManager:LoadPrefabCallBack(uiBase, _uiType, mMutex, parem, callBack)
    if uiBase == nil then
        return;
    end
    uiBase:Init();
    self:ShowVisible(_uiType, mMutex, parem, callBack);
end

-- 显示UI动画
function UIManager:PlayShow(_uiType, parem, callBack)
    local uiClass = self:GetUIClass(_uiType);
    uiClass:SetVisible(_uiType,true, parem);

    local Scaltime = UIConfigTable[_uiType].ShowTime;
    local AlphaTime = UIConfigTable[_uiType].AlphaShowTime;

    if Scaltime == 0 and AlphaTime == 0 then
        uiClass.gameObject.transform.localScale = Vector3.one;
    else
        
        local startAlpha = UIConfigTable[_uiType].StartAlter;
        local isTweenScal = false;
        local startScal = UIConfigTable[_uiType].StartScale;
        local endScal = 0;
        local scalFadeTime = 0;
        if Scaltime ~= 0 then
            isTweenScal = true;
        end
        self:PlayAlpha(uiClass.gameObject, true,startAlpha, 1, AlphaTime, function() end ,isTweenScal,startScal,1,Scaltime);
    end
end

-- 显示UI动画完成
function UIManager:PlayShowOver()

end

-- 显示UI关闭动画
function UIManager:PlayHide(ui, _uiType, _parem,beforDestroyCall)
    local transform = ui.gameObject.transform;
    local Scaltime = UIConfigTable[_uiType].HideTime;
    local AlphaTime = UIConfigTable[_uiType].AlphaHideTime;

    if Scaltime == 0 and AlphaTime == 0 then
        
        self:PlayHideOver(_uiType, _parem,beforDestroyCall);
    else
        local isTweenScal = false;
        if Scaltime ~= 0 then
            isTweenScal = true;
        end
        self:PlayAlpha(transform.gameObject, false,1, 0, AlphaTime, function() self:PlayHideOver(_uiType, _parem,beforDestroyCall) end ,isTweenScal,1,0,Scaltime);
    end
end

-- 透明度播放 参数分别为： UI类型 对象 开始透明对 结束透明度 动画时间
function UIManager:PlayAlpha(gameObject, isOpen,from, to, time,callBack,isTweenScal,startScal,endScal,scalFadeTime)
    if gameObject == nil then
        return;
    end
    if (isOpen == false and gameObject.activeSelf == false) then
        return;
    end
    CommonService:Instance():SetTweenAlphaGameObject(gameObject,isOpen,nil,true,from,to,time,callBack,isTweenScal,startScal,endScal,scalFadeTime);
end

-- 显示UI动画完成
function UIManager:PlayHideOver(_uiType, _parem,beforDestroyCall,isDestroy)
    --print("界面关闭完成：".._uiType.."  Time:"..Time.timeSinceLevelLoad);
    local uiClass = self:GetUIClass(_uiType);
    if uiClass ~= nil then
        uiClass:SetVisible(_uiType,false, parem);
--        if isDestroy == nil then
--            if UIConfigTable[_uiType].Destroygrade ~= 3 then
--                GameResFactory.Instance():UIDestroyFunc(uiClass.gameObject,DataUIConfig[_uiType].Destroygrade,
--                function() self._allUIObject[_uiType] = nil;end,
--                function() uiClass:OnBeforeDestroy(); end);
--            end
--        end
    end
end

function UIManager:CreateInitUI(_uiType, _parentObj, mUIBase)
    local path = mUIBase.ResourcePath;
    local _className = mUIBase.ClassName;
    local mMutex = mUIBase.Mutex;
    local uiBase = require(_className).new();
    GameResFactory.Instance():GetUIPrefab("UIPrefab/" .. path, _parentObj.transform, uiBase, function(go)
       
        if self._allUIObject[_uiType] == nil then
            self._allUIObject[_uiType] = uiBase;
        end
        uiBase:Init();
        self:PlayHideOver(_uiType,nil,nil,false);
    end );
end


-- 增加层级和物体
function UIManager:AddUIPanel(nUIType, nLevel, nDepth)

    local levelObj = self:GetLevelObject(nLevel);
    if levelObj == nil then
        levelObj = self:CreateLevelObj(nLevel);
    end

    if levelObj == nil then
        -- print("LevelObj is nil");
    end

    local depthObj = self:GetDepth(levelObj.gameObject, nDepth);
    if depthObj == nill then
        depthObj = self:CreateDepthObj(levelObj.gameObject, nDepth);
    end

    if depthObj == nill then
        -- print("depthObj is nil");
    end
    -- --print("depthObj:"..depthObj.name);
    return depthObj;
end


-- 获取深度
function UIManager:GetDepth(_parentObj, _depth)
    -- --print(_depth);
    -- --print("ChildCount:".._parentObj.gameObject.transform.childCount);
    if _parentObj.gameObject.transform.childCount - 1 < _depth or _parentObj.gameObject.transform:GetChild(_depth) == nil then
        return nil;
    end

    local depthObj = _parentObj.gameObject.transform:GetChild(_depth);
    return depthObj;
end

-- 创建深度物体
function UIManager:CreateDepthObj(_parentObj, _depth)
    -- --print(_parentObj.gameObject.name);
    if _depth > 0 and self:GetDepth(_parentObj, _depth - 1) == nil then
        self:CreateDepthObj(_parentObj, _depth - 1);
    end

    local obj = UGameObject("UIDepth" .. _depth);
    self:ResetPos(obj, _parentObj);

    return obj;
end

-- 创建层级物体
function UIManager:CreateLevelObj(_level)
    if _level > 0 and self:GetLevelObject(_level - 1) == nil then
        self:CreateLevelObj(_level - 1);
    end

    local camObj = self._totalParentObj;
    -- --print("camObj:"..camObj);
    local obj = UGameObject("UIlevel" .. _level);
    self:ResetPos(obj, camObj);
    -- obj:GetComponent(typeof(UnityEngine.RectTransform)).rect=UnityEngine.Rect.New(0,0,0,0);

    if self._allLevelObject[_level] == nil then
        self._allLevelObject[_level] = obj;
    end

    return obj;
end

function UIManager:ResetPos(obj, parentObj)
    obj:AddComponent(typeof(UnityEngine.RectTransform));
    obj.transform:SetParent(parentObj.gameObject.transform);
    obj.transform.localPosition = Vector3.zero;
    obj.transform.localScale = Vector3.one;
    obj:GetComponent(typeof(UnityEngine.RectTransform)).anchorMax = Vector2.one;
    obj:GetComponent(typeof(UnityEngine.RectTransform)).anchorMin = Vector2.zero;
    obj:GetComponent(typeof(UnityEngine.RectTransform)).offsetMax = Vector2.zero;
    obj:GetComponent(typeof(UnityEngine.RectTransform)).offsetMin = Vector2.zero;
end

-- 获取层级
function UIManager:GetLevelObject(nLevel)
    if self._allLevelObject[nLevel] then
        return self._allLevelObject[nLevel];
    end

    return nil;
end

-- 是否存在
function UIManager:ExitUI(_uiType)
    if self._allUIObject[_uiType] == nil then
        return false;
    end
    return true;
end

-- 清空
function UIManager:Clear()
    self._allUIObject = { };
    -- 所有的UI
    -- self._allLevelObject=List:new();
    self._allLevelObject = { };
    -- 所有的层级table
    self._allGameObject = { };
end
 
function UIManager:ClearClickUI()
    self._allClickUI = { }
end

function UIManager:AddClickUI(clickUI)
    if self:IsContain(clickUI) then
        return
    end
    table.insert(self._allClickUI, clickUI)
end

function UIManager:GetClickUI(index)
    return self._allClickUI[index]
end

function UIManager:GetClickUICount()
    return #self._allClickUI
end

function UIManager:AddMainUI(clickUI)
    if clickUI == nil then
        return;
    end
    table.insert(self._AddMainUI, clickUI)
end

function UIManager:GetMainUI(index)
    return self._AddMainUI[index]
end

function UIManager:GetMainUICount()
    return #self._AddMainUI
end

function UIManager:IsContain(clickUI)
    for k, v in pairs(self._allClickUI) do
        if v == clickUI then
            return true
        end
    end
    return false
end

function UIManager:GetUpUI(index)
    return self.UpUI[index]
end

-- 检测一块地是否标记
function UIManager:IsMarked(tiled)
    local markerCount = PlayerService:Instance():GetMarkerCount()
    for i = 1, markerCount do
        if tiled:GetIndex() == PlayerService:Instance():GetMarkerListByIndex(i) then
            return true
        end
    end
    return false
end

function UIManager:HideFortImage()
    for i = 1, #self.fortImageName do
        self.fortImageName[i].gameObject:SetActive(false);
    end
end

function UIManager:ShowFortImage()
    for i = 1, #self.fortImageName do
        self.fortImageName[i].gameObject:SetActive(true);
    end
end

function UIManager:AddFortImage(obj)
    if obj == nil then
        return
    end
    table.insert(self.fortImageName, obj)
end

--预制上的脚本实现心跳用
function UIManager:AddUI(uiType, uiBase)
    if self.allPrefabUiBase[uiType] == nil then
        local baseTables = { };
        baseTables[#baseTables + 1] = uiBase;
        self.allPrefabUiBase[uiType] = baseTables;
    else
        local count = #self.allPrefabUiBase[uiType];
        self.allPrefabUiBase[uiType][count + 1] = uiBase
    end
end

function UIManager:RemoveUI(uiType)
    self.allPrefabUiBase[uiType] = nil;
end

return UIManager;
