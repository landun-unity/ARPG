using UnityEngine;
using System.Collections;
using System.Threading;
using System.Collections.Generic;
using System;
using System.Net;
using System.Diagnostics;
using LuaInterface;

public class UIGameObjectClass
{
    private GameObject Z_UIGameObject;
    private int Z_GameObjectLeve;
    private int Z_GameObjectBatch;
    private int Z_GameObjectGraded;
    private LuaFunction Z_des;
    public UIGameObjectClass(GameObject gameobj, int leve, int batch, int graded,LuaFunction des)
    {
        this.Z_UIGameObject = gameobj;
        this.Z_GameObjectLeve = leve;
        this.Z_GameObjectBatch = batch;
        this.Z_GameObjectGraded = graded;
        this.Z_des = des;
    }
    public GameObject UIGameObject
    {
        get
        {
            return Z_UIGameObject;
        }
    }
    public int GameObjectLeve
    {
        get
        {
            return Z_GameObjectLeve;
        }
    }
    public int GameObjectBatch
    {
        get
        {
            return Z_GameObjectBatch;
        }
    }
    public int GameObjectGraded
    {
        get
        {
            return Z_GameObjectGraded;
        }
    }
    public LuaFunction des
    {
        get
        {
            return Z_des;
        }
    }
}

