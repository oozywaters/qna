$(document).on('turbolinks:load', function() {
    $('.edit-question-link').click(function(e) {
        e.preventDefault();
        $(this).hide();
        const questionId = $(this).data('questionId');
        $('#edit-question-form' + questionId).show();
    });
});
