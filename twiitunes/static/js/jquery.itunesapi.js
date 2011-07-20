/**
 * jQuery Plugin iTunesAPI v1.0
 *
 * @author t-suzuki
 *
*/

/** description **

    $.searchMusicTrackByTerm({
        params    : {
            country     : "JP",                 // "JP":日本, "":米国
            term        : "Michael Jackson",    // 検索キーワード
        },
        page        : 1,    //ページ数
        page_row    : 20,   //表示行数
        callback    : function(json) {
            // your function
        }
    });

*/


jQuery.searchMusicTrackByTerm = function(args) {
    var uri             = "http://ax.itunes.apple.com/WebObjects/MZStoreServices.woa/wa/wsSearch?callback=?";
    args.params.entity  = "musicTrack";
    args.params.limit   = args.page * args.page_row;
    $.getJSON(uri, args.params,
        function(json){
            var results = new Array();
            if (json.resultCount >= 1) {
                results = json.results.splice( (args.page-1) * args.page_row, args.page_row );
            }
            args.callback(results);
        }
    );
}

