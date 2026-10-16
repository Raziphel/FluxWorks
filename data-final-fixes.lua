-- Register manufacturing only after other mods finish adding their items,
-- machines and planet metadata. Razi integrations are entirely optional.
require("prototypes.focused.core-recipes").apply()
require("prototypes.identity.four-works-charter")
require("prototypes.identity.seven-foundries")
require("prototypes.recipes.flux-condensing")
require("__razi_lib__/lib/recipe").normalize_all_2_1()
require("prototypes.validation.focused-core")
