using UnityEngine;
using System.Collections;
using UnityEngine.UI;

public class DecompressionScr : MonoBehaviour {

    private Slider DecompressionPercent;
    private Text DecompressionText;
    private Text DecompressionSize;
	void Start () {
        DecompressionPercent = gameObject.transform.Find("DecompressionSlider").GetComponent<Slider>();
        DecompressionText = gameObject.transform.Find("Text").GetComponent<Text>();
        DecompressionSize = gameObject.transform.Find("Size").GetComponent<Text>();
	}
	
	
	void Update () {
        DecompressionPercent.value = GameManager.Instance.z_DecompressionPercent;
        if (GameManager.Instance.z_DecompressionPercent >= 0.99f)
        {
            GameManager.Instance.z_DecompressionPercent = 0.999f;
        }
        DecompressionText.text = "正在解压..."+(GameManager.Instance.z_DecompressionPercent * 100).ToString("F1") + "%";
        DecompressionSize.text = (GameManager.Instance.z_fileSize / (1024 * 1024)).ToString("F2") + "MB/" + (GameManager.Instance.z_WaitDecompressionSize / (1024 * 1024)).ToString("F2") + "MB";
	}
}
