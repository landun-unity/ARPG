using UnityEngine;
using System.Collections.Generic;
using System.Collections;
using System.IO;
using LuaInterface;
using UnityEngine.UI;
using System;
using System.Text.RegularExpressions;

public class GameResFactory
{

    private static GameResFactory sInstance = null;

    private static Dictionary<object, object> m_dictionary = new Dictionary<object, object>();
    public static GameResFactory Instance()
    {
        if (sInstance == null)
        {
            sInstance = new GameResFactory();
            sInstance.mResManager = AppFacade.Instance.GetManager<ResourceManager>();
        }
        return sInstance;
    }

    internal ResourceManager mResManager;
    private List<GameObject> mUIEffectsList = new List<GameObject>();
    internal AssetPacker mAssetPacker = null;


    private Vector2 oldPos0;
    private Vector2 oldPos1;


    public Sprite GetResSprite(string spName)
    {
        if (mAssetPacker == null)
        {
            return Sprite.Create(Texture2D.whiteTexture, new Rect(0, 0, 4, 4), new Vector2(0.5f, 0.5f));
        }
        return mAssetPacker.GetSprite(spName);
    }

    /*public Material GetMaterial(string mtName)
    {
        if (mAssetPacker == null)
        {
            return null;
        }
        return mAssetPacker.GetMaterial(mtName);
    }*/
    //加载预设体
    public void GetUIPrefab(string assetName, Transform parent, LuaTable luaTable, LuaFunction luaCallBack)
    {
        #region LoadText_GetUIPrefab
        //  Caching.CleanCache();
        //  string path = "http://192.168.1.75/StreamingAssets/Win/Resources/";
        //  string manifestPath = "http://192.168.1.75/StreamingAssets/Win/" + "Win";  //依赖
        //  WWW wwwManifest = WWW.LoadFromCacheOrDownload(manifestPath, 0);
        ////  yield return wwwManifest;
        //  if (wwwManifest.error == null)
        //  {
        //      AssetBundle manifestBundle = wwwManifest.assetBundle;
        //      AssetBundleManifest manifest = (AssetBundleManifest)manifestBundle.LoadAsset("AssetBundleManifest");
        //      manifestBundle.Unload(false);
        //      //然后根据我们需要加载的资源名称，获得所有依赖资源： 
        //      string[] dependentAssetBundles = manifest.GetAllDependencies("resources/" + assetName + GameSetting.ExtName);

        //      AssetBundle[] abs = new AssetBundle[dependentAssetBundles.Length];
        //      for (int i = 0; i < dependentAssetBundles.Length; i++)
        //      {
        //          WWW www = WWW.LoadFromCacheOrDownload(path + dependentAssetBundles[i].Replace("resources/", string.Empty), 0);
        //          // yield return www;
        //          abs[i] = www.assetBundle;
        //          if (abs[i].name.Contains(".png"))
        //          {
        //              string[] dependentAssets = abs[i].GetAllAssetNames();
        //              abs[i].LoadAsset<Sprite>(dependentAssets[0]);
        //          }
        //      }
        //      //加载资源 
        //      WWW www2 = WWW.LoadFromCacheOrDownload(path + assetName + GameSetting.ExtName, 0);
        //     // yield return www2;
        //      AssetBundle assetBundle = www2.assetBundle;
        //      string[] TargetAssetBundles = assetBundle.GetAllAssetNames();
        //      GameObject obj = assetBundle.LoadAsset<GameObject>(TargetAssetBundles[0]);
        //      //UnityEngine.Debug.Log(obj.name);
        //      if (obj != null)
        //      {
        //          GameObject myObj = GameObject.Instantiate(obj) as GameObject;
        //          myObj.transform.SetParent(parent, false);
        //          myObj.GetComponent<RectTransform>().localPosition = Vector3.zero;

        //          LuaBehaviour tmpBehaviour = myObj.AddComponent<LuaBehaviour>();
        //          tmpBehaviour.Init(luaTable);

        //          if (luaCallBack != null)
        //          {
        //              luaCallBack.BeginPCall();
        //              luaCallBack.Push(myObj);
        //              luaCallBack.PCall();
        //              luaCallBack.EndPCall();
        //          }
        //          Debug.Log("CreatePanel::>> " + assetName + " " + obj);
        //          //Instantiate(obj);
        //          // a = assetBundle.LoadAsset(TargetAssetBundles[0]) as GameObject;
        //      }
        //      assetBundle.Unload(false);

        //      foreach (AssetBundle ab in abs)
        //      {
        //          ab.Unload(false);
        //      }
        //  }
        //  else
        //  {
        //      Debug.Log(wwwManifest.error);
        //  }
        #endregion
        #region Frame_GetUIPrefab
        if (mResManager == null) return;
        string tmpAssetName = assetName;
        if (GameSetting.DevelopMode)
        {

        }
        else
        {
            string[] KeyAssetName = assetName.Replace('_', '/').Split('/');
            assetName = KeyAssetName[1];
            tmpAssetName = assetName;
        }
        mResManager.LoadPrefab(assetName + GameSetting.ExtName, tmpAssetName, delegate(UnityEngine.Object[] objs)
        {
            if (objs.Length == 0) return;
            GameObject prefab = objs[0] as GameObject;
            if (prefab == null)
            {
                return;
            }
            //Debug.Log("GetUIPrefab"+assetName);
            GameObject go = UnityEngine.GameObject.Instantiate(prefab) as GameObject;
            if (GameSetting.DevelopMode)
            {
                go.name = assetName.Split('/')[1];
            }
            else
            {
                go.name = tmpAssetName;
            }
            go.layer = LayerMask.NameToLayer("UI");

            Vector3 anchorPos = Vector3.zero;
            Vector2 sizeDel = Vector2.zero;
            Vector3 scale = Vector3.one;

            RectTransform rtTr = go.GetComponent<RectTransform>();
            if (rtTr != null)
            {
                anchorPos = rtTr.anchoredPosition;
                sizeDel = rtTr.sizeDelta;
                scale = rtTr.localScale;
            }

            go.transform.SetParent(parent, false);

            if (rtTr != null)
            {
                rtTr.anchoredPosition = anchorPos;
                rtTr.sizeDelta = sizeDel;
                rtTr.localScale = scale;
            }

            LuaBehaviour tmpBehaviour = go.AddComponent<LuaBehaviour>();
            tmpBehaviour.Init(luaTable);

            if (luaCallBack != null)
            {
                luaCallBack.BeginPCall();
                luaCallBack.Push(go);
                luaCallBack.PCall();
                luaCallBack.EndPCall();
            }
            //Debug.Log("CreatePanel::>> " + assetName + " " + prefab);
            //mUIList.Add(go);
        });
        #endregion
    }

