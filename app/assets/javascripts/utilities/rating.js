$(document).on('turbolinks:load', function() {
    $('.vote').bind('ajax:success', function(e) {
        var data = e.detail.data;
        var status = e.detail.status;
        var xhr = e.detail.xhr;
        var parentClass = ".rating_" + data.klass + "_" + data.id;
        afterVote(parentClass, data.rating);
    });
    function afterVote(parent, rating) {
        $(parent + ' span').html(rating);
        $(parent + ' .vote-reset').toggle();
        $(parent + ' .vote-up').toggle();
        $(parent + ' .vote-down').toggle();
    }
});