﻿//this source code was auto-generated by tolua#, do not modify it
using System;
using LuaInterface;

public class SocketClientWrap
{
	public static void Register(LuaState L)
	{
		L.BeginClass(typeof(SocketClient), typeof(System.Object));
		L.RegFunction("Init", Init);
		L.RegFunction("Close", Close);
		L.RegFunction("Connect", Connect);
		L.RegFunction("Send", Send);
		L.RegFunction("CopyState", CopyState);
		L.RegFunction("GetStateCount", GetStateCount);
		L.RegFunction("DequeueState", DequeueState);
		L.RegFunction("BufferToInt32", BufferToInt32);
		L.RegFunction("BufferSize", BufferSize);
		L.RegFunction("ReadBuffer", ReadBuffer);
		L.RegFunction("New", _CreateSocketClient);
		L.RegFunction("__tostring", Lua_ToString);
		L.EndClass();
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int _CreateSocketClient(IntPtr L)
	{
		try
		{
			int count = LuaDLL.lua_gettop(L);

			if (count == 0)
			{
				SocketClient obj = new SocketClient();
				ToLua.PushObject(L, obj);
				return 1;
			}
			else
			{
				return LuaDLL.luaL_throw(L, "invalid arguments to ctor method: SocketClient.New");
			}
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int Init(IntPtr L)
	{
		try
		{
			ToLua.CheckArgsCount(L, 3);
			SocketClient obj = (SocketClient)ToLua.CheckObject(L, 1, typeof(SocketClient));
			string arg0 = ToLua.CheckString(L, 2);
			int arg1 = (int)LuaDLL.luaL_checknumber(L, 3);
			obj.Init(arg0, arg1);
			return 0;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int Close(IntPtr L)
	{
		try
		{
			ToLua.CheckArgsCount(L, 1);
			SocketClient obj = (SocketClient)ToLua.CheckObject(L, 1, typeof(SocketClient));
			obj.Close();
			return 0;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int Connect(IntPtr L)
	{
		try
		{
			ToLua.CheckArgsCount(L, 1);
			SocketClient obj = (SocketClient)ToLua.CheckObject(L, 1, typeof(SocketClient));
			obj.Connect();
			return 0;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int Send(IntPtr L)
	{
		try
		{
			int count = LuaDLL.lua_gettop(L);

			if (count == 2 && TypeChecker.CheckTypes(L, 1, typeof(SocketClient), typeof(byte[])))
			{
				SocketClient obj = (SocketClient)ToLua.ToObject(L, 1);
				byte[] arg0 = ToLua.CheckByteBuffer(L, 2);
				obj.Send(arg0);
				return 0;
			}
			else if (count == 4 && TypeChecker.CheckTypes(L, 1, typeof(SocketClient), typeof(byte[]), typeof(int), typeof(int)))
			{
				SocketClient obj = (SocketClient)ToLua.ToObject(L, 1);
				byte[] arg0 = ToLua.CheckByteBuffer(L, 2);
				int arg1 = (int)LuaDLL.lua_tonumber(L, 3);
				int arg2 = (int)LuaDLL.lua_tonumber(L, 4);
				obj.Send(arg0, arg1, arg2);
				return 0;
			}
			else
			{
				return LuaDLL.luaL_throw(L, "invalid arguments to method: SocketClient.Send");
			}
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int CopyState(IntPtr L)
	{
		try
		{
			ToLua.CheckArgsCount(L, 1);
			SocketClient obj = (SocketClient)ToLua.CheckObject(L, 1, typeof(SocketClient));
			obj.CopyState();
			return 0;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int GetStateCount(IntPtr L)
	{
		try
		{
			ToLua.CheckArgsCount(L, 1);
			SocketClient obj = (SocketClient)ToLua.CheckObject(L, 1, typeof(SocketClient));
			int o = obj.GetStateCount();
			LuaDLL.lua_pushinteger(L, o);
			return 1;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int DequeueState(IntPtr L)
	{
		try
		{
			ToLua.CheckArgsCount(L, 1);
			SocketClient obj = (SocketClient)ToLua.CheckObject(L, 1, typeof(SocketClient));
			int o = obj.DequeueState();
			LuaDLL.lua_pushinteger(L, o);
			return 1;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int BufferToInt32(IntPtr L)
	{
		try
		{
			ToLua.CheckArgsCount(L, 1);
			SocketClient obj = (SocketClient)ToLua.CheckObject(L, 1, typeof(SocketClient));
			int o = obj.BufferToInt32();
			LuaDLL.lua_pushinteger(L, o);
			return 1;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int BufferSize(IntPtr L)
	{
		try
		{
			ToLua.CheckArgsCount(L, 1);
			SocketClient obj = (SocketClient)ToLua.CheckObject(L, 1, typeof(SocketClient));
			int o = obj.BufferSize();
			LuaDLL.lua_pushinteger(L, o);
			return 1;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int ReadBuffer(IntPtr L)
	{
		try
		{
			ToLua.CheckArgsCount(L, 4);
			SocketClient obj = (SocketClient)ToLua.CheckObject(L, 1, typeof(SocketClient));
			byte[] arg0 = ToLua.CheckByteBuffer(L, 2);
			int arg1 = (int)LuaDLL.luaL_checknumber(L, 3);
			int arg2 = (int)LuaDLL.luaL_checknumber(L, 4);
			obj.ReadBuffer(arg0, arg1, arg2);
			return 0;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int Lua_ToString(IntPtr L)
	{
		object obj = ToLua.ToObject(L, 1);

		if (obj != null)
		{
			LuaDLL.lua_pushstring(L, obj.ToString());
		}
		else
		{
			LuaDLL.lua_pushnil(L);
		}

		return 1;
	}
}

