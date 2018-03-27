-- 终端列表

Terminal = 
{
    -- 系统
	System = 0,
	
	-- 客户端
	Client = 1,
	
	-- 账号
	Account = 2,
	
	-- 逻辑
	Logic = 3, 
	
	-- 聊天
	Chat = 4, 
}

-- 根据消息ID获取来源终端
function FromTerminal( msgId )
	local t1, t2 = math.modf(msgId / 16777216)
	return t1;
end

-- 根据消息ID获取消息终端
function ToTerminal( msgId )
	local t1, t2 = math.modf(msgId / 16777216)
	t1 = t1 * 16777216;
	t1 = msgId - t1;
	t1, t2 = math.modf(t1 / 65536);
	return t1;
end
