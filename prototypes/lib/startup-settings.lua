local M = require("__razi_lib__/lib/settings")

function M.difficulty_mode()
  return M.difficulty_tier("fw-balance-flux-core-difficulty", "normal")
end

function M.difficulty_tier(name, fallback)
  local value = M.value(name, fallback or "normal")
  if value == "easy" or value == "hard" then
    return value
  end

  return "normal"
end

return M
