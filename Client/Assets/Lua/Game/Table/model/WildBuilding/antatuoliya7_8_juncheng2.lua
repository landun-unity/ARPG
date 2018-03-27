return {
  version = "1.1",
  luaversion = "5.1",
  tiledversion = "0.17.1",
  orientation = "isometric",
  renderorder = "right-down",
  width = 7,
  height = 7,
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
      width = 7,
      height = 7,
      visible = true,
      opacity = 1,
      offsetx = 0,
      offsety = 0,
      properties = {},
      encoding = "lua",
      data = {
        14, 12, 6, 5, 35, 36, 1,
        66, 9, 3, 28, 34, 37, 48,
        9, 10, 19, 24, 33, 13, 47,
        67, 11, 18, 25, 32, 39, 46,
        14, 12, 17, 26, 31, 13, 45,
        2, 15, 40, 45, 1, 41, 44,
        7, 14, 15, 30, 29, 42, 43
      }
    }
  }
}
