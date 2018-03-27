
--[[
    Name:ui基类
    anchor:Dr
    Data:16/9/7
--]]

local List = require("common/List");--实现List
local UIBase = class("UIBase");


-- 构造函数
function UIBase:ctor()
    self.allAllocPosition = 10000;
    self.allNoticeMap = {};
    self.curUiType = nil;
end

-- 初始化
function UIBase:Init()
	self:DoDataExchange();
	self:DoEventAdd();
    self:RegisterAllNotice();
	return self:OnInit();
end

-- 初始化的时候
function UIBase:OnInit()
end

-- 释放界面
function UIBase:Release()
	self:RemoveAllNotice();
	self:OnRelease();
end

-- 当释放界面
function UIBase:OnRelease()
end

-- 控件查找
function UIBase:DoDataExchange()
end

-- 控件事件添加
function UIBase:DoEventAdd()
end

-- 注册所有的事件
function UIBase:RegisterAllNotice()
end
-- 心跳
function UIBase:_OnHeartBeat()
end

-- 注册消息通知
function UIBase:RegisterNotice(msgId, fun)
    if msgId == nil or type(msgId) ~= "number" or fun == nil then
        return;
    end
--print("sssss: "..msgId)
    if self.allNoticeMap[msgId] ~= nil then
        self:RemoveNotice(msgId);
    end

    self.allNoticeMap[msgId] = fun;
    MessageService:Instance():RegisterNotice(msgId, self, fun);
end

-- 移除消息的通知
function UIBase:RemoveNotice(msgId)
    if type(msgId) ~= "number" then
        return;
    end
    -- print("777777777777777")
    if self.allNoticeMap[msgId] == nil then
        return;
    end
    self.allNoticeMap[msgId] = nil;
    MessageService:Instance():RemoveNotice(msgId, self);
end

-- 移除所有的消息通知
function UIBase:RemoveAllNotice()
    if self.allNoticeMap ~= nil then
        -- print("00000000000000000")
        for k,v in pairs(self.allNoticeMap) do
            --if k ~= nil and v ~= nil and type(k) == "number" then
                MessageService:Instance():RemoveNotice(k, self.gameObject);
            --end
        end
        self.allNoticeMap = {};
    end
end

-- 当界面显示的时候调用
function UIBase:OnShow(param)
	-- body
end

function UIBase:OnDestroy()
	-- body
        
end

function UIBase:OnBeforeDestroy()
	-- body
    -- print("走了没有");
    self:Release();
end

-- 当界面隐藏的时候调用
function UIBase:OnHide(param)
	-- body
end

-- 是否显示
function UIBase:GetVisible()
	-- body

	if self.gameObject == nil then
		--todo
        --print("UI为空");
		return false;
	end

	return self.gameObject.activeSelf;
end

-- 显示界面
function UIBase:SetVisible(_uiType,mvisible, param)
	-- bodyallAllocPosition
    UnityEngine.Profiler.BeginSample("SetActive");
    if mvisible == true then
        if self.gameObject.activeSelf == false then
            self.gameObject:SetActive(mvisible);
        end
        self.gameObject.transform.localPosition = Vector3.New(0, 0, 0);
        self.gameObject.transform.localScale = Vector3.New(1, 1, 1);
        self.gameObject.layer = 5;
        self.curUiType = _uiType;
    elseif mvisible == false then
        if self.gameObject.activeSelf == true then
            self.gameObject:SetActive(mvisible);
        end
        self.gameObject.transform.localPosition = Vector3.New(0, self.allAllocPosition, 0);
        self.gameObject.transform.localScale = Vector3.New(1, 0, 1);
        self.gameObject.layer = 9;
    end
    --self.gameObject:SetActive(mvisible);
     UnityEngine.Profiler.EndSample();
    --print("visibele"..mvisible);
	if mvisible then
		--todo
        UnityEngine.Profiler.BeginSample("OnShow");
		self:OnShow(param);
        UnityEngine.Profiler.EndSample();
	else
		--todo
        UnityEngine.Profiler.BeginSample("OnHide");
		self:OnHide(param);
        UnityEngine.Profiler.EndSample();
	end
end

  --注册控件
  --control控件类型(如Button)
  --_strName在父物体下的名字
