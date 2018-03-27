local GameService = require("FrameWork/Game/GameService")

local CurrencyHandler = require("Game/Currency/CurrencyHandler")
local CurrencyManage = require("Game/Currency/CurrencyManage");
CurrencyService = class("CurrencyService", GameService)

-- 同步相关的服务
function CurrencyService:ctor( )
    CurrencyService._instance = self;
    CurrencyService.super.ctor(self, CurrencyManage.new(), CurrencyHandler.new());
end

-- 单例
function CurrencyService:Instance()
    return CurrencyService._instance;
end

--清空数据
function CurrencyService:Clear()
    self._logic:ctor()
end

function CurrencyService:RequestCurrencyInfo()
	self._logic:RequestCurrencyInfo()
end



return CurrencyService;