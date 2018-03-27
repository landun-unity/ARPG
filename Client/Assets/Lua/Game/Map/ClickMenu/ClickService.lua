local GameService = require("FrameWork/Game/GameService")
local ClickManage = require("Game/Map/ClickMenu/ClickManage");
ClickService = class("ClickService", GameService)

-- 构造函数
function ClickService:ctor( )
    ClickService._instance = self;
    ClickService.super.ctor(self, ClickManage.new());
end

-- 单例
function ClickService:Instance()
    return ClickService._instance;
end

--清空数据
function ClickService:Clear()
    self._logic:ctor()
end

--返回当当前UIPublicClass,设置同盟标记详情的位置
function ClickService:GetCurClickUI(posy)
    self._logic:GetCurClickUI(posy)
end

function ClickService:InitUI(UIparent)
    self._logic:InitUI(UIparent);
end

function ClickService:HideCityName()
	self._logic:_HideCityName();
end

function ClickService:ShowCityName(tiled)
	self._logic:_ShowCityName(tiled);
end

function ClickService:HideTiled()
	self._logic:HideTiled();
end

function ClickService:ShowTiled(tiled, postion)
	self._logic:ShowTiled(tiled, postion);
end

function ClickService:RealShowTiled()
	self._logic:RealShowTiled();
end

function ClickService:ShowUIBreathingFrameByIndex(tiled, index)
	self._logic:ShowUIBreathingFrameByIndex(tiled, index);
end

function ClickService:HideUIBreathingFrame()
	self._logic:HideUIBreathingFrame();
end

function ClickService:GetTopPanel()
    return self._logic:GetTopPanel();
end

return ClickService;