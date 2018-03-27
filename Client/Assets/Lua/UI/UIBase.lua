
--[[
    Name:ui基类
    anchor:Dr
    Data:16/9/7
--]]

local List=require("common/List");--实现List
local UIBase = class("UIBase");


-- 构造函数
--注意:本函数只支持注册Button，其他控件(如InputField)请写在外面
function UIBase:ctor()
--self.mPanel=nil;
	
end


-- 初始化
function UIBase:Init()
	-- body

	--self:SetPanel(panel);
	self:DoDataExchange();
	self:DoEventAdd();
    --print("Init");
	return self:OnInit();
end


---- 设置界面
--function UIBase:SetPanel(panel)
--	-- body
--	self.mPanel = panel;
--end

---- 获取界面
--function UIBase:GetPanel()
--	-- body
--	return self.mPanel;
--end

-- 初始化的时候
function UIBase:OnInit()
	-- body
end

-- 释放界面
function UIBase:Release()
	-- body
	self:OnRelease();
end

-- 当释放界面
function UIBase:OnRelease()
	-- body
end

-- 控件查找
function UIBase:DoDataExchange()
	-- body
end

-- 控件事件添加
function UIBase:DoEventAdd()
	-- body
end


-- 当界面显示的时候调用
function UIBase:OnShow(param)
	-- body
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
        print("UI为空");
		return false;
	end

	return self.gameObject.activeSelf;
end



-- 显示界面
function UIBase:SetVisible(mvisible, param)
	-- body

    self.gameObject:SetActive(mvisible);

    --print("visibele"..mvisible);
	if mvisible then
		--todo
		self:OnShow(param);
	else
		--todo
		self:OnHide(param);
	end
end



  --注册控件
  --control控件类型(如Button)
  --_strName在父物体下的名字
  function UIBase:RegisterController(control,_strName)

    local obj =self.transform:Find(_strName);
    print(obj)
  	local  _controle= obj:GetComponent(typeof(control));

    if _controle==nil then
    print("control为空");
    end

    return _controle;
  end



--  function UIBase:ErAddListener(obj, method)
--    return function(...)
--        return method(obj, ...)
--    end
--end

-- --点击事件
--function UIBase:OneAddListener(obj,func)
--  obj:AddListener(
--  function (...)
--  func(self,...);
--  end

--  )

--end


--点击事件
--obj物体
--method回调函数
  function UIBase:AddListener(obj, method)

  self.lua_behaviour:AddClick(obj,function(...)
        return method(self,obj, ...)
        end )

end



return UIBase;