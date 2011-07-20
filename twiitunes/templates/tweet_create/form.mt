? my $c = $_[0];
? my $twiitunes_music = $c->stash->{twiitunes_music};
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
 "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
  <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
  <title>chirmusic -Tweet your favorite tracks on iTunes preview.</title>
  <?= $c->render_part("include_import_jquery.mt") | raw ?>
  <? if ($c->is_smartphone) { ?>
    <!-- X}[gtH? -->
    <link rel="stylesheet" type="text/css" href="<?= $c->uri_for('/static/css/import_ip.css') ?>">
    <link rel="apple-touch-icon" href="<?= $c->uri_for('/static/apple-touch-icon.png') ?>">
    <meta name="viewport" content="width=320">
  <? } ?>
  <? if (!$c->is_smartphone) { ?>
    <!-- X}[gtH??? -->
    <link rel="stylesheet" type="text/css" href="<?= $c->uri_for('/static/css/import.css') ?>">
  <? } ?>
  <?= $c->render_part("include_google_analytics.mt") | raw ?>
</head>
<body>

<div id="soundengine"></div>

<div id="container">
  <div id="container-inner">

    <div id="header">
      <div id="header-inner">

        <?= $c->render_part("include_header.mt") | raw ?>

      <!-- /header-inner -->
      </div>
    <!-- /header -->
    </div>
    
    <div id="pagebody" >
      <div id="pagebody-inner" class="clearfix">
        <div id="alpha" >
          
              <!-- TrackArea -->
                <div Id="TrackArea">
                    <div Id="TrackArea-contents" class="clearfix">
                        <div id="musicImg">
                             <p class="trackpage"><img src="<?= $twiitunes_music->itune_artworkurl100 ?>" width="100" height="100" alt=""></p>
                        </div>
                        <div id="musicData">
                        <ul>
                        <li id="artist"><?= $twiitunes_music->itunes_artistname ?></li>
                        <li id="track"><?= $twiitunes_music->itunes_trackname ?></li>
                        <li id="album"><?= $twiitunes_music->itunes_collectionname ?></li>
                        <li id="itune"><a href="<?= $c->config->{itunes_store_tracking_url} ?><?= $twiitunes_music->itunes_trackviewurl ?>">iTunes music store</a></li>
                        </ul>
                        </div>

                        <div class="chirplayer">
                          <a class="track" href="<?= $twiitunes_music->itunes_previewurl ?>">Track</a>
                          <table>
                            <tbody>
                              <tr>
                                <td>
                                  <ul class="controls"> 
                                    <li><a href="javascript:void(0)" class="play"><span class="alt">play</span></a></li> 
                                    <li><a href="javascript:void(0)" class="stop"><span class="alt">stop</span></a></li> 
                                  </ul>
                                </td>
                                <td>
                                  <div class="progress"> 
                                    <div class="loaded"></div>
                                    <div class="played"><div class="bar"></div></div>
                                  </div>
                                </td>
                              </tr>
                            </tbody>
                          </table> 
                        <!-- /chirplayer -->
                        </div>

                    </div>
                </div>
              <!-- /TrackArea -->

