--[[
	加载资源预设
--]]

local LoadResourcesPrefab = class("LoadResourcesPrefab")

function LoadResourcesPrefab:ctor()
	-- 缓存池
	self._LoadResourcesPrefabQueue = Queue.new()

	-- 资源路径
	self._resPath = ""

	--回收上移偏量
	self._recoveryY = 200000;
end

-- 设置资源路径
function LoadResourcesPrefab:SetResPath(resPath)
	self._resPath = resPath
end

-- 加载预制
function LoadResourcesPrefab:Load(parent, loadComplete, identification)
	if self._LoadResourcesPrefabQueue:Count() ~= 0 then
		local resObject = self._LoadResourcesPrefabQueue:Pop()
		loadComplete(resObject)
		return
	end

    if identification == nil then
	    GameResFactory.Instance():GetResourcesPrefab(self._resPath, parent, function (resObject)
		    loadComplete(resObject)
	    end)
    else
        GameResFactory.Instance():GetResourcesPrefabByIdentification(self._resPath, parent, function (resObject)
		    loadComplete(resObject)
	    end, identification)
    end
end

-- 回收预制
function LoadResourcesPrefab:Recovery(resTransform)
	if resTransform == nil or resTransform.gameObject == nil then
		return
	end
	--resTransform.gameObject:SetActive(false)
	resTransform.transform.localPosition = self:_GetRecoveryPosition(resTransform.transform.localPosition);
	self._LoadResourcesPrefabQueue:Push(resTransform.gameObject)
end

function LoadResourcesPrefab:_GetRecoveryPosition(resTransform)
	return Vector3.New(resTransform.x, resTransform.y + self._recoveryY, 0);
end

return LoadResourcesPrefab