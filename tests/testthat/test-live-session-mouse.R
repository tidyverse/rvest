test_that("LiveSessionMouse click dispatches correct events", {
  mock_session <- mock_session_for_mouse()
  mouse <- LiveSessionMouse$new(mock_session, function() 1)
  mouse$click(node = 101, n_clicks = 2)
  expect_snapshot_value({
    mock_session$log$events
  })
})

test_that("LiveSessionMouse scroll_to calls correct functions", {
  mock_session <- mock_session_for_mouse()
  mouse <- LiveSessionMouse$new(mock_session, function() 1)
  mouse$scroll_to(top = 100, left = 50)
  expect_snapshot_value(
    {
      mock_session$log$events
    },
    style = "json2"
  )
})

test_that("LiveSessionMouse scroll_by calls correct functions", {
  mock_session <- mock_session_for_mouse()
  mouse <- LiveSessionMouse$new(mock_session, function() 1)
  mouse$scroll_by(top = 20, left = -10)
  expect_snapshot_value({
    mock_session$log$events
  })
})

test_that("LiveSessionMouse get_scroll_position returns a value", {
  mock_session <- mock_session_for_mouse()
  mouse <- LiveSessionMouse$new(mock_session, function() 1)
  position <- mouse$get_scroll_position()
  expect_equal(position, list(x = 100, y = 200))
})

test_that("LiveSessionMouse scroll_into_view calls correct functions", {
  mock_session <- mock_session_for_mouse()
  mouse <- LiveSessionMouse$new(mock_session, function() 1)
  mouse$scroll_into_view(node = 101)
  expect_snapshot_value({
    mock_session$log$events
  })
})