<!-- error message -->
<? if ( $c->flash->get("validate_error") ) { ?>
    <? my $validate_error = $c->flash->get("validate_error") ?>
    <? if ( $validate_error->{description}->{not_null} ) { ?>
              <p>Please input the comment box.</p>
    <? } ?>
    <? if ( $validate_error->{description}->{length} ) { ?>
              <p>Please input the comment box in less than <?= $c->config->{tweet_validate}->{description}->{length} ?> characters.</p>
    <? } ?>
    <? if ( $validate_error->{twitter_update} ) { ?>
              <p>After some time, please try again.</p>
    <? } ?>
<? } ?>

              <!-- TweetArea -->
              <div id="tw_wrapper">
                  <div id="comment_area">
                      <p>comment box:<span id="countup"></span><span id="countup-message" class="error"> Please be less than <?= $c->config->{tweet_validate}->{description}->{length} ?> characters.</span></p>
                    <form action="<?= $c->uri_for('/tweet_create/req') ?>" method="post">
                      <input type="hidden" name="sid" value="<?= $c->session->session_id ?>"/>
                      <input type="hidden" name="itunes_trackid" value="<?= $twiitunes_music->itunes_trackid ?>"/>
                      <textarea name="description" id="input-up" rows="10"></textarea>
                      <div id="form_raty"></div>
                      <input id="ratings" type="hidden" name="ratings" value="0"/>
                      <br />
                      <div id="commentpost">
                        <input type="image" src="<?= $c->uri_for('/static/img/bt_tweet.jpg') ?>" width="104" height="25" alt="search">
                        <p>NOTE: Comments will be also  posted to your twitter TL.<!---(For more than 140 characters will be omitted on your TL)---></p>
                      </div>
                    </form>
                  </div>
                  
              </div>
              <!-- TweetArea -->
        <!-- /alpha -->
        </div>

        <div id="beta" >
          <div id="beta-inner" >
              <?= $c->render_part("include_script_sidebar_public_timeline.mt") | raw ?>
           <!-- /beta-inner -->
          </div>
        <!-- /beta -->
        </div>

      <!-- /pagebody-inner -->
      </div>

      <!-- /pagebody_footer -->
      <div id="pagebody_footer"></div>
      <!-- /pagebody_footer -->

    <!-- /pagebody -->
    </div>
    
    
  <!-- /container-inner -->
  </div>

        <?= $c->render_part("include_footer.mt") | raw ?>

<!-- /container -->
</div>
</body>

<script type="text/javascript">

    var withFlash = true;
    if ( navigator.userAgent.match( /iPhone|iPad/g ) ) {
      withFlash = false;
    }

    // preload chirplayer style image
    function preload( imgs ){
      for( var i = 0; i < imgs.length; i++ ){
        var imgObj = new Image();
        imgObj.src = imgs[i];
      }
    }
    preload([ 
      "<?= $c->uri_for("/static/css/bt_play.jpg") ?>", 
      "<?= $c->uri_for("/static/css/bt_stop.jpg") ?>", 
      "<?= $c->uri_for("/static/css/player_parts.jpg") ?>",
      "<?= $c->uri_for("/static/css/loading.gif") ?>"
    ]);

    // soundengine and chirplayers
    var soundengine;
    var players = new Array();

    // onload
    $( function() {

        // ratings
        var default_rating_value = 3;
        $('#form_raty').raty({
            start: default_rating_value,
            onClick: function(score) {
                $('#ratings').attr('value', score);
            },
            path: "<?= $c->uri_for(qw{/static/js/raty/img/}) ?>"
        });
        $('#ratings').val(default_rating_value);

        if ( withFlash ) {
          soundengine = new FlexSoundEngine( $( "#soundengine"), "<?= $c->uri_for("/static/js/chirplayer/flexplayer.swf") ?>" );
        }
        else {
          soundengine = new JSoundEngine( $( "#soundengine"), "<?= $c->uri_for("/static/js/chirplayer/Jplayer.swf") ?>" );
        }

        $( ".chirplayer" ).each( function () { 
          players.push( new ChirPlayer( $( this ), soundengine ) );
        });

        // comment counter
        $("#input-up").keyup(function(){
            var comCounter = $(this).val().length;
            $("#countup").text(comCounter + "characters");

            $("#commentpost > input").show();
            $("#countup-message").hide();
            if (comCounter >= <?= $c->config->{tweet_validate}->{description}->{length} ?>) {
                $("#countup-message").show();
                $("#commentpost > input").hide();
            }
        });

        // コメント初期表示
        $("#input-up").val('\n"<?= $twiitunes_music->itunes_trackname ?> / <?= $twiitunes_music->itunes_artistname ?>" <?= $twiitunes_music->shorten_url ?> <?= $c->config->{tweet_twitter}->{hash_tag} ?>').trigger("keyup");

    });

</script>

</html>
