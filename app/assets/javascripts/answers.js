$(document).on('turbolinks:load', function() {
    $('.edit-answer-link').click(function(e) {
        e.preventDefault();
        $(this).hide();
        answerId = $(this).data('answerId');
        $('form#edit-answer-' + answerId).show();
    });
});