using UnityEngine;
using System.Collections;
using System.Collections.Generic;
using System.IO;
using System;
using System.Text;

public class GameManager : Manager
{
    protected static bool mInitialize = false;

    private List<string> mDownloadFiles = new List<string>();

    private StringBuilder mSb = new StringBuilder(42);

    ResourceManager resMgr = AppFacade.Instance.AddManager<ResourceManager>();

    public static GameManager Instance;

    #region 数据
    //等待解压的文件大小
    public float z_WaitDecompressionSize = 0f;
    //正在解压大小
    public float z_fileSize = 0;
    //需要更新大小
    public float z_update_Size = 0f;
    //正在更新大小
    public float z_nowUpdateSize = 0f;
    //解压进度
    public float z_DecompressionPercent = 0;
    //下载进度
    public float z_UpdatePercent = 0f;
    //显示解压界面
    public bool z_showDecompressionUI = false;
    //解压是否完成
    public bool z_decompressionBool = false;
    //需要更新
    public bool z_needUpdateBool = false;
    //是否更新
    public bool z_checkUpdateBool = false;
    //更新是否完成
    public bool z_updateBool = false;
    //需要初始化
    public bool z_needInitializeBool = false;
    //初始化是否结束
    public bool z_initializeBool = false;
    //关闭热更新UI
    public bool z_closeHotUpdateUI = false;
    //解压失败
    public bool z_waringDecompressionBool = false;
    //更新失败
    public bool z_waringUpdateBool = false;
    //初始化失败
    public bool z_waringInitializeBool = false;

    public bool z_WaitCheckUpdate = false;
    #endregion

    void Awake()
    {
        Init();
        Instance = this;
    }

    void Init()
    {
        //释放资源
        CheckExtractResource();
        Screen.sleepTimeout = SleepTimeout.NeverSleep;
        Application.targetFrameRate = GameSetting.GameFrameRate;
    }

    /// <summary>
    /// 释放资源
    /// </summary>
    public void CheckExtractResource()
    {
        bool isExists = Directory.Exists(Tools.DataPath)
            && Directory.Exists(Tools.DataPath + "lua/")
            && Directory.Exists(Tools.DataPath + "Resources/")
            && File.Exists(Tools.DataPath + "files.txt");

        if (isExists || GameSetting.DevelopMode)
        {
            z_decompressionBool = true;
            z_WaitCheckUpdate = true;
            StartCoroutine(CheckUpdateSize());
            return;   //文件已经解压过了，自己可添加检查文件列表逻辑
        }
        StartDecompression();

    }
    //启动解压方法
    public void StartDecompression()
    {
        z_showDecompressionUI = true;
        try
        {
            StartCoroutine(OnExtractResource());    //启动释放协成 
        }
        catch (IOException e)
        {
            //弹出解压失败界面
            z_waringDecompressionBool = true;
            if (e.Source != null)
            {
                Debug.Log("游戏解压失败，请检查内存空间");
            }
            throw;
        }
    }
    #region 统计文件大小方法