    //加载预设体
    public void GetUIPrefabByIdentification(string assetName, Transform parent, LuaTable luaTable, LuaFunction luaCallBack, object Identification)
    {
        #region LoadText_GetUIPrefab
        //  Caching.CleanCache();
        //  string path = "http://192.168.1.75/StreamingAssets/Win/Resources/";
        //  string manifestPath = "http://192.168.1.75/StreamingAssets/Win/" + "Win";  //依赖
        //  WWW wwwManifest = WWW.LoadFromCacheOrDownload(manifestPath, 0);
        ////  yield return wwwManifest;
        //  if (wwwManifest.error == null)
        //  {
        //      AssetBundle manifestBundle = wwwManifest.assetBundle;
        //      AssetBundleManifest manifest = (AssetBundleManifest)manifestBundle.LoadAsset("AssetBundleManifest");
        //      manifestBundle.Unload(false);
        //      //然后根据我们需要加载的资源名称，获得所有依赖资源： 
        //      string[] dependentAssetBundles = manifest.GetAllDependencies("resources/" + assetName + GameSetting.ExtName);

        //      AssetBundle[] abs = new AssetBundle[dependentAssetBundles.Length];
        //      for (int i = 0; i < dependentAssetBundles.Length; i++)
        //      {
        //          WWW www = WWW.LoadFromCacheOrDownload(path + dependentAssetBundles[i].Replace("resources/", string.Empty), 0);
        //          // yield return www;
        //          abs[i] = www.assetBundle;
        //          if (abs[i].name.Contains(".png"))
        //          {
        //              string[] dependentAssets = abs[i].GetAllAssetNames();
        //              abs[i].LoadAsset<Sprite>(dependentAssets[0]);
        //          }
        //      }
        //      //加载资源 
        //      WWW www2 = WWW.LoadFromCacheOrDownload(path + assetName + GameSetting.ExtName, 0);
        //     // yield return www2;
        //      AssetBundle assetBundle = www2.assetBundle;
        //      string[] TargetAssetBundles = assetBundle.GetAllAssetNames();
        //      GameObject obj = assetBundle.LoadAsset<GameObject>(TargetAssetBundles[0]);
        //      //UnityEngine.Debug.Log(obj.name);
        //      if (obj != null)
        //      {
        //          GameObject myObj = GameObject.Instantiate(obj) as GameObject;
        //          myObj.transform.SetParent(parent, false);
        //          myObj.GetComponent<RectTransform>().localPosition = Vector3.zero;

        //          LuaBehaviour tmpBehaviour = myObj.AddComponent<LuaBehaviour>();
        //          tmpBehaviour.Init(luaTable);

        //          if (luaCallBack != null)
        //          {
        //              luaCallBack.BeginPCall();
        //              luaCallBack.Push(myObj);
        //              luaCallBack.PCall();
        //              luaCallBack.EndPCall();
        //          }
        //          Debug.Log("CreatePanel::>> " + assetName + " " + obj);
        //          //Instantiate(obj);
        //          // a = assetBundle.LoadAsset(TargetAssetBundles[0]) as GameObject;
        //      }
        //      assetBundle.Unload(false);

        //      foreach (AssetBundle ab in abs)
        //      {
        //          ab.Unload(false);
        //      }
        //  }
        //  else
        //  {
        //      Debug.Log(wwwManifest.error);
        //  }
        #endregion
        #region Frame_GetUIPrefab
        if (m_dictionary.ContainsKey(Identification) == true) return;
        m_dictionary.Add(Identification, Identification);

        if (mResManager == null) return;
        //Debug.Log("GetUIPrefab"+assetName);
        string tmpAssetName = assetName;
        if (GameSetting.DevelopMode)
        {

        }
        else
        {
            string[] KeyAssetName = assetName.Replace('_', '/').Split('/');
            assetName = KeyAssetName[1];
            tmpAssetName = assetName;
        }
        mResManager.LoadPrefab(assetName + GameSetting.ExtName, tmpAssetName, delegate(UnityEngine.Object[] objs)
        {
            if (objs.Length == 0) return;
            GameObject prefab = objs[0] as GameObject;
            if (prefab == null)
            {
                return;
            }
            //Debug.Log("GetUIPrefab"+assetName);
            GameObject go = UnityEngine.GameObject.Instantiate(prefab) as GameObject;
            if (GameSetting.DevelopMode)
            {
                go.name = assetName.Split('/')[1];
            }
            else
            {
                go.name = tmpAssetName;
            }
            go.layer = LayerMask.NameToLayer("UI");

            Vector3 anchorPos = Vector3.zero;
            Vector2 sizeDel = Vector2.zero;
            Vector3 scale = Vector3.one;

            RectTransform rtTr = go.GetComponent<RectTransform>();
            if (rtTr != null)
            {
                anchorPos = rtTr.anchoredPosition;
                sizeDel = rtTr.sizeDelta;
                scale = rtTr.localScale;
            }

            go.transform.SetParent(parent, false);

            if (rtTr != null)
            {
                rtTr.anchoredPosition = anchorPos;
                rtTr.sizeDelta = sizeDel;
                rtTr.localScale = scale;
            }

            LuaBehaviour tmpBehaviour = go.AddComponent<LuaBehaviour>();
            tmpBehaviour.Init(luaTable);

            if (luaCallBack != null)
            {
                luaCallBack.BeginPCall();
                luaCallBack.Push(go);
                luaCallBack.PCall();
                luaCallBack.EndPCall();
            }
            m_dictionary.Remove(Identification);
            //Debug.Log("CreatePanel::>> " + assetName + " " + prefab);
            //mUIList.Add(go);
        });
        #endregion
    }
    //加载资源预设体
    public void GetResourcesPrefab(string assetName, Transform parent, LuaFunction luaCallBack)
    {
        #region LoadText_GetUIPrefab
        //  Caching.CleanCache();
        //  string path = "http://192.168.1.75/StreamingAssets/Win/Resources/";
        //  string manifestPath = "http://192.168.1.75/StreamingAssets/Win/" + "Win";  //依赖
        //  WWW wwwManifest = WWW.LoadFromCacheOrDownload(manifestPath, 0);
        ////  yield return wwwManifest;
        //  if (wwwManifest.error == null)
        //  {
        //      AssetBundle manifestBundle = wwwManifest.assetBundle;
        //      AssetBundleManifest manifest = (AssetBundleManifest)manifestBundle.LoadAsset("AssetBundleManifest");
        //      manifestBundle.Unload(false);
        //      //然后根据我们需要加载的资源名称，获得所有依赖资源： 
        //      string[] dependentAssetBundles = manifest.GetAllDependencies("resources/" + assetName + GameSetting.ExtName);

        //      AssetBundle[] abs = new AssetBundle[dependentAssetBundles.Length];
        //      for (int i = 0; i < dependentAssetBundles.Length; i++)
        //      {
        //          WWW www = WWW.LoadFromCacheOrDownload(path + dependentAssetBundles[i].Replace("resources/", string.Empty), 0);
        //          // yield return www;
        //          abs[i] = www.assetBundle;
        //          if (abs[i].name.Contains(".png"))
        //          {
        //              string[] dependentAssets = abs[i].GetAllAssetNames();
        //              abs[i].LoadAsset<Sprite>(dependentAssets[0]);
        //          }
        //      }
        //      //加载资源 
        //      WWW www2 = WWW.LoadFromCacheOrDownload(path + assetName + GameSetting.ExtName, 0);
        //     // yield return www2;
        //      AssetBundle assetBundle = www2.assetBundle;
        //      string[] TargetAssetBundles = assetBundle.GetAllAssetNames();
        //      GameObject obj = assetBundle.LoadAsset<GameObject>(TargetAssetBundles[0]);
        //      //UnityEngine.Debug.Log(obj.name);
        //      if (obj != null)
        //      {
        //          GameObject myObj = GameObject.Instantiate(obj) as GameObject;
        //          myObj.transform.SetParent(parent, false);
        //          myObj.GetComponent<RectTransform>().localPosition = Vector3.zero;

        //          LuaBehaviour tmpBehaviour = myObj.AddComponent<LuaBehaviour>();
        //          tmpBehaviour.Init(luaTable);

        //          if (luaCallBack != null)
        //          {
        //              luaCallBack.BeginPCall();
        //              luaCallBack.Push(myObj);
        //              luaCallBack.PCall();
        //              luaCallBack.EndPCall();
        //          }
        //          Debug.Log("CreatePanel::>> " + assetName + " " + obj);
        //          //Instantiate(obj);
        //          // a = assetBundle.LoadAsset(TargetAssetBundles[0]) as GameObject;
        //      }
        //      assetBundle.Unload(false);

        //      foreach (AssetBundle ab in abs)
        //      {
        //          ab.Unload(false);
        //      }
        //  }
        //  else
        //  {
        //      Debug.Log(wwwManifest.error);
        //  }
        #endregion
        #region Frame_GetUIPrefab
        if (mResManager == null) return;
        //Debug.Log("GetResourcesPrefab" + assetName);
        string tmpAssetName = assetName;
        if (GameSetting.DevelopMode)
        {

        }
        else
        {
            string[] KeyAssetName = assetName.Replace('_', '/').Split('/');
            assetName = KeyAssetName[1];
            tmpAssetName = assetName;
        }
        mResManager.LoadPrefab(assetName + GameSetting.ExtName, tmpAssetName, delegate(UnityEngine.Object[] objs)
        {
            if (objs.Length == 0) return;
            GameObject prefab = objs[0] as GameObject;
            if (prefab == null)
            {
                return;
            }
            //Debug.Log("GetResourcesPrefab" + assetName);
            GameObject go = UnityEngine.GameObject.Instantiate(prefab) as GameObject;
            if (GameSetting.DevelopMode)
            {
                go.name = assetName.Split('/')[1];
            }
            else
            {
                go.name = tmpAssetName;
            }
            //go.layer = LayerMask.NameToLayer("Default");

            Vector3 anchorPos = Vector3.zero;
            Vector2 sizeDel = Vector2.zero;
            Vector3 scale = Vector3.one;

            RectTransform rtTr = go.GetComponent<RectTransform>();
            if (rtTr != null)
            {
                anchorPos = rtTr.anchoredPosition;
                sizeDel = rtTr.sizeDelta;
                scale = rtTr.localScale;
            }

            go.transform.SetParent(parent, false);

            if (rtTr != null)
            {
                rtTr.anchoredPosition = anchorPos;
                rtTr.sizeDelta = sizeDel;
                rtTr.localScale = scale;
            }
            if (luaCallBack != null)
            {
                luaCallBack.BeginPCall();
                luaCallBack.Push(go);
                luaCallBack.PCall();
                luaCallBack.EndPCall();
            }
            //Debug.Log("CreatePanel::>> " + assetName + " " + prefab);
            //mUIList.Add(go);
        });
        #endregion
    }
    //重复加载问题
    public void GetResourcesPrefabByIdentification(string assetName, Transform parent, LuaFunction luaCallBack, object Identification)
    {
        #region LoadText_GetUIPrefab
        //  Caching.CleanCache();
        //  string path = "http://192.168.1.75/StreamingAssets/Win/Resources/";
        //  string manifestPath = "http://192.168.1.75/StreamingAssets/Win/" + "Win";  //依赖
        //  WWW wwwManifest = WWW.LoadFromCacheOrDownload(manifestPath, 0);
        ////  yield return wwwManifest;
        //  if (wwwManifest.error == null)
        //  {
        //      AssetBundle manifestBundle = wwwManifest.assetBundle;
        //      AssetBundleManifest manifest = (AssetBundleManifest)manifestBundle.LoadAsset("AssetBundleManifest");
        //      manifestBundle.Unload(false);
        //      //然后根据我们需要加载的资源名称，获得所有依赖资源： 
        //      string[] dependentAssetBundles = manifest.GetAllDependencies("resources/" + assetName + GameSetting.ExtName);

        //      AssetBundle[] abs = new AssetBundle[dependentAssetBundles.Length];
        //      for (int i = 0; i < dependentAssetBundles.Length; i++)
        //      {
        //          WWW www = WWW.LoadFromCacheOrDownload(path + dependentAssetBundles[i].Replace("resources/", string.Empty), 0);
        //          // yield return www;
        //          abs[i] = www.assetBundle;
        //          if (abs[i].name.Contains(".png"))
        //          {
        //              string[] dependentAssets = abs[i].GetAllAssetNames();
        //              abs[i].LoadAsset<Sprite>(dependentAssets[0]);
        //          }
        //      }
        //      //加载资源 
        //      WWW www2 = WWW.LoadFromCacheOrDownload(path + assetName + GameSetting.ExtName, 0);
        //     // yield return www2;
        //      AssetBundle assetBundle = www2.assetBundle;
        //      string[] TargetAssetBundles = assetBundle.GetAllAssetNames();
        //      GameObject obj = assetBundle.LoadAsset<GameObject>(TargetAssetBundles[0]);
        //      //UnityEngine.Debug.Log(obj.name);
        //      if (obj != null)
        //      {
        //          GameObject myObj = GameObject.Instantiate(obj) as GameObject;
        //          myObj.transform.SetParent(parent, false);
        //          myObj.GetComponent<RectTransform>().localPosition = Vector3.zero;

        //          LuaBehaviour tmpBehaviour = myObj.AddComponent<LuaBehaviour>();
        //          tmpBehaviour.Init(luaTable);

        //          if (luaCallBack != null)
        //          {
        //              luaCallBack.BeginPCall();
        //              luaCallBack.Push(myObj);
        //              luaCallBack.PCall();
        //              luaCallBack.EndPCall();
        //          }
        //          Debug.Log("CreatePanel::>> " + assetName + " " + obj);
        //          //Instantiate(obj);
        //          // a = assetBundle.LoadAsset(TargetAssetBundles[0]) as GameObject;
        //      }
        //      assetBundle.Unload(false);

        //      foreach (AssetBundle ab in abs)
        //      {
        //          ab.Unload(false);
        //      }
        //  }
        //  else
        //  {
        //      Debug.Log(wwwManifest.error);
        //  }
        #endregion
        #region Frame_GetUIPrefab
        if (m_dictionary.ContainsKey(Identification) == true) return;
        m_dictionary.Add(Identification, Identification);

        if (mResManager == null) return;
        //Debug.Log("GetResourcesPrefab" + assetName);
        string tmpAssetName = assetName;
        if (GameSetting.DevelopMode)
        {

        }
        else
        {
            string[] KeyAssetName = assetName.Replace('_', '/').Split('/');
            assetName = KeyAssetName[1];
            tmpAssetName = assetName;
        }
        mResManager.LoadPrefab(assetName + GameSetting.ExtName, tmpAssetName, delegate(UnityEngine.Object[] objs)
        {
            if (objs.Length == 0) return;
            GameObject prefab = objs[0] as GameObject;
            if (prefab == null)
            {
                return;
            }
            //Debug.Log("GetResourcesPrefab" + assetName);
            GameObject go = UnityEngine.GameObject.Instantiate(prefab) as GameObject;
            if (GameSetting.DevelopMode)
            {
                go.name = assetName.Split('/')[1];
            }
            else
            {
                go.name = tmpAssetName;
            }
            //go.layer = LayerMask.NameToLayer("Default");

            Vector3 anchorPos = Vector3.zero;
            Vector2 sizeDel = Vector2.zero;
            Vector3 scale = Vector3.one;

            RectTransform rtTr = go.GetComponent<RectTransform>();
            if (rtTr != null)
            {
                anchorPos = rtTr.anchoredPosition;
                sizeDel = rtTr.sizeDelta;
                scale = rtTr.localScale;
            }

            go.transform.SetParent(parent, false);

            if (rtTr != null)
            {
                rtTr.anchoredPosition = anchorPos;
                rtTr.sizeDelta = sizeDel;
                rtTr.localScale = scale;
            }
            if (luaCallBack != null)
            {
                luaCallBack.BeginPCall();
                luaCallBack.Push(go);
                luaCallBack.PCall();
                luaCallBack.EndPCall();
            }
            m_dictionary.Remove(Identification);
            //Debug.Log("CreatePanel::>> " + assetName + " " + prefab);
            //mUIList.Add(go);
        });
        #endregion
    }
    public void DestroyUIPrefab(GameObject go)
    {
        GameObject.Destroy(go);
        //mUIList.Remove(go);
    }

