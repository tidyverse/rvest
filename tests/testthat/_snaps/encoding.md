# can guess encoding

    Code
      html_encoding_guess(x)
    Output
          encoding language confidence
      1 ISO-8859-1       fr       0.31
      2 ISO-8859-2       ro       0.22
      3   UTF-16BE                0.10
      4   UTF-16LE                0.10
      5    GB18030       zh       0.10
      6       Big5       zh       0.10
      7 ISO-8859-9       tr       0.06
      8 IBM424_rtl       he       0.01
      9 IBM424_ltr       he       0.01

---

    Code
      guess_encoding(x)
    Condition
      Warning:
      `guess_encoding()` was deprecated in rvest 1.0.0.
      Please use `html_encoding_guess()` instead.
    Output
          encoding language confidence
      1 ISO-8859-1       fr       0.31
      2 ISO-8859-2       ro       0.22
      3   UTF-16BE                0.10
      4   UTF-16LE                0.10
      5    GB18030       zh       0.10
      6       Big5       zh       0.10
      7 ISO-8859-9       tr       0.06
      8 IBM424_rtl       he       0.01
      9 IBM424_ltr       he       0.01

# encoding repair is deprecated

    Code
      repair_encoding(text)
    Condition
      Warning:
      `html_encoding_repair()` was deprecated in rvest 1.0.0.
      Instead, re-load using the `encoding` argument of `read_html()`
      Error:
      ! No guess has more than 50% confidence

---

    Code
      repair_encoding(text, "ISO-8859-1")
    Condition
      Warning:
      `html_encoding_repair()` was deprecated in rvest 1.0.0.
      Instead, re-load using the `encoding` argument of `read_html()`
    Output
      [1] "ÉmigrÃ© cause cÃ©lÃ¨bre dÃ©jÃ  vu."

