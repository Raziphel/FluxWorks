local item = table.deepcopy(data.raw["item"]["radar"])

item.name = "remnant-beacon"
item.place_result = "remnant-beacon"
item.order = "g"
item.icon = "__FluxWorksAssets__/graphics/icons/items/fw-remnant-beacon.png"
item.icon_size = 64
item.stack_size = 1
item.weight = 1000000

data:extend{item}

local entity = table.deepcopy(data.raw["radar"]["radar"])

entity.name = "remnant-beacon"
entity.icon = "__FluxWorksAssets__/graphics/icons/items/fw-remnant-beacon.png"

entity.minable = {mining_time = 1.0, result = "remnant-beacon"}

entity.fast_replaceable_group = nil

entity.collision_box = {{-1.9, -1.9}, {1.9, 1.9}}
entity.selection_box = {{-2.0, -2.0}, {2.0, 2.0}}

entity.energy_usage = "500kW"
entity.energy_per_sector = "100GW"
entity.max_distance_of_nearby_sector_revealed = 1
entity.max_distance_of_sector_revealed = 1
entity.energy_per_nearby_scan = "250kW"

entity.integration_patch = nil

entity.pictures = {
    layers = {
        {
            filename = "__FluxWorksAssets__/graphics/entity/remnant-beacon/fw-remnant-beacon.png",
            priority = "low",
            width = 294,
            height = 407,
            apply_projection = false,
            direction_count = 1,
            shift = util.by_pixel(0.0, -30.0),
            scale = 0.45
        },
        {
            filename = "__FluxWorksAssets__/graphics/entity/remnant-beacon/fw-remnant-beacon-shadow.png",
            priority = "low",
            width = 424,
            height = 246,
            apply_projection = false,
            direction_count = 1,
            shift = util.by_pixel(24.0, 3.0),
            draw_as_shadow = true,
            scale = 0.5
        }
    }
}

entity.water_reflection = nil

entity.circuit_connector = nil

entity.surface_conditions = {
  {
    property = "gravity",
    min = 0,
    max = 0
  }
},

data:extend{entity}

local recipe = {
    type = "recipe",
    name = "remnant-beacon",
    enabled = false,
    energy_required = 20,
    ingredients = {
        { type = "item", name = "processing-unit", amount = 50 },
        { type = "item", name = "low-density-structure", amount = 25 },
        { type = "item", name = "steel-plate", amount = 100 },
    },
    results = {{type="item", name="remnant-beacon", amount=1}},
    requester_paste_multiplier = 5
}

data:extend{recipe}

local technology = {
    type = "technology",
    name = "remnant-beacon",
    icon = "__FluxWorksAssets__/graphics/technology/fw-remnant-beacon.png",
    icon_size = 256,
    effects =
    {
        {
            type = "unlock-recipe",
            recipe = "remnant-beacon"
        },
    },
    prerequisites = { "rocket-chunk-processing" },
    unit =
    {
        count = 1000,
        ingredients =
        {
            { "automation-science-pack", 1 },
            { "logistic-science-pack",   1 },
            { "chemical-science-pack",   1 },
            { "production-science-pack", 1 },
            { "utility-science-pack",    1 },
            { "space-science-pack",      1 },
        },
        time = 60
    }
}

data:extend{technology}