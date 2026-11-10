-- Definice receptů – čas (energy_required) je navýšen 10x, protože základní budova má jen 1MW
local science_recipes = {
  {
    type = "recipe",
    name = "energy-to-automation-science",
    categories = {"energy-science"},
    subgroup = "science-pack",
    energy_required = 10, -- 10s při 1MW = 10 MJ energie
    ingredients = {},
    results = {{type = "item", name = "automation-science-pack", amount = 1}},
    enabled = true
  },
  {
    type = "recipe",
    name = "energy-to-logistic-science",
    categories = {"energy-science"},
    subgroup = "science-pack",
    energy_required = 20, -- 20s při 1MW = 20 MJ energie
    ingredients = {},
    results = {{type = "item", name = "logistic-science-pack", amount = 1}},
    enabled = true
  },
  {
    type = "recipe",
    name = "energy-to-military-science",
    categories = {"energy-science"},
    subgroup = "science-pack",
    energy_required = 30,
    ingredients = {},
    results = {{type = "item", name = "military-science-pack", amount = 1}},
    enabled = true
  },
  {
    type = "recipe",
    name = "energy-to-chemical-science",
    categories = {"energy-science"},
    subgroup = "science-pack",
    energy_required = 40,
    ingredients = {},
    results = {{type = "item", name = "chemical-science-pack", amount = 1}},
    enabled = true
  },
  {
    type = "recipe",
    name = "energy-to-production-science",
    categories = {"energy-science"},
    subgroup = "science-pack",
    energy_required = 60,
    ingredients = {},
    results = {{type = "item", name = "production-science-pack", amount = 1}},
    enabled = true
  },
  {
    type = "recipe",
    name = "energy-to-utility-science",
    categories = {"energy-science"},
    subgroup = "science-pack",
    energy_required = 60,
    ingredients = {},
    results = {{type = "item", name = "utility-science-pack", amount = 1}},
    enabled = true
  },
  {
    type = "recipe",
    name = "energy-to-space-science",
    categories = {"energy-science"},
    subgroup = "science-pack", -- OPRAVENO: space-science neexistuje, patří pod science-pack
    energy_required = 100, -- 100s při 1MW = 100 MJ energie
    ingredients = {},
    results = {{type = "item", name = "space-science-pack", amount = 1}},
    enabled = true
  }
}

-- Načtení základní laboratoře jako šablony
local base_lab = data.raw["lab"]["lab"]
local cc_def = circuit_connector_definitions and circuit_connector_definitions["assembling-machine"]
local cc_table = cc_def and {cc_def, cc_def, cc_def, cc_def} or nil

-------------------------------------------------------------------------------
-- 1. ZÁKLADNÍ BUDOVA (1 MW, Rychlost 1.0)
-------------------------------------------------------------------------------
local converter_entity = table.deepcopy(base_lab)
converter_entity.name = "energy-science-converter"
converter_entity.type = "assembling-machine"
converter_entity.crafting_categories = {"energy-science"}
converter_entity.crafting_speed = 1.0
converter_entity.energy_source = { type = "electric", usage_priority = "secondary-input", emissions_per_minute = { pollution = 0 } }
converter_entity.energy_usage = "1MW" 

if converter_entity.minable then converter_entity.minable.result = "energy-science-converter" end
converter_entity.graphics_set = {
  animation = base_lab.on_animation or base_lab.animation or base_lab.idle_animation,
  working_visualisations = base_lab.working_visualisations
}
converter_entity.on_animation, converter_entity.off_animation, converter_entity.inputs, converter_entity.researching_speed, converter_entity.inputs_inline_fluid_box_index = nil, nil, nil, nil, nil
converter_entity.base_working_sound = data.raw["assembling-machine"]["assembling-machine-1"].working_sound
converter_entity.allowed_effects = {"consumption", "speed", "productivity", "pollution"}
converter_entity.circuit_connector = cc_table

-- Předmět a recept pro základní budovu
local converter_item = {
  type = "item",
  name = "energy-science-converter",
  icon = base_lab.icon, icon_size = base_lab.icon_size,
  subgroup = "production-machine", order = "g[energy-science-converter]",
  place_result = "energy-science-converter", stack_size = 10
}
local converter_craft_recipe = {
  type = "recipe",
  name = "energy-science-converter",
  ingredients = {
    {type = "item", name = "advanced-circuit", amount = 5},
    {type = "item", name = "copper-cable", amount = 20},
    {type = "item", name = "steel-plate", amount = 10}
  },
  results = {{type = "item", name = "energy-science-converter", amount = 1}},
  enabled = true
}

-------------------------------------------------------------------------------
-- 2. POKROČILÁ BUDOVA (1 MW základ * 10x rychlost = 10 MW spotřeba v tahu)
-------------------------------------------------------------------------------
local advanced_converter_entity = table.deepcopy(converter_entity)
advanced_converter_entity.name = "advanced-energy-science-converter"
advanced_converter_entity.crafting_speed = 10.0 -- 10x rychlejší zpracování receptů

if advanced_converter_entity.graphics_set and advanced_converter_entity.graphics_set.animation then
  advanced_converter_entity.graphics_set.animation.tint = {r = 0.7, g = 0.8, b = 1.0, a = 1.0}
end
if advanced_converter_entity.minable then advanced_converter_entity.minable.result = "advanced-energy-science-converter" end

-- Předmět a recept pro pokročilou budovu
local advanced_converter_item = {
  type = "item",
  name = "advanced-energy-science-converter",
  icon = base_lab.icon, icon_size = base_lab.icon_size,
  tint = {r = 0.7, g = 0.8, b = 1.0, a = 1.0},
  subgroup = "production-machine", order = "g[advanced-energy-science-converter]",
  place_result = "advanced-energy-science-converter", stack_size = 10
}
local advanced_converter_craft_recipe = {
  type = "recipe",
  name = "advanced-energy-science-converter",
  ingredients = {
    {type = "item", name = "energy-science-converter", amount = 1},
    {type = "item", name = "processing-unit", amount = 5},
    {type = "item", name = "advanced-circuit", amount = 5}
  },
  results = {{type = "item", name = "advanced-energy-science-converter", amount = 1}},
  enabled = true
}

-------------------------------------------------------------------------------
-- REGISTRACE DO HRY
-------------------------------------------------------------------------------
local crafting_category = { type = "recipe-category", name = "energy-science" }

data:extend({
  crafting_category,
  converter_entity, converter_item, converter_craft_recipe,
  advanced_converter_entity, advanced_converter_item, advanced_converter_craft_recipe
})

for _, recipe in ipairs(science_recipes) do
  data:extend({recipe})
end
