if not Config.Debug then
    return
end

RegisterCommand("servernotification", function(source)
    exports["lb-phone"]:SendNotification(source, {
        title = "Test"
    })
end, false)

RegisterCommand("notifyeveryone", function()
    Wait(0) -- make debug prints show on the server console instead of client

    local players = GetPlayers()

    for i = 1, #players do
        local player = players[i]
        local phoneNumber = exports["lb-phone"]:GetEquippedPhoneNumber(tonumber(player))

        if phoneNumber then
            exports["lb-phone"]:SendNotification(phoneNumber, {
                app = "Wallet",
                title = "Test Notification",
                content = "This is a test notification.",
            })
        end
    end
end, false)

RegisterCommand("testmail", function(source)
    local phoneNumber = exports["lb-phone"]:GetEquippedPhoneNumber(source)
    local address = "test@lbphone.com"
    if phoneNumber then
        address = exports["lb-phone"]:GetEmailAddress(phoneNumber)
    end

    debugprint("Address: ", address)

    exports["lb-phone"]:SendMail({
        to = address,
        sender = "Test",
        subject = "Test",
        message = "Hello this is a test",
        actions = {
            {
                label = "Server event!",
                data = {
                    event = "phone:debug:mail",
                    isServer = true,
                    data = {
                        wow = "cool"
                    }
                }
            },
            {
                label = "Client event!",
                data = {
                    event = "phone:debug:mail",
                    isServer = false,
                    data = {
                        wow = "cool"
                    }
                }
            }
        }
    })
end, false)

RegisterNetEvent("phone:debug:mail", function(id, data)
    print(source, id, json.encode(data))
end)

RegisterCommand("testcall", function(src, args)
    local number = args[1]
    if not number then
        return
    end

    exports["lb-phone"]:CreateCall({
        phoneNumber = "123",
        source = src
    }, number, {
        requirePhone = false,
        hideNumber = true
    })
end, false)

RegisterCommand("addcontactserver", function(source, args)
    local number = exports["lb-phone"]:GetEquippedPhoneNumber(source)

    print("Number: ", number)

    exports["lb-phone"]:AddContact(number, {
        firstname = "David",
        lastname =  "Doe",
        number = args[1] or "1234567890",
        avatar = "https://i.imgur.com/2X1uYkU.png"
    })
end, false)

RegisterCommand("amberalertserver", function(source)
    local number = exports["lb-phone"]:GetEquippedPhoneNumber(source)

    if not number then return print("No number") end

    exports["lb-phone"]:SendAmberAlert(source, {
        title = "Amber Alert",
        content = "This is a test amber alert.",
        icon = "warning"
    })
end, false)

RegisterCommand("endcall", function(source)
    exports["lb-phone"]:EndCall(source)
end, false)

RegisterCommand("testamberexport", function(source)
    exports['lb-phone']:SendAmberAlert(source, {
        title = "Emergency Alert", -- the title of the notification
        content = "This is a test emergency alert", -- the description of the notification
        icon = "danger", -- the icon of the notification (optional), "warning" or "danger"
    })
end, false)

RegisterCommand("customCrypto", function()
    exports["lb-phone"]:AddCustomCoin(
        "lb-coin",
        "LB Coin",
        "lbc",
        "https://docs.lbscripts.com/images/icons/icon.png",
        18.5723523,
        {
            15.45253,
            16.234234,
            15.6843,
            17.000002,
            18.5723523,
        },
        0.5
    )
end, false)

-- post = { id, username, content, attachments, like_count, reply_count, retweet_count, reply_to, timestamp, replyToAuthor, display_name, username, profile_image, verified, liked, retweeted }
AddEventHandler("lb-phone:birdy:newPost", function(post)
    print("New Birdy post:", json.encode(post))
end)

-- post = { id, username, media, caption?, location? }
AddEventHandler("lb-phone:instapic:newPost", function(post)
    print("New InstaPic post:", json.encode(post))
end)

-- post = { id, username, caption, videoUrl }
AddEventHandler("lb-phone:trendy:newPost", function(post)
    print("New Trendy post:", json.encode(post))
end)

-- post = { id, number, title, description, attachment, price }
AddEventHandler("lb-phone:pages:newPost", function(post)
    print("New Pages post:", json.encode(post))
end)

-- post = { id, number, title, description, attachment, price }
AddEventHandler("lb-phone:marketplace:newPost", function(post)
    print("New MarketPlace post:", json.encode(post))
end)

RegisterCommand("airshare", function(source)
   exports["lb-phone"]:AirShare(source, source, "image", {
        isVideo = false,
        src = "https://image.api.playstation.com/vulcan/ap/rnd/202311/2801/803e41fee0edf8f8ed1de518e6eac60ddf30ac485b9a16a2.png",
        timestamp = os.time() * 1000
   })
end, false)
