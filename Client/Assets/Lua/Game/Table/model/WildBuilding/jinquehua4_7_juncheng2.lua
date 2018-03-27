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
        0, 12, 36, 63, 9, 21, 0,
        67, 12, 5, 47, 29, 2, 4,
        69, 22, 54, 57, 60, 5, 1,
        4, 9, 53, 56, 59, 39, 51,
        23, 38, 52, 55, 58, 45, 37,
        34, 23, 4, 5, 50, 45, 1,
        0, 30, 41, 66, 3, 8, 0
      }
    }
  }
}
