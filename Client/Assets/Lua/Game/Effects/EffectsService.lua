
local GameService = require("FrameWork/Game/GameService")
local EffectsManage = require("Game/Effects/EffectsManage");
EffectsService = class("EffectsService", GameService)

-- 构造函数
function EffectsService:ctor()
    EffectsService._instance = self;
    EffectsService.super.ctor(self, EffectsManage.new());
end
--特效 loop为1 为单次播放自动删除
--loop 为2 循环播放 需要自己调用RemoveEffect方法
--AddEffect为添加特效 parent 父物体位置归0 effectsType 特效表Id callBack 回调可以为空
--AddPointEffect为屏幕点击特效 position 为image的位置

-- 单例
function EffectsService:Instance()
    return EffectsService._instance;
end

--清空数据
function EffectsService:Clear()
    self._logic:ctor()
end

function EffectsService:AddPointEffect(position, parent, effectsType, loop, callBack)
    self._logic:AddPointEffect(position, parent, effectsType, loop, callBack);
end

function EffectsService:AddEffect(parent, effectsType, loop, callBack, position)
    return self._logic:AddEffect(parent, effectsType, loop, callBack, position);
end

function EffectsService:RemoveEffect(item)
    self._logic:RemoveEffect(item);
end

function EffectsService:RemoveAllEffect()
    self._logic:RemoveAllEffect();
end

return EffectsService;