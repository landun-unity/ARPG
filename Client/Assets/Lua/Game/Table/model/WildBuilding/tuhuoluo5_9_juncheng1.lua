return {
  version = "1.1",
  luaversion = "5.1",
  tiledversion = "0.17.1",
  orientation = "isometric",
  renderorder = "right-down",
  width = 9,
  height = 9,
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
      width = 9,
      height = 9,
      visible = true,
      opacity = 1,
      offsetx = 0,
      offsety = 0,
      properties = {},
      encoding = "lua",
      data = {
        0, 12, 21, 45, 68, 30, 9, 68, 0,
        8, 7, 8, 44, 49, 50, 36, 4, 3,
        7, 6, 63, 20, 38, 34, 30, 48, 34,
        50, 5, 10, 19, 24, 33, 42, 9, 69,
        34, 22, 11, 18, 25, 32, 39, 51, 51,
        15, 3, 12, 17, 26, 31, 40, 45, 69,
        36, 2, 13, 16, 27, 30, 41, 42, 67,
        30, 65, 14, 15, 28, 4, 42, 43, 49,
        0, 38, 35, 48, 6, 66, 2, 12, 0
      }
    }
  }
}
