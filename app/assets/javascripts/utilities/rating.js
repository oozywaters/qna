$(document).on('turbolinks:load', function() {
    $('.vote').bind('ajax:success', function(e) {
        var [data, status, xhr] = e.detail;
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