    /// <summary>
    /// 获取单个文件大小方法，返回Long
    /// </summary>
    /// <param name="文件绝对路径"></param>
    /// <returns></returns>
    public static float GetFileLength(string filepath){
        FileInfo fi =  new FileInfo(filepath);
        float len = 0;
        len = fi.Length;
        return len;
    }
    /// <summary>
    /// 获取文件夹下所有数据，包括子文件
    /// </summary>
    /// <param name="文件夹路径"></param>
    /// <returns></returns>
    public static float GetDirectorySLength(string dirPath)
    {
        if (!Directory.Exists(dirPath))
            return 0;
        float len = 0;

        DirectoryInfo di = new DirectoryInfo(dirPath);

        foreach (FileInfo fi in di.GetFiles())
        {
            len += fi.Length;
        }

        //获取di中所有的文件夹,并存到一个新的对象数组中
        DirectoryInfo[] dis = di.GetDirectories();
        if (dis.Length > 0)
        {
            for (int i = 0; i < dis.Length; i++)
            {
                //Debug.Log(dis[i].FullName);
                //递归
                len += GetDirectorySLength(dis[i].FullName);
            }
        }
        return len;
    }
    #endregion
    IEnumerator OnExtractResource()
    {
        
        string dataPath = Tools.DataPath; //数据目录
        string resPath = Tools.AppContentPath(); //游戏包资源目录
       // Debug.Log(resPath);
        if (Directory.Exists(dataPath)) Directory.Delete(dataPath,true);
        Directory.CreateDirectory(dataPath);

        string infile = resPath + "/files.txt";
        string outfile = dataPath + "files.txt";
        if (File.Exists(outfile)) File.Delete(outfile);

        string message = "正在解包文件:>files.txt";

        if (Application.platform == RuntimePlatform.Android)
        {
            WWW www = new WWW(infile);
            yield return www;

            if (www.isDone)
            {
                File.WriteAllBytes(outfile, www.bytes);
            }
            yield return null;
        }
        else
        {
            File.Copy(infile, outfile, true);
        }

        yield return new WaitForEndOfFrame();
        z_WaitDecompressionSize = 440401920;
        //释放所有文件到数据目录

        //string[] infiles = File.ReadAllLines(infile);
        //foreach (string file in infiles)
        //{
        //    string[] fs = file.Split('|');
        //    infile = resPath + fs[0];
        //    z_WaitDecompressionSize += GetFileLength(infile);
        //}
 
        string[] files = File.ReadAllLines(outfile);
        foreach (string file in files)
        {
            string[] fs = file.Split('|');
            infile = resPath + fs[0];
            outfile = dataPath + fs[0];


            message = "正在解包文件:>" + fs[0];
            //Debug.Log("正在解包文件" + infile);

            GameFacade.SendMessageCommand(NotiConst.UPDATE_MESSAGE, message);

            string dir = Path.GetDirectoryName(outfile);
            if (!Directory.Exists(dir))
            {
                Directory.CreateDirectory(dir);
            }

            if (Application.platform == RuntimePlatform.Android)
            {
                WWW www = new WWW(infile);
                yield return www;
                if (www.isDone)
                {
                    File.WriteAllBytes(outfile, www.bytes);
                }
                yield return null;
            }
            else
            {
                if (File.Exists(outfile))
                {
                    File.Delete(outfile);
                }
                File.Copy(infile, outfile, true);
            }
            //输出当前已解压文件大小
            z_fileSize += GetFileLength(outfile);
            z_DecompressionPercent = z_fileSize / z_WaitDecompressionSize;
            ///这里需要返回一个percent信息

            yield return new WaitForEndOfFrame();
        }

        message = "解包完成!!!";
        Debug.Log("解压完成");
        //解压完成，开关true
       z_decompressionBool = true;
       z_WaitCheckUpdate = true;
        GameFacade.SendMessageCommand(NotiConst.UPDATE_MESSAGE, message);
        yield return new WaitForSeconds(0.1f);


        message = string.Empty;
        //释放完成，开始启动更新资源
        Debug.Log("开始更新方法，切换界面");

        StartCoroutine(CheckUpdateSize());
    }

    private void OnUpdateFailed(string file)
    {
        string message = "更新失败!>" + file;
        //弹出更新失败界面
        z_waringUpdateBool = true;
        Debug.LogWarning("更新失败!");
        GameFacade.SendMessageCommand(NotiConst.UPDATE_MESSAGE, message);
    }

    /// <summary>
    /// 是否下载完成
    /// </summary>
    bool IsDownOK(string file)
    {
        return mDownloadFiles.Contains(file);
    }

    /// <summary>
    /// 线程下载
    /// </summary>
    void BeginDownload(string url, string file)
    {     //线程下载
        object[] param = new object[2] { url, file };
        ThreadEvent ev = new ThreadEvent();
        ev.mKey = NotiConst.UPDATE_DOWNLOAD;
        ev.mParams.AddRange(param);
        ThreadMgr.AddEvent(ev, OnThreadCompleted);   //线程下载
    }

    /// <summary>
    /// 线程完成
    /// </summary>
    /// <param name="data"></param>
    void OnThreadCompleted(NotiData data)
    {
        switch (data.mEvName)
        {
            case NotiConst.UPDATE_EXTRACT:  //解压一个完成
                //
                break;
            case NotiConst.UPDATE_DOWNLOAD: //下载一个完成
                mDownloadFiles.Add(data.mEvParam.ToString());
                break;
        }
    }

