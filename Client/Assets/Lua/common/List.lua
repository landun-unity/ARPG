--
-- Author: czx
-- Date: 2015-05-21 11:46:48
--
--local class = require("common/middleclass")
local List = class("List");

-- 构造函数
function List:ctor()
	-- body
	-- 元素列表
    self._list = {};
end

-- 添加一个元素
function List:Push(value)
	-- body
	table.insert(self._list, value);
end

-- 弹出一个函数
function List:Get(index)
	-- body
	if self:Count() <= 0 or index == nil or type(index) ~= "number" then
		--todo
		return nil;
	end
	return self._list[index];
end

-- 删除对象
function List:Remove(value)
	-- body
	for i=1,self:Count() do
		local nValue = self._list[i];
		if nValue == value then
			--todo
			table.remove(self._list, i);
			i = i - 1;
		end
	end
end

-- 遍历所有成员
function List:ForEach(fun, ...)
	-- body
	for k,v in pairs(self._list) do
		fun(v, ...)
	end
end

-- 数量
function List:Count()
	-- body
	return #self._list;
end

-- 清除
function List:Clear()
	-- body
	self._list={};
end

return List;