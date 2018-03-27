local GameService = require("FrameWork/Game/GameService")
local UIMapNameManage = require("Game/MapMenu/UIMapNameManage");
UIMapNameService = class("UIMapNameService", GameService)

-- 构造函数
function UIMapNameService:ctor()
    UIMapNameService._instance = self;
    UIMapNameService.super.ctor(self, UIMapNameManage.new());
end

-- 单例
function UIMapNameService:Instance()
    return UIMapNameService._instance;
end


-- 清空数据
function UIMapNameService:Clear()
    self._logic:ctor()
end

-- 查找
function UIMapNameService:FindItem(tiled)
    return self._logic:_FindItem(tiled);
end


function UIMapNameService:_SetAllCacheUIParent(Parent)
    self._logic:_SetAllCacheUIParent(Parent);
end

function UIMapNameService:_HideTiledUILayer(tiled)
    self._logic:_HideTiledUILayer(tiled);
end

function UIMapNameService:_ShoWildUILayer(tiled)
    self._logic:_ShoWildUILayer(tiled);
end

function UIMapNameService:_ShowPlayerUILayer(tiled)
    self._logic:_ShowPlayerUILayer(tiled);
end

return UIMapNameService;