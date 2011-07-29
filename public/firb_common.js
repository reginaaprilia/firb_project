function reposition_notes(id) {
    var b = $('#'+id),
        t = b.find('div.widgetContent div.transcription_text'),
        n = b.find('div.widgetContent div.transcription_notes_content'),
        maxH=0,
        t_top = t.offset().top;
    
    $('#'+id+' div.transcription_notes_content div.note').each(function(i, e){
        var note_id = $(e).attr('id'),
            my_class = note_id.substr(5),
            top = $('#'+id+' .'+my_class+':first').offset().top;
        $(this).offset({top: top});
        if (top+$(this).height()-t_top > maxH)
            maxH = top + $(this).height() - t_top;
    });

    // Set the notes column height to max between the calculated height
    // of the heighest note, and the transcription box height
    n.height(Math.max(t.height(), maxH));

} // reposition_notes

function getFlashObject(movieName) {
    if (navigator.appName.indexOf("Microsoft") != -1) {
        return window[movieName];
    } else {
        var obj = document[movieName];
        if (obj.length != 'undefined') {
            for(var i=0;i<obj.length;i++) { 
                if(obj[i].tagName.toLowerCase() == 'embed') return obj[i]; 
            }
        }
        return obj;
    }
}

// Initialization: IMT will call this when it's ready to load an image
function jsapi_initializeIMW(id) {
    var new_b64;
    if (navigator.appName.indexOf("Microsoft") != -1) 
        new_b64 = $("#"+id).attr('b64');
    else 
        new_b64 = $('#'+id+" embed").attr('b64');

    // Mode=2: the zones have an hierarchi, IMT will zoom the view
    // to the root zone
    getFlashObject(id).initialize(new_b64, 2);
} // jsapi_initializeIMW()

function jsapi_mouseOver(fid, ki) {	
    $("#image_zone_"+ki).toggleClass('highlighted');
}

function jsapi_mouseOut(fid, ki) {
    $("#image_zone_"+ki).toggleClass('highlighted');
}

function jsapi_mouseClick(fid, ki) {}


function init_firb_common(theme) {

    // Sets boxview's height to match the height of the page.
    $('#pageContent').height(($(window).height() - $('#pageHeader').height() - 1));
    $(window).resize(function(){
        $('#pageContent').height(($(window).height() - $('#pageHeader').height() - 1));
    });

    // History box
    $("#pref_history").click(function(e){
        e.preventDefault();
        myBoxView.openHistoryBox();
    });

    // Open intro automatically
    $("#pref_intro").click();

    // Phen item: highlight the selected item
    $('div.fen_menu_panel li.phen_item').live('click', function() {
        var c = $(this).attr('about'),
            b = $(this).parents('div.box'),
            h = $(this).hasClass('highlighted');
            
        // Close the menu panel
        b.find('div.fen_menu_panel').toggleClass('hidden');

        // TODO: if the parent section is highlighted, deselect all
        // and force the selection of this content again
        b.find('span.highlighted, li.highlighted, span.'+c).toggleClass('highlighted');
        if (!h)
            $(this).addClass('highlighted');
    });
    
    // Phen section: highlight all the items of this category
    $('div.fen_menu_panel li.phen_section').live('click', function() {
        var c = $(this).attr('about'),
            b = $(this).parents('div.box'),
            h = $(this).hasClass('highlighted');
        
        // Close the menu panel
        b.find('div.fen_menu_panel').toggleClass('hidden');

        // Remove all the highlights
        b.find('span.highlighted, li.highlighted').removeClass('highlighted');

        if (!h) {
            b.find('span.'+c).addClass('highlighted');
            $(this).addClass('highlighted');
            // Highlights this section and the subsections
            $(this).next().find('li.phen_item').addClass('highlighted');
        }

    });
    
    // Expands an image
    $('.transcription_image_icon, .transcription_letter_icon').live('click', function() {
        $(this).next().removeClass('hidden');
        $(this).addClass('hidden');
        reposition_notes($(this).parents('div.box').attr('id'));
    });
    // Collapses an image
    $('.transcription_close_icon, .transcription_letter_icon').live('click', function() {
        $(this).parent().addClass('hidden');
        $(this).parent().prev().removeClass('hidden');
        reposition_notes($(this).parents('div.box').attr('id'));
    });

} // init_firb_common