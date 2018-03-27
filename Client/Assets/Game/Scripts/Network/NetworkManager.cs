using UnityEngine;
using System.Collections;
using System.Collections.Generic;
using LuaInterface;
using UnityEngine.UI;

public class NetworkManager : Manager
{
    private LuaState mLuaState = null;
    private LuaTable mLuaTable = null;

    private LuaFunction mLuaOnSocketDataFunc = null;

    static Queue<KeyValuePair<int, ByteBuffer>> sEvents = new Queue<KeyValuePair<int, ByteBuffer>>();

    private void Awake()
    {
        // Text testText = null;
        // testText.text = "Sdsdsadasda";
        // InputField ss = null;
        // ss.text = "232";
        // Toggle tt = null;
        // tt.isOn = true;

        Init();
    }

    private void Init()
    {
    }

    public void SetLuaTable(LuaTable tb)
    {
        mLuaState = SimpleLuaClient.GetMainState();
        if (mLuaState == null) return;

        if (tb == null)
        {
            mLuaTable = mLuaState.GetTable("NetworkManager");
        }
        else
        {
            mLuaTable = tb;
        }

        if (mLuaTable == null)
        {
            Debug.LogWarning("NetworkManager is null:");
            return;
        }
        else
        {
            mLuaOnSocketDataFunc = mLuaTable.GetLuaFunction("on_socket_data") as LuaFunction;
        }
    }

    public void OnSocketData(int key, ByteBuffer value)
    {
        if (mLuaOnSocketDataFunc != null)
        {
            mLuaOnSocketDataFunc.BeginPCall();
            mLuaOnSocketDataFunc.Push(key);
            mLuaOnSocketDataFunc.Push(value);
            mLuaOnSocketDataFunc.PCall();
            mLuaOnSocketDataFunc.EndPCall();
        }
    }

    private bool CheckValid()
    {
        if (mLuaState == null) return false;
        if (mLuaTable == null) return false;
        return true;
    }

    public void SendConnect()
    {
    }

    public void SendMessage(ByteBuffer buffer)
    {
    }

    public static void AddEvent(int _event, ByteBuffer data)
    {
        sEvents.Enqueue(new KeyValuePair<int, ByteBuffer>(_event, data));
    }

    /// <summary>
    /// 交给Command，这里不想关心发给谁。
    /// </summary>
    private void Update()
    {
    }

    private void OnDestroy()
    {
        OnUnLoad();
        Debug.Log("~NetworkManager was destroy");

        if (mLuaOnSocketDataFunc != null)
        {
            mLuaOnSocketDataFunc.Dispose();
            mLuaOnSocketDataFunc = null;
        }

        if (mLuaTable != null)
        {
            mLuaTable.Dispose();
            mLuaTable = null;
        }
    }

    public void OnInit()
    {
        if (!CheckValid()) return;
        LuaFunction OnInitFunc = mLuaTable.GetLuaFunction("on_init") as LuaFunction;
        if (OnInitFunc != null)
        {
            OnInitFunc.BeginPCall();
            OnInitFunc.PCall();
            OnInitFunc.EndPCall();

            OnInitFunc.Dispose();
            OnInitFunc = null;
        }
    }

    public void OnUnLoad()
    {
        if (!CheckValid()) return;
        LuaFunction OnUnLoadFunc = mLuaTable.GetLuaFunction("on_unload") as LuaFunction;
        if (OnUnLoadFunc != null)
        {
            OnUnLoadFunc.BeginPCall();
            OnUnLoadFunc.PCall();
            OnUnLoadFunc.EndPCall();

            OnUnLoadFunc.Dispose();
            OnUnLoadFunc = null;
        }
    }
}
