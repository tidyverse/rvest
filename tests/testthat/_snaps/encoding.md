# can guess encoding

    Code
      html_encoding_guess(x)
    Output
             encoding language confidence
      1         UTF-8                1.00
      2  windows-1252       fr       0.31
      3  windows-1250       ro       0.22
      4      UTF-16BE                0.10
      5      UTF-16LE                0.10
      6       GB18030       zh       0.10
      7          Big5       zh       0.10
      8  windows-1254       tr       0.06
      9    IBM424_rtl       he       0.01
      10   IBM424_ltr       he       0.01

---

    Code
      . <- guess_encoding(x)
    Condition
      Warning:
      `guess_encoding()` was deprecated in rvest 1.0.0.
      i Please use `html_encoding_guess()` instead.

# encoding repair is deprecated

    Code
      . <- repair_encoding(text, "ISO-8859-1")
    Condition
      Warning:
      `html_encoding_repair()` was deprecated in rvest 1.0.0.
      i Instead, re-load using the `encoding` argument of `read_html()`

