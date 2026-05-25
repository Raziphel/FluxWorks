local Common = require("__haul_lib__/utils/common")


data:extend({
{
  type = "recipe",
  name = "stone-upcycle",
  category = "chemistry",
  subgroup = "fluid-recipes",
  order = "a[chemistry]-aa[stone-upcycle]",
  enabled = true,
  energy_required = 5,
  main_product = "coal",
  ingredients =
  {
    {type = "item", name = "stone", amount = 10},
    {type = "fluid", name = "purple-flux", amount = 1},
  },
  results=
  {
    {type = "item", name = "coal", amount = 10}
  }
},
{
  type = "recipe",
  name = "coal-upcycle",
  category = "chemistry",
  subgroup = "fluid-recipes",
  order = "a[chemistry]-ab[coal-upcycle]",
  enabled = true,
  energy_required = 5,
  main_product = "copper-ore",
  ingredients =
  {
    {type = "item", name = "coal", amount = 10},
    {type = "fluid", name = "purple-flux", amount = 1},
  },
  results=
  {
    {type = "item", name = "copper-ore", amount = 10}
  }
},
{
  type = "recipe",
  name = "copper-upcycle",
  category = "chemistry",
  subgroup = "fluid-recipes",
  order = "a[chemistry]-ac[copper-upcycle]",
  enabled = true,
  energy_required = 5,
  main_product = "iron-ore",
  ingredients =
  {
    {type = "item", name = "copper-ore", amount = 10},
    {type = "fluid", name = "purple-flux", amount = 1},
  },
  results=
  {
    {type = "item", name = "iron-ore", amount = 10}
  }
},
{
  type = "recipe",
  name = "iron-upcycle",
  category = "chemistry",
  subgroup = "fluid-recipes",
  order = "a[chemistry]-ad[iron-upcycle]",
  enabled = true,
  energy_required = 5,
  main_product = "uranium-ore",
  ingredients =
  {
    {type = "item", name = "iron-ore", amount = 10},
    {type = "fluid", name = "purple-flux", amount = 5},
  },
  results=
  {
    {type = "item", name = "uranium-ore", amount = 10}
  }
},




{
  type = "recipe",
  name = "coal-downcycle",
  category = "chemistry",
  subgroup = "fluid-recipes",
  order = "a[chemistry]-ba[coal-downcycle]",
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
    {type = "fluid", name = "purple-flux", amount = 1},
  }
},
{
  type = "recipe",
  name = "copper-downcycle",
  category = "chemistry",
  subgroup = "fluid-recipes",
  order = "a[chemistry]-bb[copper-downcycle]",
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
    {type = "fluid", name = "purple-flux", amount = 1},
  }
},
{
  type = "recipe",
  name = "iron-downcycle",
  category = "chemistry",
  subgroup = "fluid-recipes",
  order = "a[chemistry]-bc[iron-downcycle]",
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
    {type = "fluid", name = "purple-flux", amount = 1},
  }
},
{
  type = "recipe",
  name = "uranium-downcycle",
  category = "chemistry",
  subgroup = "fluid-recipes",
  order = "a[chemistry]-bd[uranium-downcycle]",
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
    {type = "fluid", name = "purple-flux", amount = 2},
  }
}
})

