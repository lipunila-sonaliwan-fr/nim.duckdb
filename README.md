```
   _._
 o|- -|o This file is licensed under CC BY-NC-SA 4.0 international license.
  ( l )  To view a copy of this license, visit http://creativecommons.org/licenses/by-nc-sa/4.0/
    =    Author: jean-marc "jihem" quere 2016
```

## duQuack
> Lab'Oratoire / Project magenta – Laboratory of Cognitive and Social Psycholinguistics
> https://lipunila.sonaliwan.fr – metalab(at)sonaliwan.fr (french)

The duQuack package includes a lightweight library - **sonaliwan/duckdb** - that enables core DuckDB functionality.
It also provides the **duQuack** server, which allows multiple DuckDB clients to connect using the Quack protocol.

The `duquack.txt` file contains, on its first line, the name of the resource accessed (and made available) by the server. This could be an in-memory space (`:memory:`), a file on disk (CSV, Excel, Parquet, etc.), or a database (DuckDB, SQLite, MySQL, PostgreSQL, or any other accessible via ODBC). The second line defines the token that clients must present to access the server.

After loading the package (via `nimble install duquack`), you can...
- Run tests with `nimble test`
- Build the project (and the library) with `nimble build`
- Start the duQuack server with `nimble run`.

The output displayed on the screen looks like this:

```
jihem@sonaliwan-mac01 nim.duckdb % nimble run
      Info: using /opt/homebrew/Cellar/nim/2.2.10/nim/bin/nim for compilation
   Building duquack/duquack using c backend
     _         ____                  _
  __| |_   _  /___ \_   _  __ _  ___| | __
 / _` | | | |//  / / | | |/ _` |/ __| |/ /
| (_| | |_| / \_/ /| |_| | (_| | (__|   <
 \__,_|\__,_\___,_\ \__,_|\__,_|\___|_|\_\
                                     1.0.0
 Press [Ctrl]-[C] twice to stop.

  - 00:18:08.955918 <== uptime du serveur (tel que renvoyé par "FROM whoami()") 
```

The default settings (used when the `duquack.txt` file is unmodified or missing) are as follows:
- Resource provided: an empty in-memory database (`:memory:`).
- Token: 'secret'.

The builds include the dynamic libraries and the DuckDB console interface (version 1.5.5) for Linux, macOS, and Windows. The server and any developed Nim applications can be deployed across all these operating systems and are interoperable.

Once the server is running, you can use the DuckDB console - either one you have installed yourself or one of the provided options - to access the duquack server.

```
jihem@sonaliwan-lin01 nim.duckdb % **duckdb**
DuckDB v1.5.5 (Variegata)
Enter ".help" for usage hints.
memory D **LOAD 'QUACK';**
memory D **create secret(type quack, token 'secret');**
┌─────────┐
│ Success │
│ boolean │
├─────────┤
│ true    │
└─────────┘
memory D **attach 'quack:<server IP address or 127.0.0.1 if used locally>:9494' as server (disable_ssl true);**
memory D **select * from server.query("from whoami()");**
┌─────────┬──────────┬──────────┬─────────┬────────────────┬───────────────────────────────┬──────────────────────────────────┐
│  name   │ provider │ hostname │ region  │     uptime     │            ts_now             │               meta               │
│ varchar │ varchar  │ varchar  │ varchar │    interval    │   timestamp with time zone    │               json               │
├─────────┼──────────┼──────────┼─────────┼────────────────┼───────────────────────────────┼──────────────────────────────────┤
│ NULL    │ NULL     │ NULL     │ NULL    │ 00:25:00.68998 │ 2026-09-04 18:26:57.535303+02 │ {                                │
│         │          │          │         │                │                               │   "duckdb_version": "v1.5.5",    │
│         │          │          │         │                │                               │   "platform": "osx_arm64"        │
│         │          │          │         │                │                               │ }                                │
└─────────┴──────────┴──────────┴─────────┴────────────────┴───────────────────────────────┴──────────────────────────────────┘
memory D
```

Commands in **bold** can also be integrated into a Nim program to create a client and operate in client/server mode. DuckDB can be used by the application independently of any server. See the *tests* folder for examples.

IMPORTANT: to ensure persistent server data storage, replace **:memory:** in the duquack.txt file (located in the compiled executable's folder) with an available resource, such as a file or database.

Example (duquack.txt)
sona.duckdb
secret

If the file `ququack.txt` is missing from the folder, copy it from the `src` folder or create it, then restart the server: stop it by pressing `[Ctrl]-[C]` twice, then run `nimble run` again.

The following steps should be performed in a new DuckDB session (use `.exit` to leave the previous one):

```
memory D **create secret(type quack, token 'secret');** 
┌─────────┐
│ Success │
│ boolean │
├─────────┤
│ true    │
└─────────┘
memory D **attach '<quack:server IP address or 127.0.0.1 if used locally:9494>' as server (disable_ssl true);**
memory D **create table server.demo (nom varchar, age int);**
memory D **insert into server.demo values ('Paul', 35);**
memory D **select * from server.demo;**
┌─────────┬───────┐
│   nom   │  age  │
│ varchar │ int32 │
├─────────┼───────┤
│ Paul    │    35 │
└─────────┴───────┘
memory D
```

You can then stop the server again. A new file appears in its directory: **sona.duckdb**.
This is the database file, containing the table created along with the added row.

When restarting the server (``nimble run``) and reconnecting via a new DuckDB console session (using commands like `create secret...`, `attach...`), running the query **select * from server.demo;** again displays the previously entered data, confirming it was successfully saved.

DuckDB's capabilities are virtually limitless, and we have only scratched the surface (using Nim!). You are strongly encouraged to visit the official DuckDB website (https://duckdb.org), which offers extensive and accessible documentation (including a description of Quack: https://duckdb.org/quack). Many excellent tutorials are also available online.

IMPORTANT: If, for any reason, you encounter difficulties loading DuckDB extensions (such as Quack), you can trigger their installation (once and for all) for the current session using the DuckDB console command: **INSTALL '<plugin_name>'**. These are stored in the **.duckdb** folder at the root of the user account (e.g., `/home/<name>` on Linux, `/Users/<name>` on macOS, and `/Users/<name>` on Windows). Specifically, they are located in the **.duckdb/extensions/<DuckDB_version>/<OS_version>** directory. You can then copy the contents of this directory to another system for installation (provided it runs the same versions of DuckDB and the operating system).

As a special measure, this repository includes the required binaries - DuckDB console executables and necessary Nim libraries - for Linux, macOS, and Windows (version 1.5.5); the provided library automatically detects and utilizes them.

Please find below a reminder of the associated license:

Copyright 2018-2026 Stichting DuckDB Foundation

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

### One more thing!
A small gesture that can—hugely—help us out... [Caffeine is important for a team of neurodivergent individuals: ASD, ADHD, GAD, gifted IQ and highly/exceptionally gifted (members of **mensa.fr** and **triplenine.org**).]

[![Buy Me a Coffee](buymeacoffe.png)](https://buymeacoffee.com/sonaliwan.fr)
