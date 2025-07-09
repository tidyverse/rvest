# LiveSessionMouse click dispatches correct events

    [
      {
        "func": "scrollIntoViewIfNeeded",
        "args": [
          101
        ]
      },
      {
        "func": "dispatchMouseEvent",
        "args": {
          "type": "mouseMoved",
          "x": 15,
          "y": 15,
          "wait_": true
        }
      },
      {
        "func": "dispatchMouseEvent",
        "args": {
          "type": "mousePressed",
          "x": 15,
          "y": 15,
          "button": "left",
          "clickCount": 1,
          "wait_": true
        }
      },
      {
        "func": "dispatchMouseEvent",
        "args": {
          "type": "mouseReleased",
          "x": 15,
          "y": 15,
          "clickCount": 1,
          "button": "left",
          "wait_": true
        }
      },
      {
        "func": "dispatchMouseEvent",
        "args": {
          "type": "mousePressed",
          "x": 15,
          "y": 15,
          "button": "left",
          "clickCount": 2,
          "wait_": true
        }
      },
      {
        "func": "dispatchMouseEvent",
        "args": {
          "type": "mouseReleased",
          "x": 15,
          "y": 15,
          "clickCount": 2,
          "button": "left",
          "wait_": true
        }
      }
    ]

# LiveSessionMouse scroll_to calls correct functions

    {
      "type": "list",
      "attributes": {},
      "value": [
        {
          "type": "list",
          "attributes": {
            "names": {
              "type": "character",
              "attributes": {},
              "value": ["func", "args"]
            }
          },
          "value": [
            {
              "type": "character",
              "attributes": {},
              "value": ["callFunctionOn"]
            },
            {
              "type": "list",
              "attributes": {
                "names": {
                  "type": "character",
                  "attributes": {},
                  "value": ["", "objectId"]
                }
              },
              "value": [
                {
                  "type": "character",
                  "attributes": {},
                  "value": ["function() { return this.documentElement.scrollTo(50, 100)}"]
                },
                {
                  "type": "character",
                  "attributes": {},
                  "value": ["obj-1"]
                }
              ]
            }
          ]
        }
      ]
    }

# LiveSessionMouse scroll_by calls correct functions

    [
      {
        "func": "dispatchMouseEvent",
        "args": {
          "type": "mouseWheel",
          "x": 0,
          "y": 0,
          "deltaX": -10,
          "deltaY": 20
        }
      }
    ]

# LiveSessionMouse scroll_into_view calls correct functions

    [
      {
        "func": "scrollIntoViewIfNeeded",
        "args": [
          101
        ]
      }
    ]

