# has print method

    Code
      sess
    Output
      {xml_nodeset (46)}
       [1] <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">\n
       [2] <meta charset="utf-8">\n
       [3] <meta http-equiv="X-UA-Compatible" content="IE=edge">\n
       [4] <meta name="viewport" content="width=device-width, initial-scale=1, shri ...
       [5] <meta name="description" content="rvest">\n
       [6] <title>Star Wars films • rvest</title>\n
       [7] <link rel="icon" type="image/png" sizes="16x16" href="../favicon-16x16.p ...
       [8] <link rel="icon" type="image/png" sizes="32x32" href="../favicon-32x32.p ...
       [9] <link rel="apple-touch-icon" type="image/png" sizes="180x180" href="../a ...
      [10] <link rel="apple-touch-icon" type="image/png" sizes="120x120" href="../a ...
      [11] <link rel="apple-touch-icon" type="image/png" sizes="76x76" href="../app ...
      [12] <link rel="apple-touch-icon" type="image/png" sizes="60x60" href="../app ...
      [13] <script src="../deps/jquery-3.6.0/jquery-3.6.0.min.js"></script>
      [14] <meta name="viewport" content="width=device-width, initial-scale=1, shri ...
      [15] <link href="../deps/bootstrap-5.2.2/bootstrap.min.css" rel="stylesheet">\n
      [16] <script src="../deps/bootstrap-5.2.2/bootstrap.bundle.min.js"></script>
      [17] <link href="../deps/Source_Sans_Pro-0.4.7/font.css" rel="stylesheet">\n
      [18] <link href="../deps/Source_Code_Pro-0.4.7/font.css" rel="stylesheet">\n
      [19] <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font ...
      [20] <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font ...
      ...

# gracefully errors on bad inputs

    Code
      as_key_desc("xyz")
    Condition
      Error in `as_key_desc()`:
      ! No key definition for "xyz".
    Code
      as_key_desc("X", "Malt")
    Condition
      Error:
      ! `modifiers` must be one of "Alt", "Control", "Meta", or "Shift", not "Malt".
      i Did you mean "Alt"?

