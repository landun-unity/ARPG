﻿//this source code was auto-generated by tolua#, do not modify it
using System;
using LuaInterface;
using UnityEngine;
using UnityEngine.EventSystems;

public class UnityEngine_PointerEventDataWrap
{
    public static void Register(LuaState L)
    {
        L.BeginClass( typeof(PointerEventData), typeof(System.Object));
		L.RegVar("position", get_position, set_position);
        //L.RegFunction("pressEventCamera", get_pressEventCamera);
        L.RegVar("pressEventCamera", get_pressEventCamera, null);
        L.EndClass();
    }


    [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
    static int get_position(IntPtr L)
    {
        object o = null;

        try
        {
            o = ToLua.ToObject(L, 1);
            PointerEventData obj = (PointerEventData)o;
            UnityEngine.Vector2 ret = obj.position;
            ToLua.Push(L, ret);
            return 1;
        }
        catch (Exception e)
        {
            return LuaDLL.toluaL_exception(L, e, o == null ? "attempt to index position on a nil value" : e.Message);
        }
    }

    [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
    static int set_position(IntPtr L)
    {
        object o = null;

        try
        {
            o = ToLua.ToObject(L, 1);
            UnityEngine.Rect obj = (UnityEngine.Rect)o;
            UnityEngine.Vector2 arg0 = ToLua.ToVector2(L, 2);
            obj.position = arg0;
            ToLua.SetBack(L, 1, obj);
            return 0;
        }
        catch (Exception e)
        {
            return LuaDLL.toluaL_exception(L, e, o == null ? "attempt to index position on a nil value" : e.Message);
        }
    }



        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int get_pressEventCamera(IntPtr L)
        {
            object o = null;

            try
            {
                o = ToLua.ToObject(L, 1);
                PointerEventData obj = (PointerEventData)o;
                UnityEngine.Camera ret = obj.pressEventCamera;
                ToLua.Push(L, ret);
                return 1;
            }
            catch (Exception e)
            {
                return LuaDLL.toluaL_exception(L, e, o == null ? "attempt to index cookie on a nil value" : e.Message);
            }
        }
}

