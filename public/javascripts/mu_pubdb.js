// mu_pubdb.js
//
// Javascript functions spezific to the RPubDB program

function mu_hide(obj) {obj.className = obj.className.replace('visible', 'hidden');}
function mu_show(obj) {obj.className = obj.className.replace('hidden', 'visible');}

// set scope in the publication form
function set_scope(obj) {
  var conf_obj = document.getElementById('scope_conf');
  var jour_obj = document.getElementById('scope_jour');
  var book_obj = document.getElementById('scope_book');
  var volume_obj = document.getElementById('f_volume');
  var number_obj = document.getElementById('f_number');
  var year_obj = document.getElementById('f_year');
  var pages_obj = document.getElementById('f_pages');
  var doi_obj = document.getElementById('f_doi');
  var citation_obj = document.getElementById('f_citation');

  if (conf_obj && jour_obj && book_obj && volume_obj && number_obj && year_obj && pages_obj && doi_obj && citation_obj)
  {
    var val = obj.value;
    if (val == "0") {
      mu_show(conf_obj);
      mu_show(doi_obj);
      mu_hide(jour_obj);
      mu_hide(book_obj);
      mu_hide(volume_obj);
      mu_hide(number_obj);
      mu_hide(year_obj);
      mu_hide(pages_obj);
      mu_hide(citation_obj);
    } else if (val == "1") {
      mu_show(jour_obj);
      mu_show(volume_obj);
      mu_show(number_obj);
      mu_show(year_obj);
      mu_show(pages_obj);
      mu_show(doi_obj);
      mu_hide(conf_obj);
      mu_hide(book_obj);
      mu_hide(citation_obj);
    } else if (val == "2") {
      mu_show(book_obj);
      mu_show(year_obj);
      mu_show(pages_obj);
      mu_show(doi_obj);
      mu_hide(jour_obj);
      mu_hide(conf_obj);
      mu_hide(volume_obj);
      mu_hide(number_obj);
      mu_hide(citation_obj);
    } else if (val == "3") {
      mu_hide(book_obj);
      mu_hide(jour_obj);
      mu_hide(conf_obj);
      mu_hide(volume_obj);
      mu_hide(number_obj);
      mu_hide(year_obj);
      mu_hide(pages_obj);
      mu_hide(doi_obj);
      mu_show(citation_obj);
    }
  }
}

// add item to selection list
function mu_two_select_add(id_select, id_list)
{
  var select_obj = document.getElementById(id_select);
  var list_obj = document.getElementById(id_list);
  if (select_obj && list_obj) {
    // add item to selection list
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
    // remove item from full list
    for (var i = list_obj.length - 1; i >= 0; --i) {
      if (list_obj.options[i].selected) {
        list_obj.remove(i);
      }
    }
  }

}

// remove item from selection list
function mu_two_select_remove(id_select, id_list) {
  var select_obj = document.getElementById(id_select);
  var list_obj = document.getElementById(id_list);
  if (select_obj && list_obj) {
    // add item to full list
    for (var i = 0; i < select_obj.length; ++i) {
      if (select_obj.options[i].selected) {
        var new_option = document.createElement('option');
        new_option.text = select_obj.options[i].text;
        new_option.value = select_obj.options[i].value;
        try {
          list_obj.add(new_option, null); // standards compliant
        } catch(ex) {
          list_obj.add(new_option); // Fucking IE only
        }
      }
    }
    // remove item from selection list
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
