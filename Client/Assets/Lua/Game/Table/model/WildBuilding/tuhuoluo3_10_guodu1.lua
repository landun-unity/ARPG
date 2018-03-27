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
        47, 12, 21, 45, 68, 30, 9, 68, 38,
        8, 7, 8, 21, 22, 35, 36, 49, 36,
        7, 6, 9, 20, 23, 34, 37, 48, 34,
        50, 5, 10, 19, 24, 33, 38, 47, 47,
        34, 4, 11, 18, 25, 32, 39, 51, 61,
        8, 3, 12, 17, 26, 31, 40, 45, 41,
        36, 2, 13, 16, 27, 30, 41, 44, 67,
        30, 1, 14, 15, 28, 29, 42, 43, 49,
        2, 38, 35, 48, 6, 8, 2, 12, 36
      }
    }
  }
}
