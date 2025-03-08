PropsMenu.PropsList = {};
PropsMenu.PropsList.UI = RageUI.CreateSubMenu(PropsMenu.Main.UI, "Liste des props", "Props Menu");
PropsMenu.PropsList.Items = {}

table.insert(PropsMenu.Main.Items, {
    Name = "Liste des props",
    Type = "Button",
    Enabled = true,
    SubMenuLink = PropsMenu.PropsList.UI,
    Callback = {
        onSelected = function()
            PropsMenu.PropsList.Items = {}
            for _, prop in pairs(props_list) do
                table.insert(PropsMenu.PropsList.Items, {
                    data = prop,
                    Name = prop.name,
                    Type = "List",
                    List = {"Supprimer", "Déplacer", "Poser au sol"},
                    Index = 1,
                    Enabled = true,
                    SubMenuLink = nil,
                    Callback = {
                        onListChange = function(Index, Item)
                            PropsMenu.PropsList.Items[_].Index = Index
                        end,
                        onActive = function ()
                            outline_data.prev = outline_data.current
                            outline_data.current = prop.handle
                        end,
                        onSelected = function ()
                            if PropsMenu.PropsList.Items[_].Index == 1 then
                                DeleteEntity(prop.handle)
                                table.remove(props_list, _)
                            elseif PropsMenu.PropsList.Items[_].Index == 2 then
                                Functions.Gizmo.Use(prop.handle, prop.name)
                            elseif PropsMenu.PropsList.Items[_].Index == 3 then
                                PlaceObjectOnGroundProperly(prop.handle)
                            end
                        end
                    },
                    Style = { RightLabel = "" }
                })
            end
        end,
        onActive = function ()
            Functions.Gizmo.Cancel()
            if outline_data.current then
                SetEntityDrawOutline(outline_data.current, false)
            end
            outline_data.prev = nil
            outline_data.current = nil
        end,
    },
    Style = { RightLabel = "→" }
})