--山管理类

local TiledSprite = require("Game/Map/TiledSprite")
local Queue = require("common/Queue");
local MapLoad = require("Game/Map/MapLoad")
local Data = require("Game/Table/model/DataMoutain")
local DataGameConfig = require("Game/Table/model/DataGameConfig");
local MoutainManage = class("MoutainManage")

function MoutainManage:ctor()
	--所有的大山精灵
	self._allMoutainSpriteList = {};
  --所有的小山精灵
  --self._smallMoutainSpriteList = {};
	--山父亲
	self._moutainParent = nil;
    --山缓存
    self._cacheMoutain = {};
    --加载过的类
    self._allMoutainMap = {};

    --self._cacheMoutainParent = nil;
end

function MoutainManage:_AllSprite(moutainId)
    local name = "Moutain";
    local width = Data[moutainId].Size;
    local height = Data[moutainId].Size;
    self:_CreateMoutainSprite(Data[moutainId].MoutainPicture..Data[moutainId].MoutainType, name, moutainId, width, height);
end

function MoutainManage:_CreateMoutainSprite(i, image, moutainId, width, height)
    self._allMoutainSpriteList[i] = TiledSprite.new();
    local finalImage = string.format("%s_%02d_%02d", image, Data[moutainId].MoutainPicture, Data[moutainId].MoutainType);
    self._allMoutainSpriteList[i]:Init(i, finalImage, width, height);
end

function MoutainManage:_SetAllCacheMoutainParent(cacheMoutainParent, moutainParent)
    --self._cacheMoutainParent = cacheMoutainParent;
    self._moutainParent = moutainParent;
    ------print(self._cacheTiledParent);
end

function MoutainManage:_GetSprite(id)
    if id == nil then
        return nil;
    end
    local tiledSprite = self._allMoutainSpriteList[id];
    if tiledSprite == nil then
        return nil;
    end

    return tiledSprite:GetSprite();
end

-- -- 回收格子
-- function MoutainManage:_ReleaseSmallMoutain(cacheTiled)
--     if cacheTiled == nil then
--         return;
--     end
--     self._cachesmallmoutainQueue:Push(cacheTiled);
--     --cacheTiled:SetParent(self._cacheMoutainParent);
-- end

-- -- 回收格子
-- function MoutainManage:_AllocSamllMoutain()
--     if self._cachesmallmoutainQueue:Count() == 0 then
--         return nil;
--     end

--     return self._cachesmallmoutainQueue:Pop();
-- end

-- function MoutainManage:_ReleaseBigMoutain(cacheTiled)
--     if cacheTiled == nil then
--         return;
--     end
--     self._cachebigmoutainQueue:Push(cacheTiled);
--     --cacheTiled:SetParent(self._cacheMoutainParent);
-- end

-- -- 回收格子
-- function MoutainManage:_AllocBigMoutain()
--     if self._cachebigmoutainQueue:Count() == 0 then
--         return nil;
--     end

--     return self._cachebigmoutainQueue:Pop();
-- end

function MoutainManage:_ReleaseMoutain(id, cacheTiled)
    if id == nil or cacheTiled == nil then
        return;
    end
    if self._cacheMoutain[id] == nil then
        self._cacheMoutain[id] = Queue.new();
    end

    self._cacheMoutain[id]:Push(cacheTiled);
    --cacheTiled:SetParent(self._cacheMoutainParent);
end

-- 回收格子
function MoutainManage:_AllocMoutain(id)
    if id == nil or self._cacheMoutain[id] == nil
    or self._cacheMoutain[id]:Count() == 0 then
        return nil;
    end

    return self._cacheMoutain[id]:Pop();
end

function MoutainManage:_FindMoutain(index, moutainId)
    if index == nil or moutainId == 0 then
        return;
    end
    --print(moutainId)
    local x,y = MapService:Instance():GetTiledCoordinate(index);
    for i=1,4 do
        local MoutainIndex = MapService:Instance():GetTiledIndex(x + Data[moutainId].MoutainPosition[i * 2 - 1], y + Data[moutainId].MoutainPosition[i * 2]);
        ------print(MoutainIndex)
        if self._allMoutainMap[MoutainIndex] ~= nil then
            return self._allMoutainMap[MoutainIndex];
        end
    end
    return nil;
end

