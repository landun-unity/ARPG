using System;
using System.Collections.Generic;
using System.Text;
using UnityEngine;
/// <summary>
/// 环形缓冲区
/// 只允许一个线程读，另一个线程写
/// <summary>
public class RingBuffer
{
    /// <summary>
    /// 缓存区
    /// <summary>
    private byte[] buffer = null;

    /// <summary>
    /// 读取的位置
    /// <summary>
    private volatile int readPointer = 0;

    /// <summary>
    /// 写的位置
    /// <summary>
    private volatile int writePointer = 0;

    /// <summary>
    /// 最大长度
    /// <summary>
    private int maxLength = 0;

    public RingBuffer(int maxLength)
    {
        this.maxLength = maxLength;
        this.buffer = new byte[maxLength];
    }

    /// <summary>
    /// 大小
    /// <summary>
    public int Size()
    {
        return (maxLength + writePointer - readPointer) % maxLength;
    }

    /// <summary>
    /// 写缓存
    /// <summary>
    public void Write(byte[] buffer, int offset, int length)
    {
        WriteBuffer(buffer, offset, length);

        writePointer = (writePointer + length) % maxLength;
        // Debug.LogError(" 写缓存完成   writePointer ===="+writePointer);
    }

    /// <summary>
    /// 写缓存
    /// <summary>
    private void WriteBuffer(byte[] buffer, int offset, int length)
    {
        int copyLength = Math.Min(length, maxLength - writePointer);
        // Debug.LogError("写缓存  copyLength ===="+copyLength);
        // Debug.LogError("写缓存  writePointer ===="+writePointer);
        System.Buffer.BlockCopy(buffer, offset, this.buffer, writePointer, copyLength);

        System.Buffer.BlockCopy(buffer, offset + copyLength, this.buffer, 0, length - copyLength);
    }

    /// <summary>
    /// 读缓存
    /// <summary>
    public void Read(byte[] buffer, int offset, int length)
    {
        ReadBuffer(buffer, offset, length);

        readPointer = (readPointer + length) % maxLength;
        // Debug.LogError("读缓存完成  readPointer ===="+readPointer);
    }

    /// <summary>
    /// 读缓存
    /// <summary>
    private void ReadBuffer(byte[] buffer, int offset, int length)
    {
        int copyLength = Math.Min(length, maxLength - readPointer);
        // Debug.LogError("读缓存  copyLength ===="+copyLength);
        // Debug.LogError("读缓存  readPointer ===="+readPointer);
        System.Buffer.BlockCopy(this.buffer, readPointer, buffer, offset, copyLength);

        System.Buffer.BlockCopy(this.buffer, 0, buffer, offset + copyLength, length - copyLength);
    }

    /// <summary>
    /// 换成Int32
    /// <summary>
    public int ToInt32()
    {
        byte[] copy = new byte[4];
        ReadBuffer(copy, 0, copy.Length);

        return BitConverter.ToInt32(copy, 0);
    }
}