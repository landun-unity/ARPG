using UnityEngine;
using System.Collections;
using System.Net;
using System.Net.Sockets;
using System.IO;
using System;
using LuaInterface;

public class SocketClient
{
    /// <summary>
    /// 需要同步到主线程的状态
    /// </summary>
    private enum State
    {
        /// <summary>
        /// 连接中
        /// </summary>
        Connecting = 1, 

        /// <summary>
        /// 连接OK
        /// </summary>
        ConnectSuccess = 2, 

        /// <summary>
        /// 断开连接
        /// </summary>
        DisConnect = 3, 

        /// <summary>
        /// 连接失败
        /// </summary>
        ConnectFail = 4, 

        /// <summary>
        /// 发送成功
        /// </summary>
        SendDone = 5, 
    }

    /// <summary>
    /// 套接字
    /// </summary>
    private Socket socket = null;

    /// <summary>
    /// 远程主机
    /// </summary>
    private string host = string.Empty;

    /// <summary>
    /// 远程端口
    /// </summary>
    private int port = 8401;

    /// <summary>
    /// 最大的接收大小
    /// </summary>
    private const int Max_Receive_Size = 1024000;

    /// <summary>
    /// 最大的发送大小
    /// </summary>
    private const int Max_Send_Size = 1024000;

    /// <summary>
    /// 接收缓存
    /// </summary>
    private byte[] receiveBuffer = new byte[Max_Receive_Size];

    /// <summary>
    /// 套接字的缓存
    /// </summary>
    private RingBuffer socketBuffer = new RingBuffer(Max_Receive_Size);

    /// <summary>
    /// 接收缓存的偏移
    /// </summary> 
    private int receiveOffset = 0;

    /// <summary>
    /// 状态 0: 空状态 1:连接中 2:连接
    /// <summary>
    private int state = 0;

    /// <summary>
    /// 状态同步 1:连接中 2:连接OK 3:断开连接 4:连接失败
    /// <summary>
    private SingleReadQueue<int> stateQueue = new SingleReadQueue<int>();

    public SocketClient()
    {
        ResetSocket();
    }

    /// <summary>
    /// 初始化
    /// <summary>
    public void Init(String host, int port)
    {
        this.host = host;
        this.port = port;
    }

    /// <summary>
    /// 重置连接
    /// <summary>
    private void ResetSocket()
    {
        if(socket != null)
            socket.Close();

        socket = new Socket(AddressFamily.InterNetwork, SocketType.Stream, ProtocolType.Tcp);
        socket.SendBufferSize = Max_Send_Size;
        socket.ReceiveBufferSize = Max_Receive_Size;
    }

    /// <summary>
    /// 关闭连接
    /// <summary>
    public void Close()
    {
        Debug.LogError("关闭连接");
        if(socket != null)
        {
            ResetSocket();
            //socket.Close();
        }

        InsertState(State.DisConnect);
    }

    /// <summary>
    /// 连接远程终端
    /// <summary>
    public void Connect()
    {
        try
        {
            socket.BeginConnect(this.host, this.port, new AsyncCallback(EndConnect), socket);
            InsertState(State.Connecting);
        }catch(SocketException ex)
        {
            int errorCode = ex.ErrorCode;
            String strError = ex.ToString();
            Debug.LogError(strError);
            Close();
        }
        catch(Exception ex)
        {
            String strError = ex.ToString();
            Debug.LogError(strError);
            Close();
        }
    }

    /// <summary>
    /// 连接返回
    /// <summary>
    private void EndConnect(IAsyncResult iar)
    {
        try
        {
            Socket socket = (Socket)iar.AsyncState;
            socket.EndConnect(iar);

            InsertState(State.ConnectSuccess);
            StartReceive();
        }
        catch(SocketException ex)
        {
            int errorCode = ex.ErrorCode;
            String strError = ex.ToString();
            // Debug.LogError(strError);
            Close();
        }
        catch(Exception ex)
        {
            String strError = ex.ToString();
            Debug.LogError(strError);
            Close();
        }
    }

