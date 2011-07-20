? my $c = $_[0];
<div id="tw_wrapper"></div>
<div id="link-next-page-area"></div>
<div id="run-script"></div>
<script>
    // ready
    $(function() {
        getTweetTimelineData(0);
    });

    // TweetTimeline Data
    function getTweetTimelineData(last_twiitunes_tweet_id) {
        $("#link-next-page-area").html("").createAppend(
            'img',{src:'<?= $c->uri_for("/static/img/loading.gif") ?>', alt:'loading'},[]
        );

        var uri = getTweetTimelineDataURI + '/' + last_twiitunes_tweet_id + '/' + tweetTimelinePageRow;
        $.getJSON(uri, function(json){
            $("#link-next-page-area").html("");
            if (json.length >= 1) {
                setTweetTimelineData(json);

                // 次のページボタン
                if (json.length >= tweetTimelinePageRow) {
                    $("#link-next-page-area").createAppend(
                        'a',{ id: 'link-next-page', href: "javascript:getTweetTimelineData(" + (json[(json.length-1)].id) + ")" },'view more.'
                    );
                }
            }
        });
    }

    function setTweetTimelineData(json) {
        for(var i = 0; i < json.length; i++){
            var rating_tag_id   = 'tw-rating-' + json[i].id + '-' + i;
            var tweets_text     = json[i].tweets_count + ((json[i].tweets_count > 1) ? "tweets" : "tweet");
            $('#tw_wrapper').createAppend(
                'div', {id:'tw_area'}, [
                    'div',{id:'tw_img'},[
                        'img',{src:json[i].twiitunes_account.twitter_profile_image_url, alt:'user icon'},[]
                    ],
                    'div',{id:'tw_tweet'},[
                        'div',{id:'trackbubble','class':'triangle-border left'},[
                            'ul',{'class':'clearfix'},[
                                'li',{'id':'track'},[
                                    'a',{href:'<?= $c->uri_for("/tweet_timeline/view/") ?>' + json[i].twiitunes_music.itunes_trackid}, json[i].twiitunes_music.itunes_trackname,
                                    'span',{id:'tweets'},[
                                        'a',{href:'<?= $c->uri_for("/tweet_timeline/view/") ?>' + json[i].twiitunes_music.itunes_trackid}, tweets_text
                                    ]
                                ]
                            ],
                            'p',{id:'comment'},json[i].description + '<span id="date">('+json[i].created_on.replace(/\..*$/,"")+')</span>',
                            'div',{'class':'clearfix'},[
                                'div',{id:'public-star'},[
                                    'div',{id:rating_tag_id, 'class':'fixed'}, '',
                                    
                                ],
                                'p',{id:'public-tweet-i'},[
                                'a', {href: '<?= $c->config->{twitter_uri} ?>' + json[i].twiitunes_account.twitter_screen_name}, json[i].twiitunes_account.twitter_screen_name
                            ]
                            ]
                        ]
                    ]
                ]
            );
            $("#run-script").append('<script>$("#'+rating_tag_id+'").raty({ readOnly:  true, start: '+json[i].ratings+', path: "<?= $c->uri_for(qw{/static/js/raty/img/}) ?>" });</scri' + 'pt>');
            $("#run-script").empty();
        }
    }
</script>
