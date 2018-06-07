$(document).on('turbolinks:load', function() {
    App.cable.subscriptions.create('QuestionsChannel', {
        connected: function() {
            this.perform('follow');
        },
        received: function(data) {
            $('.questions-index').append(JST["templates/question"](data));
        }
    });
});