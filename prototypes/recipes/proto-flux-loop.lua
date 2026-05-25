local Common = require("__haul_lib__/utils/common")


data:extend({
{
  type = "recipe",
  name = "fw-stone-upcycle",
  category = "chemistry",
  subgroup = "fluid-recipes",
  order = "a[chemistry]-aa[fw-stone-upcycle]",
  enabled = true,
  energy_required = 5,
  main_product = "coal",
  ingredients =
  {
    {type = "item", name = "stone", amount = 10},
    {type = "fluid", name = "fw-purple-flux", amount = 1},
  },
  results=
  {
    {type = "item", name = "coal", amount = 10}
  }
},
{
  type = "recipe",
  name = "fw-coal-upcycle",
  category = "chemistry",
  subgroup = "fluid-recipes",
  order = "a[chemistry]-ab[fw-coal-upcycle]",
  enabled = true,
  energy_required = 5,
  main_product = "copper-ore",
  ingredients =
  {
    {type = "item", name = "coal", amount = 10},
    {type = "fluid", name = "fw-purple-flux", amount = 1},
  },
  results=
  {
    {type = "item", name = "copper-ore", amount = 10}
  }
},
{
  type = "recipe",
  name = "fw-copper-upcycle",
  category = "chemistry",
  subgroup = "fluid-recipes",
  order = "a[chemistry]-ac[fw-copper-upcycle]",
  enabled = true,
  energy_required = 5,
  main_product = "iron-ore",
  ingredients =
  {
    {type = "item", name = "copper-ore", amount = 10},
    {type = "fluid", name = "fw-purple-flux", amount = 1},
  },
  results=
  {
    {type = "item", name = "iron-ore", amount = 10}
  }
},
{
  type = "recipe",
  name = "fw-iron-upcycle",
  category = "chemistry",
  subgroup = "fluid-recipes",
  order = "a[chemistry]-ad[fw-iron-upcycle]",
  enabled = true,
  energy_required = 5,
  main_product = "uranium-ore",
  ingredients =
  {
    {type = "item", name = "iron-ore", amount = 10},
    {type = "fluid", name = "fw-purple-flux", amount = 5},
  },
  results=
  {
    {type = "item", name = "uranium-ore", amount = 10}
  }
},




{
  type = "recipe",
  name = "fw-coal-downcycle",
  category = "chemistry",
  subgroup = "fluid-recipes",
  order = "a[chemistry]-ba[fw-coal-downcycle]",
  enabled = true,
  energy_required = 5,
  main_product = "stone",
  ingredients=
  {
    {type = "item", name = "coal", amount = 10}
  },
  results=
  {
    {type = "item", name = "stone", amount = 10},
    {type = "fluid", name = "fw-purple-flux", amount = 1},
  }
},
{
  type = "recipe",
  name = "fw-copper-downcycle",
  category = "chemistry",
  subgroup = "fluid-recipes",
  order = "a[chemistry]-bb[fw-copper-downcycle]",
  enabled = true,
  energy_required = 5,
  main_product = "coal",
  ingredients=
  {
    {type = "item", name = "copper-ore", amount = 10}
  },
  results=
  {
    {type = "item", name = "coal", amount = 10},
    {type = "fluid", name = "fw-purple-flux", amount = 1},
  }
},
{
  type = "recipe",
  name = "fw-iron-downcycle",
  category = "chemistry",
  subgroup = "fluid-recipes",
  order = "a[chemistry]-bc[fw-iron-downcycle]",
  enabled = true,
  energy_required = 5,
  main_product = "copper-ore",
  ingredients=
  {
    {type = "item", name = "iron-ore", amount = 10}
  },
  results=
  {
    {type = "item", name = "copper-ore", amount = 10},
    {type = "fluid", name = "fw-purple-flux", amount = 1},
  }
},
{
  type = "recipe",
  name = "fw-uranium-downcycle",
  category = "chemistry",
  subgroup = "fluid-recipes",
  order = "a[chemistry]-bd[fw-uranium-downcycle]",
  enabled = true,
  energy_required = 5,
  main_product = "iron-ore",
  ingredients=
  {
    {type = "item", name = "uranium-ore", amount = 10}
  },
  results=
  {
    {type = "item", name = "iron-ore", amount = 10},
    {type = "fluid", name = "fw-purple-flux", amount = 2},
  }
}
})
