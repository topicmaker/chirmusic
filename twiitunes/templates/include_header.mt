? my $c = $_[0];
  <? if (!$c->is_smartphone) { ?>
        <div id="head-left" class="clearfix">
          <h1><a href="<?= $c->uri_for('/') ?>"><img src="<?= $c->uri_for('/static/img/chirmusic.png') ?>" width="258" height="51" alt="chirmusic"></a></h1>
        </div>
        <div id="head-right">
          <!-- ナビ -->
          <div id="global-navi" class="clearfix">
              <ul>
  <? } ?>

  <? if ($c->is_smartphone) { ?>
              <ul id="user_id">
  <? } ?>

<? if ( $c->user ) { ?>

                <li id="nocont"><a href="<?= $c->uri_for('/logout') ?>"><?= $c->user->twitter_screen_name ?><img id="twitter-icon-s" src="<?= $c->user->twitter_profile_image_url ?>" width="16" height="16" alt="id"> Sign out</a></li>

  <? if (!$c->is_smartphone) { ?>
                <li><a href="<?= $c->uri_for('/your_tweet/') ?>">your tweets</a></li>
  <? } ?>


<? } else { ?>
                <li id="nocont"><a href="<?= $c->uri_for('/login') ?>">Click here to login or create an account <img id="twitter-icon-s" src="<?= $c->uri_for('/static/img/icon_twitter.jpg') ?>" width="16" height="16" alt="id"> Sign in with Twitter</a></li>
    <? if ( !$c->config->{product_mode} ) { ?>
                <!-- 本番サーバでは表示されません -->
                <li><a href="<?= $c->uri_for('/debug/manual_login') ?>">topicmaker_dev login</a></li>
    <? } ?>
<? } ?>

  <? if (!$c->is_smartphone) { ?>
                
                <li><a href="<?= $c->uri_for('/public_timeline') ?>">public timeline</a></li>
              </ul>
          </div>
          <!-- /ナビ -->
  <? } ?>


  <? if ($c->is_smartphone) { ?>
              </ul>
          <h1><a href="<?= $c->uri_for('/') ?>"><img src="<?= $c->uri_for('/static/img/chirmusic.png') ?>" width="258" height="51" alt="chirmusic"></a></h1>
  <? } ?>







          <!-- 検索 -->
          <form id="searcharea" action="<?= $c->uri_for('/search/list') ?>" method="get">
            <p>
              <input type="text" name="k" value="<?= $c->req->param('k') || '' ?>" id="field_id">
              <label for="field_id">Search a track or an artist</label><br />
              <input type="image" src="<?= $c->uri_for('/static/img/bt_search_tweet.png') ?>" width="148" height="32" alt="search">
            </p>
          </form>
        <!-- /検索 -->



  <? if ($c->is_smartphone) { ?>
          <!-- ナビ -->
          <ul id="global_navi">
                <? if ( $c->user ) { ?>
                <li><a href="<?= $c->uri_for('/your_tweet/') ?>">your tweets</a></li>
                <? } ?>
                <li><a href="<?= $c->uri_for('/public_timeline') ?>">public timeline</a></li>
          </ul>
          <!-- /ナビ -->
  <? } ?>





<script type="text/javascript" charset="utf-8"> 
    $(function(){ 
        $("label").inFieldLabels(); 
        $("input").attr("autocomplete","off");
    });
</script>