    protected void GetEffectObj(string effname, System.Action<GameObject> callBack)
    {
        if (mResManager == null) return;
        string tmpAssetName = effname;
        if (!GameSetting.DevelopMode)
        {
            string[] KeyAssetName = effname.Replace('_', '/').Split('/');
            effname = KeyAssetName[1];
            tmpAssetName = effname;
        }
        mResManager.LoadPrefab(effname, tmpAssetName, delegate(UnityEngine.Object[] objs)
        {
            if (objs.Length == 0) return;
            GameObject prefab = objs[0] as GameObject;
            if (prefab == null)
            {
                return;
            }
            GameObject go = GameObject.Instantiate(prefab) as GameObject;
            if (callBack != null)
            {
                callBack(go);
            }
        });
    }

    //获取UI特效
    public void GetUIEffect(string effname, LuaFunction luaCallBack)
    {
        GetEffectObj(effname, (Obj) =>
        {
            if (Obj != null)
            {
                mUIEffectsList.Add(Obj);
            }
            if (luaCallBack != null)
            {
                luaCallBack.BeginPCall();
                luaCallBack.Push(Obj);
                luaCallBack.PCall();
                luaCallBack.EndPCall();
            }
        });
    }

    public void DestroyUIEffect(GameObject obj)
    {
        GameObject.Destroy(obj);
        //mUIEffectsList.Remove(obj);
    }

