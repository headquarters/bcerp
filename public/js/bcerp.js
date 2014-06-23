$(document).foundation({
    accordion: {
        multi_expand: true    
    }
});

//http://foundation.zurb.com/forum/posts/629-sticky-footer
/*$(window).on("load, resize", function () {
    var footer = $("footer");
    var pos = footer.position();
    var height = $(window).height();
    height = height - pos.top;
    height = height - footer.height();
    if (height > 0) {
        footer.css({
            'margin-top': height + 'px'
        });
    }
});*/

var timeout;

$('#age').on('change', function(){
    timeout = null;
    var $this = $(this);
    var value = $this.val();
    
    if (value > 45) {
        $('#age-message').html('<p><span class="high">High Risk:</span> Women over the age of 45 are at higher risk for breast cancer.\
                        The median age for breast cancer diagnosis is 62.</p>');
    
    
    } else {
        $('#age-message').html('<p><span class="low">Low Risk:</span> Older women are at higher risk for breast cancer, but <strong>breast cancer affects women of all ages</strong>.\
                        The median age for breast cancer diagnosis is 62.</p>');
    }
    $('#age-message').css('background', '#FFFF6B');
    
    /*timeout = setTimeout(function(){
     $('#age-message').css('background', 'transparent');
    }, 2000);*/
    $('#age-message').stop().animate({
         backgroundColor: "transparent"
    }, 1500 );
});

$('#race-ethnicity input').on('change', function(){
    timeout = null;
    var $this = $(this);
    var value = $this.val();
    
    if (value == "Black") {
        $('#race-message').html('<p><em>All races and ethnicities are susceptible to breast cancer, but some forms are more common among African Americans.<em></p>');
    } else {
        $('#race-message').empty();
    }
    $('#race-message').css('background', '#FFFF6B');
    
    /*timeout = setTimeout(function(){
     $('#age-message').css('background', 'transparent');
    }, 2000);*/
    $('#race-message').stop().animate({
         backgroundColor: "transparent"
    }, 1500 );  
});

$('input[name="first_child"]').on('change', function(){
    timeout = null;
    var $this = $(this);
    var value = $this.val();
    
    if (value == "No children" || value == "35 or older") {
        $('#children-message').html('<p><span class="high">High Risk:</span> Having no children or having your first child after 35 increases lifetime exposure to estrogen, which is associated with risk of breast cancer.</p>');
    } else {
        $('#children-message').html('<p><span class="low">Low Risk:</span> Having children before 35 decreases lifetime exposure to estrogen, which is associated with risk of breast cancer.</p>');
    }
    $('#children-message').css('background', '#FFFF6B');
    
    /*timeout = setTimeout(function(){
     $('#age-message').css('background', 'transparent');
    }, 2000);*/
    $('#children-message').stop().animate({
         backgroundColor: "transparent"
    }, 1500 );    
});

if ($('html').hasClass('no-touch')) {
    $('click-or-tap').text('Click');
} else {
    $('click-or-tap').text('Tap');
}