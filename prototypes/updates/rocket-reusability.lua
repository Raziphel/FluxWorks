require("prototypes.updates.remnant-beacon")

local space_age_sounds = require("__space-age__.prototypes.entity.sounds")
local explosion_animations = require("__space-age__.prototypes.entity.explosion-animations")
local space_age_item_sounds = require("__space-age__.prototypes.item_sounds")
local Common = require("__haul_lib__/utils/common")

data:extend
{
    {
        type = "explosion",
        name = "used-rocket-explosion",
        icon = "__FluxWorksAssets__/graphics/icons/items/fw-incomplete-rocket-part.png",
        flags = { "not-on-map" },
        hidden = true,
        height = 0,
        animations = explosion_animations.asteroid_explosion_chunk({ tint = { 0.533, 0.506, 0.545, 1 } }),
        sound = space_age_sounds.asteroid_collision_carbonic_small,
        created_effect =
        {
            type = "direct",
            action_delivery =
            {
                type = "instant",
                target_effects =
                {
                    {
                        type = "create-trivial-smoke",
                        repeat_count = 6,
                        probability = 1,
                        smoke_name = "asteroid-smoke-carbonic-chunk",
                        offset_deviation = { { -0.1, -0.1 }, { 0.1, 0.1 } },
                        initial_height = -0.2,
                        speed_from_center = 0.01,
                        speed_from_center_deviation = 0.01
                    },
                }
            }
        }
    },
    {
        type = "asteroid",
        name = "used-rocket-asteroid",
        overkill_fraction = 0.01,
        localised_description = { "entity-description.used-rocket-asteroid" },
        icon = "__FluxWorksAssets__/graphics/icons/items/fw-used-rocket-icon.png",
        icon_size = 128,
        selection_box = { { -9, -9 }, { 9, 9 } },
        collision_box = { { -9, -9 }, { 9, 9 } },
        collision_mask = { layers = { object = true }, not_colliding_with_itself = true },
        graphics_set = {
            rotation_speed = 0.0003 * (2),
            normal_strength = 0.3,
            lights = {

            },
            ambient_light = { 1.0, 1.0, 1.0 },
            brightness = 0.3,
            variations = {
                color_texture = {
                    filename = "__FluxWorksAssets__/graphics/resources/asteroids/fw-used-rocket.png",
                    width = 353,
                    height = 829,
                    scale = 1
                },
                normal_map = {
                    filename = "__FluxWorksAssets__/graphics/resources/asteroids/fw-used-rocket-normal.png",
                    premul_alpha = false,
                    width = 353,
                    height = 829,
                    scale = 1
                },
                roughness_map = {
                    filename = "__FluxWorksAssets__/graphics/resources/asteroids/fw-used-rocket-roughness.png",
                    premul_alpha = false,
                    width = 353,
                    height = 829,
                    scale = 1
                },
            }

        },
        dying_trigger_effect = {
            {
                type = "create-explosion",
                entity_name = "used-rocket-explosion"
            },
            {
                type = "create-explosion",
                entity_name = "carbonic-asteroid-explosion-5"
            },
            {
                type = "create-asteroid-chunk",
                asteroid_name = "rocket-chunk",
                offset_deviation = { { -3, -3 }, { 3, 3 } },
                offsets = {
                    { -4.5 / 2, -4.5 / 4 },
                    { 4.5 / 2, 4.5 / 4 },
                    { -4.5,   0 },
                    { -4.5 / 3, 4.5 / 6 },
                    { 4.5 / 6, -4.5 / 3 },
                }
            }
        },

        subgroup = "space-environment",
        order = "e[used-rocket]-b[regular]",
        factoriopedia_simulation = [[
            require("__core__/lualib/story")
            game.simulation.camera_position = {0, 0}

            for x = -8, 8, 1 do
            for y = -3, 3 do
                game.surfaces[1].set_tiles{{position = {x, y}, name = "empty-space"}}
            end
            end

            for x = -1, 0, 1 do
            for y = -1, 0 do
                game.surfaces[1].set_chunk_generated_status({x, y}, defines.chunk_generated_status.entities)
            end
            end

            local story_table =
            {
            {
                {
                name = "start",
                action = function() game.surfaces[1].create_entity{name="]] .. "used-rocket" .. [[", position = {0, 0}, velocity = {0, 0.011}} end
                },
                {
                condition = story_elapsed_check(]] .. "15" .. [[),
                action = function() story_jump_to(storage.story, "start") end
                }
            }
            }
            tip_story_init(story_table)
        ]],

        -- asteroid-chunk properties
        --minable = asteroid_size_name == "chunk" and {mining_time = 0.2, result = asteroid_name, mining_particle = asteroid_type.."-asteroid-chunk-particle-medium" } or nil,

        -- asteroid properties
        flags = { "placeable-enemy", "placeable-off-grid", "not-repairable", "not-on-map" },
        max_health = 5000,
        mass = 500000,
        resistances = {
            {
                type = "physical",
                decrease = 0,
                percent = 50
            },
            {
                type = "electric",
                decrease = 0,
                percent = 100
            },
            {
                type = "laser",
                decrease = 0,
                percent = 90
            },
            {
                type = "explosion",
                decrease = 0,
                percent = 60
            },
            {
                type = "fire",
                decrease = 0,
                percent = 100
            }
        },
    },
    {
        type = "item",
        name = "rocket-chunk",
        icon = "__FluxWorksAssets__/graphics/icons/items/fw-rocket-chunk.png",
        subgroup = "space-material",
        order = "e[rocket]-e[chunk]",
        inventory_move_sound = space_age_item_sounds.rock_inventory_move,
        pick_sound = space_age_item_sounds.rock_inventory_pickup,
        drop_sound = space_age_item_sounds.rock_inventory_move,
        stack_size = 1,
        weight = 100 * 1000,
    },
    {
        type = "asteroid-chunk",
        name = "rocket-chunk",
        overkill_fraction = 0.01,
        localised_description = { "entity-description.rocket-chunk" },
        icon = "__FluxWorksAssets__/graphics/icons/items/fw-rocket-chunk.png",
        icon_size = 64,
        selection_box = { { -0.5, -0.5 }, { 0.5, 0.5 } },
        collision_box = { { -0.5, -0.5 }, { 0.5, 0.5 } },
        collision_mask = nil,
        graphics_set = {
            rotation_speed = 0.0003 * (6),
            normal_strength = 0.3,
            lights = {

            },
            ambient_light = { 1.0, 1.0, 1.0 },
            brightness = 0.1,
            variations = {
                color_texture = {
                    filename = "__FluxWorksAssets__/graphics/resources/asteroids/fw-rocket-chunk.png",
                    width = 64,
                    height = 64,
                    scale = 0.5
                },
                normal_map = {
                    filename = "__FluxWorksAssets__/graphics/resources/asteroids/fw-rocket-chunk-normal.png",
                    premul_alpha = false,
                    width = 64,
                    height = 64,
                    scale = 0.5
                },
                roughness_map = {
                    filename = "__FluxWorksAssets__/graphics/resources/asteroids/fw-rocket-chunk-roughness.png",
                    premul_alpha = false,
                    width = 64,
                    height = 64,
                    scale = 0.5
                },
            }

        },
        dying_trigger_effect = nil,

        subgroup = "space-environment",
        order = "a[rocket-chunk]-b[regular]",
        factoriopedia_simulation = [[
            require("__core__/lualib/story")
            game.simulation.camera_position = {0, 0}

            for x = -8, 8, 1 do
            for y = -3, 3 do
                game.surfaces[1].set_tiles{{position = {x, y}, name = "empty-space"}}
            end
            end

            for x = -1, 0, 1 do
            for y = -1, 0 do
                game.surfaces[1].set_chunk_generated_status({x, y}, defines.chunk_generated_status.entities)
            end
            end

            local story_table =
            {
            {
                {
                name = "start",
                action = function() game.surfaces[1].create_entity{name="]] .. "rocket-chunk" .. [[", position = {0, 0}, velocity = {0, 0.011}} end
                },
                {
                condition = story_elapsed_check(]] .. "15" .. [[),
                action = function() story_jump_to(storage.story, "start") end
                }
            }
            }
            tip_story_init(story_table)
        ]],

        -- asteroid-chunk properties
        minable = { mining_time = 0.2, result = "rocket-chunk", mining_particle = "metallic-asteroid-chunk-particle-medium" },

        -- asteroid properties
        flags = nil,
        max_health = nil,
        mass = nil,
        resistances = {

        },
    }
}

