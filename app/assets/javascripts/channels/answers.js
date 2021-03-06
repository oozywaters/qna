$(document).on('turbolinks:load', function() {
    var questionId = $('.question').data('id');
    App.cable.subscriptions.create('AnswersChannel', {
        connected: function() {
            this.perform('follow', {
                id: questionId
            });
        },
        received: function(data) {
            if (data.answer.user_id !== gon.user_id) {
                $('.answers').prepend(JST["templates/answer"](data));
                voteBind();
            }
        }
    });
});