    public void DestroyAllUIEffect()
    {
        for (int i = mUIEffectsList.Count - 1; i >= 0; --i)
        {
            GameObject.Destroy(mUIEffectsList[i]);
        }
        mUIEffectsList.Clear();
    }

    public void DestroyOldChid(GameObject obj)
    {
        foreach (Transform chid in obj.transform)
        {
            GameObject.Destroy(chid.gameObject);
        }
    }

    public void ReadFile(string path, LuaFunction luaCallBack)
    {
        string filePath = "";
        if (GameSetting.DevelopMode)
        {
            filePath = Application.dataPath + "/../" + path;
        }
        else
        {
            filePath = Tools.DataPath + path;
        }
        if (File.Exists(filePath) == false)
        {
            Debug.Log("路径错误" + Application.dataPath);
            Debug.Log("路径错误" + filePath);
            return;
        }

        mResManager.LoadLocalDataFile("file:///" + filePath, delegate(byte[] data)
        {
            if (luaCallBack != null)
            {
                luaCallBack.BeginPCall();
                luaCallBack.Push(data);
                luaCallBack.PCall();
                luaCallBack.EndPCall();
            }
        });
    }


    public void SetInt(string str, int i)
    {
        PlayerPrefs.SetInt(str, i);
    }


    public int GetInt(string str)
    {
        return PlayerPrefs.GetInt(str,0);
    }

