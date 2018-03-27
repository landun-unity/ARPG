﻿//this source code was auto-generated by tolua#, do not modify it
using System;
using LuaInterface;

public class DG_Tweening_TweenWrap
{
	public static void Register(LuaState L)
	{
		L.BeginClass(typeof(DG.Tweening.Tween), typeof(System.Object));
		L.RegFunction("__tostring", Lua_ToString);
		L.RegVar("timeScale", get_timeScale, set_timeScale);
		L.RegVar("isBackwards", get_isBackwards, set_isBackwards);
		L.RegVar("id", get_id, set_id);
		L.RegVar("target", get_target, set_target);
		L.RegVar("easeOvershootOrAmplitude", get_easeOvershootOrAmplitude, set_easeOvershootOrAmplitude);
		L.RegVar("easePeriod", get_easePeriod, set_easePeriod);
		L.RegVar("fullPosition", get_fullPosition, set_fullPosition);
		L.EndClass();
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

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_timeScale(IntPtr L)
	{
		object o = null;

		try
		{
			o = ToLua.ToObject(L, 1);
			DG.Tweening.Tween obj = (DG.Tweening.Tween)o;
			float ret = obj.timeScale;
			LuaDLL.lua_pushnumber(L, ret);
			return 1;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e, o == null ? "attempt to index timeScale on a nil value" : e.Message);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_isBackwards(IntPtr L)
	{
		object o = null;

		try
		{
			o = ToLua.ToObject(L, 1);
			DG.Tweening.Tween obj = (DG.Tweening.Tween)o;
			bool ret = obj.isBackwards;
			LuaDLL.lua_pushboolean(L, ret);
			return 1;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e, o == null ? "attempt to index isBackwards on a nil value" : e.Message);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_id(IntPtr L)
	{
		object o = null;

		try
		{
			o = ToLua.ToObject(L, 1);
			DG.Tweening.Tween obj = (DG.Tweening.Tween)o;
			object ret = obj.id;
			ToLua.Push(L, ret);
			return 1;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e, o == null ? "attempt to index id on a nil value" : e.Message);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_target(IntPtr L)
	{
		object o = null;

		try
		{
			o = ToLua.ToObject(L, 1);
			DG.Tweening.Tween obj = (DG.Tweening.Tween)o;
			object ret = obj.target;
			ToLua.Push(L, ret);
			return 1;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e, o == null ? "attempt to index target on a nil value" : e.Message);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_easeOvershootOrAmplitude(IntPtr L)
	{
		object o = null;

		try
		{
			o = ToLua.ToObject(L, 1);
			DG.Tweening.Tween obj = (DG.Tweening.Tween)o;
			float ret = obj.easeOvershootOrAmplitude;
			LuaDLL.lua_pushnumber(L, ret);
			return 1;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e, o == null ? "attempt to index easeOvershootOrAmplitude on a nil value" : e.Message);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_easePeriod(IntPtr L)
	{
		object o = null;

		try
		{
			o = ToLua.ToObject(L, 1);
			DG.Tweening.Tween obj = (DG.Tweening.Tween)o;
			float ret = obj.easePeriod;
			LuaDLL.lua_pushnumber(L, ret);
			return 1;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e, o == null ? "attempt to index easePeriod on a nil value" : e.Message);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_fullPosition(IntPtr L)
	{
		object o = null;

		try
		{
			o = ToLua.ToObject(L, 1);
			DG.Tweening.Tween obj = (DG.Tweening.Tween)o;
			float ret = obj.fullPosition;
			LuaDLL.lua_pushnumber(L, ret);
			return 1;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e, o == null ? "attempt to index fullPosition on a nil value" : e.Message);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int set_timeScale(IntPtr L)
	{
		object o = null;

		try
		{
			o = ToLua.ToObject(L, 1);
			DG.Tweening.Tween obj = (DG.Tweening.Tween)o;
			float arg0 = (float)LuaDLL.luaL_checknumber(L, 2);
			obj.timeScale = arg0;
			return 0;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e, o == null ? "attempt to index timeScale on a nil value" : e.Message);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int set_isBackwards(IntPtr L)
	{
		object o = null;

		try
		{
			o = ToLua.ToObject(L, 1);
			DG.Tweening.Tween obj = (DG.Tweening.Tween)o;
			bool arg0 = LuaDLL.luaL_checkboolean(L, 2);
			obj.isBackwards = arg0;
			return 0;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e, o == null ? "attempt to index isBackwards on a nil value" : e.Message);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int set_id(IntPtr L)
	{
		object o = null;

		try
		{
			o = ToLua.ToObject(L, 1);
			DG.Tweening.Tween obj = (DG.Tweening.Tween)o;
			object arg0 = ToLua.ToVarObject(L, 2);
			obj.id = arg0;
			return 0;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e, o == null ? "attempt to index id on a nil value" : e.Message);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int set_target(IntPtr L)
	{
		object o = null;

		try
		{
			o = ToLua.ToObject(L, 1);
			DG.Tweening.Tween obj = (DG.Tweening.Tween)o;
			object arg0 = ToLua.ToVarObject(L, 2);
			obj.target = arg0;
			return 0;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e, o == null ? "attempt to index target on a nil value" : e.Message);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int set_easeOvershootOrAmplitude(IntPtr L)
	{
		object o = null;

		try
		{
			o = ToLua.ToObject(L, 1);
			DG.Tweening.Tween obj = (DG.Tweening.Tween)o;
			float arg0 = (float)LuaDLL.luaL_checknumber(L, 2);
			obj.easeOvershootOrAmplitude = arg0;
			return 0;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e, o == null ? "attempt to index easeOvershootOrAmplitude on a nil value" : e.Message);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int set_easePeriod(IntPtr L)
	{
		object o = null;

		try
		{
			o = ToLua.ToObject(L, 1);
			DG.Tweening.Tween obj = (DG.Tweening.Tween)o;
			float arg0 = (float)LuaDLL.luaL_checknumber(L, 2);
			obj.easePeriod = arg0;
			return 0;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e, o == null ? "attempt to index easePeriod on a nil value" : e.Message);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int set_fullPosition(IntPtr L)
	{
		object o = null;

		try
		{
			o = ToLua.ToObject(L, 1);
			DG.Tweening.Tween obj = (DG.Tweening.Tween)o;
			float arg0 = (float)LuaDLL.luaL_checknumber(L, 2);
			obj.fullPosition = arg0;
			return 0;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e, o == null ? "attempt to index fullPosition on a nil value" : e.Message);
		}
	}
}

