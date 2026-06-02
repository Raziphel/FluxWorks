function verify_whitelist ()
    storage.platform_type_whitelist = storage.platform_type_whitelist or {player = {}}
    storage.platform_type_whitelist["player"]["space-platform-starter-pack"] = true
end

local function on_init_setup()
    verify_whitelist()
end

remote.add_interface("rocket-reusability",
{
    add_whitelist = function (starter_pack_name, force_name) storage.platform_type_whitelist[force_name or "player"][starter_pack_name] = true end,
    remove_whitelist = function (starter_pack_name, force_name) table.remove(storage.platform_type_whitelist[force_name or "player"][starter_pack_name]) end,
    is_whitelisted = function (starter_pack_name, force_name) if storage.platform_type_whitelist[force_name or "player"][starter_pack_name] then return true else return false end end
})

commands.add_command("reset-whitelist", "Resets the whitelist for space platform starter packs. Can cause unpredictable behavior with other mods, but useful for removing mods.", function (command)
    storage.platform_type_whitelist = {player = {"space-platform-starter-pack"}}
end)


script.on_event(
    {
        defines.events.on_rocket_launched
    },
    function (event)
        if event.rocket_silo and event.rocket_silo.valid then

            verify_whitelist()

            local surface = event.rocket_silo.surface
            local planet
            for index, test_planet in pairs(game.planets) do
                if test_planet.surface == surface then
                    planet = test_planet
                    break
                end
            end
            if not planet then return end
            ---@type LuaForce
            local force = event.rocket_silo.force

            if not force.is_space_platforms_unlocked() then return end
            if not force.technologies["rocket-chunk-processing"].researched then return end

            local whitelist = storage.platform_type_whitelist[force.name]

            local platform_candidates = {}
            local platform_count = 0
            local priority_candidates = {}
            local priority_count = 0
            for index, platform in pairs(force.platforms) do
                if true then
                    if platform.surface then
                        if platform.space_location then
                            if platform.space_location.name == planet.prototype.name then

                                table.insert(platform_candidates, platform)
                                platform_count = platform_count + 1
                                
                                local candidates = platform.surface.find_entities_filtered({name = "remnant-beacon"})
                                if #candidates > 0 then
                                    ---@type LuaEntity
                                    local remnant_beacon = candidates[1]
                                    if remnant_beacon and remnant_beacon.valid then
                                        if remnant_beacon.status == defines.entity_status.working or remnant_beacon.status == defines.entity_status.low_power then
                                            table.insert(priority_candidates, platform)
                                            priority_count = priority_count + 1
                                        end
                                    end
                                end
                            end
                        end
                    end
                end
            end

            if #platform_candidates == 0 then
                return 
            end

            local target
            if priority_count > 0 then
                target = priority_candidates[math.random(1, priority_count)]
            else
                target = platform_candidates[math.random(1, platform_count)]
            end

            local x_pos = math.random(-40, 40)
            local y_pos = -40
            local found_empty_space = false
            while not found_empty_space do
                local result = target.surface.get_tile(x_pos, y_pos)
                if result.name ~= "empty-space" then
                    y_pos = y_pos - 10
                else
                    found_empty_space = true
                    y_pos = y_pos - 50
                end
            end

            target.surface.create_entity({name = "used-rocket-asteroid", position = {x_pos, y_pos}})
        end
    end
)

script.on_configuration_changed(function()
    verify_whitelist()
end)

script.on_init(function()
    on_init_setup()
end)
