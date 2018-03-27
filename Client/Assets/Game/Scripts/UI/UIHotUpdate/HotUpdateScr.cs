using UnityEngine;
using System.Collections;

public class HotUpdateScr : MonoBehaviour
{
    #region Gameobject
    private GameObject DecompressionPercent;
    private GameObject WaringDecompression;
    private GameObject CheckUpdateBox;
    private GameObject UpdatePercent;
    private GameObject WaringUpdateBox;
    private GameObject InitializationBox;
    private GameObject WaringInitializeBox;
    private GameObject background;
    private GameObject WaitCheckUpdate;
    #endregion
	// Use this for initialization
	void Start () {
        DecompressionPercent = gameObject.transform.Find("Decompression").gameObject;
        WaringDecompression = gameObject.transform.Find("WaringDecompressionBox").gameObject;
        CheckUpdateBox = gameObject.transform.Find("CheckUpdateBox").gameObject;
        UpdatePercent = gameObject.transform.Find("UpdatePercent").gameObject;
        WaringUpdateBox = gameObject.transform.Find("WaringUpdateBox").gameObject;
        InitializationBox = gameObject.transform.Find("InitializationText").gameObject;
        WaringInitializeBox = gameObject.transform.Find("WaringInitializeBox").gameObject;
        background = gameObject.transform.Find("back").gameObject;
        WaitCheckUpdate = gameObject.transform.Find("WaitCheckUpdate").gameObject;
	}
	
	// Update is called once per frame
	void Update () {
        //开启解压界面
        if (GameManager.Instance.z_showDecompressionUI&&!GameManager.Instance.z_decompressionBool)
        {
            DecompressionPercent.SetActive(true);
        }
        //关闭解压界面
        if (GameManager.Instance.z_decompressionBool)
        {
            DecompressionPercent.SetActive(false);
        }
        if (GameManager.Instance.z_WaitCheckUpdate)
        {
            WaitCheckUpdate.SetActive(true);
        }else
        {
            WaitCheckUpdate.SetActive(false);
        }
        //确认更新消息窗体
        if (GameManager.Instance.z_needUpdateBool && !GameManager.Instance.z_checkUpdateBool)
        {
            CheckUpdateBox.SetActive(true);
        }
        //更新界面开启
        if (GameManager.Instance.z_checkUpdateBool && !GameManager.Instance.z_updateBool)
        {
            UpdatePercent.SetActive(true);
        }
        //更新界面关闭
        if (GameManager.Instance.z_updateBool)
        {
            UpdatePercent.SetActive(false);
        }
        //初始化界面开启
        if (GameManager.Instance.z_needInitializeBool)
        {
            InitializationBox.SetActive(true);
        }
        else
        {
            InitializationBox.SetActive(false);
        }
        //初始化界面关闭
        if (GameManager.Instance.z_initializeBool)
        {
            InitializationBox.SetActive(false);
        }
        //背景开启
        if (GameManager.Instance.z_closeHotUpdateUI)
        {
            background.SetActive(false);
            WaitCheckUpdate.SetActive(false);
        }
        //背景关闭
        if (!GameManager.Instance.z_closeHotUpdateUI)
        {
            background.SetActive(true);
        }
        //警报
        if (GameManager.Instance.z_waringDecompressionBool)
        {
            WaringDecompression.SetActive(true);
        }
        if (GameManager.Instance.z_waringUpdateBool)
        {
            WaringUpdateBox.SetActive(true);
        }
        if (GameManager.Instance.z_waringInitializeBool)
        {
            WaringInitializeBox.SetActive(true);
        }
	}
    //重新解压
    public void ReDecompression()
    {
        GameManager.Instance.ReDecompression();
        WaringDecompression.SetActive(false);
        DecompressionPercent.SetActive(true);
    }
    //重新下载
    public void ReUpdate()
    {
        GameManager.Instance.ReUpdate();
        WaringUpdateBox.SetActive(false);
    }
    //重新初始化
    public void ReInitialize()
    {
        GameManager.Instance.ReInitialize();
        WaringInitializeBox.SetActive(false);
        InitializationBox.SetActive(true);
    }
    public void CheckUpdate()
    {
        GameManager.Instance.CheckUpdate();
        CheckUpdateBox.SetActive(false);
    }
    public void QuitGame()
    {
#if UNITY_EDITOR
        UnityEditor.EditorApplication.isPlaying = false;
#else
Application.Quit ();
#endif
        //WaringUpdateBox.SetActive(true);
    }
}