public class UIGameObjectClassPredicate
{
    public static bool UILeve0(UIGameObjectClass UGC)
    {
        if (UGC.GameObjectLeve == 0)
        {
            return true;
        }
        else
        {
            return false;
        }
    }
    public static bool UILeve1(UIGameObjectClass UGC)
    {
        if (UGC.GameObjectLeve == 1)
        {
            return true;
        }
        else
	    {
            return false;
	    }
    }
    public static bool UILeve2(UIGameObjectClass UGC)
    {
        if (UGC.GameObjectLeve == 2)
        {
            return true;
        }
        else
        {
            return false;
        }
    }
}
public class UIDestroyManager : Manager
{
    private Thread uThread;
    private Thread zThread;
    private Stopwatch uStopWatch;
    enum emleve
    {
        leve0 = 0,
        leve1 = 1,
        leve2 = 2,
        leve3 = 3
    }
    public static UIDestroyManager sInstance;
    #region  字段
    //批次
    private bool OpenThread = false;
    private bool OpenGC = false;
    private bool OpenUnload = false;
    Dictionary<GameObject, LuaFunction> Leve1Dic = new Dictionary<GameObject, LuaFunction>();
    Dictionary<GameObject, LuaFunction> Leve2Dic = new Dictionary<GameObject, LuaFunction>();
    Dictionary<GameObject, LuaFunction> leve1Func = new Dictionary<GameObject, LuaFunction>();
    Dictionary<GameObject, LuaFunction> leve2Func = new Dictionary<GameObject, LuaFunction>();
    Queue<GameObject> ClearLeve1 = new Queue<GameObject>();
    Queue<GameObject> CLearLeve2 = new Queue<GameObject>();
    #endregion
    void StartThread()
    {
        zThread = new Thread(Z_TimerCount);
    }
    void Awake()
    {
        sInstance = this;
        StartThread();
        //print("qidong");
        zThread.Start();
    }
    void Update()
    {
        if (OpenUnload)
        {
            //print("OPENUNLOAD");
            OpenUnload = false;
            Resources.UnloadUnusedAssets();
        }
    }
    void OnDisable()
    {
        Thread.Sleep(1000);
        zThread.Abort();
    }
    //注册
    public void Z_Register(GameObject listG, int leve,LuaFunction luafunc,LuaFunction CallBack)
    {
        switch (leve)
        {
            case 0:
                ////print("DesTroy");
                if (CallBack != null)
                {
                    CallBack.BeginPCall();
                    CallBack.PCall();
                    CallBack.EndPCall();
                }
                GameObject.Destroy(listG);
                if (luafunc != null)
                {
                    luafunc.BeginPCall();
                    luafunc.PCall();
                    luafunc.EndPCall();
                }
                
                break;
            case 1:
                ////print("INLeve1");
                if (!Leve1Dic.ContainsKey(listG))
                {
                    
                    Leve1Dic.Add(listG, luafunc);
                    ClearLeve1.Enqueue(listG);
                    if (CallBack != null)
                    {
                        leve1Func.Add(listG, CallBack);
                    }
                }
                //print(Leve2Dic.Count);
                //print(ClearLeve1.Count);
                break;
            case 2:
                //print("INLeve2");
                if (!Leve2Dic.ContainsKey(listG))
                {
                    Leve2Dic.Add(listG, luafunc);
                    CLearLeve2.Enqueue(listG); 
                    if (CallBack!= null)
                    {
                        leve2Func.Add(listG, CallBack);
                    }
                }
                //print(Leve2Dic.Count);
                //print(ClearLeve1.Count);
                break;
            default:
                break;
        }
    }
    //计时器
    public void Z_TimerCount()
    {
        //print("Start");
        //一分钟计时器
        System.Timers.Timer tmr0 = new System.Timers.Timer(1000 * 60 * 1);
        tmr0.Elapsed += delegate
        {
            //print(ClearLeve1.Count);
            if (Leve1Dic.Count > 0)
            {
                //print("一分钟启动");
               // Z_Clear(1);
            }
            OpenGC = true;
            System.GC.Collect();
            //print("子线程GC启动");
        };
        tmr0.Start();
        //五分钟计时器
        System.Timers.Timer tmr1 = new System.Timers.Timer(1000 * 60 * 5);
        tmr1.Elapsed += delegate
        {
            //print(CLearLeve2.Count);
            if (Leve2Dic.Count > 0)
            {
                //print("五分钟启动");
                //Z_Clear(2);
            }
            OpenUnload = true;
            //print("五分钟计时器开始");
        };
        tmr1.Start();
    }
    //激活列表
    public void Z_Activation(GameObject obj,int leve)
    {
        //print("Actication");
        //print(obj.name);
        switch (leve)
        {
            case 1:
                if (Leve1Dic.ContainsKey(obj))
                {
                    //print("Actication1");
                    Leve1Dic.Remove(obj);
                    leve1Func.Remove(obj);
                }
                break;
            case 2:
                if (Leve2Dic.ContainsKey(obj))
                {
                    //print("Actication2");
                    Leve2Dic.Remove(obj);
                    leve2Func.Remove(obj);
                }
                break;
            default:
                break;
        }
    }
    //清理
    private void Z_Clear(int leve)
    {
        switch (leve)
        {
            case 1:
                if (ClearLeve1.Count > 0)
                {
                    for (int i = 0; i < ClearLeve1.Count; i++)
                    {
                        GameObject CObj1 = ClearLeve1.Dequeue();
                        if (Leve1Dic.ContainsKey(CObj1))
                        {
                            GameObject.Destroy(CObj1);
                            LuaFunction luafunc = null;
                            Leve1Dic.TryGetValue(CObj1, out luafunc);
                            if (luafunc != null)
                            {
                                luafunc.BeginPCall();
                                luafunc.PCall();
                                luafunc.EndPCall();
                            }
                            Leve1Dic.Remove(CObj1);
                            LuaFunction Callback = null;
                            leve1Func.TryGetValue(CObj1, out Callback);
                            if (Callback != null)
                            {
                                Callback.BeginPCall();
                                Callback.PCall();
                                Callback.EndPCall();
                            }
                            leve1Func.Remove(CObj1);
                        }
                    }
                }
                break;
            case 2:
                for (int i = 0; i < ClearLeve1.Count; i++)
                {
                    if (CLearLeve2.Count > 0)
                    {
                        GameObject CObj2 = CLearLeve2.Dequeue();
                        if (Leve2Dic.ContainsKey(CObj2))
                        {
                            GameObject.Destroy(CObj2);
                            LuaFunction luafunc = null;
                            Leve1Dic.TryGetValue(CObj2, out luafunc);
                            if (luafunc != null)
                            {
                                luafunc.BeginPCall();
                                luafunc.PCall();
                                luafunc.EndPCall();
                            }
                            Leve2Dic.Remove(CObj2);
                            LuaFunction Callback = null;
                            leve2Func.TryGetValue(CObj2, out Callback);
                            if (Callback != null)
                            {
                                Callback.BeginPCall();
                                Callback.PCall();
                                Callback.EndPCall();
                            }
                        }
                    }
                        
                }
                break;
            default:
                break;
        }
    }
}
