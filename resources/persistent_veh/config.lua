Config = {

  -- repopulate the map with vehicles that were lost when the server rebooted
  populateOnReboot = false,

  -- save vehicle data on txAdmin scheduled restart
  txAdmin = true,

  -- how close a player needs to get to a deleted persistent vehicle before it is respawned
  respawnDistance = 550, -- 350+

  -- don't respawn a vehicle that's been destroyed
  forgetOnDestroyed = false,

  -- time in ms that the server waits before it attempts to spawn vehicles and update their properties/coords. 
  serverTickTime = 1500, -- anything lower than 1000 will cause unnecessary server load. Anything higher than 3000 may cause vehicle popping depending on "respawnDistance"

  -- enable debugging to see server console messages; can be toggled with server command: pv-toggle-debugging
  debug = true,
}