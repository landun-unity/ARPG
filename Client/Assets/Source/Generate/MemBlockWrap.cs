//this source code was auto-generated by tolua#, do not modify it
using System;
using LuaInterface;
using UnityEngine;

public class MemBlockWrap
{
	public static void Register(LuaState L)
	{
		L.BeginClass(typeof(MemBlock), typeof(System.Object));
		L.RegFunction("SetUseSize", SetUseSize);
		L.RegFunction("GetUseSize", GetUseSize);
		L.RegFunction("GetBytes", GetBytes);
		L.RegFunction("CopyBytes", CopyBytes);
		L.RegFunction("New", _CreateMemBlock);
		L.EndClass();
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int _CreateMemBlock(IntPtr L)
	{
		try
		{
			int count = LuaDLL.lua_gettop(L);

			if (count == 1)
			{
				int arg0 = (int)LuaDLL.luaL_checknumber(L, 1);
				MemBlock obj = new MemBlock(arg0);
				ToLua.PushObject(L, obj);
				return 1;
			}
			else
			{
				return LuaDLL.luaL_throw(L, "invalid arguments to ctor method: MemBlock.New");
			}
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int GetBytes(IntPtr L)
	{
		try
		{
			ToLua.CheckArgsCount(L, 1);
			MemBlock obj = (MemBlock)ToLua.CheckObject(L, 1, typeof(MemBlock));
			byte[] o = obj.GetBytes();
			ToLua.Push(L, o);
			return 1;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int SetUseSize(IntPtr L)
	{
		try
		{
			ToLua.CheckArgsCount(L, 2);
			MemBlock obj = (MemBlock)ToLua.CheckObject(L, 1, typeof(MemBlock));
			int arg0 = (int)LuaDLL.luaL_checknumber(L, 2);
			obj.UseSize = arg0;
			return 0;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int GetUseSize(IntPtr L)
	{
		try
		{
			ToLua.CheckArgsCount(L, 1);
			MemBlock obj = (MemBlock)ToLua.CheckObject(L, 1, typeof(MemBlock));
			int o = obj.UseSize;
			ToLua.Push(L, o);
			return 1;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int CopyBytes(IntPtr L)
	{
		try
		{
			ToLua.CheckArgsCount(L, 4);
			MemBlock obj = (MemBlock)ToLua.CheckObject(L, 1, typeof(MemBlock));
			byte[] arg0 = ToLua.CheckByteBuffer(L, 2);
			int arg1 = (int)LuaDLL.luaL_checknumber(L, 3);;
			int arg2 = (int)LuaDLL.luaL_checknumber(L, 4);;
			obj.CopyBytes(arg0, arg1, arg2);
			return 0;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}
}

