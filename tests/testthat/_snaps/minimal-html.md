# minimal html doesn't change unexpected

    Code
      cat(as.character(minimal_html("test", "<p>Hi")))
    Output
      <!DOCTYPE html>
      <html>
      <head>
      <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
      <meta charset="utf-8">
      <title>test</title>
      </head>
      <body><p>Hi</p></body>
      </html>

