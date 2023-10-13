table.Merge( _LAMBDAPLAYERSWEAPONS, {
  st_deagle = {
      model = "models/lambdaplayers/weapons/w_st3_deagle.mdl",
      origin = "Slendytubbies:III Multiplayer",
      prettyname = "Deagle",
      holdtype = "revolver",
      killicon = "lambdaplayers/killicons/icon_st3_deagle",
      -----------------------------------------------------
      bonemerge = true,
      keepdistance = 350,
      attackrange = 2000,
      islethal = true,
      ----------------------------------------------------
      clip = 25,
      tracername = "st3_ogtracer",
      damage = 12,
      spread = 0.2,
      rateoffiremin = 0.2,
      rateoffiremax = 0.45,
      ------------------------------------------------------
      muzzleflash = 1,
      shelleject = "ShellEject",
      shelloffpos = Vector(0,2,5),
      attackanim = ACT_HL2MP_GESTURE_RANGE_ATTACK_PISTOL,
      attacksnd = "lambdaplayers/weapons/SlendytubbiesSFX's/MP/st3_mp_shoot.wav",
      -------------------------------------------------------
      reloadtime = 1.8,
      reloadanim = ACT_HL2MP_GESTURE_RELOAD_PISTOL,
      reloadanimspeed = 1,
      reloadsounds = {            
     { 0, "lambdaplayers/weapons/SlendytubbiesSFX's/Deagle/st3_deaglereload.wav" },
     -----------------------------------------------------------
OnDeploy = function( self, wepent )
   wepent:EmitSound( "lambdaplayers/weapons/SlendytubbiesSFX's/onequip.wav" )
end,
---------------------------------------------------------------
OnAttack = function( lambda )
  if LAMBDA_ST3:IsUnderwater(lambda) then lambda:EmitSound("lambdaplayers/weapons/SlendytubbiesSFX's/dryfire_pistol.wav") lambda.l_WeaponUseCooldown = CurTime() + 0.2 return end
end,
---------------------------------------------------------------
      islethal = true,
    }
  }
})