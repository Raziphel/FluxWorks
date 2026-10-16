local RaziSettings=require("__razi_lib__/lib/settings")
-- Use RaziLib for prototype construction while retaining every setting ID,
-- allowed value and startup/default behaviour from previous FluxWorks saves.
local function startup_bool(name, default_value, order)
  return RaziSettings.bool(name,"startup",default_value,order)
end
local function startup_choice(name, default_value, values, order)
  return RaziSettings.string(name,"startup",default_value,values,order)
end
local function startup_difficulty(name,order)
  return startup_choice(name,"normal",{"easy","normal","hard"},order)
end

-- Factory-only settings. The older fw-* identifiers remain registered for
-- existing saves, but none of the host campaign settings are changed.
data:extend({
  startup_choice("fw-rp-factory-design","reborn",{"reborn","legacy"},"aa[expansion]-0[factory-design]"),
  startup_choice("fw-rp-industrial-depth", "expanded", {"core", "expanded"}, "aa[expansion]-a[depth]"),
  startup_choice("fw-rp-industrial-power", "standard", {"efficient", "standard", "demanding"}, "aa[expansion]-b[power]"),
  startup_bool("fw-rp-convergence-universal", true, "aa[expansion]-c[convergence]"),
  startup_choice("fw-rp-process-tempo", "standard", {"rapid", "standard", "deliberate"}, "aa[expansion]-d[tempo]"),
  startup_choice("fw-rp-project-research", "standard", {"accelerated", "standard", "monumental"}, "aa[expansion]-e[projects]"),
  startup_bool("fw-rp-galactic-industry", true, "aa[expansion]-f[worlds]"),
  startup_bool("fw-rp-k2so-galaxy-industry", true, "aa[expansion]-g[k2so-worlds]"),
  startup_bool("fw-rp-interplanetary-factories", true, "aa[expansion]-h[freight]"),
  startup_difficulty("fw-balance-flux-core-difficulty", "aa[balance]-a[flux-core]"),
  startup_difficulty("fw-balance-harvesting-difficulty", "aa[balance]-b[harvesting]"),
  startup_difficulty("fw-balance-synthesis-difficulty", "aa[balance]-c[synthesis]"),
  startup_difficulty("fw-balance-condensing-difficulty", "aa[balance]-d[condensing]"),
  startup_difficulty("fw-balance-petrochemistry-difficulty", "aa[balance]-e[petrochemistry]"),
  startup_difficulty("fw-balance-hydraulics-difficulty", "aa[balance]-f[hydraulics]"),
  startup_difficulty("fw-balance-atomic-enrichment-difficulty", "aa[balance]-g[atomic]"),
  startup_difficulty("fw-balance-integrated-recipes-difficulty", "aa[balance]-h[integrated]"),
  startup_difficulty("fw-balance-science-recipes-difficulty", "aa[balance]-i[science]"),
  startup_difficulty("fw-balance-fluid-systems-difficulty", "aa[balance]-j[fluid]"),
  startup_difficulty("fw-balance-control-systems-difficulty", "aa[balance]-k[control]"),
  startup_difficulty("fw-balance-late-machines-difficulty", "aa[balance]-l[late]"),
  startup_difficulty("fw-balance-orbital-recipes-difficulty", "aa[balance]-m[orbital]"),
  startup_difficulty("fw-balance-crafting-time-difficulty", "aa[balance]-n[craft-time]"),
  startup_choice(
    "fw-starting-crash-loadout",
    "normal",
    { "easy", "normal", "hard" },
    "aa[balance]-o[starting-loadout]"
  ),
  startup_difficulty("fw-balance-space-platform-drag", "aa[balance]-p[space-platform-drag]"),
  startup_difficulty("fw-balance-asteroid-pressure", "aa[balance]-q[asteroid-pressure]"),
  startup_difficulty("fw-balance-space-logistics", "aa[balance]-r[space-logistics]"),
  startup_difficulty("fw-balance-spoilage-pressure", "aa[balance]-s[spoilage-pressure]"),
  startup_difficulty("fw-balance-origin-singularity-difficulty", "aa[balance]-t[origin-singularity]"),
  startup_difficulty("fw-balance-shattered-asteroid-pressure", "aa[balance]-u[shattered-asteroids]"),
  startup_difficulty("fw-balance-ion-storm-intensity", "aa[balance]-v[ion-storm]"),
  startup_difficulty("fw-balance-research-cost", "aa[balance]-w[research]"),
  startup_difficulty("fw-balance-rift-logistics", "aa[balance]-x[rift-logistics]"),

  startup_bool("fw-worldgen-enable-standalone-ores", false, "ab[worldgen]-f[standalone-ores]"),
  startup_bool("fw-worldgen-enable-promethium-impacts", true, "ab[worldgen]-j[promethium-enabled]"),

  startup_bool("fw-enable-k2so-integration", true, "ba[compat]-a[k2so]"),
  startup_bool("fw-enable-early-domain-science-gates", false, "ba[overhaul]-a[early-science]"),
  startup_bool("fw-enable-early-industry-overhaul", false, "ba[overhaul]-a[early-industry]"),
  startup_bool("fw-enable-legacy-technology-overhaul", false, "ba[overhaul]-a[technology]"),
  startup_bool("fw-enable-asteroid-recipe-overrides", false, "ba[overhaul]-a[asteroids]"),

  startup_bool("fw-enable-recipe-integration", false, "ba[overhaul]-a[recipe-integration]"),
  startup_bool("fw-enable-core-material-replacements", false, "ba[overhaul]-b[core-materials]"),
  startup_bool("fw-enable-combat-recipe-integration", false, "ba[overhaul]-c[combat-integration]"),
  startup_bool("fw-enable-orbital-and-planetary-integration", false, "ba[overhaul]-d[orbital-planetary]"),
  startup_bool("fw-enable-fulgora-scrap-integration", true, "ba[overhaul]-e[fulgora-scrap]"),
  startup_bool("fw-enable-machine-part-rehoming", false, "ba[overhaul]-f[machine-rehoming]"),
  startup_choice(
    "fw-global-compatibility-mode",
    "off",
    { "off", "conservative", "broad" },
    "ba[overhaul]-h[global-compatibility]"
  ),

  startup_bool("fw-enable-crafting-tab-reorganization", false, "ca[qol]-a[crafting-tabs]"),
  startup_bool("fw-tab-logistics-organization", true, "ca[qol]-b[logistics-tab]"),
  startup_bool("fw-tab-production-organization", true, "ca[qol]-c[production-tab]"),
  startup_bool("fw-tab-science-organization", true, "ca[qol]-d[science-tab]"),
  startup_bool("fw-tab-bioprocessing-organization", true, "ca[qol]-e[bioprocessing-tab]"),
  startup_bool("fw-tab-energy-organization", true, "ca[qol]-f[energy-tab]"),
  startup_bool("fw-tab-chemistry-organization", true, "ca[qol]-g[chemistry-tab]"),
  startup_bool("fw-tab-flux-organization", true, "ca[qol]-i[flux-tab]"),
  startup_bool("fw-tab-fabrication-organization", true, "ca[qol]-j[fabrication-tab]"),

  startup_bool("enable-incomplete-rocket-parts", false, "da[other]-a[incomplete-parts]"),
  startup_bool("enable-incomplete-rocket-parts-productivity", false, "da[other]-b[incomplete-productivity]"),
  startup_bool("fw-enable-unattended-shattered-asteroids", true, "ea[performance]-a[unattended-asteroids]"),

  {
    type = "string-setting",
    name = "fw-memory-unit-power-usage",
    setting_type = "runtime-global",
    default_value = "300kW",
    allowed_values = { "0W", "60kW", "180kW", "300kW", "480kW", "600kW", "1.2MW", "2.4MW", "3.6MW", "5MW", "10MW", "20MW", "50MW" },
    order = "ea[performance]-b[memory-power-usage]",
  },
})

-- Legacy controls were kept for old settings files, but do not belong in a
-- Razi-hosted extension's visible settings page. Never force old save values.
local delegated = {
  "fw-starting-crash-loadout", "fw-balance-space-platform-drag",
  "fw-balance-asteroid-pressure", "fw-balance-space-logistics",
  "fw-balance-spoilage-pressure", "fw-balance-origin-singularity-difficulty",
  "fw-balance-shattered-asteroid-pressure", "fw-balance-ion-storm-intensity",
  "fw-worldgen-enable-standalone-ores", "fw-worldgen-enable-promethium-impacts",
  "fw-enable-unattended-shattered-asteroids",
  "fw-enable-asteroid-recipe-overrides", "fw-enable-fulgora-scrap-integration",
  "fw-enable-legacy-technology-overhaul",
}
for _, name in ipairs(delegated) do
  local setting = (data.raw["string-setting"] or {})[name] or (data.raw["bool-setting"] or {})[name]
  if setting then setting.hidden = true end
end
