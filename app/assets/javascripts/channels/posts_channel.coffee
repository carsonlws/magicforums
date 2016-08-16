postsChannelFunctions = () ->

  checkMe = (comment_id, username) ->
    unless $('meta[name=wizardwonka]').length > 0 || $("meta[user=#{username}]").length > 0
      $(".comment[data-id=#{comment_id}] .control-panel").remove()
    $(".comment[data-id=#{comment_id}]").removeClass("hidden")

  createComment = (data) ->
    if $('.comments.index').data().id == data.post.id && $(".comment[data-id=#{data.comment.id}]").length < 1
      $('#comments').append(data.partial)
      checkMe(data.comment.id)
      if document.hidden
        notification = new Notification data.post.title, body: data.comment.body, icon: data.post.image.thumb.url

        notification.onclick = () ->
          window.focus()
          this.close()

  updateComment = (data) ->
    if $('.comments.index').data().id == data.post.id
      $(".comment[data-id=#{data.comment.id}]").after(data.partial).remove();
      checkMe(data.comment.id)

  destroyComment = (data) ->
    if $('.comments.index').data().id == data.post.id
      $(".comment[data-id=#{data.comment.id}]").remove();


  if $('.comments.index').length > 0
    App.posts_channel = App.cable.subscriptions.create {
      channel: "PostsChannel"
    },
    connected: () ->
      console.log("I'm loaded")

    disconnected: () ->


    received: (data) ->
      switch data.type
        when "create" then createComment(data)
        when "update" then updateComment(data)
        when "destroy" then destroyComment(data)

 $(document).on 'turbolinks:load', postsChannelFunctions