local add_incomplete = settings.startup["enable-incomplete-rocket-parts"].value

local reusable_rocket_components = {
    {
        type = "item",
        name = "fw-rocket-avionics",
        icon = "__FluxWorksAssets__/graphics/icons/items/reusable-rocket-avionics.png",
        icon_size = 64,
        icon_mipmaps = 0,
        subgroup = "fw-intermediate-aerospace",
        order = "b[fw-rocket-avionics]",
        stack_size = 50
    },
    {
        type = "item",
        name = "fw-rocket-heatshield",
        icon = "__FluxWorksAssets__/graphics/icons/items/fw-rocket-heatshield.png",
        icon_size = 64,
        icon_mipmaps = 0,
        subgroup = "fw-intermediate-aerospace",
        order = "c[fw-rocket-heatshield]",
        stack_size = 50
    }
}

local reusable_rocket_component_recipes = {
    {
        type = "recipe",
        name = "fw-rocket-avionics",
        icon = "__FluxWorksAssets__/graphics/icons/items/reusable-rocket-avionics.png",
        icon_size = 64,
        icon_mipmaps = 0,
        energy_required = 8,
        enabled = false,
        category = "crafting",
        ingredients = {
            { type = "item", name = "processing-unit", amount = 2 },
            { type = "item", name = "fw-sensor-package", amount = 1 },
            { type = "item", name = "fw-ribbon-cable", amount = 2 }
        },
        results = { { type = "item", name = "fw-rocket-avionics", amount = 1 } }
    },
    {
        type = "recipe",
        name = "fw-rocket-heatshield",
        icon = "__FluxWorksAssets__/graphics/icons/items/fw-rocket-heatshield.png",
        icon_size = 64,
        icon_mipmaps = 0,
        energy_required = 8,
        enabled = false,
        category = "crafting",
        ingredients = {
            { type = "item", name = "low-density-structure", amount = 2 },
            { type = "item", name = "fw-cermet", amount = 2 },
            { type = "item", name = "fw-glass", amount = 4 }
        },
        results = { { type = "item", name = "fw-rocket-heatshield", amount = 1 } }
    }
}

