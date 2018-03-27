using System;
using System.Collections;

/// <summary>
/// 内存块
/// </summary>
public class MemBlock
{
    /// <summary>
    /// 内存
    /// </summary>
    protected byte[] _mem;

    /// <summary>
    /// 使用大小
    /// </summary>
    protected int mUseSize;

    /// <summary>
    /// 用户自定义数据
    /// </summary>
    protected object _userData;

    public MemBlock(int length)
    {
        _mem = new byte[length];
        mUseSize = 0;
        _userData = null;
    }

    /// <summary>
    /// 获取最大大小
    /// </summary>
    /// <returns></returns>
    public int GetMaxLength()
    {
        return _mem.Length;
    }

    /// <summary>
    /// 使用大小
    /// </summary>
    public int UseSize
    {
        get { return mUseSize; }
        set { mUseSize = value; }
    }

    public byte[] GetBytes()
    {
        return _mem;
    }

    /// <summary>
    /// 用户数据
    /// </summary>
    public object UserData
    {
        get { return _userData; }
        set { _userData = value; }
    }

    public void CopyBytes(byte[] data, int length, int offset)
    {
        Buffer.BlockCopy(data, offset, _mem, 0, length);
    }
}
