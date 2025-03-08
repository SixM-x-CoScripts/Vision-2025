props_list = {}
outline_data = {
    prev = nil,
    current = nil
}

gizmoEntity = nil

PropsMenu = {};

PropsMenu.Main = {};
PropsMenu.Main.UI = RageUI.CreateMenu("Props", "Props Menu", 0, 0);

PropsMenu.Main.Items = {}