    /// <summary>
    /// 启动更新下载，这里只是个思路演示，此处可启动线程下载更新
    /// </summary>
    IEnumerator OnUpdateResource()
    {
        Debug.Log("更新方法开启>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>.");
        if (!GameSetting.UpdateMode)
        {
            OnResourceInited();
            yield break;
        }

        string dataPath = Tools.DataPath;
        string url = GameSetting.WebUrl;
        string message = string.Empty;

        string random = DateTime.Now.ToString("yyyymmddhhmmss");

        string listUrl = url + "files.txt?v=" + random;
       // Debug.LogWarning("LoadUpdate---->>>" + listUrl);
       // Debug.Log("准备连接服务器");
        WWW www = new WWW(url + "files.txt");
        yield return www;
        if (www.error != null)
        {
            OnUpdateFailed(string.Empty);
            yield break;
        }

        if (!Directory.Exists(dataPath))
        {
            Directory.CreateDirectory(dataPath);
        }

        File.WriteAllBytes(dataPath + "files.txt", www.bytes);
        Debug.Log("已经连接上");
        string filesText = www.text;
        string[] files = filesText.Split('\n');
        if (z_checkUpdateBool)
        {
            for (int i = 0; i < files.Length; i++)
            {
                if (string.IsNullOrEmpty(files[i])) continue;

                string[] keyValue = files[i].Split('|');
                string f = keyValue[0].Remove(0, 1);
                //本地地址
                string localFile = (dataPath + f).Trim();
                string path = Path.GetDirectoryName(localFile);
                if (!Directory.Exists(path))
                {
                    Directory.CreateDirectory(path);
                }
                //服务器的文件地址
                string fileUrl = mSb.Remove(0, mSb.Length)
                        .Append(url)
                        .Append(f)
                    /*.Append("?v=")
                    .Append(random)*/.ToString();
                //不存在文件检查
                bool canUpdate = !File.Exists(localFile);
                //本地存在文件比对MD5
                if (!canUpdate)
                {
                    string remoteMd5 = keyValue[1].Trim();
                    string localMd5 = Tools.md5file(localFile);
                    canUpdate = !remoteMd5.Equals(localMd5);
                    if (canUpdate) File.Delete(localFile);
                }

                //本地缺少文件
                if (canUpdate)
                {
                    z_nowUpdateSize += float.Parse(keyValue[2]);
                    //Debug.Log("更新下载大小！！！！！！！！！！！！！！" + z_nowUpdateSize);
                    z_UpdatePercent = z_nowUpdateSize / z_update_Size;
                    //输出进度条百分比
                   // Debug.Log("进度条百分比》》》》》》》》》》》" + z_UpdatePercent);

                  //  Debug.Log(fileUrl + localFile + "AAAAAAAAAAAAAAAAAAAAAAAAAAA");

                    message = mSb.Remove(0, mSb.Length).Append("downloading>>")
                        .Append(fileUrl).ToString();
                    Debug.Log(">>>>>>>>>>>>>>正在下载");
                    GameFacade.SendMessageCommand(NotiConst.UPDATE_MESSAGE, message);
                    /*
                    www = new WWW(fileUrl); yield return www;
                    if (www.error != null) {
                        OnUpdateFailed(path);   
                        yield break;
                    }
                    File.WriteAllBytes(localfile, www.bytes);
                     */
                    //这里都是资源文件，用线程下载
                    BeginDownload(fileUrl, localFile);
                    while (!(IsDownOK(localFile)))
                    {
                        yield return new WaitForEndOfFrame();
                    }
                }
            }
        yield return new WaitForEndOfFrame();
        Debug.Log("更新完成！！！！");
        message = "更新完成!!";
        GameFacade.SendMessageCommand(NotiConst.UPDATE_MESSAGE, message);
        //输出准备初始化数值
        Debug.Log("准备初始化游戏...请稍后");
        z_updateBool = true;
        z_needInitializeBool = true;
        //开启资源初始化
        OnResourceInited();
        }
            //如果不点确定的话
    }
    IEnumerator CheckUpdateSize()
    {
        //Debug.Log("检查更新方法开启");
        if (!GameSetting.UpdateMode)
        {
            z_needInitializeBool = true;
            z_WaitCheckUpdate = false;
            OnResourceInited();
            yield break;
        }

        string dataPath = Tools.DataPath;
        string url = GameSetting.WebUrl;
        string message = string.Empty;

        string random = DateTime.Now.ToString("yyyymmddhhmmss");

        string listUrl = url + "files.txt?v=" + random;
       // Debug.LogWarning("LoadUpdate---->>>" + listUrl);
        Debug.Log("准备连接服务器");
        WWW www = new WWW(url + "files.txt");
        yield return www;
        if (www.error != null)
        {
            OnUpdateFailed(string.Empty);
            yield break;
        }

        if (!Directory.Exists(dataPath))
        {
            Directory.CreateDirectory(dataPath);
        }

        File.WriteAllBytes(dataPath + "files.txt", www.bytes);
        Debug.Log("已经连接上");
        string filesText = www.text;
        string[] files = filesText.Split('\n');

        //获取需要更新文件的总大小
        for (int i = 0; i < files.Length; i++)
        {
            if (string.IsNullOrEmpty(files[i])) continue;
            string[] keyValue = files[i].Split('|');
            string f = keyValue[0].Remove(0,1);
            string localFile = (dataPath + f).Trim();
            string path = Path.GetDirectoryName(localFile);
            if (!Directory.Exists(path))
            {
                Directory.CreateDirectory(path);
            }
            string fileUrl = mSb.Remove(0, mSb.Length)
                    .Append(url)
                    .Append(f)
                    .ToString();
            bool needUpdate = !File.Exists(localFile);

            //本地存在文件比对MD5
            if (!needUpdate)
            {
                string remoteMd5 = keyValue[1].Trim();
                string localMd5 = Tools.md5file(localFile);
                needUpdate = !remoteMd5.Equals(localMd5);
            }
            if (needUpdate)
            {
                z_update_Size += float.Parse(keyValue[2]);
            }
        }

        Debug.Log("需要更新的内容总量为" + z_update_Size);
        //弹出提示更新界面,判断是否需要更新
        if (z_update_Size > 0)
        {
            z_WaitCheckUpdate = false;
            z_needUpdateBool = true;
        }
        else
        {
            Debug.Log("不需要更新，准备初始化游戏...请稍后");
            if (!z_needUpdateBool)
            {
                z_WaitCheckUpdate = false;
                z_needInitializeBool = true;
            }
            OnResourceInited();
        }
        yield return new WaitForEndOfFrame();
    }

