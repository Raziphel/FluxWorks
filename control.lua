local modules = {
  require("scripts.rocket-remnants"),
  require("scripts.phase-vaults"),
  require("scripts.spectral-reservoirs"),
  require("scripts.rift-exchange"),
}

local event_handlers = {}
local nth_tick_handlers = {}

local registrar = {}

function registrar.on_event(events, handler)
  if type(events) == "table" then
    for _, event_id in ipairs(events) do
      registrar.on_event(event_id, handler)
    end
    return
  end

  event_handlers[events] = event_handlers[events] or {}
  table.insert(event_handlers[events], handler)
end

function registrar.on_nth_tick(interval, handler)
  nth_tick_handlers[interval] = nth_tick_handlers[interval] or {}
  table.insert(nth_tick_handlers[interval], handler)
end

for _, module in ipairs(modules) do
  if module.register_events then
    module.register_events(registrar)
  end
end

for event_id, handlers in pairs(event_handlers) do
  script.on_event(event_id, function(event)
    for _, handler in ipairs(handlers) do
      handler(event)
    end
  end)
end

for interval, handlers in pairs(nth_tick_handlers) do
  script.on_nth_tick(interval, function(event)
    for _, handler in ipairs(handlers) do
      handler(event)
    end
  end)
end

script.on_init(function()
  for _, module in ipairs(modules) do
    if module.on_init then
      module.on_init()
    end
  end
end)

script.on_configuration_changed(function(configuration_changed_data)
  for _, module in ipairs(modules) do
    if module.on_configuration_changed then
      module.on_configuration_changed(configuration_changed_data)
    end
  end
end)
