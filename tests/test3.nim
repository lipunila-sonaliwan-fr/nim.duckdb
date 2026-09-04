import unittest
import sonaliwan/duckdb

proc tok_query(): string =
  result = ""
  try:
    var db = openDB(":memory:")
    defer: db.close()

    var conn = db.connect()
    defer: conn.close()

    conn.exec("attach 'cities.parquet' as data;")

    var rows = conn.query("select country, name from data.file where inhabitants > 12000000;")
    for col in rows.columns():
      result = result & col & "|"

    result = result & "|" & $rows.rowCount

    for row in rows:
      result = result & "||" & $row[0] & "|" & $row[1]
  except:
    discard

test "Query":
  check tok_query() == "country|name||6||China|Shanghai||India|Delhi||China|Beijing||Türkiye|Istanbul||India|Mumbai||China|Guangzhou"
