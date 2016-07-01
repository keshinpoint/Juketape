



$(document).ready(function () {

    var fbKey = 'CAAN8jaC1kPQBAF0hoyJ4CZAGDCjUtbHjNSPBsgxS3yJffK0eRyRaDXh44xn2LdwEgyiewnBIqHBbrmVE2MrZB2NJk6kGNa40T3MP3FMZB3ZCgoyqPiktqAOQzW8unolN4YhhTmeJTcO20Q9QntaMV5ppZCZAKXjqmt6mVVoT8P8R2yhoo30I0B2jfTxAXLWyMZD';
    $.getJSON('https://graph.facebook.com/CollegeHumor?access_token=' + fbKey + '&fields=videos.summary(true),likes', function (fbResult) {

        $('.likes').html(fbResult.likes);
        $('.videos').html(fbResult.videos.summary.total_count);


        $('.social-icons').on('mouseenter', function () {
            $('.social-icons').css({ "color": "white" });
        });


        $('.fb-icon').on('click', function () {
            $("#youtube-row").children().hide();
            event.stopPropagation();
            event.preventDefault();
            $('.fb-icon').css({ "color": "white" }); //this is because the font awesome anchored fb icon gets dark blue when clicked, so we override that to show white
            $.each(fbResult.videos.data, function (index, elem) {

                $('<div class="col-md-3" id="vids-border"> </div>').append(
                '<div class="callwithPad col-md-12"> <a target="_blank" href="https://facebook.com/' + elem.id + ' ">' +
                '<img src="https://graph.facebook.com/' + elem.id + '/picture" class="vid-thumbnail" />' + '</a>' +
                //'<div class="anchor-image"> <i class= "fa fa-play-circle"> </i> </div>' +

                '<div> Vid-Name </div>' +    //+vid_name+
               '<div class ="vid-details" > <span class="vid-date"> Vid-Date </span>' + /*+elem.updated_time+ */  '<span class="vid-likes"> <i class="fa fa-heart fa"> </i>' + '<span> 200 </span>' + '</span>' + //the last span closes the vid-likes class
                '</div> </div> </br>'
                ).appendTo('#facebook-row');
            });
        });

    });

});

$(document).ready(function () {
    $('.social-icons').on('mousenter', function () {


    });

});


$(document).ready(function () {
   
    var youtubeKey = 'AIzaSyCC98JB5KKlN3FWVO72Er9gtdOOws0ZTec';

    $.getJSON('https://www.googleapis.com/youtube/v3/channels?part=contentDetails%2Cstatistics&id=UCPDXXXJj9nax0fr0Wfc048g&maxResults=10&key=' +youtubeKey+ ' ', function (youtubeResult) {
        //the content details and statistics in part give the reqd info, while the id is for college humor's page
        //to get id: https://www.googleapis.com/youtube/v3/channels?part=snippet&forUsername={username}&key={YOUR_API_KEY}
        console.log(youtubeResult.items[0].kind);
        $('.youtube-subs').html(youtubeResult.items[0].statistics.subscriberCount);
        $('.youtube-videos').html(youtubeResult.items[0].statistics.videoCount);
        $('.youtube-views').html(youtubeResult.items[0].statistics.viewCount);
    });

    $('.youtube-icon').on('click', function () {
        console.log('hi');
        $("#facebook-row").children(".col-md-3").hide();
        event.stopPropagation();
        event.preventDefault();

        $.getJSON('https://www.googleapis.com/youtube/v3/search?order=date&part=snippet&channelId=UCPDXXXJj9nax0fr0Wfc048g&maxResults=25&key=AIzaSyCC98JB5KKlN3FWVO72Er9gtdOOws0ZTec', function (youtubeVids) {
            console.log(youtubeVids);

            $.each(youtubeVids.items, function (index, elem) {
                console.log(index);
                var videoId = elem.id.videoId;
                $('<div class="col-md-3" id="vids-border"> </div>').append(
                '<div class="callwithPad col-md-12"> <a target="_blank" href="https://www.youtube.com/watch?v=' + elem.id.videoId + ' ">' +
                '<img src=" ' + elem.snippet.thumbnails.high.url + ' " class="vid-thumbnail" />' + '</a>' +
                //'<div class="anchor-image"> <i class= "fa fa-play-circle"> </i> </div>' +

                '<div> Vid-Name </div>' +    //+vid_name+
               '<div class ="vid-details" > <span class="vid-date"> Vid-Date </span>' + /*+elem.updated_time+ */  '<span class="vid-likes"> <i class="fa fa-heart fa"> </i>' + '<span id="youtube-likes-count-' + index + ' ">  </span>' + '</span>' + //the last span closes the vid-likes class
           '</div> </div> </br>'
         ).appendTo('#youtube-row');
                console.log(index);

                $.getJSON('https://www.googleapis.com/youtube/v3/videos?part=statistics&id=' + videoId + '&key=AIzaSyCC98JB5KKlN3FWVO72Er9gtdOOws0ZTec', function (videoStat) {
                    console.log(elem.id.videoId);
                    var likes = videoStat.items[0].statistics.likeCount; 
                    console.log(index);
                    //console.log('#youtube-likes-count-' + index + '');
                    $('#youtube-likes-count-' + index).html(likes);


                });

            });


        });

    });

});

