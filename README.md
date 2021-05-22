# Setup SQL Server SQLPackage tool on Linux runner

Sets up [SQLPackage](https://docs.microsoft.com/en-us/sql/tools/sqlpackage/sqlpackage-download?view=sql-server-ver15#get-sqlpackage-net-core-for-linux) for .NET Core Linux.

## Status

- Supports downloading sqlpackage tool and setting up path to the tool as action output
- Works with ubuntu-latest runner on GH Actions

## TODO

- Detect runner and pick proper download/setup routine
- Fix setting up PATH
- 
