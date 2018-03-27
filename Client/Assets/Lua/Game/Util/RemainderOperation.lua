--[[
	取余运算
]]

local RemainderOperation = class("RemainderOperation");

function RemainderOperation:ctor()
	-- body
	self._Dividend = 0;

	self._Divisor = 0;

	self._Remainder = 0;
end

-- 初始化
function RemainderOperation:Init(dividend, divisor)
    
end

--计算余数

function RemainderOperation:TakeOver(dividend,divisor)
	-- body
	if divisor == 0 then
		return;
	end
	self._Dividend = dividend;
    self._Divisor = divisor;
	self._Remainder = self._Dividend - math.floor(self._Dividend / self._Divisor) * self._Divisor;
	return self._Remainder;
end

return RemainderOperation;