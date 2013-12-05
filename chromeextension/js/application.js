$("#homenav").click(function() {
  $(".homepage").show();
  $(".querypage").hide();
  $(".parsepage").hide();
  $.ajax({
                    type: "GET",
                    url: "http://localhost:3000/posts.json",
                    dataType: 'json',                 
                    cache: true,
                    success: function(response) {
                      var result = JSON.stringify(response,null,4);
                      $('.dagrlist').html(result);
                        //$(this).html(response);
                    }
                });
});

$("#querynav").click(function() {
  $(".homepage").hide();
  $(".querypage").show();
  $(".parsepage").hide();
});

$("#parsenav").click(function() {
  $(".homepage").hide();
  $(".querypage").hide();
  $(".parsepage").show();
});


$('#queryselectall').click(function() {

});

$('#parsecurrentpagebutton').click(function () {
        var btn = $(this);
        btn.button('loading');
        chrome.tabs.query({
    active: true
}, function(tabs) {
    var link = tabs[0].url;
    $.ajax({
          type: 'GET', 
          url: 'test.html',
          dataType: 'html',
          success: function(data) {

            //cross platform xml object creation from w3schools
            try //Internet Explorer
              {
              xmlDoc=new ActiveXObject("Microsoft.XMLDOM");
              xmlDoc.async="false";
              xmlDoc.loadXML(data);
              }
            catch(e)
              {
              try // Firefox, Mozilla, Opera, etc.
                {
                parser=new DOMParser();
                xmlDoc=parser.parseFromString(data,"text/html");
                }
              catch(e)
                {
                alert(e.message);
                return;
                }
              }
              images = xmlDoc.images;
              for (var i = 0; i < images.length; i++){
                alert(images[i].src);
              }
          }
    });
});
        setTimeout(function () {
            btn.button('reset');
        }, 3000);
    });