    public void ClearInt(string str)
    {
        PlayerPrefs.DeleteKey(str);
    }


    public void SetString(string str, string i)
    {
        PlayerPrefs.SetString(str, i);
    }

    public string GetString(string str)
    {
        return PlayerPrefs.GetString(str);
    }


    public void CloseUIOnTouch(LuaFunction luaCallBack)
    {
        if (Input.touchCount > 0)
        {
            if (Input.GetTouch(0).phase == TouchPhase.Began)
            {
                luaCallBack.BeginPCall();
                luaCallBack.PCall();
                luaCallBack.EndPCall();
            }
        }
    }

    public void OnOneTouch(LuaFunction luaCallBack)
    {
        if (Input.touchCount > 1)
        {
            if (luaCallBack != null)
            {
                luaCallBack.BeginPCall();
                luaCallBack.PCall();
                luaCallBack.EndPCall();
            }
        }
    }


    public void QiutGame(LuaFunction luaCallBack)
    {
        if (Input.GetKeyUp(KeyCode.Escape))
        {
            if (luaCallBack != null)
            {
                luaCallBack.BeginPCall();
                luaCallBack.PCall();
                luaCallBack.EndPCall();
            }
        }
    }


    public void CheckTouchNum(LuaFunction luaCallBack)
    {
        if (Input.touchCount == 0)
        {
            if (luaCallBack != null)
            {
                luaCallBack.BeginPCall();
                luaCallBack.PCall();
                luaCallBack.EndPCall();
            }
        }
    }

