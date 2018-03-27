--[[
	加载带回调函数资源预设
--]]

local LoadResourcesPrefabWithCallBack = class("LoadResourcesPrefabWithCallBack")

function LoadResourcesPrefabWithCallBack:ctor()
	-- 缓存池
	self._LoadResourcesPrefabWithCallBackQueue = Queue.new()

	-- 资源路径
	self._resPath = ""
end

-- 设置资源路径
function LoadResourcesPrefabWithCallBack:SetResPath(resPath)
	self._resPath = resPath
end


-- 加载预制
function LoadResourcesPrefabWithCallBack:Load(parent, uiClass, loadComplete)
	if self._LoadResourcesPrefabWithCallBackQueue:Count() ~= 0 then
		local resObject = self._LoadResourcesPrefabWithCallBackQueue:Pop()
		loadComplete(resObject)
		return
	end

	GameResFactory.Instance():GetUIPrefab(self._resPath, parent, uiClass, function (resObject)
		loadComplete(resObject)
	end)
end

-- 回收预制
function LoadResourcesPrefabWithCallBack:Recovery(resObject)
	if resObject == nil then
		return
	end
	resObject:SetActive(false)
	self._LoadResourcesPrefabWithCallBackQueue:Push(resObject)
end



return LoadResourcesPrefabWithCallBack