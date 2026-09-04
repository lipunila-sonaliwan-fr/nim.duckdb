import unittest
import sonaliwan/duckdb

proc tok_openClose(): bool =
  try:
    var db = openDB(":memory:")
    defer: db.close()

    var conn = db.connect()
    defer: conn.close()
    true
  except:
    false

test "Open & Close":
  check tok_openClose()
