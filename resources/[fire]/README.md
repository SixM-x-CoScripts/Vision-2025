## Installation
You must start firehose and firehosemodels if you just need the fire hose
You must start firescript if you want our custom made fire script
You must start discordwebhooks if you want to use the discord webhooks in our firescript

Check the firehose/settings/trucks.ini and change any value to your liking
You must add your fire trucks inside settings.ini under [TruckInfo]
If you use SmartFires you must edit the SmartFires Script Config
We Recommend Using Our Own Custom Fire Script That Comes With The Script
Open the config.lua to adjust it to your likings

If you use our firescript
You can choose to use ESX framework, Qbus Framework Or Standalone in the config.lua

If You Want To Use SmartFires:
You must set 'usingHoseLS' to true
You must change the water weapon model to 'weapon_firehose'

## Example Config
main = {
    fireSpawnDistance = 200.0, -- This is the distance the player must be within to a fire to spawn in (for performance)
    smokeSpawnDistance = 500.0,-- This is the distance the player must be within to smoke to spawn in (for performance)
    usingHoseLS = true,

weapons = {
    water = {
        model = `WEAPON_FIREHOSE`, -- If you are using HoseLS, we do not recommend changing this
        name = "Hose",
        reduceBy = 0.65, -- This is how powerful it is, lower the number the better
        increaseBy = 1.3, --  This is how powerful it is against the wrong fire type, higher the number the more powerful
    },

## Stuff To Note
Make sure you add the weapon to your anticheat whitelist if you have one (WEAPON_FIREHOSE)