    public void OnTwoTouch(LuaFunction luaCallBack)
    {
        if (Input.touchCount == 1)
        {
            oldPos0 = Input.GetTouch(0).position;
            if (luaCallBack != null)
            {
                luaCallBack.BeginPCall();
                luaCallBack.Push(oldPos0);
                luaCallBack.PCall();
                luaCallBack.EndPCall();
            }
        }
    }

    public void CheckMapDrag(LuaFunction luaCallBack)
    {
        if (Input.touchCount <= 1)
        {
            if (luaCallBack != null)
            {
                luaCallBack.BeginPCall();
                luaCallBack.PCall();
                luaCallBack.EndPCall();
            }
        }
    }


    //多点触控
    public void OnTouch(LuaFunction luaCallBack)
    {
        if (Input.touchCount > 1)
        {
            if (Input.GetTouch(1).phase == TouchPhase.Began)
            {
                oldPos0 = Input.GetTouch(0).position;
                oldPos1 = Input.GetTouch(1).position;
                return;
            }

            Vector2 pos0 = Input.GetTouch(0).position;
            Vector2 pos1 = Input.GetTouch(1).position;

            if (Input.GetTouch(0).phase == TouchPhase.Moved || Input.GetTouch(1).phase == TouchPhase.Moved)
            {

                if (isEnlarge(oldPos0, oldPos1, pos0, pos1))
                {
                    if (luaCallBack != null)
                    {
                        luaCallBack.BeginPCall();
                        luaCallBack.PCall();
                        luaCallBack.EndPCall();
                    }
                }
            }
        }
    }

