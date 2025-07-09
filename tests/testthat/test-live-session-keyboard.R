test_that("LiveSessionKeyboard type calls focus and insertText", {
  mock_session <- mock_session_for_keyboard()
  keyboard <- LiveSessionKeyboard$new(mock_session)
  keyboard$type(node = 101, text = "hello")
  expect_snapshot_value({
    mock_session$log$events
  })
})

test_that("LiveSessionKeyboard press calls focus and dispatchKeyEvent", {
  mock_session <- mock_session_for_keyboard()
  keyboard <- LiveSessionKeyboard$new(mock_session)
  keyboard$press(node = 101, key_code = "Enter")
  expect_snapshot_value({
    mock_session$log$events
  })
})
