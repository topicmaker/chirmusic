? my $c = $_[0];
<?
    my $public_timeline_page_row    = $c->is_smartphone()   ? $c->config->{public_timeline}->{top_page_row}->{smartphone}
                                                            : $c->config->{public_timeline}->{top_page_row}->{default};
?>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
 "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
  <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
  <title>chirmusic -Tweet your favorite tracks on iTunes preview.</title>
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
          <p id="public-timeline">public timeline</p>

<script>
    var getTweetTimelineDataURI = "<?= $c->uri_for('/public_timeline_api/get_tweet') ?>";
    var tweetTimelinePageRow    = <?= $public_timeline_page_row ?>;
</script>
<?= $c->render_part("include_script_set_tweet_timeline.mt") | raw ?>

        <div id="ad_space">
        <?= $c->render_part("include_itunes_ad.mt") | raw ?>
        </div>

        <!-- /alpha -->
        </div>
        <div id="beta" >
          <div id="beta-inner" >
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

