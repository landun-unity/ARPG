--region *.lua
--Date
--此文件由[BabeLua]插件自动生成

-- 新手引导全屏无法点击

local UIBase = require("Game/UI/UIBase");
local UIGuideAllScreenNoClick = class("UIGuideAllScreenNoClick", UIBase);

-- 构造函数
function UIGuideAllScreenNoClick:ctor()
    UIGuideAllScreenNoClick.super.ctor(self);

end

-- 控件查找
function UIGuideAllScreenNoClick:DoDataExchange(args)
    
end

-- 控件事件添加
function UIGuideAllScreenNoClick:DoEventAdd()
    
end

-- 当界面显示的时候调用
function UIGuideAllScreenNoClick:OnShow(param)

end

return UIGuideAllScreenNoClick;


--endregion
