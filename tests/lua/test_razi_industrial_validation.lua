-- Source-level regression test that the extension's startup validator
-- rejects an unavailable input machine and accepts simple guarded recipes.
local module = "prototypes/validation/razi-industrial-extension.lua"
_G.settings = {startup = {["fw-rp-industrial-depth"] = {value = "core"}}}
_G.data = {raw = {}}
assert(pcall(dofile, module), "Core profile must not require extra processes")
settings.startup["fw-rp-industrial-depth"].value = "expanded"
data.raw = {recipe={}, technology={}, ["assembling-machine"]={}}
assert(pcall(dofile, module), "Absent optional ingredients do not abort loading")
local recipe = {
  name = "fw-industry-living-filtration", category = "fw-flux-synthesis",
  enabled = false, allow_productivity = false, auto_recycle = false,
  energy_required = 13, main_product = "fw-inline-filter",
  icons = {{icon="one"}, {icon="two"}},
  ingredients = {{type="item", name="fw-resin", amount=1}},
  results = {{type="item", name="fw-inline-filter", amount=7}},
}
data.raw.recipe[recipe.name] = recipe
data.raw["assembling-machine"]["synthesis"] = {crafting_categories={"fw-flux-synthesis"}}
data.raw.technology["unlock"] = {effects={{type="unlock-recipe",recipe=recipe.name}}}
assert(pcall(dofile,module), "Valid guarded recipe should pass")
recipe.allow_productivity = true
assert(not pcall(dofile,module), "Productivity loop must be rejected")
recipe.allow_productivity = false
data.raw.technology["unlock"].effects = {}
assert(not pcall(dofile,module), "Orphan recipe unlock must be rejected")
print("Industrial validator: core, optional, valid and invalid recipe paths pass")
