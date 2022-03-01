# validates inputs

    Code
      make_selector()
    Condition
      Error:
      ! Please supply one of css or xpath

---

    Code
      make_selector("a", "b")
    Condition
      Error:
      ! Please supply css or xpath, not both

---

    Code
      make_selector(css = 1)
    Condition
      Error in `make_selector()`:
      ! `css` must be a string

---

    Code
      make_selector(xpath = 1)
    Condition
      Error in `make_selector()`:
      ! `xpath` must be a string

