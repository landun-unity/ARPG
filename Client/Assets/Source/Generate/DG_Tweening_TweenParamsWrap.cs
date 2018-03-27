﻿//this source code was auto-generated by tolua#, do not modify it
using System;
using LuaInterface;

public class DG_Tweening_TweenParamsWrap
{
	public static void Register(LuaState L)
	{
		L.BeginClass(typeof(DG.Tweening.TweenParams), typeof(System.Object));
		L.RegFunction("Clear", Clear);
		L.RegFunction("SetAutoKill", SetAutoKill);
		L.RegFunction("SetId", SetId);
		L.RegFunction("SetTarget", SetTarget);
		L.RegFunction("SetLoops", SetLoops);
		L.RegFunction("SetEase", SetEase);
		L.RegFunction("SetRecyclable", SetRecyclable);
		L.RegFunction("SetUpdate", SetUpdate);
		L.RegFunction("OnStart", OnStart);
		L.RegFunction("OnPlay", OnPlay);
		L.RegFunction("OnRewind", OnRewind);
		L.RegFunction("OnUpdate", OnUpdate);
		L.RegFunction("OnStepComplete", OnStepComplete);
		L.RegFunction("OnComplete", OnComplete);
		L.RegFunction("OnKill", OnKill);
		L.RegFunction("OnWaypointChange", OnWaypointChange);
		L.RegFunction("SetDelay", SetDelay);
		L.RegFunction("SetRelative", SetRelative);
		L.RegFunction("SetSpeedBased", SetSpeedBased);
		L.RegFunction("New", _CreateDG_Tweening_TweenParams);
		L.RegFunction("__tostring", Lua_ToString);
		L.RegVar("Params", get_Params, null);
		L.EndClass();
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int _CreateDG_Tweening_TweenParams(IntPtr L)
	{
		try
		{
			int count = LuaDLL.lua_gettop(L);

			if (count == 0)
			{
				DG.Tweening.TweenParams obj = new DG.Tweening.TweenParams();
				ToLua.PushObject(L, obj);
				return 1;
			}
			else
			{
				return LuaDLL.luaL_throw(L, "invalid arguments to ctor method: DG.Tweening.TweenParams.New");
			}
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int Clear(IntPtr L)
	{
		try
		{
			ToLua.CheckArgsCount(L, 1);
			DG.Tweening.TweenParams obj = (DG.Tweening.TweenParams)ToLua.CheckObject(L, 1, typeof(DG.Tweening.TweenParams));
			DG.Tweening.TweenParams o = obj.Clear();
			ToLua.PushObject(L, o);
			return 1;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int SetAutoKill(IntPtr L)
	{
		try
		{
			ToLua.CheckArgsCount(L, 2);
			DG.Tweening.TweenParams obj = (DG.Tweening.TweenParams)ToLua.CheckObject(L, 1, typeof(DG.Tweening.TweenParams));
			bool arg0 = LuaDLL.luaL_checkboolean(L, 2);
			DG.Tweening.TweenParams o = obj.SetAutoKill(arg0);
			ToLua.PushObject(L, o);
			return 1;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int SetId(IntPtr L)
	{
		try
		{
			ToLua.CheckArgsCount(L, 2);
			DG.Tweening.TweenParams obj = (DG.Tweening.TweenParams)ToLua.CheckObject(L, 1, typeof(DG.Tweening.TweenParams));
			object arg0 = ToLua.ToVarObject(L, 2);
			DG.Tweening.TweenParams o = obj.SetId(arg0);
			ToLua.PushObject(L, o);
			return 1;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int SetTarget(IntPtr L)
	{
		try
		{
			ToLua.CheckArgsCount(L, 2);
			DG.Tweening.TweenParams obj = (DG.Tweening.TweenParams)ToLua.CheckObject(L, 1, typeof(DG.Tweening.TweenParams));
			object arg0 = ToLua.ToVarObject(L, 2);
			DG.Tweening.TweenParams o = obj.SetTarget(arg0);
			ToLua.PushObject(L, o);
			return 1;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int SetLoops(IntPtr L)
	{
		try
		{
			ToLua.CheckArgsCount(L, 2);
			DG.Tweening.TweenParams obj = (DG.Tweening.TweenParams)ToLua.CheckObject(L, 1, typeof(DG.Tweening.TweenParams));
			int arg0 = (int)LuaDLL.luaL_checknumber(L, 2);
			DG.Tweening.TweenParams o = obj.SetLoops(arg0);
			ToLua.PushObject(L, o);
			return 1;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int SetEase(IntPtr L)
	{
		try
		{
			int count = LuaDLL.lua_gettop(L);

			if (count == 2 && TypeChecker.CheckTypes(L, 1, typeof(DG.Tweening.TweenParams), typeof(DG.Tweening.EaseFunction)))
			{
				DG.Tweening.TweenParams obj = (DG.Tweening.TweenParams)ToLua.ToObject(L, 1);
				DG.Tweening.EaseFunction arg0 = null;
				LuaTypes funcType2 = LuaDLL.lua_type(L, 2);

				if (funcType2 != LuaTypes.LUA_TFUNCTION)
				{
					 arg0 = (DG.Tweening.EaseFunction)ToLua.ToObject(L, 2);
				}
				else
				{
					LuaFunction func = ToLua.ToLuaFunction(L, 2);
					arg0 = DelegateFactory.CreateDelegate(typeof(DG.Tweening.EaseFunction), func) as DG.Tweening.EaseFunction;
				}

				DG.Tweening.TweenParams o = obj.SetEase(arg0);
				ToLua.PushObject(L, o);
				return 1;
			}
			else if (count == 2 && TypeChecker.CheckTypes(L, 1, typeof(DG.Tweening.TweenParams), typeof(UnityEngine.AnimationCurve)))
			{
				DG.Tweening.TweenParams obj = (DG.Tweening.TweenParams)ToLua.ToObject(L, 1);
				UnityEngine.AnimationCurve arg0 = (UnityEngine.AnimationCurve)ToLua.ToObject(L, 2);
				DG.Tweening.TweenParams o = obj.SetEase(arg0);
				ToLua.PushObject(L, o);
				return 1;
			}
			else if (count == 4 && TypeChecker.CheckTypes(L, 1, typeof(DG.Tweening.TweenParams), typeof(DG.Tweening.Ease), typeof(System.Nullable<float>), typeof(System.Nullable<float>)))
			{
				DG.Tweening.TweenParams obj = (DG.Tweening.TweenParams)ToLua.ToObject(L, 1);
				DG.Tweening.Ease arg0 = (DG.Tweening.Ease)ToLua.ToObject(L, 2);
				System.Nullable<float> arg1 = (System.Nullable<float>)ToLua.ToObject(L, 3);
				System.Nullable<float> arg2 = (System.Nullable<float>)ToLua.ToObject(L, 4);
				DG.Tweening.TweenParams o = obj.SetEase(arg0, arg1, arg2);
				ToLua.PushObject(L, o);
				return 1;
			}
			else
			{
				return LuaDLL.luaL_throw(L, "invalid arguments to method: DG.Tweening.TweenParams.SetEase");
			}
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int SetRecyclable(IntPtr L)
	{
		try
		{
			ToLua.CheckArgsCount(L, 2);
			DG.Tweening.TweenParams obj = (DG.Tweening.TweenParams)ToLua.CheckObject(L, 1, typeof(DG.Tweening.TweenParams));
			bool arg0 = LuaDLL.luaL_checkboolean(L, 2);
			DG.Tweening.TweenParams o = obj.SetRecyclable(arg0);
			ToLua.PushObject(L, o);
			return 1;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int SetUpdate(IntPtr L)
	{
		try
		{
			int count = LuaDLL.lua_gettop(L);

			if (count == 2 && TypeChecker.CheckTypes(L, 1, typeof(DG.Tweening.TweenParams), typeof(bool)))
			{
				DG.Tweening.TweenParams obj = (DG.Tweening.TweenParams)ToLua.ToObject(L, 1);
				bool arg0 = LuaDLL.lua_toboolean(L, 2);
				DG.Tweening.TweenParams o = obj.SetUpdate(arg0);
				ToLua.PushObject(L, o);
				return 1;
			}
			else if (count == 3 && TypeChecker.CheckTypes(L, 1, typeof(DG.Tweening.TweenParams), typeof(DG.Tweening.UpdateType), typeof(bool)))
			{
				DG.Tweening.TweenParams obj = (DG.Tweening.TweenParams)ToLua.ToObject(L, 1);
				DG.Tweening.UpdateType arg0 = (DG.Tweening.UpdateType)ToLua.ToObject(L, 2);
				bool arg1 = LuaDLL.lua_toboolean(L, 3);
				DG.Tweening.TweenParams o = obj.SetUpdate(arg0, arg1);
				ToLua.PushObject(L, o);
				return 1;
			}
			else
			{
				return LuaDLL.luaL_throw(L, "invalid arguments to method: DG.Tweening.TweenParams.SetUpdate");
			}
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int OnStart(IntPtr L)
	{
		try
		{
			ToLua.CheckArgsCount(L, 2);
			DG.Tweening.TweenParams obj = (DG.Tweening.TweenParams)ToLua.CheckObject(L, 1, typeof(DG.Tweening.TweenParams));
			DG.Tweening.TweenCallback arg0 = null;
			LuaTypes funcType2 = LuaDLL.lua_type(L, 2);

			if (funcType2 != LuaTypes.LUA_TFUNCTION)
			{
				 arg0 = (DG.Tweening.TweenCallback)ToLua.CheckObject(L, 2, typeof(DG.Tweening.TweenCallback));
			}
			else
			{
				LuaFunction func = ToLua.ToLuaFunction(L, 2);
				arg0 = DelegateFactory.CreateDelegate(typeof(DG.Tweening.TweenCallback), func) as DG.Tweening.TweenCallback;
			}

			DG.Tweening.TweenParams o = obj.OnStart(arg0);
			ToLua.PushObject(L, o);
			return 1;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int OnPlay(IntPtr L)
	{
		try
		{
			ToLua.CheckArgsCount(L, 2);
			DG.Tweening.TweenParams obj = (DG.Tweening.TweenParams)ToLua.CheckObject(L, 1, typeof(DG.Tweening.TweenParams));
			DG.Tweening.TweenCallback arg0 = null;
			LuaTypes funcType2 = LuaDLL.lua_type(L, 2);

			if (funcType2 != LuaTypes.LUA_TFUNCTION)
			{
				 arg0 = (DG.Tweening.TweenCallback)ToLua.CheckObject(L, 2, typeof(DG.Tweening.TweenCallback));
			}
			else
			{
				LuaFunction func = ToLua.ToLuaFunction(L, 2);
				arg0 = DelegateFactory.CreateDelegate(typeof(DG.Tweening.TweenCallback), func) as DG.Tweening.TweenCallback;
			}

			DG.Tweening.TweenParams o = obj.OnPlay(arg0);
			ToLua.PushObject(L, o);
			return 1;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int OnRewind(IntPtr L)
	{
		try
		{
			ToLua.CheckArgsCount(L, 2);
			DG.Tweening.TweenParams obj = (DG.Tweening.TweenParams)ToLua.CheckObject(L, 1, typeof(DG.Tweening.TweenParams));
			DG.Tweening.TweenCallback arg0 = null;
			LuaTypes funcType2 = LuaDLL.lua_type(L, 2);

			if (funcType2 != LuaTypes.LUA_TFUNCTION)
			{
				 arg0 = (DG.Tweening.TweenCallback)ToLua.CheckObject(L, 2, typeof(DG.Tweening.TweenCallback));
			}
			else
			{
				LuaFunction func = ToLua.ToLuaFunction(L, 2);
				arg0 = DelegateFactory.CreateDelegate(typeof(DG.Tweening.TweenCallback), func) as DG.Tweening.TweenCallback;
			}

			DG.Tweening.TweenParams o = obj.OnRewind(arg0);
			ToLua.PushObject(L, o);
			return 1;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int OnUpdate(IntPtr L)
	{
		try
		{
			ToLua.CheckArgsCount(L, 2);
			DG.Tweening.TweenParams obj = (DG.Tweening.TweenParams)ToLua.CheckObject(L, 1, typeof(DG.Tweening.TweenParams));
			DG.Tweening.TweenCallback arg0 = null;
			LuaTypes funcType2 = LuaDLL.lua_type(L, 2);

			if (funcType2 != LuaTypes.LUA_TFUNCTION)
			{
				 arg0 = (DG.Tweening.TweenCallback)ToLua.CheckObject(L, 2, typeof(DG.Tweening.TweenCallback));
			}
			else
			{
				LuaFunction func = ToLua.ToLuaFunction(L, 2);
				arg0 = DelegateFactory.CreateDelegate(typeof(DG.Tweening.TweenCallback), func) as DG.Tweening.TweenCallback;
			}

			DG.Tweening.TweenParams o = obj.OnUpdate(arg0);
			ToLua.PushObject(L, o);
			return 1;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int OnStepComplete(IntPtr L)
	{
		try
		{
			ToLua.CheckArgsCount(L, 2);
			DG.Tweening.TweenParams obj = (DG.Tweening.TweenParams)ToLua.CheckObject(L, 1, typeof(DG.Tweening.TweenParams));
			DG.Tweening.TweenCallback arg0 = null;
			LuaTypes funcType2 = LuaDLL.lua_type(L, 2);

			if (funcType2 != LuaTypes.LUA_TFUNCTION)
			{
				 arg0 = (DG.Tweening.TweenCallback)ToLua.CheckObject(L, 2, typeof(DG.Tweening.TweenCallback));
			}
			else
			{
				LuaFunction func = ToLua.ToLuaFunction(L, 2);
				arg0 = DelegateFactory.CreateDelegate(typeof(DG.Tweening.TweenCallback), func) as DG.Tweening.TweenCallback;
			}

			DG.Tweening.TweenParams o = obj.OnStepComplete(arg0);
			ToLua.PushObject(L, o);
			return 1;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int OnComplete(IntPtr L)
	{
		try
		{
			ToLua.CheckArgsCount(L, 2);
			DG.Tweening.TweenParams obj = (DG.Tweening.TweenParams)ToLua.CheckObject(L, 1, typeof(DG.Tweening.TweenParams));
			DG.Tweening.TweenCallback arg0 = null;
			LuaTypes funcType2 = LuaDLL.lua_type(L, 2);

			if (funcType2 != LuaTypes.LUA_TFUNCTION)
			{
				 arg0 = (DG.Tweening.TweenCallback)ToLua.CheckObject(L, 2, typeof(DG.Tweening.TweenCallback));
			}
			else
			{
				LuaFunction func = ToLua.ToLuaFunction(L, 2);
				arg0 = DelegateFactory.CreateDelegate(typeof(DG.Tweening.TweenCallback), func) as DG.Tweening.TweenCallback;
			}

			DG.Tweening.TweenParams o = obj.OnComplete(arg0);
			ToLua.PushObject(L, o);
			return 1;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int OnKill(IntPtr L)
	{
		try
		{
			ToLua.CheckArgsCount(L, 2);
			DG.Tweening.TweenParams obj = (DG.Tweening.TweenParams)ToLua.CheckObject(L, 1, typeof(DG.Tweening.TweenParams));
			DG.Tweening.TweenCallback arg0 = null;
			LuaTypes funcType2 = LuaDLL.lua_type(L, 2);

			if (funcType2 != LuaTypes.LUA_TFUNCTION)
			{
				 arg0 = (DG.Tweening.TweenCallback)ToLua.CheckObject(L, 2, typeof(DG.Tweening.TweenCallback));
			}
			else
			{
				LuaFunction func = ToLua.ToLuaFunction(L, 2);
				arg0 = DelegateFactory.CreateDelegate(typeof(DG.Tweening.TweenCallback), func) as DG.Tweening.TweenCallback;
			}

			DG.Tweening.TweenParams o = obj.OnKill(arg0);
			ToLua.PushObject(L, o);
			return 1;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int OnWaypointChange(IntPtr L)
	{
		try
		{
			ToLua.CheckArgsCount(L, 2);
			DG.Tweening.TweenParams obj = (DG.Tweening.TweenParams)ToLua.CheckObject(L, 1, typeof(DG.Tweening.TweenParams));
			DG.Tweening.TweenCallback<int> arg0 = null;
			LuaTypes funcType2 = LuaDLL.lua_type(L, 2);

			if (funcType2 != LuaTypes.LUA_TFUNCTION)
			{
				 arg0 = (DG.Tweening.TweenCallback<int>)ToLua.CheckObject(L, 2, typeof(DG.Tweening.TweenCallback<int>));
			}
			else
			{
				LuaFunction func = ToLua.ToLuaFunction(L, 2);
				arg0 = DelegateFactory.CreateDelegate(typeof(DG.Tweening.TweenCallback<int>), func) as DG.Tweening.TweenCallback<int>;
			}

			DG.Tweening.TweenParams o = obj.OnWaypointChange(arg0);
			ToLua.PushObject(L, o);
			return 1;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int SetDelay(IntPtr L)
	{
		try
		{
			ToLua.CheckArgsCount(L, 2);
			DG.Tweening.TweenParams obj = (DG.Tweening.TweenParams)ToLua.CheckObject(L, 1, typeof(DG.Tweening.TweenParams));
			float arg0 = (float)LuaDLL.luaL_checknumber(L, 2);
			DG.Tweening.TweenParams o = obj.SetDelay(arg0);
			ToLua.PushObject(L, o);
			return 1;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int SetRelative(IntPtr L)
	{
		try
		{
			ToLua.CheckArgsCount(L, 2);
			DG.Tweening.TweenParams obj = (DG.Tweening.TweenParams)ToLua.CheckObject(L, 1, typeof(DG.Tweening.TweenParams));
			bool arg0 = LuaDLL.luaL_checkboolean(L, 2);
			DG.Tweening.TweenParams o = obj.SetRelative(arg0);
			ToLua.PushObject(L, o);
			return 1;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int SetSpeedBased(IntPtr L)
	{
		try
		{
			ToLua.CheckArgsCount(L, 2);
			DG.Tweening.TweenParams obj = (DG.Tweening.TweenParams)ToLua.CheckObject(L, 1, typeof(DG.Tweening.TweenParams));
			bool arg0 = LuaDLL.luaL_checkboolean(L, 2);
			DG.Tweening.TweenParams o = obj.SetSpeedBased(arg0);
			ToLua.PushObject(L, o);
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

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_Params(IntPtr L)
	{
		try
		{
			ToLua.PushObject(L, DG.Tweening.TweenParams.Params);
			return 1;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}
}

