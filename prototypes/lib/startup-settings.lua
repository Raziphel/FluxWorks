local M = {}

local function startup_setting(name)
  if not (settings and settings.startup) then
    return nil
  end

  return settings.startup[name]
end

function M.value(name, fallback)
  local setting = startup_setting(name)
  if setting == nil or setting.value == nil then
    return fallback
  end

  return setting.value
end

function M.enabled(name, fallback)
  local value = M.value(name, fallback)
  if value == nil then
    return false
  end

  return value == true
end

function M.difficulty_mode()
  local value = M.value("fw-difficulty-mode", "normal")
  if value == "easy" or value == "hard" then
    return value
  end

  return "normal"
end

return M
