using UnityEngine;
using System.Collections;
using System.Collections.Generic;

public class AssetPacker : ScriptableObject
{
    public Object[] mAssets;

    private Dictionary<string, Object> allAssetDict = new Dictionary<string, Object>();

    public void CopyAssets()
    {
        if( mAssets == null )
            return;
            
        allAssetDict.Clear();

        for (int i = 0; i < mAssets.Length; ++i)
        {
            Object obj = mAssets[i];
            if (obj == null || allAssetDict.ContainsKey(obj.name))
                continue;

            allAssetDict.Add(obj.name, obj);
        }
    }

    public Object GetAsset(string objName)
    {
        Object obj = null;
        allAssetDict.TryGetValue(objName, out obj);

        return obj;
    }

    public Sprite GetSprite(string objName)
    {
        Object obj = GetAsset(objName);
        if (obj == null)
        {
            return Sprite.Create(Texture2D.whiteTexture, new Rect(0, 0, 4, 4), new Vector2(0.5f, 0.5f));
        }
        return obj as Sprite;
    }

    public Texture2D GetTexture(string objName)
    {
        Object obj = GetAsset(objName);
        if (obj == null)
        {
            return Texture2D.whiteTexture;
        }
        return obj as Texture2D;
    }
}
