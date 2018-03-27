using System;
using LuaInterface;


public class CSharp_TimeWrap
{
    public static void Register(LuaState L)
    {
        L.BeginClass(typeof(DateTime), typeof(System.Object));
        L.RegVar("NowTicks", Get_Now, null);
        L.EndClass();
    }

    [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
    static int Get_Now(IntPtr L)
    {
        object o = null;

        try
        {
            ToLua.Push(L, DateTime.Now.Ticks);
            return 1;

           // o = ToLua.ToObject(L, 1);
           // UnityEngine.Debug.Log(o.GetType().Name);
           // DateTime obj = (DateTime)o;
           // long ticks = obj.Ticks;
           // //ToLua.Push(L, ticks);
           // UnityEngine.Debug.Log(ticks);
           //// LuaDLL.tolua_pushint64(L, ticks);
           // LuaDLL.lua_pushnumber(L, ticks);
           // return 1;
        }
        catch (Exception e)
        {
            return LuaDLL.toluaL_exception(L, e, o == null ? "DateTime is null" : e.Message);
        }
    }

}

