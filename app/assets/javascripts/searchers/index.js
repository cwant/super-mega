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
    'page': undefined,
    'tab_pages': {}
  }
  last_state = clone(state);

  function update_search(reset_page) {
    reset_page = reset_page || false;
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
    if (!state['page'] || reset_page) {
      state['page'] = 1;
    }

    console.log(state['page'])
    if ((state['term'] != last_state['term']) ||
        (state['page'] != last_state['page'])) {

      $('.search-results').each(function() {
        var results = $(this);
        var label = $('#' + results.data('tab-id'));
        if (state['term']) {
          var search_url = $(this).data('base-url') + '?term=' + state['term'] +
              '&page=' + state['page'];
          var hits = ''
          $.getJSON(search_url).done(function(data) {
            results.html(data.results_html);
            label.html(data.tab_label_html);
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
      if (key == 'tab_pages') {
        continue;
      }
      item = state[key];
      if (item) {
        params.set(key, state[key]);
      }
      else {
        params.delete(key);
      }
    }
    if (state['tab'] in state['tab_pages']) {
      params.set('page', state['tab_pages'][state['tab']]);
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

  # Search button click
  $('#search-submit').on('click', function() {
    state['tab_pages'] = {};
    update_search(true);
    update_query_string();
  });
  # Search input on enter
  $('#search-term').keyup(function(e){
    if(e.keyCode == 13)
    {
      state['tab_pages'] = {};
      update_search(true);
      update_query_string();
    }
  });

  # Pressing a tab
  $('#source-select a').on('click', function() {
    var tab = $(this).data('tab')
    state['tab'] = tab;
    update_query_string();
  });

  # Page links
  $(document).on("ajax:success", 'a.page-link',
                          function(event) {
    var data = event.detail[0];
    var results = $(this).closest('.search-results');
    results.html(data.results_html);

    var href = $(this).attr('href');
    var query_string = href.substring(href.indexOf('?') + 1);
    var params = new URLSearchParams(query_string);
    var page = params.get('page') || 1;
    state['page'] = page;
    if (state['tab']) {
      state['tab_pages'][state['tab']] = page;
    }
    update_query_string();
  });

  # When page first loads ...
  update_tab();
  update_search();

});
