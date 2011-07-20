? my $c = $_[0];    #　
<?
    my $public_timeline_page_row    = $c->is_smartphone()   ? $c->config->{public_timeline}->{sidebar_page_row}->{smartphone}
                                                            : $c->config->{public_timeline}->{sidebar_page_row}->{default};
?>
<div id="tw_wrapper-side"></div>
<script>
    var public_timeline_page_row = <?= $public_timeline_page_row ?>;
    var public_top_twiitunes_tweet_id;

    // ready
    $(function() {
        public_top_twiitunes_tweet_id = 0;
        getPublicTimelineData();
    });

    // reload timer 
    $.timer(30 * 1000, function (timer) {
        getPublicTimelineData();
    });

    // PublicTimeline Data
    function getPublicTimelineData() {
        var uri = "<?= $c->uri_for('/public_timeline_api/get_new_tweet') ?>";
        uri = uri + '/' + public_top_twiitunes_tweet_id + '/' + public_timeline_page_row;
        $.getJSON(uri, function(json){
            if (json.length >= 1) {
                public_top_twiitunes_tweet_id = json[0].id;
                $('#tw_wrapper-side').hide();
                $('#tw_wrapper-side').html("");
                setPublicTimelineData(json);
                $('#tw_wrapper-side').fadeIn("slow");
            }
        });
    }

    function setPublicTimelineData(json) {
        for(var i = 0; i < json.length; i++){
            $('#tw_wrapper-side').createAppend(
                'div', {id:'tw_area'}, [
                    'div',{id:'tw_img'},[
                        'img',{src:json[i].twiitunes_account.twitter_profile_image_url, alt:'user icon'},[]
                    ],
                    'div',{id:'tw_tweet'},[
                        'div',{'class':'triangle-border left'},[
                            'a', {href:'<?= $c->uri_for("/tweet_timeline/view/") ?>' + json[i].twiitunes_music.itunes_trackid}, json[i].short_description + " ... read more"
                        ,
                        'p',,[
                            'a', {href: '<?= $c->config->{twitter_uri} ?>' + json[i].twiitunes_account.twitter_screen_name}, json[i].twiitunes_account.twitter_screen_name
                        ]
                        ]
                    ]
                ]
            );
        }
    }

</script>
