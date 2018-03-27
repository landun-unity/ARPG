--[[
	特效管理
--]]
require("Game/Table/model/DataSpecialEffects")
local Queue = require("common/Queue");
local GamePart = require("FrameWork/Game/GamePart");
local CommonEffects = require("Game/Effects/CommonEffects");
local EffectsManage = class("EffectsManage", GamePart)

function EffectsManage:ctor()
    EffectsManage.super.ctor(self);
    --总时间间隔
    self._time = 0.1;
    --脚本回收
    self._cacheQueue = Queue.new();
    --image回收
    self._cacheImageQueue = Queue.new();
    --回收上移偏量
    self._recoveryY = 20000;

    self._commonEffectQueue = Queue.new();

    self._EffectPool = nil;
end

function EffectsManage:_OnInit()
    self._EffectPool = UnityEngine.GameObject.Find("EffectPool");
end

--回收
function EffectsManage:_AllocImage()
   if self._cacheImageQueue:Count() == 0 then
    -- print("CameIn")
        return nil;
   end
   return self._cacheImageQueue:Pop();
end

--释放
function EffectsManage:_ReleaseImage(cache)
  if cache == nil then
     return;
  end
  self._cacheImageQueue:Push(cache);
  if self._EffectPool == nil then
        self._EffectPool = UnityEngine.GameObject.Find("EffectPool"); 
  end
  cache.transform:SetParent(self._EffectPool.transform);
  cache.transform.localPosition = Vector3.New(0, 0, 0);
  -- cache.transform.localPosition = Vector3.New(0, self._recoveryY, 0);
end

--回收
function EffectsManage:_Alloc()
   if self._cacheQueue:Count() == 0 then
        return nil;
   end
   return self._cacheQueue:Pop();
end

--释放
function EffectsManage:_Release(cache)
  if cache == nil then
     return;
  end

  self._cacheQueue:Push(cache);
  cache:Clear();
end

--回收
function EffectsManage:_Alloc()
   if self._cacheQueue:Count() == 0 then
        return nil;
   end
   return self._cacheQueue:Pop();
end


function EffectsManage:AddEffect(parent, effectsType, loop, callBack, position)
    if parent == nil or effectsType == nil or loop == nil then
        return;
    end

    local commonEffect = self:_Alloc();
    local effectImage = self:_AllocImage();
    if commonEffect == nil then
        commonEffect = CommonEffects.new();
        self._commonEffectQueue:Push(commonEffect);
        if effectImage == nil then
            GameResFactory.Instance():GetUIEffect("UIPrefab/".."effectsImage", function (effectImage)
                commonEffect:Init(parent, effectImage, DataSpecialEffects[effectsType].Name, DataSpecialEffects[effectsType].Number, self._time, loop, callBack, position);
                commonEffect:Show();
            end);
        else
            commonEffect:Init(parent, effectImage, DataSpecialEffects[effectsType].Name, DataSpecialEffects[effectsType].Number, self._time, loop, callBack, position);
            commonEffect:Show();
        end
        return commonEffect;
    end

    if effectImage == nil then
        GameResFactory.Instance():GetUIEffect("UIPrefab/".."effectsImage", function (effectImage)
            commonEffect:Init(parent, effectImage, DataSpecialEffects[effectsType].Name, DataSpecialEffects[effectsType].Number, self._time, loop, callBack, position);
            commonEffect:Show();
        end);
    else
        commonEffect:Init(parent, effectImage, DataSpecialEffects[effectsType].Name, DataSpecialEffects[effectsType].Number, self._time, loop, callBack, position);
        commonEffect:Show();
    end
    return commonEffect;
end

function EffectsManage:AddPointEffect(position, parent, effectsType, loop, callBack)
    if position == nil or parent == nil or effectsType == nil or loop == nil then
        return;
    end

    local commonEffect = self:_Alloc();
    local effectImage = self:_AllocImage();
    if commonEffect == nil then
        commonEffect = CommonEffects.new();

        self._commonEffectQueue:Push(commonEffect);
        if effectImage == nil then
            GameResFactory.Instance():GetUIEffect("UIPrefab/".."effectsImage", function (effectImage)
                commonEffect:Init(parent, effectImage, DataSpecialEffects[effectsType].Name, DataSpecialEffects[effectsType].Number, self._time, loop, callBack, position);
                commonEffect:Show();
            end);
        else
            commonEffect:Init(parent, effectImage, DataSpecialEffects[effectsType].Name, DataSpecialEffects[effectsType].Number, loop, callBack, position);
            commonEffect:Show();
        end
        return;
    end
    if effectImage == nil then
        GameResFactory.Instance():GetUIEffect("UIPrefab/".."effectsImage", function (effectImage)
            commonEffect:Init(parent, effectImage, DataSpecialEffects[effectsType].Name, DataSpecialEffects[effectsType].Number, self._time, loop, callBack, position);
            commonEffect:Show();
        end);
    else
        commonEffect:Init(parent, effectImage, DataSpecialEffects[effectsType].Name, DataSpecialEffects[effectsType].Number, self._time, loop, callBack, position);
        commonEffect:Show();
    end
end

function EffectsManage:RemoveEffect(item)
    if item == nil then
        return;
    end

    self:_ReleaseImage(item._effectImage);
    self:_Release(item);
    self._commonEffectQueue:Remove(item);
end

function EffectsManage:_OnHeartBeat()
    
end

function EffectsManage:RemoveAllEffect()
    --print(self._commonEffectQueue:Count())
    self._commonEffectQueue:ForEach(function(...)
        self:RemoveEffect(...);
    end );
    self._EffectPool = nil;
end

return EffectsManage;