/* ----------------------------------------------------------------------------

  ChirPlayer Class
  
 ---------------------------------------------------------------------------- */

var ChirPlayer = function ( jelement, soundengine ) {

  this.jelement  = jelement;
  this.track     = $( jelement ).find( ".track" ).attr( "href" );
  this.engine    = soundengine;
  this.hasLoaded = true;
  this.hasPlayed = true;
  this.init();

  var player = this;

  $( this.jelement ).find( ".play" ).bind( "click", function () { player.play() });
  $( this.jelement ).find( ".stop" ).bind( "click", function () { player.stop() });

}

ChirPlayer.prototype.play  = function () {
 
  if ( this.isPaused ) {
    this.isPaused = false;
    $( this.jelement ).find( ".play" ).toggleClass( "playing" );
    this.engine.resume();
  }
  else if ( this.isStarted ) {
    this.isPaused = true;
    $( this.jelement ).find( ".play" ).toggleClass( "playing" );
    this.engine.pause();
  }
  else {
    this.engine.setPlayer( this );
    this.isStarted = true;
    $( this.jelement ).find( ".play" ).toggleClass( "playing" );
    this.engine.play();
  }

}

ChirPlayer.prototype.stop  = function () {

  this.init();
  this.engine.stop();
  $( this.jelement ).find( ".play" ).removeClass( "playing" );

}

ChirPlayer.prototype.init = function () {

  this.isStarted = false;
  this.isPaused = false;
  $( this.jelement ).find( ".loaded" ).hide();
  $( this.jelement ).find( ".played" ).show();
  $( this.jelement ).find( ".played .bar" ).css( "width", 0 );

}

ChirPlayer.prototype.loaded = function ( bytesLoaded, bytesTotal ) {

  if ( this.isStarted ) {
    $( this.jelement ).find( ".played" ).hide();
    $( this.jelement ).find( ".loaded" ).show();
    $( this.jelement ).find( ".loaded" ).text( "Loading ... " + parseInt( ( bytesLoaded / bytesTotal ) * 100 ) + "%"  );
  }

}

ChirPlayer.prototype.played = function ( playedTime, totalTime ) {

  $( this.jelement ).find( ".loaded" ).hide();
  $( this.jelement ).find( ".played" ).show();
  var percentage = parseInt( ( playedTime / totalTime ) * 100 );
  if ( percentage > 98 ) {
    percentage  = 100;
  }
  $( this.jelement ).find( ".played .bar" ).css( "width", percentage + "%" );

}

/* ----------------------------------------------------------------------------

  ChirPlayerLite Class
  
 ---------------------------------------------------------------------------- */

var ChirPlayerLite = function ( jelement, soundengine ) {

  this.jelement  = jelement;
  this.track     = $( jelement ).find( ".track" ).attr( "href" );
  this.engine    = soundengine;
  this.hasLoaded = true;
  this.hasPlayed = true;
  this.isStarted = false;

  var player = this;

  $( this.jelement ).find( ".play" ).bind( "click", function () { player.play() });
  $( this.jelement ).addClass( "constracted" );

}

ChirPlayerLite.prototype.play  = function () {
  if ( this.isStarted ) {
    this.stop();
  }
  else {
    this.engine.setPlayer( this );
    this.isStarted = true;
    $( this.jelement ).find( ".play" ).addClass( "playing" );
    this.engine.play();
  }

}

ChirPlayerLite.prototype.stop  = function () {

  this.isStarted = false;
  $( this.jelement ).find( ".play" ).removeClass( "loading" ).removeClass( "playing" );
  this.engine.stop();

}

ChirPlayerLite.prototype.loaded = function ( bytesLoaded, bytesTotal ) {

  if ( this.isStarted ) {
    $( this.jelement ).find( ".play" ).removeClass( "playing" );
    $( this.jelement ).find( ".play" ).addClass( "loading" );
  }

}

ChirPlayerLite.prototype.played = function ( bytesLoaded, bytesTotal ) {

  if ( this.isStarted ) {
    $( this.jelement ).find( ".play" ).removeClass( "loading" );
    $( this.jelement ).find( ".play" ).addClass( "playing" );
  }

}

/* ----------------------------------------------------------------------------
 
SoundEngine by JPlayer Class

----------------------------------------------------------------------------- */

JSoundEngine = function ( jelement, swfpath ) {

  var engine = this;

  this.jelement = jelement;
  
  $( this.jelement ).jPlayer( { swfPath : swfpath } );
  $( this.jelement ).jPlayer( "onProgressChange", function ( loadPercent, playedPercentRelative, playedPercentAbsolute, playedTime, totalTime ) {

    loadPercent = parseInt( loadPercent );
    playedTime  = parseInt( playedTime );
    totalTime   = parseInt( totalTime );

    if ( playedTime == 0 && engine.player.hasLoaded ) {
      engine.player.loaded( loadPercent, 100 )
    }
    else if ( playedTime != totalTime  && engine.player.hasPlayed ) {
      engine.player.played( playedTime, totalTime );
    }

  });
    
  $( this.jelement ).jPlayer( "onSoundComplete", function () {
      engine.player.stop();
  });

  this.player;

}

JSoundEngine.prototype.setPlayer = function ( player ) {
  if ( this.player ) {
    this.player.stop();
  }
  this.player = player;
}

JSoundEngine.prototype.play = function () {
  $( this.jelement ).jPlayer( "setFile", this.player.track );
  $( this.jelement ).jPlayer( "play" );
}

JSoundEngine.prototype.pause = function () {
  $( this.jelement ).jPlayer( "pause" );
}

JSoundEngine.prototype.resume = function () {
  $( this.jelement ).jPlayer( "play" );
}

JSoundEngine.prototype.stop = function () {
  $( this.jelement ).jPlayer( "stop" );
}

/* ----------------------------------------------------------------------------

SoundEngine by FlexPlayer Class

----------------------------------------------------------------------------- */

FlexSoundEngine = function ( jelement, swfpath ) {

  var engine = this;

  this.engine = new $( jelement ).flexplayer({ 
    swfPath : swfpath,
    onProgress : function ( bytesLoaded, bytesTotal, playedTime, totalTime ) {

      bytesLoaded = parseInt( bytesLoaded );
      bytesTotal  = parseInt( bytesTotal );
      playedTime  = parseInt( playedTime );
      totalTime   = parseInt( totalTime );

      if ( playedTime == 0 && engine.player.hasLoaded  ) {
        engine.player.loaded( bytesLoaded, bytesTotal )
      }
      else if ( playedTime != totalTime && engine.player.hasPlayed  ) {
        engine.player.played( playedTime, totalTime );
      }

    },
    onSoundComplete : function () {
      engine.player.stop();
    }
  });

  this.player;

}

FlexSoundEngine.prototype.setPlayer = function ( player ) {
  if ( this.player ) {
    this.player.stop();
  }
  this.player = player;
}

FlexSoundEngine.prototype.play = function () {
  this.engine.play( { path : this.player.track } );
}

FlexSoundEngine.prototype.pause = function () {
  this.engine.pause();
}

FlexSoundEngine.prototype.resume = function () {
  this.engine.resume();
}

FlexSoundEngine.prototype.stop = function () {
  this.engine.stop();
}