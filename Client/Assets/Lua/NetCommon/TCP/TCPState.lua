-- TCP的一些状态变化

TCPState = 
{
    -- 连接中
    Connecting = 1, 

    -- 连接OK
    ConnectSuccess = 2, 

    -- 断开连接
    DisConnect = 3, 

    -- 连接失败
    ConnectFail = 4, 

    -- 发送成功
    SendDone = 5, 
}

return TCPState;
