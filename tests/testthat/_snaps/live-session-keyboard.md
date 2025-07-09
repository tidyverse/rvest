# LiveSessionKeyboard type calls focus and insertText

    [
      {
        "func": "focus",
        "args": [
          101
        ]
      },
      {
        "func": "insertText",
        "args": [
          "hello"
        ]
      }
    ]

# LiveSessionKeyboard press calls focus and dispatchKeyEvent

    [
      {
        "func": "focus",
        "args": [
          101
        ]
      },
      {
        "func": "dispatchKeyEvent",
        "args": {
          "type": "keyDown",
          "key": "Enter",
          "windowsVirtualKeyCode": 13,
          "code": "Enter",
          "location": 0,
          "text": "\r",
          "modifiers": 0
        }
      },
      {
        "func": "dispatchKeyEvent",
        "args": {
          "type": "keyUp",
          "key": "Enter",
          "windowsVirtualKeyCode": 13,
          "code": "Enter",
          "location": 0,
          "text": "\r",
          "modifiers": 0
        }
      }
    ]

