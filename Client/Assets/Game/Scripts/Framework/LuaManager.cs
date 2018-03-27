using UnityEngine;
using System.Collections;
using LuaInterface;
using System.IO;
using System.Text;

public class SimpleLuaResLoader : LuaFileUtils
{
    private StringBuilder mSb = new StringBuilder(42);
    public SimpleLuaResLoader()
    {
        instance = this;
        if (GameSetting.DevelopMode)
        {
            if (GameSetting.LuaBundleMode)
            {
                beZip = true;
            }
            else
            {
                beZip = false;
            }
        }
        else
        {
            beZip = true;
        }
    }

    public override byte[] ReadFile(string fileName)
    {
        if (GameSetting.DevelopMode)
        {
            byte[] buffer = base.ReadFile(fileName);
            if (buffer == null)
            {
                buffer = ReadResourceFile(fileName);
            }
            if (buffer == null)
            {
                buffer = ReadDownLoadFile(fileName);
            }
            return buffer;
        }
        else
        {
            byte[] buffer = ReadDownLoadFile(fileName);
            if (buffer == null)
            {
                buffer = ReadResourceFile(fileName);
            }
            if (buffer == null)
            {
                buffer = base.ReadFile(fileName);
            }
            return buffer;
        }
    }

    private byte[] ReadResourceFile(string fileName)
    {
        byte[] buffer = null;
        string path = "Lua/" + fileName;
        TextAsset text = Resources.Load(path, typeof(TextAsset)) as TextAsset;

        if (text != null)
        {
            buffer = text.bytes;
            Resources.UnloadAsset(text);
        }

        return buffer;
    }

    private byte[] ReadDownLoadFile(string fileName)
    {
        string path = fileName;
        if (!Path.IsPathRooted(fileName))
        {
            string dir = Application.persistentDataPath.Replace('\\', '/');
            mSb.Remove(0, mSb.Length).Append(dir).Append("/").Append(GetOSDir())
                .Append("/Lua/").Append(fileName);
            path = mSb.ToString();
        }
        if (File.Exists(path))
        {
            return File.ReadAllBytes(path);
        }
        return null;
    }
}

public class SimpleLuaClient : LuaClient
{
    protected override LuaFileUtils InitLoader()
    {
        return new SimpleLuaResLoader();
    }

    protected override void LoadLuaFiles()
    {
    }

    protected override void OpenLibs()
    {
        base.OpenLibs();
    }

    public override void CallMain()
    {
        base.CallMain();
    }

    protected override void StartMain()
    {
        base.StartMain();
    }

    protected override void Bind()
    {
        base.Bind();
    }

    protected override void OnLoadFinished()
    {
    }

    public void OnLuaFilesLoaded()
    {
        if (GameSetting.EnableLuaDebug && LuaConst.openZbsDebugger)
        {
            OpenZbsDebugger();
        }

        luaState.Start();
        StartLooper();
        StartMain();
    }
}

public class LuaManager : Manager
{
    private SimpleLuaClient mSimpleLuaClient;

    private void InitLuaPath()
    {
       if (!GameSetting.DevelopMode)
        {
            SimpleLuaClient.GetMainState().AddSearchPath(Tools.DataPath + "lua");
        }
    }

    private void Awake()
    {
        mSimpleLuaClient = gameObject.AddComponent<SimpleLuaClient>();
    }

    public void StartMain()
    {
        mSimpleLuaClient.CallMain();
    }

    private void AddBundle(string bundleName)
    {
        string url = Tools.DataPath + bundleName;
        if (File.Exists(url))
        {
            AssetBundle bundle = AssetBundle.LoadFromFile(url);
            if (bundle != null)
            {
                bundleName = bundleName.Replace("lua/", "");
                bundleName = bundleName.Replace(".unity3d", "");
                LuaFileUtils.Instance.AddSearchBundle(bundleName.ToLower(), bundle);
            }
        }
    }

    /// <summary>
    /// 初始化LuaBundle
    /// </summary>
    void InitLuaBundle()
    {
        if (!GameSetting.DevelopMode
            && GameSetting.LuaBundleMode)
        {
            string[] files = File.ReadAllLines(Tools.DataPath + "files.txt");
            string BundlesPath = "/lua/lua_";
            string BundlesExtName = ".manifest";
            for (int i = 0; i < files.Length; i++)
            {
                if (files[i].StartsWith(BundlesPath) && !files[i].Contains(BundlesExtName))
                {
                    string[] BundlesName = files[i].Split('|');
                    AddBundle(BundlesName[0].Remove(0,1).Trim());
                }
            }
            AddBundle("lua/lua.unity3d");//总的luabundle
            //AddBundle("lua/lua_math.unity3d");
            //AddBundle("lua/lua_system.unity3d");
            //AddBundle("lua/lua_u3d.unity3d");
            //AddBundle("lua/lua_misc.unity3d");
            //AddBundle("lua/lua_cjson.unity3d");
            //AddBundle("lua/lua_lscripts.unity3d");
            //AddBundle("lua/lua_socket.unity3d");
            //AddBundle("lua/lua_protobuf.unity3d");
            //AddBundle("lua/lua_UnityEngine.unity3d");
            //AddBundle("lua/lua_system_reflection.unity3d");
            //AddBundle("lua/lua_common.unity3d");
            //AddBundle("lua/lua_common_net.unity3d");
            //AddBundle("lua/lua_eventsystem.unity3d");
            //AddBundle("lua/lua_game_net.unity3d");
            //AddBundle("lua/lua_game_login.unity3d");
            //AddBundle("lua/lua_game_table.unity3d");
            //AddBundle("lua/lua_game_table_model.unity3d");
            //AddBundle("lua/lua_game.unity3d");
            //AddBundle("lua/lua_game_ui.unity3d");
            //AddBundle("lua/lua_game_begin.unity3d");
            //AddBundle("lua/lua_game_accountregister.unity3d");
            //AddBundle("lua/lua_framework_game.unity3d");
            //AddBundle("lua/lua_framework_message.unity3d");
            //AddBundle("lua/lua_framework_net.unity3d");
            //AddBundle("lua/lua_ui_manager.unity3d");
            //AddBundle("lua/lua_ui_uigamebase.unity3d");
            //AddBundle("lua/lua_ui_uienum.unity3d");
            //AddBundle("lua/lua_netcommon_util.unity3d");
            //AddBundle("lua/lua_netcommon_http.unity3d");
            //AddBundle("lua/lua_framework_net_adapter.unity3d");
            //AddBundle("lua/lua_messagecommon_util.unity3d");
            //AddBundle("lua/lua_messagecommon_msg_msg_a2c.unity3d");
            //AddBundle("lua/lua_messagecommon_msg_msg_c2a.unity3d");
            //AddBundle("lua/lua_messagecommon_msg_msg_c2l.unity3d");
            //AddBundle("lua/lua_messagecommon_msg_msg_l2c.unity3d");
            //AddBundle("lua/lua_messagecommon_msg_msg_l2c.unity3d");
        }
    }
    public void InitStart()
    {
        InitLuaPath();
        InitLuaBundle();
        mSimpleLuaClient.OnLuaFilesLoaded();
    }

    public object[] CallFunction(string funcName, params object[] args)
    {
        LuaFunction func = SimpleLuaClient.GetMainState().GetFunction(funcName);
        if (func != null)
        {
            return func.Call(args);
        }
        return null;
    }

    public void Close()
    {
    }
}