    /// <summary>
    /// 资源初始化结束
    /// </summary>
    public void OnResourceInited()
    {
        try
        {
#if ASYNC_MODE
            if (GameSetting.DevelopMode)
            {
                StartCoroutine(LoadAssetPacker());

                OnInitialize();
            }
            else
            {
                ResManager.Initialize(Tools.GetOS(), delegate()
                {
                    StartCoroutine(LoadAssetPacker());

                    Debug.Log("Initialize OK!!!");
                    //热更新界面退出
                    z_needInitializeBool = false;
                    z_initializeBool = true;
                    z_closeHotUpdateUI = true;
                    OnInitialize();
                });
            }
#else
        z_needInitializeBool = false;
        z_initializeBool = true;
        z_closeHotUpdateUI = true;
        ResManager.Initialize();
        OnInitialize();
#endif
        }
        catch (Exception)
        {

            Debug.Log("初始化失败!");
            z_initializeBool = false;
            z_waringInitializeBool = true;
            throw;
        }
    }
    //加载资源包
    IEnumerator LoadAssetPacker()
    {
        bool canNext = false;

        resMgr.LoadAssetPacker("res_asset_packer.unity3d", "res_asset_packer", delegate(UnityEngine.Object[] objs)
        {
            if (objs.Length == 0) return;
            GameResFactory.Instance().mAssetPacker = objs[0] as AssetPacker;
            GameResFactory.Instance().mAssetPacker.CopyAssets();
            canNext = true;
        });

        while (canNext == false)  yield return null;
    }

  public  void OnInitialize()
    {
        LuaMgr.InitStart();
        //LuaManager.DoFile("Logic/Game");         //加载游戏
        //LuaManager.DoFile("Logic/Network");      //加载网络
        //NetManager.OnInit();                     //初始化网络
        //Util.CallMethod("Game", "OnInitOK");     //初始化完成
        mInitialize = true;
    }

    /// <summary>
    /// 析构函数
    /// </summary>
    void OnDestroy()
    {
        if (LuaMgr != null)
        {
            LuaMgr.Close();
            Caching.CleanCache();
        }
        Debug.Log("~CacheMemory was cleared");
        Debug.Log("~GameManager was destroyed");
    }
    #region 方法
    //重新开始解压
    public void ReDecompression()
    {
        StartDecompression();
        //清空文件统计数据
        z_DecompressionPercent = 0;
        z_fileSize = 0;
        z_WaitDecompressionSize = 0;
    }
    //重新下载
    public void ReUpdate()
    {
        StartCoroutine(CheckUpdateSize());
        //清空文件统计数据
        z_UpdatePercent = 0;
        z_nowUpdateSize = 0;
        z_update_Size = 0;
    }
    //重新初始化
    public void ReInitialize()
    {
        OnResourceInited();
    }
    //开始更新
    public void CheckUpdate()
    {
        StartCoroutine(OnUpdateResource());
        z_checkUpdateBool = true;
    }
    #endregion
}
