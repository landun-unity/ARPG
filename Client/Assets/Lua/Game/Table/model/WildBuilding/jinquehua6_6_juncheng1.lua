return {
  version = "1.1",
  luaversion = "5.1",
  tiledversion = "0.17.1",
  orientation = "isometric",
  renderorder = "right-down",
  width = 5,
  height = 5,
  tilewidth = 200,
  tileheight = 100,
  nextobjectid = 1,
  properties = {},
  tilesets = {
    {
      name = "peoplecity",
      firstgid = 1,
      tilewidth = 200,
      tileheight = 400,
      spacing = 0,
      margin = 0,
      image = "../野城切图/peoplecity.png",
      imagewidth = 3200,
      imageheight = 2000,
      tileoffset = {
        x = 0,
        y = 0
      },
      properties = {},
      terrains = {},
      tilecount = 80,
      tiles = {}
    }
  },
  layers = {
    {
      type = "tilelayer",
      name = "peoplecity",
      x = 0,
      y = 0,
      width = 5,
      height = 5,
      visible = true,
      opacity = 1,
      offsetx = 0,
      offsety = 0,
      properties = {},
      encoding = "lua",
      data = {
        36, 4, 27, 29, 2,
        22, 41, 16, 50, 30,
        9, 2, 62, 46, 46,
        38, 3, 30, 41, 45,
        8, 34, 38, 49, 43
      }
    }
  }
}
