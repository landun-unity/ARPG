﻿//this source code was auto-generated by tolua#, do not modify it
using System;
using LuaInterface;

public class System_BitConverterWrap
{
	public static void Register(LuaState L)
	{
		L.BeginStaticLibs("BitConverter");
		L.RegFunction("DoubleToInt64Bits", DoubleToInt64Bits);
		L.RegFunction("Int64BitsToDouble", Int64BitsToDouble);
		L.RegFunction("GetBytes", GetBytes);
		L.RegFunction("ToBoolean", ToBoolean);
		L.RegFunction("ToChar", ToChar);
		L.RegFunction("ToInt16", ToInt16);
		L.RegFunction("ToInt32", ToInt32);
		L.RegFunction("ToInt64", ToInt64);
		L.RegFunction("ToUInt16", ToUInt16);
		L.RegFunction("ToUInt32", ToUInt32);
		L.RegFunction("ToUInt64", ToUInt64);
		L.RegFunction("ToSingle", ToSingle);
		L.RegFunction("ToDouble", ToDouble);
		L.RegFunction("ToString", ToString);
		L.RegVar("IsLittleEndian", get_IsLittleEndian, null);
		L.EndStaticLibs();
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int DoubleToInt64Bits(IntPtr L)
	{
		try
		{
			ToLua.CheckArgsCount(L, 1);
			double arg0 = (double)LuaDLL.luaL_checknumber(L, 1);
			long o = System.BitConverter.DoubleToInt64Bits(arg0);
			LuaDLL.lua_pushnumber(L, o);
			return 1;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int Int64BitsToDouble(IntPtr L)
	{
		try
		{
			ToLua.CheckArgsCount(L, 1);
			long arg0 = (long)LuaDLL.luaL_checknumber(L, 1);
			double o = System.BitConverter.Int64BitsToDouble(arg0);
			LuaDLL.lua_pushnumber(L, o);
			return 1;
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
			int count = LuaDLL.lua_gettop(L);

			if (count == 1 && TypeChecker.CheckTypes(L, 1, typeof(double)))
			{
				double arg0 = (double)LuaDLL.lua_tonumber(L, 1);
				byte[] o = System.BitConverter.GetBytes(arg0);
				ToLua.Push(L, o);
				return 1;
			}
			else if (count == 1 && TypeChecker.CheckTypes(L, 1, typeof(bool)))
			{
				bool arg0 = LuaDLL.lua_toboolean(L, 1);
				byte[] o = System.BitConverter.GetBytes(arg0);
				ToLua.Push(L, o);
				return 1;
			}
			else
			{
				return LuaDLL.luaL_throw(L, "invalid arguments to method: System.BitConverter.GetBytes");
			}
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int ToBoolean(IntPtr L)
	{
		try
		{
			ToLua.CheckArgsCount(L, 2);
			byte[] arg0 = ToLua.CheckByteBuffer(L, 1);
			int arg1 = (int)LuaDLL.luaL_checknumber(L, 2);
			bool o = System.BitConverter.ToBoolean(arg0, arg1);
			LuaDLL.lua_pushboolean(L, o);
			return 1;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int ToChar(IntPtr L)
	{
		try
		{
			ToLua.CheckArgsCount(L, 2);
			byte[] arg0 = ToLua.CheckByteBuffer(L, 1);
			int arg1 = (int)LuaDLL.luaL_checknumber(L, 2);
			char o = System.BitConverter.ToChar(arg0, arg1);
			LuaDLL.lua_pushnumber(L, o);
			return 1;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int ToInt16(IntPtr L)
	{
		try
		{
			ToLua.CheckArgsCount(L, 2);
			byte[] arg0 = ToLua.CheckByteBuffer(L, 1);
			int arg1 = (int)LuaDLL.luaL_checknumber(L, 2);
			short o = System.BitConverter.ToInt16(arg0, arg1);
			LuaDLL.lua_pushnumber(L, o);
			return 1;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int ToInt32(IntPtr L)
	{
		try
		{
			ToLua.CheckArgsCount(L, 2);
			byte[] arg0 = ToLua.CheckByteBuffer(L, 1);
			int arg1 = (int)LuaDLL.luaL_checknumber(L, 2);
			int o = System.BitConverter.ToInt32(arg0, arg1);
			LuaDLL.lua_pushinteger(L, o);
			return 1;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int ToInt64(IntPtr L)
	{
		try
		{
			ToLua.CheckArgsCount(L, 2);
			byte[] arg0 = ToLua.CheckByteBuffer(L, 1);
			int arg1 = (int)LuaDLL.luaL_checknumber(L, 2);
			long o = System.BitConverter.ToInt64(arg0, arg1);
			LuaDLL.lua_pushnumber(L, o);
			return 1;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int ToUInt16(IntPtr L)
	{
		try
		{
			ToLua.CheckArgsCount(L, 2);
			byte[] arg0 = ToLua.CheckByteBuffer(L, 1);
			int arg1 = (int)LuaDLL.luaL_checknumber(L, 2);
			ushort o = System.BitConverter.ToUInt16(arg0, arg1);
			LuaDLL.lua_pushnumber(L, o);
			return 1;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int ToUInt32(IntPtr L)
	{
		try
		{
			ToLua.CheckArgsCount(L, 2);
			byte[] arg0 = ToLua.CheckByteBuffer(L, 1);
			int arg1 = (int)LuaDLL.luaL_checknumber(L, 2);
			uint o = System.BitConverter.ToUInt32(arg0, arg1);
			LuaDLL.lua_pushnumber(L, o);
			return 1;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int ToUInt64(IntPtr L)
	{
		try
		{
			ToLua.CheckArgsCount(L, 2);
			byte[] arg0 = ToLua.CheckByteBuffer(L, 1);
			int arg1 = (int)LuaDLL.luaL_checknumber(L, 2);
			ulong o = System.BitConverter.ToUInt64(arg0, arg1);
			LuaDLL.lua_pushnumber(L, o);
			return 1;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int ToSingle(IntPtr L)
	{
		try
		{
			ToLua.CheckArgsCount(L, 2);
			byte[] arg0 = ToLua.CheckByteBuffer(L, 1);
			int arg1 = (int)LuaDLL.luaL_checknumber(L, 2);
			float o = System.BitConverter.ToSingle(arg0, arg1);
			LuaDLL.lua_pushnumber(L, o);
			return 1;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int ToDouble(IntPtr L)
	{
		try
		{
			ToLua.CheckArgsCount(L, 2);
			byte[] arg0 = ToLua.CheckByteBuffer(L, 1);
			int arg1 = (int)LuaDLL.luaL_checknumber(L, 2);
			double o = System.BitConverter.ToDouble(arg0, arg1);
			LuaDLL.lua_pushnumber(L, o);
			return 1;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int ToString(IntPtr L)
	{
		try
		{
			int count = LuaDLL.lua_gettop(L);

			if (count == 1 && TypeChecker.CheckTypes(L, 1, typeof(byte[])))
			{
				byte[] arg0 = ToLua.CheckByteBuffer(L, 1);
				string o = System.BitConverter.ToString(arg0);
				LuaDLL.lua_pushstring(L, o);
				return 1;
			}
			else if (count == 2 && TypeChecker.CheckTypes(L, 1, typeof(byte[]), typeof(int)))
			{
				byte[] arg0 = ToLua.CheckByteBuffer(L, 1);
				int arg1 = (int)LuaDLL.lua_tonumber(L, 2);
				string o = System.BitConverter.ToString(arg0, arg1);
				LuaDLL.lua_pushstring(L, o);
				return 1;
			}
			else if (count == 3 && TypeChecker.CheckTypes(L, 1, typeof(byte[]), typeof(int), typeof(int)))
			{
				byte[] arg0 = ToLua.CheckByteBuffer(L, 1);
				int arg1 = (int)LuaDLL.lua_tonumber(L, 2);
				int arg2 = (int)LuaDLL.lua_tonumber(L, 3);
				string o = System.BitConverter.ToString(arg0, arg1, arg2);
				LuaDLL.lua_pushstring(L, o);
				return 1;
			}
			else
			{
				return LuaDLL.luaL_throw(L, "invalid arguments to method: System.BitConverter.ToString");
			}
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_IsLittleEndian(IntPtr L)
	{
		try
		{
			LuaDLL.lua_pushboolean(L, System.BitConverter.IsLittleEndian);
			return 1;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}
}

