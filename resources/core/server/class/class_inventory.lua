-- inventory = {

--     createInventory = function(owner_type, owner_id)
--         MySQL.Async.insert("INSERT INTO inventory (owner_type, type_id) VALUES (@1, @2)", {
--             ['@1'] = owner_type,
--             ['@2'] = owner_id
--         }, function()
--             CorePrint("Inventory créer")
--         end)
--     end

-- }