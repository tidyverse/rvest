# validates inputs

    Code
      make_selector()
    Condition
      Error:
      ! One of `css` or `xpath` must be supplied.

---

    Code
      make_selector("a", "b")
    Condition
      Error:
      ! Exactly one of `css` or `xpath` must be supplied.

---

    Code
      make_selector(css = 1)
    Condition
      Error:
      ! `css` must be a single string, not the number 1.

---

    Code
      make_selector(xpath = 1)
    Condition
      Error:
      ! `xpath` must be a single string, not the number 1.

