$(document).on('turbolinks:load', function() {

  function clone(original) {
    var dup = {}
    for (var key in original) {
      dup[key] = original[key];
    }
    return dup;
  }

  state = {
    'term': undefined,
    'tab': undefined,
    'page': undefined
  }
  last_state = clone(state);

  function update_search() {
    var params = new URLSearchParams(window.location.search);
    var query_string_changes = {};

    state['term'] = $('#search-term').val();
    if (!state['term']) {
      // Search term in form empty, get from query string
      state['term'] = params.get('term');
      // Update search form term
      $('#search-term').val(state['term']);
    }

    state['page'] = params.get('page');
    if (!state['page']) {
      state['page'] = 1;
    }

    if ((state['term'] != last_state['term']) ||
        (state['page'] != last_state['page'])) {

      $('.search-results').each(function() {
        var results = $(this);
        if (state['term']) {
          var search_url = $(this).data('base-url') + '?term=' + state['term'] +
              '&page=' + state['page'];
          var hits = ''
          $.getJSON(search_url).done(function(data) {
            results.html(data.html);
          });
        }
        else {
          results.html('');
        }
      });
    }

    last_state = clone(state);
  }

  function update_query_string() {
    // Update query string for current state
    // TODO: investigate visual state on back button (e.g., showing correct tab)
    var params = new URLSearchParams(window.location.search);
    for (var key in state) {
      item = state[key];
      if (item) {
        params.set(key, state[key]);
      }
      else {
        params.delete(key);
      }
    }
    if (params.get('page') == 1) {
      params.delete('page');
    }
    var href = window.location.pathname + '?' + params.toString();
    window.history.pushState(state, '', href);
  }

  function update_tab() {
    state['tab'] = $('#source-select a.active').data('tab');
    last_state = clone(state);
  }

  $('#search-submit').on('click', function() {
    update_search();
    update_query_string();
  });

  $('#source-select a').on('click', function() {
    var tab = $(this).data('tab')
    state['tab'] = tab;
    update_query_string();
  });

  $(document).on("ajax:success", 'a.page-link',
                          function(event) {
    var data = event.detail[0];
    var results = $(this).closest('.search-results');
    results.html(data.html);

    var href = $(this).attr('href');
    var query_string = href.substring(href.indexOf('?') + 1);
    var params = new URLSearchParams(query_string);
    var page = params.get('page') || 1;
    state['page'] = page;
    update_query_string();
  });

  update_tab();
  update_search();

});
