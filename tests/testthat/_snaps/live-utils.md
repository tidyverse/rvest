# create_xpath_finder_js generates correct JavaScript

    Code
      create_xpath_finder_js(xpath)
    Output
        (function() {
          const xpathResult = document.evaluate('//a[@id=\'test\']', document, null, XPathResult.ORDERED_NODE_SNAPSHOT_TYPE, null);
          const nodes = [];
          for (let i = 0; i < xpathResult.snapshotLength; i++) {
            nodes.push(xpathResult.snapshotItem(i));
          }
          return(nodes);
        })();

# create_xpath_finder_js escapes special characters

    Code
      create_xpath_finder_js(xpath_escape)
    Output
        (function() {
          const xpathResult = document.evaluate('//a[text()="it\'s a \`test\`"]', document, null, XPathResult.ORDERED_NODE_SNAPSHOT_TYPE, null);
          const nodes = [];
          for (let i = 0; i < xpathResult.snapshotLength; i++) {
            nodes.push(xpathResult.snapshotItem(i));
          }
          return(nodes);
        })();

# as_key_desc gracefully errors on bad inputs

    Code
      as_key_desc("xyz")
    Condition
      Error in `as_key_desc()`:
      ! No key definition for "xyz".
    Code
      as_key_desc("X", "Malt")
    Condition
      Error:
      ! `modifiers` must be one of "Alt", "Control", "Meta", or "Shift", not "Malt".
      i Did you mean "Alt"?

