-- The final data stage is our test suite. Keep every contract in one list.
local validators = {
  "prototypes.validation.playtest-report",
  "prototypes.validation.dual-pipe-networks",
  "prototypes.validation.compatibility-api",
  "prototypes.validation.combat-materials",
  "prototypes.validation.factorio-2-1",
  "prototypes.validation.machine-quality",
  "prototypes.validation.industrial-machine-upgrades",
  "prototypes.validation.razi-industrial-extension",
  "prototypes.validation.galactic-factories",
  "prototypes.validation.reborn-core",
  "prototypes.validation.native-industry",
  "prototypes.validation.item-uses",
  "prototypes.validation.steel-default",
  "prototypes.validation.recipe-complexity",
  "prototypes.validation.flux-composition",
  "prototypes.validation.flux-recovery-safety",
  "prototypes.validation.domain-science",
  "prototypes.validation.progression-projects",
  "prototypes.validation.research-programs",
  "prototypes.validation.progression-programs",
  "prototypes.validation.mastery-research",
  "prototypes.validation.progression-graph",
  "prototypes.validation.progression-ladders",
  "prototypes.validation.progression-compression",
  "prototypes.validation.planetary-self-sufficiency",
  "prototypes.validation.recipe-decomposition",
  "prototypes.validation.prototype-icons",
  "prototypes.validation.technology-icons",
  "prototypes.validation.expansion-preservation",
  "prototypes.validation.k2so",
  "prototypes.validation.owned-iconography",
  "prototypes.validation.crafting-tabs",
}

for _, module_name in ipairs(validators) do
  require(module_name)
end
