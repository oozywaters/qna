$(document).on('turbolinks:load', function() {
    const questionId = $('.question').data('id');
    App.cable.subscriptions.create('CommentsChannel', {
        connected: function() {
            this.perform('follow', {
                id: questionId
            });
        },
        received: function(data) {
            if (data.comment.user_id !== gon.user_id) {
                const parentClass = $(".comment_" + data.comment.commentable_type + "_" + data.comment.commentable_id);
                $(parentClass).prepend(JST["templates/comment"](data));
            }
        }
    });
});