function MoutainManage:_FindMoutainIndex(index, moutainId)
    if index == nil then
        return;
    end

    local x,y = MapService:Instance():GetTiledCoordinate(index);
    for i=1,4 do
        local MoutainIndex = MapService:Instance():GetTiledIndex(x + Data[moutainId].MoutainPosition[i * 2 - 1], y + Data[moutainId].MoutainPosition[i * 2]);
        if self._allMoutainMap[MoutainIndex] ~= nil then
            return MoutainIndex;
        end
    end
    return nil;
end


-- 插入一个建筑物
function MoutainManage:_InsertMoutain(index, moutainView)
    if index == nil then
        return;
    end
    self._allMoutainMap[index] = moutainView;
end

-- 插入一个建筑物
function MoutainManage:_RomoveMoutain(index)
    self._allMoutainMap[index] = nil;
end

-- function MoutainManage:_MoutainConfig(x, y)
--     for i,v in pairs(MoutainConfig[x]) do
--         if y ~= i then
            
--         else
--             return v;
--         end
--     end
-- end

function MoutainManage:ShowTiledLayer(tiled)
    local moutainId = tiled:GetImageId(LayerType.Moutain);
    if moutainId == 0 or moutainId == nil then
        return;
    end

    local moutainView = self:_FindMoutain(tiled:GetIndex(), moutainId);
    if moutainView == nil then
        moutainView = self:_CreatMoutainView(tiled:GetIndex(), moutainId);
        self:_OnShowMoutain(tiled, moutainView, moutainId);
    end

    --self:_OnShowMoutain(tiled, moutainView, moutainId);
end

function MoutainManage:_CreatMoutainView(index, moutainId)
    --山类型文件

    local moutainView = require("Game/Environment/"..Data[moutainId].name).new();
    moutainView:Init(Data[moutainId].MoutainPicture..Data[moutainId].MoutainType, Data[moutainId].MoutainType, DataGameConfig[MapMoveType.Moutain].OfficialData);
    self:_InsertMoutain(index, moutainView);
    self:_AllSprite(moutainId);
    return moutainView;
end

function MoutainManage:_OnShowMoutain(tiled, moutainView, moutainId)
    local moutainTransform = nil;
    -- if moutainId == 254 then
    --     moutainTransform = self:_AllocSamllMoutain();
    -- else
--     moutainTransform = self:_AllocBigMoutain();
    -- end
    moutainTransform = self:_AllocMoutain(Data[moutainId].MoutainType);
    --print(moutainTransform)
    if moutainTransform == nil then
        GameResFactory.Instance():GetResourcesPrefab("Map/TileImage", self._moutainParent, 
          function (MoutainObject)
            self:_OnShowMoutainImage(MoutainObject.transform, tiled, moutainView, moutainId);
          end);
        return;
    end
    self:_OnShowMoutainImage(moutainTransform.transform, tiled, moutainView, moutainId);
end

function MoutainManage:_OnShowMoutainImage(moutainTransform, tiled, moutainView, moutainId)
    moutainView:SetMoutainTransform(moutainTransform);
    local imageId = moutainView:GetImageId();
    ------print(imageId)
    moutainView:SetImageSprite(moutainTransform.gameObject);
    moutainTransform.name = string.format("%d", tiled:GetIndex());
    MapService:Instance():BuildingSort(moutainTransform, self._moutainParent);
    moutainView:SetSprite(self:_GetSprite(Data[moutainId].MoutainPicture..Data[moutainId].MoutainType));
    -- moutainTransform.name = string.format("%d", tiled:GetIndex());
    -- MapService:Instance():BuildingSort(moutainTransform, self._moutainParent);
    moutainTransform.localPosition = moutainView:GetMoutainPosition(tiled:GetX(), tiled:GetY(), Data[moutainId].core);
    moutainTransform.localScale = Vector3.one;
    
end

function MoutainManage:HideTiled(tiled)
    local moutainId =  tiled:GetImageId(LayerType.Moutain);
    if moutainId == nil then
      return;
    end
    local moutainView = self:_FindMoutain(tiled:GetIndex(), moutainId);
    if moutainView == nil then
        return;
    end
    local Moutain = moutainView:GetMoutainTransform();
    -- if Data[moutainId].Size == 400 then
    --     local Moutain = moutainView:GetMoutainTransform();
    --     self:_ReleaseSmallMoutain(Moutain);
    -- else
    --     local Moutain = moutainView:GetMoutainTransform();
    --     self:_ReleaseBigMoutain(Moutain);
    -- end
    self:_ReleaseMoutain(Data[moutainId].MoutainType, Moutain);

    self:_RomoveMoutain(self:_FindMoutainIndex(tiled:GetIndex(), moutainId));

end

return MoutainManage;