
local CommonEffects = class("CommonEffects")

-- 构造函数
function CommonEffects:ctor()  
   self._effectName = "";

   self._effectCount = 0;

   self._effectImage = nil;

   self._currCount = 0;

   self._callBack = nil;
   --间隔
   self._time = 0;

   self._loop = 0;

   self._coroutine = nil;
end

-- 
function CommonEffects:Init(parent, image, name, count, time, loop, callBack, position)
    self._effectImage = image:GetComponent(typeof(UnityEngine.UI.Image));
    self._time = time;
    self._effectCount = count;
    self._effectName = name;
    self._currCount = 1;
    self._loop = loop;
    self._callBack = callBack;
    self._effectImage.transform:SetParent(parent.transform);
    self._effectImage.transform.localScale = Vector3.New(1, 1, 1);
    if position ~= nil then
        self._effectImage.transform.localPosition = Vector3.New(position.x, position.y, 0);
        self._effectImage.transform:SetAsLastSibling();
        return;
    end
    self._effectImage.transform.localPosition = Vector3.New(0, 0, 0);
end

-- 清空数据
function CommonEffects:Clear()
   self:StopCoroutine();
   self._effectName = "";
   self._effectCount = 0;
   self._effectImage = nil;
   self._currCount = 0;
   self._time = 0;
   self._loop = 0;
   self._coroutine = nil;
   self._callBack = nil;
end

-- 心跳
function CommonEffects:Show()
    -- while true
    -- do
        if self._currCount ~= 1 and self._coroutine ~= nil then
            return;
        end

        self._coroutine = StartCoroutine(function ()
          for i = 1, self._effectCount do
              self:ShowImage();
              if self._loop == 1 and i == self._effectCount then
                  EffectsService:Instance():RemoveEffect(self);
              end
              WaitForSeconds(self._time, function()
              end)
          end
          self._coroutine = nil;
          if self._loop == 2 then
            self:Show();
          end
        end);
    --end
end

function CommonEffects:StopCoroutine()
    --StopCoroutine(self._coroutine);
    
    if self._effectImage ~= nil and self._effectImage.transform.parent ~= nil and self._effectImage.transform.parent.name ~= "EffectPool"  then
        self._effectImage.gameObject:SetActive(false);
    end
end

function CommonEffects:ShowImage()
   if self._effectImage == nil then
      return;
   end

   self._effectImage.sprite  = GameResFactory.Instance():GetResSprite(self._effectName..string.format("%02d", self._currCount));
   self._effectImage:SetNativeSize();
   self._currCount = self._currCount + 1;
   if self._currCount > self._effectCount then
       self._currCount = 1;
       if self._callBack ~= nil then
          self._callBack();
       end
   end
end

function CommonEffects:GetImage()
    return self._effectImage;
end

return CommonEffects;