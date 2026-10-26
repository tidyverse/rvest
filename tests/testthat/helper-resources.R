# Pages that fetch data need to be served over http, not file://
local_resource_app <- function(envir = parent.frame()) {
  skip_if_not_installed("webfakes")

  app <- webfakes::new_app()
  app$get("/", function(req, res) {
    res$set_type("html")
    res$send(
      "<html><body>
      <button id='more'>More</button>
      <script>
        fetch('/data.json?page=1');
        document.getElementById('more').onclick = () => {
          setTimeout(() => fetch('/data.json?page=2'), 200);
        };
      </script>
      </body></html>"
    )
  })
  app$get("/data.json", function(req, res) {
    res$send_json(list(page = req$query$page), auto_unbox = TRUE)
  })
  webfakes::local_app_process(app, .local_envir = envir)
}