data:extend(reusable_rocket_components)
data:extend(reusable_rocket_component_recipes)

if add_incomplete then
    local incomplete_rocket_part = Common.cloneInto("item", "rocket-part", "incomplete-rocket-part")
    incomplete_rocket_part.stack_size = 50
    incomplete_rocket_part.hidden = false

    incomplete_rocket_part.icon = "__FluxWorksAssets__/graphics/icons/items/fw-incomplete-rocket-part.png"

    local incomplete_rocket_part_recipe = {
        type = "recipe",
        name = "incomplete-rocket-part",
        energy_required = 3,
        enabled = false,
        category = "crafting",
        ingredients = {
            { type = "item", name = "processing-unit",       amount = 1 },
            { type = "item", name = "low-density-structure", amount = 1 },
            { type = "item", name = "fw-rocket-engine", amount = 1 },
            { type = "item", name = "fw-rocket-avionics", amount = 1 },
            { type = "item", name = "fw-rocket-heatshield", amount = 1 }
        },
        allow_productivity = settings.startup["enable-incomplete-rocket-parts-productivity"].value,
        results = { { type = "item", name = "incomplete-rocket-part", amount = 1 } },
    }

    data:extend { incomplete_rocket_part_recipe }
end

local recipe = {
    type = "recipe",
    name = "rocket-chunk-processing",
    icon = "__FluxWorksAssets__/graphics/icons/items/fw-rocket-chunk-crushing.png",
    category = "crushing",
    subgroup = "space-crushing",
    order = "b-a-d",
    auto_recycle = false,
    enabled = false,
    ingredients =
    {
        { type = "item", name = "rocket-chunk", amount = 1 },
    },
    energy_required = 2,
    results =
    {
        { type = "item", name = "processing-unit",       amount_min = 3, amount_max = 10 },
        { type = "item", name = "low-density-structure", amount_min = 3, amount_max = 10 },
        { type = "item", name = "fw-rocket-engine",      amount_min = 1, amount_max = 2 },
        { type = "item", name = "fw-rocket-avionics", amount_min = 1, amount_max = 2 },
        { type = "item", name = "fw-rocket-heatshield", amount_min = 1, amount_max = 2 },
        { type = "item", name = "rocket-chunk",          amount = 1,     probability = 0.1 }
    },
    allow_productivity = true,
    allow_decomposition = false
}

if add_incomplete then
    recipe.results = {
        { type = "item", name = "incomplete-rocket-part", amount_min = 3, amount_max = 10 },
        { type = "item", name = "fw-rocket-engine",       amount_min = 1, amount_max = 3 },
        { type = "item", name = "fw-rocket-avionics", amount_min = 1, amount_max = 2 },
        { type = "item", name = "fw-rocket-heatshield", amount_min = 1, amount_max = 2 },
        { type = "item", name = "rocket-chunk",           amount = 1,     probability = 0.1 }
    }
end

local technology = {
        type = "technology",
        name = "rocket-chunk-processing",
        icon = "__FluxWorksAssets__/graphics/technology/fw-rocket-chunk-processing.png",
        icon_size = 190,
        effects =
        {
            {
                type = "unlock-recipe",
                recipe = "rocket-chunk-processing"
            },
        },
        prerequisites = { "fw-orbital-hardening", "rocket-silo", "space-science-pack" },
        unit =
        {
            count = 1600,
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
    },

data:extend { recipe }
data:extend { technology }


