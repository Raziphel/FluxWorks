-- FluxWorks balances AAI loaders through their higher upfront material cost.
-- Change only AAI Loaders' default; players can still select any offered mode.
local aai_loaders_mode = data.raw["string-setting"]
  and data.raw["string-setting"]["aai-loaders-mode"]

if aai_loaders_mode then
  aai_loaders_mode.default_value = "expensive"
end
