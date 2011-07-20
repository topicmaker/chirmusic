? my $c = $_[0];
<?
    my $page_row = $c->is_smartphone() ? $c->config->{search_itunes}->{page_row}->{smartphone}
                                       : $c->config->{search_itunes}->{page_row}->{default};
?>
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
          <div id="alpha-inner">
            
             <p id="resultnum">Search for "<?= $c->req->param('k') ?>"</p>

                <!-- ResultArea -->
                <div id="search-list-area"></div>
                <div id="search-list-error-message-area"></div>
                <div id="link-next-page-area"></div>
                <!-- /ResultArea -->

          <!-- /alpha-inner -->
          </div>
        <!-- /alpha -->
        <div id="ad_space">
        <?= $c->render_part("include_itunes_ad.mt") | raw ?>
        </div>
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

      getiTunesData(1);

    });


    // Tweets Count
    function setTweetCount(link_tweet_css, itunes_trackid) {
        var uri = "<?= $c->uri_for('/tweet_timeline_api/count_tweet') ?>";
        uri = uri + '/' + itunes_trackid;
        $.getJSON(uri, function(json){
            var tweet_count = 0;
            if (json[0] >= 1) {
                tweet_count = json[0];
            }
            var tweet;
            if ( tweet_count > 1 ) {
              tweet = "tweets";
            }
            else {
              tweet = "tweet";
            }
            $("."+link_tweet_css).text(tweet_count + " " + tweet );
        });
    }


    // iTunes Data
    function getiTunesData(page) {
        $("#link-next-page-area").html("").createAppend(
            'img',{src:'<?= $c->uri_for("/static/img/loading.gif") ?>', alt:'loading'},[]
        );

        $.searchMusicTrackByTerm({
            params      : {
                country     : "<?= $c->is_lang_jp() ?>",
                term        : "<?= $c->req->param('k') | raw ?>",
            },
            page        : page,
            page_row    : <?= $page_row ?>,
            callback    : function(json) {
                if (json.length <= 0) {
                    // 検索結果ナシ
                    $('#search-list-error-message-area').createAppend(
                        'div',{ id: 'search-list-error-message' },'There were not the search results.'
                    );
                }
                else {
                    setiTunesData(json);
                }

                // 次のページボタン
                $("#link-next-page-area").html("");
                if (json.length >= <?= $page_row ?>) {
                    $("#link-next-page-area").createAppend(
                        'a',{ id: 'link-next-page', href: "javascript:getiTunesData(" + (++page) + ")" },'view more.'
                    );
                }
            }
        });

    }

    function setiTunesData(json) {
        for(var i = 0; i < json.length; i++){
            var jplayer_cssid       = 'jplayerId-' + json[i].trackId + '-' + i;
            var link_tweet_css      = 'link-tweet-cssid-' + json[i].trackId + '-' + i;

            $('#search-list-area').createAppend(
                'div', {id:'ResultArea'}, [
                    'div', {id:'ResultArea-contents', 'class':'clearfix'}, [
                        'div', {id:'musicImg'}, [
                            'p',{'class':'cover'},[
                                'img',{src: json[i].artworkUrl30, width:30, height:30, alt:''},''
                            ]
                        ],
                        
                        'div', {id:'musicData'}, [
                            'ul',,[
                                'li',{id:'artist'},json[i].artistName,
                                'li',{id:'track'},json[i].trackName,
                                'li',{id:'album'},json[i].collectionName
                            ],
                            'p',,[
                                'a',{href:'<?= $c->uri_for("/tweet_create/form/") ?>' + json[i].trackId},[
                                    'img',{src: '<?= $c->uri_for("/static/img/bt_tweet_small.jpg") ?>', width:79, height:19, alt:'tweetButton'},''
                                ],
                                'a',{'class':link_tweet_css + ' tweets', href:'<?= $c->uri_for("/tweet_timeline/view/") ?>' + json[i].trackId}, '0 tweets'
                            ]
                        ],
                        'div', { 'class': 'chirplayer-lite' }, [
                            'a', { 'class': 'track', href: json[i].previewUrl }, 'Track',
                            'a', { 'class': 'play', href: 'javascript:void(0)' }, [
                              'span', { 'class': 'alt' }, 'span'
                            ]
                        ]
                    ]
                ]
            );
            $("body").append('<script>setTweetCount("'+ link_tweet_css +'", "'+ json[i].trackId +'");</scri' + 'pt>');

        }

        $( ".chirplayer-lite" ).not( ".constracted" ).each( function () { 
          players.push( new ChirPlayerLite( $( this ), soundengine ) );
        });

    }

</script>

</body>
</html>
