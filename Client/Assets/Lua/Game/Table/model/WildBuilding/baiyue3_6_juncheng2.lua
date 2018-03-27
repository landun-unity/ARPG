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
        15, 4, 27, 41, 50,
        22, 41, 14, 49, 41,
        48, 2, 62, 47, 10,
        43, 3, 28, 41, 36,
        37, 34, 38, 45, 43
      }
    }
  }
}
