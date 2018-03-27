using UnityEngine;
using UnityEditor;
using System.Collections;
using UnityEngine.UI;
using System.IO;
using System.Text;
public class AddChild : Editor
{



    [MenuItem("Window/ClearText")]
    public static void ClearTextInChildren()
    {
        Text[] transforms = Selection.activeGameObject.GetComponentsInChildren<Text>();

        foreach (Text tex in transforms)
        {

            tex.text = "";

        }
    }


    [MenuItem("Window/ChangeText")]
    public static void MenuAddChild()
    {
        Text[] transforms = Selection.activeGameObject.GetComponentsInChildren<Text>();
        string[] line = File.ReadAllLines(Application.dataPath + "/Text.txt");
        ///@"d:\test.txt"
        foreach (Text tex in transforms)
        {
            if (tex.text == "")
            {
                Debug.Log("此处没有填加数字，请判断是否需要添加，名字为：" + tex.gameObject.transform.parent.name + "/" + tex.name);
            }
            else
            {
                string[] context = line[int.Parse(tex.text) + 3].Split('\t');
                tex.text = context[5];
                Debug.Log("此处填加了数字，内容为：" + tex.text + "—————————名字为：" + tex.gameObject.transform.parent.name + "/" + tex.name);

            }

        }
        //FileStream fs = new FileStream("D:\\test.txt", FileMode.Open);
        ////获得字节数组
        //byte[] data = System.Text.Encoding.Default.GetBytes("Hello World!");
        ////开始写入
        //fs.Write(data, 0, data.Length);
        ////清空缓冲区、关闭流
        //fs.Flush();
        //fs.Close();

    }

}