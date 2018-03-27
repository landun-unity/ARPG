--
-- Author: czx
-- Date: 2015-05-13 19:46:14
--
Queue = class("Queue")

-- 构造函数
function Queue:ctor()
	-- body
	-- 元素列表
	self._list = {};
end

-- 添加一个元素
function Queue:Push(value)
	-- body
	if value ~= nil then
		--todo
        local nPos = #self._list + 1;
		table.insert(self._list, nPos, value);
	end
end

-- 弹出一个函数
function Queue:Pop()
	if self:Count() <= 0 then
		return nil;
	end

	local nValue = self._list[1];
	table.remove(self._list, 1);

	return nValue;
end

-- 弹出一个对象，不删除
function Queue:Peek()
	if self:Count() <= 0 then
		return nil;
	end

	local nValue = self._list[1];

	return nValue;
end

-- 删除对象
function Queue:Remove(value)
	-- body
	for i=1,self:Count() do
		local nValue = self._list[i];
		if v == value then
			--todo
			table.remove(self._list, i);
			i = i - 1;
		end
	end
end

function Queue:ForEach(fun, ...)
	-- body
	for k,v in pairs(self._list) do
		fun(v, ...)
	end
end

-- 数量
function Queue:Count()
	-- body
	return #self._list;
end

function Queue:Clear()
	-- body
	self._list = {};
end

return Queue;