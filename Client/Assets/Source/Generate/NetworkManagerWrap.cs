﻿//this source code was auto-generated by tolua#, do not modify it
using System;
using LuaInterface;

public class NetworkManagerWrap
{
	public static void Register(LuaState L)
	{
		L.BeginClass(typeof(NetworkManager), typeof(Manager));
		L.RegFunction("SetLuaTable", SetLuaTable);
		L.RegFunction("OnSocketData", OnSocketData);
		L.RegFunction("SendConnect", SendConnect);
		L.RegFunction("SendMessage", SendMessage);
		L.RegFunction("AddEvent", AddEvent);
		L.RegFunction("OnInit", OnInit);
		L.RegFunction("OnUnLoad", OnUnLoad);
		L.RegFunction("__eq", op_Equality);
		L.RegFunction("__tostring", Lua_ToString);
		L.EndClass();
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int SetLuaTable(IntPtr L)
	{
		try
		{
			ToLua.CheckArgsCount(L, 2);
			NetworkManager obj = (NetworkManager)ToLua.CheckObject(L, 1, typeof(NetworkManager));
			LuaTable arg0 = ToLua.CheckLuaTable(L, 2);
			obj.SetLuaTable(arg0);
			return 0;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int OnSocketData(IntPtr L)
	{
		try
		{
			ToLua.CheckArgsCount(L, 3);
			NetworkManager obj = (NetworkManager)ToLua.CheckObject(L, 1, typeof(NetworkManager));
			int arg0 = (int)LuaDLL.luaL_checknumber(L, 2);
			ByteBuffer arg1 = (ByteBuffer)ToLua.CheckObject(L, 3, typeof(ByteBuffer));
			obj.OnSocketData(arg0, arg1);
			return 0;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int SendConnect(IntPtr L)
	{
		try
		{
			ToLua.CheckArgsCount(L, 1);
			NetworkManager obj = (NetworkManager)ToLua.CheckObject(L, 1, typeof(NetworkManager));
			obj.SendConnect();
			return 0;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int SendMessage(IntPtr L)
	{
		try
		{
			int count = LuaDLL.lua_gettop(L);

			if (count == 2 && TypeChecker.CheckTypes(L, 1, typeof(NetworkManager), typeof(string)))
			{
				NetworkManager obj = (NetworkManager)ToLua.ToObject(L, 1);
				string arg0 = ToLua.ToString(L, 2);
				obj.SendMessage(arg0);
				return 0;
			}
			else if (count == 2 && TypeChecker.CheckTypes(L, 1, typeof(NetworkManager), typeof(ByteBuffer)))
			{
				NetworkManager obj = (NetworkManager)ToLua.ToObject(L, 1);
				ByteBuffer arg0 = (ByteBuffer)ToLua.ToObject(L, 2);
				obj.SendMessage(arg0);
				return 0;
			}
			else if (count == 3 && TypeChecker.CheckTypes(L, 1, typeof(NetworkManager), typeof(string), typeof(UnityEngine.SendMessageOptions)))
			{
				NetworkManager obj = (NetworkManager)ToLua.ToObject(L, 1);
				string arg0 = ToLua.ToString(L, 2);
				UnityEngine.SendMessageOptions arg1 = (UnityEngine.SendMessageOptions)ToLua.ToObject(L, 3);
				obj.SendMessage(arg0, arg1);
				return 0;
			}
			else if (count == 3 && TypeChecker.CheckTypes(L, 1, typeof(NetworkManager), typeof(string), typeof(object)))
			{
				NetworkManager obj = (NetworkManager)ToLua.ToObject(L, 1);
				string arg0 = ToLua.ToString(L, 2);
				object arg1 = ToLua.ToVarObject(L, 3);
				obj.SendMessage(arg0, arg1);
				return 0;
			}
			else if (count == 4 && TypeChecker.CheckTypes(L, 1, typeof(NetworkManager), typeof(string), typeof(object), typeof(UnityEngine.SendMessageOptions)))
			{
				NetworkManager obj = (NetworkManager)ToLua.ToObject(L, 1);
				string arg0 = ToLua.ToString(L, 2);
				object arg1 = ToLua.ToVarObject(L, 3);
				UnityEngine.SendMessageOptions arg2 = (UnityEngine.SendMessageOptions)ToLua.ToObject(L, 4);
				obj.SendMessage(arg0, arg1, arg2);
				return 0;
			}
			else
			{
				return LuaDLL.luaL_throw(L, "invalid arguments to method: NetworkManager.SendMessage");
			}
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int AddEvent(IntPtr L)
	{
		try
		{
			ToLua.CheckArgsCount(L, 2);
			int arg0 = (int)LuaDLL.luaL_checknumber(L, 1);
			ByteBuffer arg1 = (ByteBuffer)ToLua.CheckObject(L, 2, typeof(ByteBuffer));
			NetworkManager.AddEvent(arg0, arg1);
			return 0;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int OnInit(IntPtr L)
	{
		try
		{
			ToLua.CheckArgsCount(L, 1);
			NetworkManager obj = (NetworkManager)ToLua.CheckObject(L, 1, typeof(NetworkManager));
			obj.OnInit();
			return 0;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int OnUnLoad(IntPtr L)
	{
		try
		{
			ToLua.CheckArgsCount(L, 1);
			NetworkManager obj = (NetworkManager)ToLua.CheckObject(L, 1, typeof(NetworkManager));
			obj.OnUnLoad();
			return 0;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int op_Equality(IntPtr L)
	{
		try
		{
			ToLua.CheckArgsCount(L, 2);
			UnityEngine.Object arg0 = (UnityEngine.Object)ToLua.ToObject(L, 1);
			UnityEngine.Object arg1 = (UnityEngine.Object)ToLua.ToObject(L, 2);
			bool o = arg0 == arg1;
			LuaDLL.lua_pushboolean(L, o);
			return 1;
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