function UIBase:RegisterController(control, _strName)
    local obj = self.transform:Find(_strName);
    if obj == nil then
        print("RegisterController Error: " .. _strName .. " not Find");
        return nil;
    end
    local  _controle= obj:GetComponent(typeof(control));

    if _controle==nil then
--        print("control为空");
    end

    return _controle;
end

--点击事件
--obj物体(必须含有button组件)
--method回调函数
function UIBase:AddListener(controller, method)
    if controller == nil or controller.gameObject == nil then
        print("AddListener Error");
        return;
    end

    self.lua_behaviour:AddClick(controller.gameObject, function(...)
        return method(self,obj, ...)
        end );
end

--非按钮点击使用
--比如image
function UIBase:AddOnClick(controller, method)
    if controller == nil or controller.gameObject == nil then
        --print("AddOnClick Error");
        return;
    end

    self.lua_behaviour:AddOnClick(controller.gameObject, function(...)
        return method(self, ...)
        end )
end

--拖拽事件
function UIBase:AddOnDrag(controller, method)
    if controller == nil or controller.gameObject == nil then
        --print("AddOnDrag Error");
        return;
    end

    self.lua_behaviour:AddOnDrag(controller.gameObject, function(...)
        return method(self, ...)
        end )
end

--按下事件
function UIBase:AddOnDown(controller, method)
    if controller == nil or controller.gameObject == nil then
       -- print("AddOnDown Error");
        return;
    end

    self.lua_behaviour:AddOnDown(controller.gameObject, function(...)
        return method(self, ...)
        end )
end

--松开事件
function UIBase:AddOnUp(controller, method)
    if controller == nil or controller.gameObject == nil then
        --print("AddOnUp Error");
        return;
    end

    self.lua_behaviour:AddOnUp(controller.gameObject, function(...)
        return method(self,...)
        end )
end

--滑动事件
function UIBase:AddOnValueChanged(controller, method)
    if controller == nil or controller.gameObject == nil then
        --print("AddOnValueChanged Error");
        return;
    end

    self.lua_behaviour:AddOnValueChanged(controller.gameObject, function(...)
            return method(self,...)
        end )
end

--滑动事件
function UIBase:AddScrollbarOnValueChange(controller, method)
    if controller == nil or controller.gameObject == nil then
        --print("AddScrollbarOnValueChange Error");
        return;
    end

    self.lua_behaviour:AddScrollbarOnValueChange(controller.gameObject, function(...)
            return method(self,...)
        end )
end


--清除事件
--注意:不会移除uieventlistener脚本
--只是移除list里的物体
--慎用
function UIBase:ClearAllEvent(controller, method)
    if controller == nil or controller.gameObject == nil then
        --print("ClearAllEvent Error");
        return;
    end

    self.lua_behaviour:ClearAllEvent(controller.gameObject, function(...)
            return method(self, ...)
        end )
end

function UIBase:AddSliderOnValueChanged(controller, method)
    if controller == nil or controller.gameObject == nil then
        --print("AddSliderOnValueChanged Error");
        return;
    end

    self.lua_behaviour:AddSliderOnValueChanged(controller.gameObject, function(...)
          return method(self,...)
        end )
end

--开关点击事件
function UIBase:AddToggleOnValueChanged(controller, method)
    if controller == nil or controller.gameObject == nil then
        --print("AddToggleOnValueChanged Error");
        return;
    end

    self.lua_behaviour:AddToggleOnValueChanged(controller.gameObject, function(...)
          return method(self,...)
        end )
end

--输入框事件
function UIBase:AddInputFieldOnValueChanged(controller, method)
    if controller == nil or controller.gameObject == nil then
        --print("AddToggleOnValueChanged Error");
        return;
    end

    self.lua_behaviour:AddInputFieldOnValueChanged(controller.gameObject, function(...)
          return method(self,...)
        end )
end

--输入框事件
function UIBase:AddInputFieldOnEndEdit(controller, method)
    if controller == nil or controller.gameObject == nil then
        return;
    end

    self.lua_behaviour:AddInputFieldOnEndEdit(controller.gameObject, function(...)
          return method(self,...)
        end )
end

--移除点击事件脚本
--慎用
function UIBase:RemoveListener(controller, method)
    if controller == nil or controller.gameObject == nil then
        --print("RemoveListener Error");
        return;
    end

    self.lua_behaviour:RemoveListener(controller.gameObject, function(...)
          return method(self,...)
        end )
end




return UIBase;