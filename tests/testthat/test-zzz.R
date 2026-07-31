# Regression test for a scoping bug in `.onLoad` (see `R/zzz.R`).
#
# `new_chromote` is initialised to `NULL` and, in `.onLoad`, the `if` branch
# correctly used `<<-` to update the package binding while the `else` branch
# used a *local* `<-`. When chromote was absent at load time that left the
# package-level `new_chromote` as `NULL`. `LiveHTML$check_active()` later does
# `if (new_chromote && !self$session$is_active())`, and `NULL && x` errors at
# runtime with "invalid 'x' type in 'x && y'" (reachable when chromote is
# installed after rvest is loaded).
#
# To run identically under source-tree tests and an installed-package
# `R CMD check` (where the source tree is unavailable), we exercise the
# *installed* `.onLoad` closure rather than sourcing `R/zzz.R`. We copy its
# formals and body into a new closure backed by a throwaway environment
# parented by the real closure environment, seed that throwaway with the
# initial `new_chromote <- NULL` and a mocked `is_installed()` returning FALSE,
# and invoke it. This never mutates the real rvest namespace and fails if the
# `else` branch ever reverts to a local `<-`.

test_that(".onLoad sets new_chromote to a length-1 logical when chromote is absent", {
  real_onLoad <- getFromNamespace(".onLoad", "rvest")
  real_env <- environment(real_onLoad)

  # Snapshot the real package binding so we can prove it is left untouched.
  real_before <- get("new_chromote", envir = real_env)

  # Throwaway environment parented by the real closure environment so the
  # copied body still sees everything it needs (e.g. utils::), while
  # `new_chromote` and `is_installed()` are shadowed by our local bindings.
  isolated_env <- new.env(parent = real_env)
  isolated_env$new_chromote <- NULL # mirrors the package-level initialiser
  isolated_env$is_installed <- function(...) FALSE # chromote absent at load

  # Copy the installed .onLoad into a fresh closure backed by the throwaway.
  isolated_onLoad <- function() {}
  formals(isolated_onLoad) <- formals(real_onLoad)
  body(isolated_onLoad) <- body(real_onLoad)
  environment(isolated_onLoad) <- isolated_env

  isolated_onLoad()

  # The else branch must update the enclosing binding: pre-fix it used a local
  # `<-`, leaving `new_chromote` NULL, which later made `new_chromote && ...`
  # in LiveHTML$check_active() error with "invalid 'x' type in 'x && y'".
  expect_type(isolated_env$new_chromote, "logical")
  expect_length(isolated_env$new_chromote, 1)
  expect_false(isolated_env$new_chromote)

  # The real namespace binding must be unchanged.
  expect_identical(get("new_chromote", envir = real_env), real_before)
})
