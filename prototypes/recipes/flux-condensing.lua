-- A bounded native-material valuation, not the retired recursive
-- galaxy-wide ore/material resolver. Four fluids retain their purpose.
local prices={
  ["stone"]={red=4},["coal"]={red=7,yellow=2},
  ["iron-ore"]={red=6},["copper-ore"]={yellow=6},
  ["iron-plate"]={red=12},["copper-plate"]={yellow=12},
  ["steel-plate"]={red=38},["stone-brick"]={red=10},
  ["sulfur"]={yellow=30},["plastic-bar"]={yellow=32},
  ["electronic-circuit"]={purple=12,yellow=8},
  ["advanced-circuit"]={purple=40,yellow=25},
  ["processing-unit"]={purple=115,yellow=45},
  ["spoilage"]={green=7},["nutrients"]={green=25},
  ["bioflux"]={green=75},
  ["holmium-plate"]={purple=65},
  ["tungsten-carbide"]={red=55},
  ["ice"]={purple=12},["calcite"]={red=14}
}
local qualities={{name="normal",multiplier=1}}
for name,quality in pairs(data.raw.quality or {}) do
  if name~="normal" and not quality.hidden then
    qualities[#qualities+1]={name=name,multiplier=math.max(1,quality.level or 1)}
  end
end
local table_out={}
for item,per_item in pairs(prices) do
  if (data.raw.item or {})[item] then
    local values={}
    for _,quality in ipairs(qualities) do
      local q={}
      for _,spectrum in ipairs({"purple","yellow","red","green"}) do
        q[spectrum]=(per_item[spectrum] or 0)*quality.multiplier
      end
      values[quality.name]=q
    end
    table_out[item]=values
  end
end
data:extend({{type="mod-data",name="fw-flux-extraction-values",
  data_type="fluxworks.flux-extraction-values",data=table_out}})
