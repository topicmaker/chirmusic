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
        <div id="alpha">
          <div id="top-help" class="clearfix">
          <br>
          <h1><span>Use chirmusic to play and tweet that  song you just can't get out of your head! </span></h1>

          <div id="step-wrap" class="clearfix">
          <div id="step1">
          <h2><span>serch&play from iTunes preview</span></h2>
          </div>
          <div id="step2">
          <h2><span>tweet through chirmusic</span></h2>
          </div>
          <div id="step3">
          <h2><span>share with your followers</span></h2>
          </div>
          </div>
          

          <!-- 検索 -->
          <form id="searcharea" action="<?= $c->uri_for('/search/list') ?>" method="get">
            <p>
              <input type="text" name="k" value="<?= $c->req->param('k') || '' ?>" id="main_field_id">
              <label for="main_field_id" id="main_field_label">Search a track or an artist</label><br />
              <input type="image" src="<?= $c->uri_for('/static/img/bt_search_tweet.png') ?>" width="148" height="32" alt="search">
            </p>
          </form>
          <!-- /検索 -->
          
<? if (!$c->is_smartphone) { ?>
          
<? } ?>

          <? if ($c->is_smartphone) { ?>

          <? } ?>

          
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

