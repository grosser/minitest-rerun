Print copy pasteable rerun snippets after failed runs

```
  1) Failure:
Test#test_xxx [test.rb:7]:
Failed assertion, no message given.

ruby test.rb -n 'Test#test_xxx'

2 tests, 2 assertions, 1 failures, 0 errors, 0 skips
```

Install
=======

```Bash
gem install minitest-rerun
```

Usage
=====

```Ruby
require 'minitest/rerun'
```

Author
======
[Michael Grosser](http://grosser.it)<br/>
michael@grosser.it<br/>
License: MIT<br/>
[![Build Status](https://travis-ci.org/grosser/minitest-rerun.png)](https://travis-ci.org/grosser/minitest-rerun)
