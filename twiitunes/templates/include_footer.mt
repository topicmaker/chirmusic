? my $c = $_[0];

<div id="footer">
    <div id="footer-inner" class="clearfix">
        <div id="copy">&copy;<a href="http://www.topicmaker.com/">Topic Maker</a></div>
        <div id="contact"><span>Contact us</span>:<a href="http://twitter.com/chirmusic">@chirmusic</a></div>

  <? if ($c->is_smartphone) { ?>
    </div>
    <div id="footer-inner">
  <? } ?>
        
        <div id="power">powered by <a href="http://www.apple.com/jp/itunes/">iTunes</a> API, <a href="http://twitter.com/">Twitter</a> API</div>
    
    <!-- /footer-inner -->
    </div>
<!-- /footer -->
</div>
<? if (!$c->is_smartphone) { ?>
<!-- twitter follow badge by go2web20 -->
<script src='http://www.go2web20.net/twitterfollowbadge/1.0/badge.js' type='text/javascript'></script><script type='text/javascript' charset='utf-8'><!--
tfb.account = 'chirmusic';
tfb.label = 'follow-me';
tfb.color = '#959595';
tfb.side = 'r';
tfb.top = 136;
tfb.showbadge();
--></script>
<!-- end of twitter follow badge -->
<? } ?>