SC.initialize({
    /* This is the sample client_id. you should replace this with your own*/
    client_id: "7b1a6316faf479f2859569d9cb903267"
});

$(document).ready(function() {
    var client_id = "7b1a6316faf479f2859569d9cb903267"
    var user_name = "jwagener";
    var limit = 25;
    console.log("test1");
    
    $.getJSON('http://api.soundcloud.com/resolve.json?url=http://soundcloud.com/' +user_name+ '&client_id=' +client_id+ '', function(user) { //this gives us the user id of username
        
        user_id = user.id; //because we didn't use var to declare the variable, it becomes a global variable 
        

        $.getJSON('http://api.soundcloud.com/users/' + user_id + '?client_id=' + client_id + '', function (soundcloudResult) { //gives stats
            $('.soundcloud-subs').html(soundcloudResult.followers_count);
            $('.soundcloud-tracks').html(soundcloudResult.track_count);

        });

        $.getJSON('http://api.soundcloud.com/users/' + user_id + '/tracks?client_id=' + client_id + '&limit=' +limit , function (trackResult) { //gives tracks
         
            $.each(trackResult, function (index, elem) {
                var artwork = elem.artwork_url;

                if (artwork === null) { //lot of these tracks dont have artwork, so we assign the avatur of soundcloud to them
                    artwork = elem.user.avatar_url;
                };

                var artist_permalink = elem.user.permalink; //as to go the track, url is soundcloud.com/username/trackpermalink
                var track_permalink = elem.permalink;
                

               

                $('<div class="col-md-3" id="vids-border"> </div>').append(
                   '<div class="callwithPad col-md-12">' +
                   '<ul class="artist-details">' +
                      '<li class="artist-name" >' +elem.user.permalink+ '</li>' +
                        
                        '<li class="track-name" >' +elem.title+ '</li>' +
                    '</ul>' +
                   '<a target="_blank" href="https://soundcloud.com/' + artist_permalink + '/' + track_permalink + '">' +
                   '<img src =" '+elem.waveform_url+' " class ="soundcloud-thumbnail">' +
                   '<img src =" '+artwork+' " class ="artiste-thumbnail"> </a>' +
                   '<div class="track-details">'+
                   
                    '<span class="track-likes"> <i class="fa fa-heart"> </i>' +elem.favoritings_count+ '</span>' +
                    '<span class="replays"> <i class="fa fa-play"> </i>' + elem.playback_count + '</span>' +
                    '<div> <span class="track-date"> <i class="fa fa-calendar"> </i>' +elem.created_at+ '</span> </div>' +
                    '</div></div></div>'
                     //<span class="vid-date"> Date </span>
                        //<span class="vid-likes"> <i class="fa fa-heart fa"> </i> <span id="soundcloud-likes-count-0"> </span></span>
                    //</div>                  

                    ).appendTo("#soundcloud-row");


            });


   
        });

    
        });
    });


