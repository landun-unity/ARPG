using System;
using LuaInterface;

public class GenerateMd5Wrap
{
    public static void Register(LuaState L)
    {
        L.BeginClass(typeof(GenerateMd5), typeof(System.Object));
        L.RegFunction("GenerateMd5Str", GenerateMd5Str);
		L.RegFunction("New", _CreateGenerateMd5);
		L.EndClass();
    }

    [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
    static int _CreateGenerateMd5(IntPtr L)
	{
		try
		{
			int count = LuaDLL.lua_gettop(L);

			if (count == 0)
			{
				GenerateMd5 obj = new GenerateMd5();
				ToLua.PushObject(L, obj);
				return 1;
			}
			else
			{
				return LuaDLL.luaL_throw(L, "invalid arguments to ctor method: ByteArray.New");
			}
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}

    [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
    static int GenerateMd5Str(IntPtr L)
    {
        try
        {
            ToLua.CheckArgsCount(L, 2);
            GenerateMd5 obj = (GenerateMd5)ToLua.CheckObject(L, 1, typeof(GenerateMd5));
            string arg0 = ToLua.CheckString(L, 2);
            string o = obj._GenerateMd5Str(arg0);
            LuaDLL.lua_pushstring(L, o);
            return 1;
        }
        catch (Exception e)
        {
            return LuaDLL.toluaL_exception(L, e);
        }
    }
}

