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
