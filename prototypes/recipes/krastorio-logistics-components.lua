data:extend({
  {
    type = "recipe",
    name = "fw-loader-frame",
    enabled = false,
    energy_required = 2,
    ingredients = {
      { type = "item", name = "transport-belt", amount = 1 },
      { type = "item", name = "fw-bearing", amount = 2 },
      { type = "item", name = "fw-steel-beam", amount = 1 },
      { type = "item", name = "fw-cable-harness", amount = 1 },
    },
    results = { { type = "item", name = "fw-loader-frame", amount = 1 } },
  },
  {
    type = "recipe",
    name = "fw-pressure-vessel",
    enabled = false,
    energy_required = 3,
    ingredients = {
      { type = "item", name = "fw-pressure-housing", amount = 1 },
      { type = "item", name = "fw-kr-steel-pipe", amount = 2 },
      { type = "item", name = "fw-flow-regulator", amount = 1 },
      { type = "item", name = "steel-plate", amount = 2 },
    },
    results = { { type = "item", name = "fw-pressure-vessel", amount = 1 } },
  },
  {
    type = "recipe",
    name = "fw-logistic-relay",
    enabled = false,
    energy_required = 3,
    ingredients = {
      { type = "item", name = "advanced-circuit", amount = 2 },
      { type = "item", name = "fw-signal-conduit", amount = 1 },
      { type = "item", name = "fw-circuit-substrate", amount = 1 },
      { type = "item", name = "fw-loader-frame", amount = 1 },
    },
    results = { { type = "item", name = "fw-logistic-relay", amount = 1 } },
  },
  {
    type = "recipe",
    name = "fw-bulk-router",
    enabled = false,
    energy_required = 4,
    ingredients = {
      { type = "item", name = "processing-unit", amount = 2 },
      { type = "item", name = "fw-power-regulator", amount = 1 },
      { type = "item", name = "fw-logistic-relay", amount = 1 },
      { type = "item", name = "fw-loader-frame", amount = 1 },
    },
    results = { { type = "item", name = "fw-bulk-router", amount = 1 } },
  },
})
