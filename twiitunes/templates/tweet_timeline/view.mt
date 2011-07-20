? my $c = $_[0];
? my $twiitunes_music = $c->stash->{twiitunes_music};
<?
    my $tweet_timeline_page_row     = $c->is_smartphone()   ? $c->config->{tweet_timeline}->{page_row}->{smartphone}
                                                            : $c->config->{tweet_timeline}->{page_row}->{default};
?>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
 "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
  <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
  <title><?= $twiitunes_music->itunes_trackname ?> / <?= $twiitunes_music->itunes_artistname ?> : chirmusic -Tweet your favorite tracks on iTunes preview.</title>
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

                        <a id="tweet_button" href="<?= $c->uri_for('/tweet_create/form/',$twiitunes_music->itunes_trackid) ?>"><img src="<?= $c->uri_for('/static/img/bt_tweet_b.jpg') ?>" width="104" height="25" alt="tweetButton"></a>

                    </div>
                </div>

              <!-- /TrackArea -->

              <!-- TweetArea -->
              <div id="tw_wrapper"></div>
              <div id="link-next-page-area"></div>

              <!-- TweetArea -->
        <div id="ad_space">
        <?= $c->render_part("include_itunes_ad.mt") | raw ?>
        </div>
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

        if ( withFlash ) {
          soundengine = new FlexSoundEngine( $( "#soundengine"), "<?= $c->uri_for("/static/js/chirplayer/flexplayer.swf") ?>" );
        }
        else {
          soundengine = new JSoundEngine( $( "#soundengine"), "<?= $c->uri_for("/static/js/chirplayer/Jplayer.swf") ?>" );
        }

        $( ".chirplayer" ).each( function () { 
          players.push( new ChirPlayer( $( this ), soundengine ) );
        });

        getTweetTimelineData(0);

    });

    // TweetTimeline Data
    function getTweetTimelineData(last_twiitunes_tweet_id) {
        var uri = "<?= $c->uri_for('/tweet_timeline_api/get_tweet') ?>";
        uri = uri + '/' + <?= $twiitunes_music->id ?> + '/' + last_twiitunes_tweet_id + '/' + <?= $tweet_timeline_page_row ?>;
        $.getJSON(uri, function(json){
            $("#link-next-page-area").html("");
            if (json.length >= 1) {
                setTweetTimelineData(json);

                // 次のページボタン
                if (json.length >= <?= $tweet_timeline_page_row ?>) {
                    $("#link-next-page-area").createAppend(
                        'a',{ id: 'link-next-page', href: "javascript:getTweetTimelineData(" + (json[(json.length-1)].id) + ")" },'view more.'
                    );
                }
            }
        });
    }

    function setTweetTimelineData(json) {
        for(var i = 0; i < json.length; i++){
            var rating_tag_id = 'tw-rating-' + json[i].id + '-' + i;

            $('#alpha > #tw_wrapper').createAppend(
                'div', {id:'tw_area'}, [
                    'div',{id:'tw_img'},[
                        'img',{src:json[i].twiitunes_account.twitter_profile_image_url, alt:'user icon'},[]
                    ],
                    'div',{id:'tw_tweet'},[
                        'div',{id:'trackbubble', 'class':'triangle-border left'}, [
                            'p',{},json[i].description,
                            'span',{id:'date'}, '('+json[i].created_on.replace(/\..*$/,"")+')',
                            'div',{'class':'clearfix'},[
                                'div',{id:'star'}, [
                                'div',{id:rating_tag_id}, ''
                                ],
                                'p',,[
                                    'a', {href: '<?= $c->config->{twitter_uri} ?>' + json[i].twiitunes_account.twitter_screen_name}, json[i].twiitunes_account.twitter_screen_name
                                ]
                            ]
                        ]
                    ]
                ]
            );
            $("body").append('<script>$("#'+rating_tag_id+'").raty({ readOnly:  true, start: '+json[i].ratings+', path: "<?= $c->uri_for(qw{/static/js/raty/img/}) ?>" });</scri' + 'pt>');
        }
    }

</script>

</html>

