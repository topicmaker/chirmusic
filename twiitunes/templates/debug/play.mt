? my $c = $_[0];
<html>
<head>
  <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
  <meta http-equiv="Content-Script-Type" content="text/javascript">

  <?= $c->render_part("include_import_jquery.mt") | raw ?>

</head>
<body>


<img src="http://a1.phobos.apple.com/us/r20/Music/a6/65/f7/mzi.koegdnev.100x100-75.jpg">
<img src="http://a1.phobos.apple.com/us/r20/Music/a6/65/f7/mzi.koegdnev.60x60-50.jpg">
<img src="http://a1.phobos.apple.com/us/r20/Music/a6/65/f7/mzi.koegdnev.30x30-50.jpg">

<div id="jpId"></div>
<a href="javascript:$('#jpId').jPlayer('play');void(0);">play</a>
<a href="javascript:$('#jpId').jPlayer('pause');void(0);">pause</a>
<a href="javascript:$('#jpId').jPlayer('stop');void(0);">stop</a>

<br><br>



<!-- demo player -->
<div id="jquery_jplayer"></div>
<div class="jp-single-player"> 
    <div class="jp-interface"> 

        <ul class="jp-controls"> 
            <li><a href="#" id="jplayer_play" class="jp-play" tabindex="1">play</a></li> 
            <li><a href="#" id="jplayer_pause" class="jp-pause" tabindex="1">pause</a></li> 
            <li><a href="#" id="jplayer_stop" class="jp-stop" tabindex="1">stop</a></li> 
            <li><a href="#" id="jplayer_volume_min" class="jp-volume-min" tabindex="1">min volume</a></li> 
            <li><a href="#" id="jplayer_volume_max" class="jp-volume-max" tabindex="1">max volume</a></li> 
        </ul> 
        <div class="jp-progress"> 
            <div id="jplayer_load_bar" class="jp-load-bar"> 
                <div id="jplayer_play_bar" class="jp-play-bar"></div> 
            </div> 
        </div> 
        <div id="jplayer_volume_bar" class="jp-volume-bar"> 
            <div id="jplayer_volume_bar_value" class="jp-volume-bar-value"></div> 
        </div> 
        <div id="jplayer_play_time" class="jp-play-time"></div> 
        <div id="jplayer_total_time" class="jp-total-time"></div> 
    </div> 
    <div id="jplayer_playlist" class="jp-playlist"> 
        <ul> 
            <li>track name</li> 
        </ul> 
    </div> 
</div> 
<!-- /demo player -->




<script>
  $("#jpId").jPlayer( {
    ready: function () {
      this.element.jPlayer("setFile", "http://a1.phobos.apple.com/us/r20/Music/57/b7/85/mzm.jgftsqxf.aac.p.m4a");
    },
    preload:"auto"
//   , nativeSupport: true, oggSupport: false, customCssIds: true
  });




    //-->> demo player
    // Local copy of jQuery selectors, for performance.
    var jpPlayTime  = $("#jplayer_play_time");
    var jpTotalTime = $("#jplayer_total_time");
 
    $("#jquery_jplayer").jPlayer({
        ready: function () {
            this.element.jPlayer("setFile", "http://a1.phobos.apple.com/us/r20/Music/02/a4/78/mzm.rslheowk.aac.p.m4a");
        },
        volume: 50,
        preload: 'none'
    })
    .jPlayer("onProgressChange", function(loadPercent, playedPercentRelative, playedPercentAbsolute, playedTime, totalTime) {
        jpPlayTime.text($.jPlayer.convertTime(playedTime));
        jpTotalTime.text($.jPlayer.convertTime(totalTime));
    });
    //--<< demo player



</script>


</body>
</html>
