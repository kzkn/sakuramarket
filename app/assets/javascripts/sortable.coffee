$(document).on "turbolinks:load", ->
  $(".sortable").sortable
    axis: 'y'
    items: '.item'
    update: (e, ui) ->
      item = ui.item
      itemdata = item.data()
      params = { _method: 'put' }
      params[itemdata.model] = { position: item.index() + 1 }
      $.ajax
        type: 'put'
        url: itemdata.url
        data: params
      .fail ->
        alert("順序の変更時にエラーが発生しました。")
        location.reload()
