  $(document).ready(_ => {
    $('[data-which-form="attribution"] > form').on('ajax:success', event => {
      parentDiv = $(event.currentTarget).parent();
      attributionTag = $('#attribution_' + parentDiv.data('image-id'));
      parentDiv.collapse('hide');
      attributionTag.html(event.detail[0]);
    });
  })
