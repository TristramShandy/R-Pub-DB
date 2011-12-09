// mu_pubdb.js
//
// Javascript functions spezific to the RPubDB program

// set scope in the publication form
function set_scope(obj) {
  var conf_obj = document.getElementById('scope_conf');
  var jour_obj = document.getElementById('scope_jour');
  var book_obj = document.getElementById('scope_book');

  if (conf_obj && jour_obj && book_obj)
  {
    var val = obj.value;
    if (val == "0") {
      conf_obj.className = conf_obj.className.replace('hidden', 'visible');
      jour_obj.className = jour_obj.className.replace('visible', 'hidden');
      book_obj.className = book_obj.className.replace('visible', 'hidden');
    } else if (val == "1") {
      jour_obj.className = jour_obj.className.replace('hidden', 'visible');
      book_obj.className = book_obj.className.replace('visible', 'hidden');
      conf_obj.className = conf_obj.className.replace('visible', 'hidden');
    } else if (val == "2") {
      book_obj.className = book_obj.className.replace('hidden', 'visible');
      conf_obj.className = conf_obj.className.replace('visible', 'hidden');
      jour_obj.className = jour_obj.className.replace('visible', 'hidden');
    }
  }
}

// add item to selection list
function mu_two_select_add(id_select, id_list)
{
  var select_obj = document.getElementById(id_select);
  var list_obj = document.getElementById(id_list);
  if (select_obj && list_obj) {
    for (var i = 0; i < list_obj.length; ++i) {
      if (list_obj.options[i].selected) {
        var new_option = document.createElement('option');
        new_option.text = list_obj.options[i].text;
        new_option.value = list_obj.options[i].value;
        try {
          select_obj.add(new_option, null); // standards compliant
        } catch(ex) {
          select_obj.add(new_option); // Fucking IE only
        }
      }
    }
  }

}

// remove item from selection list
function mu_two_select_remove(id_select, id_list) {
  var select_obj = document.getElementById(id_select);
  if (select_obj) {
    for (var i = select_obj.length - 1; i >= 0; --i) {
      if (select_obj.options[i].selected) {
        select_obj.remove(i);
      }
    }
  }
}

// select all choices of a multiselection
function mu_select_all(id_select) {
  var select_obj = document.getElementById(id_select);
  if (select_obj) {
    for (var i = 0; i < select_obj.length; ++i) {
      select_obj.options[i].selected = true;
    }
  }
}
