? my $c = $_[0];
<?
    my $your_tweet_page_row     = $c->is_smartphone()   ? $c->config->{your_tweet}->{page_row}->{smartphone}
                                                        : $c->config->{your_tweet}->{page_row}->{default};
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

          <!-- TweetArea -->
          <p id="whos-tweet"><a href="<?= $c->config->{twitter_uri} ?><?= $c->user->twitter_screen_name | uri ?>"><?= $c->user->twitter_screen_name ?></a>'s all tweets</p>

<script>
    var getTweetTimelineDataURI = "<?= $c->uri_for('/your_tweet_api/get_tweet') ?>";
    var tweetTimelinePageRow    = <?= $your_tweet_page_row ?>;
</script>
<?= $c->render_part("include_script_set_tweet_timeline.mt") | raw ?>
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
</html>

