Citizen.CreateThread(function()
    if Config.EnableGuidebookIntegration then
        local guidebookFound = false
        
        if LoadResourceFile(GetCurrentResourceName(), 'guidebook_added') then
            return
        end

        TriggerEvent('rcore_guidebook:supportDynamicSave', function()
            guidebookFound = true

            SaveResourceFile(GetCurrentResourceName(), 'guidebook_added', 'This file tells bowling to not add new category/page/point to guidebook, so you can edit it to your liking.', 0)
            TriggerEvent('rcore_guidebook:saveInternal', 'CATEGORY', {
                order_number = 10,
                key = 'minigames',
                label = 'Minigames',
                default_expand = false,
                is_enabled = true,
            })

            Wait(1000)

            TriggerEvent('rcore_guidebook:saveInternal', 'PAGE', {
                order_number = 1,
                key = 'bowling',
                label = 'Bowling',
                is_enabled = true,
                content = [[
                    <h1>Bowling</h1><p>Play bowling solo to practice, against friends or team vs. team to establish who has better friends! <button class="btn btn--icon-q" type="gps" data-label="Burton Bowling" data-x="-150.79" data-y="-257.50">﻿<span contenteditable="false"><svg><use xlink:href="img/teleport.svg#teleport"></use></svg>Burton Bowling</span>﻿</button></p><h2>How to play</h2><p>The goal is to score more points than your opponents. If you throw a strike (no pins standing after first throw), your next two throws will count towards this frame. If you throw a spare (no pins standing after second throw), your next throw will count towards this frame.</p><p><br></p><h2>Spin</h2><p>When throwing, you can select ball spin. This will steer the ball in desired direction at the end of the lane. This is due to the lane having oil applied, where for most of the lane the ball is just slipping, but as it gets closer to pins, there's less or no oil, allowing the spin to steer the ball.</p><p><br></p><p>With proper spin you get higher chances of hitting the pins at the correct point and angle as opposed to just straight throw.</p>
                ]],
                category_key = "minigames",
            })

            Wait(1000)
            
            TriggerEvent('rcore_guidebook:saveInternal', 'POINT', {
                is_enabled = true,
                can_navigate = true,
                draw_distance = 20.0,
                position = {
                    x = -147.75,
                    y = -250.32,
                    z = 44.05,
                },
                color = {
                    r = 255,
                    g = 255,
                    b = 255,
                },
                size = 0.5,
                key = "bowling",
                label = "Bowling",
                --Content
                content = nil,
                help_key = "bowling", --if null its used content as custom or specific page is loaded.
                --Blip
                blip_enabled = false,
                blip_size = 1.0,
                blip_display_type = 2,
                blip_sprite = 1,
            
                --Marker
                marker_enabled = true,
                marker_draw_distance = 20.0,
                marker_size = {
                    x = 1.0,
                    y = 1.0,
                    z = 0.5,
                },
                marker_color = {
                    r = 0,
                    g = 118,
                    b = 155,
                },
                marker_type = 1,
            })
            
        end)

        Wait(1000)

        if not guidebookFound then
            if GetResourceState('rcore_guidebook') == 'started' then
                print("^1WARNING:^0 Please update your rcore_guidebook to have a help point added automatically")
            else
                print("^1WARNING:^0 Guidebook not found")
                print("^1WARNING:^0 This resource includes Guidebook point that explains rules and physics of bowling to players")
                print("^1WARNING:^0 You can purchase the guidebook at https://store.rcore.cz/package/5041989")
                print("^1WARNING:^0 Or disable this warning by setting EnableGuidebookIntegration to False")
            end
        end
    end
end)