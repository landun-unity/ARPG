using System;
using System.Collections.Generic;
using System.Text;
using LuaInterface;

public class ByteArray
{
    /// <summary>
    /// byte 列表
    /// </summary>
    protected byte[] _bytes = new byte[10240000];

    /// <summary>
    /// 字符集编码
    /// </summary>
    protected Encoding _endcoding = Encoding.UTF8;

    /// <summary>
    /// 读的位置
    /// </summary>
    protected int _readPos = 0;

    /// <summary>
    /// 写的位置
    /// </summary>
    protected int _writePos = 0;

    public void InitBytes(byte[] bytes)
    {
        System.Array.Clear(_bytes, bytes.Length, 8);
        InitBytes(bytes, 0, bytes.Length);
    }

    public void InitBytes(byte[] bytes, int offset, int length)
    {
        System.Array.Clear(_bytes, offset + length, 8);
        Buffer.BlockCopy(bytes, offset, _bytes, 0, length);
    }

    public void WriteString(string sValue)
    {
        byte[] byValues = _endcoding.GetBytes(sValue);
        WriteBytes(byValues);
    }

    /// <summary>
    /// 写字节
    /// </summary>
    /// <param name="byValues"></param>
    public void WriteBytes(byte[] byValues)
    {
        WriteInt32(byValues.Length);
        Buffer.BlockCopy(byValues, 0, _bytes, _writePos, byValues.Length);
        _writePos += byValues.Length;
    }

    /**
	 * 写缓存
	 * @param value
	 */
	public void WriteBytes(byte[] value, int offset, int length)
	{
		Buffer.BlockCopy(value, offset, _bytes, _writePos, length);
		_writePos += length;
	}

    public void WriteBoolean(bool value)
    {
        WriteInt8((byte)(value ? 1 : 0));
    }

    public void WriteInt8(byte value)
    {
        Buffer.BlockCopy(BitConverter.GetBytes(value), 0, _bytes, _writePos, sizeof(byte));
        _writePos += sizeof(byte);
    }

    public void WriteChar(char value)
    {
        Buffer.BlockCopy(BitConverter.GetBytes(value), 0, _bytes, _writePos, sizeof(char));
        _writePos += sizeof(char);
    }

    public void WriteDouble(double value)
    {
        Buffer.BlockCopy(BitConverter.GetBytes(value), 0, _bytes, _writePos, sizeof(double));
        _writePos += sizeof(double);
    }

    public void WriteSingle(float value)
    {
        Buffer.BlockCopy(BitConverter.GetBytes(value), 0, _bytes, _writePos, sizeof(float));
        _writePos += sizeof(float);
    }

    public void WriteInt32(int value)
    {
        Buffer.BlockCopy(BitConverter.GetBytes(value), 0, _bytes, _writePos, sizeof(int));
        _writePos += sizeof(int);
    }

    public void WriteInt64(long value)
    {
        Buffer.BlockCopy(BitConverter.GetBytes(value), 0, _bytes, _writePos, sizeof(long));
        _writePos += sizeof(long);
    }

    public void WriteInt16(short value)
    {
        Buffer.BlockCopy(BitConverter.GetBytes(value), 0, _bytes, _writePos, sizeof(short));
        _writePos += sizeof(short);
    }

    public string ReadString()
    {
        byte[] value = ReadBytes();
        return _endcoding.GetString(value);
    }

    public byte[] ReadBytes()
    {
        int nLength = ReadInt();
        byte[] value = new byte[nLength];
        Buffer.BlockCopy(_bytes, _readPos, value, 0, nLength);
        _readPos += nLength;
        return value;
    }

	public void ReadBytes(byte[] value, int offset, int length)
	{
		Buffer.BlockCopy(_bytes, _readPos, value, offset, length);
		_readPos += length;
	}

    public int ReadInt()
    {
        int value = BitConverter.ToInt32(_bytes, _readPos);
        _readPos += sizeof(int);
        return value;
    }

    public byte ReadByte()
    {
        byte value = _bytes[_readPos];
        _readPos += sizeof(byte);
        return value;
    }

    public char ReadChar()
    {
        char value = BitConverter.ToChar(_bytes, _readPos);
        _readPos += sizeof(char);
        return value;
    }

    public bool ReadBoolean()
    {
        byte value = ReadByte();
        return value == 0 ? false : true;
    }

    public double ReadDouble()
    {
        double value = BitConverter.ToDouble(_bytes, _readPos);
        _readPos += sizeof(double);
        return value;
    }

    public short ReadInt16()
    {
        short value = BitConverter.ToInt16(_bytes, _readPos);
        _readPos += sizeof(short);
        return value;
    }

    public int ReadInt32()
    {
        int value = BitConverter.ToInt32(_bytes, _readPos);
        _readPos += sizeof(int);
        return value;
    }

    public long ReadInt64()
    {
        long value = BitConverter.ToInt64(_bytes, _readPos);
        _readPos += sizeof(long);
        return value;
    }

    public float ReadSingle()
    {
        float value = BitConverter.ToSingle(_bytes, _readPos);
        _readPos += sizeof(float);
        return value;
    }

    public void SeekAndWrite(int nOffset, int data)
    {
        Buffer.BlockCopy(BitConverter.GetBytes(data), 0, _bytes, nOffset, 4);
    }

    /// <summary>
    /// 重置读的位置和写的位置
    /// </summary>
    /// <returns></returns>
    public void Reset()
    {
        _writePos = 0;
        _readPos = 0;
    }

    /// <summary>
    /// 获取内存
    /// </summary>
    /// <returns></returns>
    public byte[] GetBytes()
    {
        return _bytes;
    }

    public byte[] GetWriteBytes()
    {
        byte[] bytes = new byte[_writePos];
        Buffer.BlockCopy(_bytes, 0, bytes, 0, _writePos);
        return bytes;
    }

    public int GetWritePos()
    {
        return _writePos;
    }

    public int GetReadPos()
    {
        return _readPos;
    }
}