    //多点触控
    public void OnTouchSmall(LuaFunction luaCallBack)
    {
        if (Input.touchCount > 1)
        {
            if (Input.GetTouch(1).phase == TouchPhase.Began)
            {
                oldPos0 = Input.GetTouch(0).position;
                oldPos1 = Input.GetTouch(1).position;
                return;
            }

            Vector2 pos0 = Input.GetTouch(0).position;
            Vector2 pos1 = Input.GetTouch(1).position;

            if (Input.GetTouch(0).phase == TouchPhase.Moved || Input.GetTouch(1).phase == TouchPhase.Moved)
            {

                if (isEnlargeSmall(oldPos0, oldPos1, pos0, pos1))
                {
                    if (luaCallBack != null)
                    {
                        luaCallBack.BeginPCall();
                        luaCallBack.PCall();
                        luaCallBack.EndPCall();
                    }
                }

            }
            oldPos0 = pos0;
            oldPos1 = pos1;
        }
    }


    bool isEnlarge(Vector2 oP1, Vector2 oP2, Vector2 nP1, Vector2 nP2)
    {
        float oldDistance = Vector2.Distance(oP1, oP2);
        float newDistance = Vector2.Distance(nP1, nP2);
        if (newDistance - oldDistance > 20)
        {
            //放大手势
            return true;
        }
        return false;
    }


    bool isEnlargeSmall(Vector2 oP1, Vector2 oP2, Vector2 nP1, Vector2 nP2)
    {
        float oldDistance = Vector2.Distance(oP1, oP2);
        float newDistance = Vector2.Distance(nP1, nP2);
        if (oldDistance - newDistance > 20)
        {
            //suoxiao手势
            return true;
        }
        return false;
    }



