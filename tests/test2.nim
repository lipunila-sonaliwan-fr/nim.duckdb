import unittest
import sonaliwan/duckdb

proc tok_exec(): bool =
  try:
    var db = openDB(":memory:")
    defer: db.close()

    var conn = db.connect()
    defer: conn.close()

    conn.exec("""
      create table cities (id integer, country varchar, name varchar, inhabitants integer, latitude double, longitude double);
      create sequence 'cities_id';
      insert into cities values
        (nextval('cities_id'), 'China',     'Shanghai',      25000000,  31.22222,   21.45806),
        (nextval('cities_id'), 'India',     'Delhi',		    23000000,	 28.65195,   77.23149),
        (nextval('cities_id'), 'China',     'Beijing',		  19000000,  39.90750,	116.39723),
        (nextval('cities_id'), 'Türkiye',   'Istanbul',		  16000000,	 41.01384,	 28.94966),
        (nextval('cities_id'), 'India',     'Mumbai',		    13000000,  19.07283,	 72.88261),
        (nextval('cities_id'), 'Mexico',    'Mexico City',	12000000,  19.42847,	-99.12766),
        (nextval('cities_id'), 'Pakistan',  'Karachi',		  12000000,  24.86080,	 67.01040),
        (nextval('cities_id'), 'China',     'Tianjin',      11000000,  39.14222,	117.17667),
        (nextval('cities_id'), 'China',     'Guangzhou',		16000000,  23.11667,	113.25000),
        (nextval('cities_id'), 'Argentina', 'Buenos Aires',	 3000000,	-34.61315,	-58.37723);
    """)

    conn.exec("copy (select * from cities) to 'cities.parquet' (compression zstd);")

    true
  except:
    false

test "Exec":
  check tok_exec()
