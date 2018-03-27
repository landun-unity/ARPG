using UnityEngine;
using System.Collections;
using LuaInterface;

public class Globals : MonoBehaviour
{
    public static Globals Instance;
    private GameObject currClickGo;
    private bool firstTimeStartGame = true;
    private LuaFunction onGetFocusCallBack = null;
    public void SetCurrClickGo(GameObject go)
    {
        currClickGo = go;
    }

    public GameObject GetCurrClickGo()
    {
        return currClickGo;
    }


    public void SetFirstTime(bool parma)
    {
        firstTimeStartGame =parma;
    }

    public bool BoolFirstTime()
    {
        return firstTimeStartGame;
    }

    void Awake()
    {
        
        DontDestroyOnLoad(this.gameObject);
        Instance = this;
        Application.LoadLevel("Login");
    }

    //private const string BuglyAppIDForiOS = "---------";
    private const string BuglyAppIDForAndroid = "3ec56cfa17";

    void Start()
    {
        AppFacade.Instance.StartUp();

        lastInterval = Time.realtimeSinceStartup;
        frames = 0;
        fontStyle.fontSize = 40;       //字体大小  
    }

    // Update is called once per frame
    void Update()
    {
        ++frames;
        float timeNow = Time.realtimeSinceStartup;
        if (timeNow > lastInterval + updateInterval)
        {
            fps = (float)(frames / (timeNow - lastInterval));
            frames = 0;
            lastInterval = timeNow;
        }

    }

    void OnGUI()
    {
        DrawFps();
    }

    public float updateInterval = 0.5F;
    private double lastInterval;
    private int frames = 0;
    private float fps;
    private GUIStyle fontStyle = new GUIStyle();  

    private void DrawFps()
    {
        if (fps > 50)
        {
            fontStyle.normal.textColor = new Color(0, 1, 0);
        }
        else if (fps > 40)
        {
            fontStyle.normal.textColor = new Color(1, 1, 0);
        }
        else
        {
            fontStyle.normal.textColor = new Color(1.0f, 0, 0);
        }

        GUI.Label(new Rect(Screen.width - 200, 32, 500, 50), "fps: " + fps.ToString("f2"), fontStyle);

    }

    public void SetGetFocusCallBack(LuaFunction callBack)
    {
        Debug.Log("设置获取焦点回调方法");
        if (callBack != null && onGetFocusCallBack == null)
            onGetFocusCallBack = callBack;
    }

    void OnApplicationFocus(bool isFocus)
    {
        if (isFocus)
        {
            if (onGetFocusCallBack != null)
            {
                onGetFocusCallBack.BeginPCall();
                onGetFocusCallBack.PCall();
                onGetFocusCallBack.EndPCall();
            }
        }
    }

}
