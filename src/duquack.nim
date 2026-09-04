# CC BY-NC-SA 4.0 - jean-marc "jihem" quere 2026

import std/[os, strutils]
import sonaliwan/duckdb

echo """
     _         ____                  _
  __| |_   _  /___ \_   _  __ _  ___| | __
 / _` | | | |//  / / | | |/ _` |/ __| |/ /
| (_| | |_| / \_/ /| |_| | (_| | (__|   <
 \__,_|\__,_\___,_\ \__,_|\__,_|\___|_|\_\
                                     1.0.0
 Press [Ctrl]-[C] twice to stop.
"""

let (path, name, _) = splitFile(paramStr(0))
var caught = false
var ucount = "*"
var conn: Conn

proc handler() {.noconv.} =
  if caught:
    conn.exec("CALL quack_stop('quack:0.0.0.0:9494')")
    stdout.write("\nServer halted.\n")
    quit()
  caught = true

setControlCHook(handler)

proc main() =
  let paramsFile = path & "/" & name & ".txt"
  var params: seq[string]

  if fileExists(paramsFile):
    params = readFile(paramsFile).split('\n')
    for n in 0..<params.len:
      params[n] = params[n].strip()
  else:
    params = @[ ":memory:", "secret" ]

  var db = openDB(params[0])
  defer: db.close()
  conn = db.connect()
  defer: conn.close()

  conn.exec("INSTALL 'QUACK';")
  conn.exec("LOAD 'QUACK';")
  conn.exec("CALL quack_serve('quack:0.0.0.0:9494', allow_other_hostname = true, token = '" & params[1] & "');")

  while true:
    for n in 1..<int64.high:
      sleep 500
      case n mod 4:
        of 1: stdout.write("\r  - ")
        of 2: stdout.write("\r  \\ ")
        of 3: stdout.write("\r  | ")
        else: stdout.write("\r  / ")

      if n mod 10 == 0:
        var rows = conn.query("select uptime from whoami();")
        ucount = $rows.getValue(0,0)

      stdout.write(ucount & "      \r")
      flushfile(stdout)

when isMainModule:
  main()
