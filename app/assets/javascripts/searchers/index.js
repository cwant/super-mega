$(document).on('turbolinks:load', function() {
  function update_search() {
    var term = $('#search-term').val();
    $('.search-results').each(function() {
      console.log('www');
      var page = 1;
      var search_url = $(this).data('base-url') + '?term=' + term;
      var $results = $(this)
      console.log($results);
      $results.html('');
      var hits = ''
      $.getJSON(search_url).done(function(data) {
        $.each(data.hits, function(idx, hit) {
          hits += '<li>' + hit.text + '</li>';
        });
        $results.html(hits);
      });
    });
  }

  $('#search-submit').on('click', function() {
    update_search();
  });

});