    public void LoadLevel(string m)
    {
        //UnityEngine.Object[] objAry = Resources.FindObjectsOfTypeAll<Texture>();
        //Debug.Log(objAry.Length);
        //for (int i = 0; i < objAry.Length; ++i)
        //{
        //    objAry[i] = null;
        //}

        //UnityEngine.Object[] objAry2 = Resources.FindObjectsOfTypeAll<UnityEngine.Object>();
        //Debug.Log(objAry2.Length);
        // for (int i = 0; i < objAry2.Length; ++i)
        // {
        //     objAry2[i] = null;
        // }

        // UnityEngine.Object[] objAry3 = Resources.FindObjectsOfTypeAll<Font>();
        // Debug.Log(objAry3.Length);
        // for (int i = 0; i < objAry3.Length; ++i)
        // {
        //     objAry3[i] = null;
        // }

        //Resources.UnloadUnusedAssets();

        //GC.Collect();
        //GC.WaitForPendingFinalizers();
        //GC.Collect();

        //if (m == "Clear")
        //{
        //    if (mAssetPacker == null)
        //    GameManager.Instance.OnPackerInited();
        //    else
        //        mAssetPacker = null;
        //}

        Application.LoadLevel(m);
    }

    public int LoadedLevelName()
    {
        return Application.loadedLevel;
    }

    //public void OnPackerInited (LuaFunction luaCallBack)
    //{
    //    GameManager.Instance.OnPackerInited(delegate(UnityEngine.Object[] objs)
    //    {
    //        if (luaCallBack != null)
    //        {
    //            luaCallBack.BeginPCall();
    //            luaCallBack.PCall();
    //            luaCallBack.EndPCall();
    //        }
    //    });
    //}

    public void ApplicationQiut()
    {
        UnityEngine.Application.Quit();
    }


    //载入音效资源
    public void LoadAudioClip(AudioSource bg, string assetName, LuaFunction luaCallBack)
    {
        string tmpAssetName = assetName;
        if (GameSetting.DevelopMode)
        {

        }
        else
        {
            string[] KeyAssetName = assetName.Replace('_', '/').Split('/');
            assetName = KeyAssetName[1];
            tmpAssetName = assetName;
        }
        //Debug.Log("LoadAudioClip" + assetName);

        mResManager.LoadAudioClip(assetName + GameSetting.ExtName, tmpAssetName, delegate(UnityEngine.Object[] objs)
        {
            if (objs.Length == 0) return;
            AudioClip prefab = objs[0] as AudioClip;
            if (prefab == null)
            {
                return;
            }
            AudioClip go = prefab as AudioClip;
            bg.clip = go;
            bg.Play();
        });
    }

    public void ChecKkName(string str, LuaFunction luaCallBack1, LuaFunction luaCallBack2)
    {
        Regex regex = new Regex("^[\u4E00-\u9FA5A-Za-z0-9_]+$");
        if (regex.IsMatch(str))//符合规则回调函数
        {
            if (luaCallBack1 != null)
            {
                luaCallBack1.BeginPCall();
                luaCallBack1.PCall();
                luaCallBack1.EndPCall();
            }
        }
        else //不符合规则回掉
        {
            if (luaCallBack2 != null)
            {
                luaCallBack2.BeginPCall();
                luaCallBack2.PCall();
                luaCallBack2.EndPCall();
            }
        }
    }


    public void UIDestroyFunc(GameObject obj, int leve,LuaFunction des,LuaFunction callback)
    {
       // UIDestroyManager.sInstance.Z_Register(obj, leve, des, callback);
    }
    public void UIActiveFunc(GameObject obj,int leve)
    {
       // UIDestroyManager.sInstance.Z_Activation(obj, leve);
    }

    public void LoadMaterial(Image imageName, string assetName)
    {
        string tmpAssetName = assetName;
        if (GameSetting.DevelopMode)
        {
            //Debug.Log("开始替换方法");
            UnityEngine.Object MaterialName = Resources.Load(assetName);
            if (MaterialName == null)
            {
                Debug.Log("MATERIAL CAN'T FIND");
            }
            imageName.material = MaterialName as Material;
        }
        else
        {
            string[] KeyAssetName = assetName.Replace('_', '/').Split('/');
            assetName = KeyAssetName[1];
            tmpAssetName = assetName;
        }
        mResManager.LoadMaterial(assetName + GameSetting.ExtName, tmpAssetName, delegate(UnityEngine.Object[] objs)
       {
           if (objs.Length == 0)
           {
               return;
           }
           Material prefab = objs[0] as Material;
           if (prefab == null)
           {
               return;
           }
           imageName.material = prefab;
       });
    }

    public void SetOnGetFocusCallBack(LuaFunction callBack)
    {
        if (callBack != null)
        {
            Globals.Instance.SetGetFocusCallBack(callBack);
        }
    }



}
