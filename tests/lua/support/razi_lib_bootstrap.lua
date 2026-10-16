-- Load genuine RaziLib 1.2.x sources into an offline Factorio data mock.
-- Requires sibling ../RaziLib, or set RAZILIB_PATH to a local RaziLib root.
-- Intentionally does NOT stub the shared library: that would mask API drift.
local M={}
function M.install()
  local root=(os.getenv and os.getenv("RAZILIB_PATH")) or "../RaziLib"
  local probe=io.open(root.."/lib/technology.lua","rb")
  assert(probe, "RaziLib source missing at "..root..
    ". Clone Raziphel/RaziLib alongside FluxWorks, or set RAZILIB_PATH.")
  probe:close()
  local modules={
    "core","collections","prototype","item","entity","recipe",
    "technology","technology_graph","science","icons","settings","validation"
  }
  for _,module in ipairs(modules) do
    local path=root.."/lib/"..module..".lua"
    local readable=io.open(path,"rb")
    assert(readable,"Required RaziLib module is absent: "..path)
    readable:close()
    package.preload["__razi_lib__/lib/"..module]=function()
      local load=assert(loadfile(path))
      return load()
    end
  end
  for _,module in ipairs({"storage","remote","events"}) do
    local path=root.."/runtime/"..module..".lua"
    local readable=io.open(path,"rb")
    assert(readable,"Required RaziLib runtime module is absent: "..path)
    readable:close()
    package.preload["__razi_lib__/runtime/"..module]=function()
      return assert(loadfile(path))()
    end
  end
  -- In a consumer mod, require(.../lib/core) must never resolve a fake shim.
  local core=require("__razi_lib__/lib/core")
  local technology=require("__razi_lib__/lib/technology")
  local icons=require("__razi_lib__/lib/icons")
  local settings=require("__razi_lib__/lib/settings")
  assert(type(core.stage_has_data)=="function"
    and type(technology.get)=="function"
    and type(icons.from_prototype)=="function"
    and type(settings.enabled)=="function",
    "Installed RaziLib does not expose the documented 1.2.0 API")
end
return M
