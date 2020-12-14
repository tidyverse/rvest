# validates inputs

    Code
      make_selector()
    Error <simpleError>
      Please supply one of css or xpath

---

    Code
      make_selector("a", "b")
    Error <simpleError>
      Please supply css or xpath, not both

---

    Code
      make_selector(css = 1)
    Error <simpleError>
      `css` must be a string

---

    Code
      make_selector(xpath = 1)
    Error <simpleError>
      `xpath` must be a string

