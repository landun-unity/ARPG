using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading;

/// <summary>
/// 多写单出的队列
/// </summary>
/// <typeparam name="T"></typeparam>
public class SingleReadQueue<T>
{
	/// <summary>
	/// 读队列
	/// </summary>
	protected Queue<T> _readQueue = new Queue<T>();

	/// <summary>
	/// 写队列
	/// </summary>
	protected Queue<T> _writeQueue = new Queue<T>();

	/// <summary>
	/// 锁标志
	/// </summary>
	protected int _exchangeMark = 0;

	/// <summary>
	/// 读写交换的锁
	/// </summary>
	protected object _exchangeLock = new object();

	/// <summary>
	/// 进入队列， 写线程
	/// </summary>
	/// <param name="value"></param>
	public virtual void Enqueue(T value)
	{
		lock(_exchangeLock)
		{
			_writeQueue.Enqueue(value);
		}
	}

	/// <summary>
	/// 写的数量，写线程
	/// </summary>
	private int _WriteCount
	{
		get { return _writeQueue.Count; }
	}

	/// <summary>
	/// 复制到读的队列，读线程
	/// </summary>
	public void CopyToReadQueue()
	{
		lock(_exchangeLock)
		{
			_CopyToReadQueue();
		}
	}

	/// <summary>
	/// 服务器到读的队列
	/// </summary>
	private void _CopyToReadQueue()
	{
		int count = _writeQueue.Count;
		for(int copyIndex = 0; copyIndex < count; ++copyIndex)
		{
			_readQueue.Enqueue(_writeQueue.Dequeue());
		}
	}

	/// <summary>
	/// 弹出一个对象，读线程
	/// </summary>
	/// <returns></returns>
	public T Dequeue()
	{
		return _readQueue.Dequeue();
	}

	/// <summary>
	/// 读数量，读线程
	/// </summary>
	public int ReadCount
	{
		get { return _readQueue.Count; }
	}
}