    /// <summary>
    /// 开始接收
    /// <summary>
    private void StartReceive()
    {
        try
        {
            socket.BeginReceive(receiveBuffer, 0, Max_Receive_Size, SocketFlags.None, new AsyncCallback(EndReceive), socket);
        }catch(SocketException ex)
        {
            int errorCode = ex.ErrorCode;
            String strError = ex.ToString();
            Debug.LogError(strError);
            Close();
        }
        catch(Exception ex)
        {
            String strError = ex.ToString();
            Debug.LogError(strError);
            Close();
        }
    }

    /// <summary>
    /// 接收到消息
    /// <summary>
    private void EndReceive(IAsyncResult iar)
    {
        try
        {
            // Socket socket = (Socket)iar.AsyncState;
            // int receive = socket.EndReceive(iar);
            // if(receive <= 0)
            // {
            //     Close();
            //     return;
            // }
            // Debug.LogError("接到消息");
            Socket socket = (Socket)iar.AsyncState;
            try
            {
                int receive = socket.EndReceive(iar);
                if(receive <= 0)
                {
                    Close();
                    return;
                }
                // Debug.LogError("写入消息 消息长度::"+receive);
                socketBuffer.Write(receiveBuffer, 0, receive);
                StartReceive();
            }catch(ObjectDisposedException ex)
            {
                
                Debug.LogError("出错了。。。。。。；");
                Close();
            }
        }
        catch(SocketException ex)
        {
            int errorCode = ex.ErrorCode;
            String strError = ex.ToString();
            Debug.LogError(strError);
            Close();
        }
        catch(Exception ex)
        {
            String strError = ex.ToString();
            Debug.LogError(strError);
            Close();
        }
    }

    /// <summary>
    /// 发送数据
    /// <summary>
    public void Send(byte[] buffer)
    {
        Send(buffer, 0, buffer.Length);
    }

    /// <summary>
    /// 发送数据
    /// <summary>
    public void Send(byte[] buffer, int offset, int length)
    {
        if( socket == null )
            return;

        socket.BeginSend(buffer, offset, length, SocketFlags.None, new AsyncCallback(EndSend), socket);
    }

    /// <summary>
    /// 发送数据结束
    /// <summary>
    private void EndSend(IAsyncResult iar)
    {
        try{
            Socket socket = (Socket)iar.AsyncState;
            socket.EndSend(iar);

            InsertState(State.SendDone);
        }
        catch(SocketException ex)
        {
            int errorCode = ex.ErrorCode;
            String strError = ex.ToString();
            Debug.LogError(strError);
            Close();
        }
        catch(Exception ex)
        {
            String strError = ex.ToString();
            Debug.LogError(strError);
            Close();
        }
    }

    /// <summary>
    /// 插入状态
    /// <summary>
    private void InsertState(State state)
    {
        this.stateQueue.Enqueue((int)state);
    }

    /// <summary>
    /// 复制状态
    /// <summary>
    public void CopyState()
    {
        this.stateQueue.CopyToReadQueue();
    }

    /// <summary>
    /// 获取状态数量
    /// <summary>
    public int GetStateCount()
    {
        return this.stateQueue.ReadCount;
    }

    /// <summary>
    /// 弹出状态
    /// <summary>
    public int DequeueState()
    {
        return this.stateQueue.Dequeue();
    }

    /// <summary>
    /// 缓存中的数据转化为一个Int32
    /// <summary>
    public int BufferToInt32()
    {
        // Debug.LogError("什么时候走？");
        return this.socketBuffer.ToInt32();
    }

    /// <summary>
    /// 缓冲区大小
    /// <summary>
    public int BufferSize()
    {
        return this.socketBuffer.Size();
    }

    public void ReadBuffer(byte[] buffer, int offset, int length)
    {
        if(buffer == null || offset < 0 || length < 0 || buffer.Length < offset + length)
            return;
        
        this.socketBuffer.Read(buffer, offset, length);
    }
}
