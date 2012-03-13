var Worklist = (typeof module !== "undefined" && module.exports) || {};

(function (exports) {
  exports.start        = start;
  exports.closeTask    = closeTask;
  exports.startProcess = startProcess;

  function start(){
    var es = new EventSource('/events');
    es.onmessage = function(e){ renderTasklist(); };
    renderTasklist();
  }

  function startProcess(data){
    $.post('/start-process', data);
  }

  function closeTask(id) {
    $.post('/close-task', {id: id});
  }

  function renderTasklist() {
    $.get('/tasklist.mustache', function(template){
      $.get('/processes.json', function(data){
        $("#tasklist").html(Mustache.render(template, data));
      });
    })
  }

})(Worklist);