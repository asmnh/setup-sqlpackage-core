# Setup SQL Server SQLPackage tool on Linux runner

Sets up [SQLPackage](https://docs.microsoft.com/en-us/sql/tools/sqlpackage/sqlpackage-download?view=sql-server-ver15#get-sqlpackage-net-core-for-linux) commandline tool for Linux runner - .NET Core version.

## Configuration

### Available action parameters

#### version

SQL Server version for runner to choose. Should match SQL Server that will be connected to using `sqlpackage` command.

You can specify full version or a version placeholder, only major version number is taken into account.

Default: `20.x`

#### export

Flag that controls if `sqlpackage` will be added to `PATH` environment variable in workflow run.

Default: `true`

Supported values: `true`, `false`

### Output variables

#### version

Version returned by `sqlpackage` tool.

#### path

Path to directory containing `sqlpackage` command.

#### executable

Full path to `sqlpackage` command.

## Example

Make a snapshot of existing database, use it as template to set up new temporary database and test migrations.

See [Starter Action Workflows to deploy to Azure](https://github.com/Azure/actions-workflow-samples) for context.

```yml
jobs:
  test-migration:
    steps:
      # Set up environment you're using
      - uses: actions/checkout@v2
      - uses: asmnh/setup-sqlpackage-core@v1
      - run: sqlpackage /a:export /scs:${{ secrets.SQL_CS_STAGING }} /tf:./sqltemplate.dacpac
      - uses: azure/login@v1
        with:
          creds: ${{ secrets.AZURE_CREDENTIALS }}
      - name: Generate new database name
        id: dbid
        run: echo "::set-output name=name::${{ github.repository_name }}-$(git rev-parse --short HEAD)"
      - name: Create new Azure SQL Database
        uses: azure/CLI@v1
        with:
          azcliversion: latest
          inlineScript: |
            az sql db create -g ${{ secrets.AZURE_RESOURCEGROUP }} -s ${{ secrets.SQL_SERVER_CI }} -n ${{ steps.dbid.outputs.name }} --service-objective S0 -z false
      - uses: azure/sql-action@v1
        with:
          server-name: ${{ secrets.SQL_SERVER_CI }}
          connection-string: ${{ secrets.SQL_CS_CI_TEMPLATE }};Database=${{ steps.dbid.outputs.name }};
          dacpac-package: ./sqltemplate.dacpac
      # You may want to extract database setup to a separate job, so you can clean up temporary database only if migration test was successful
      - name: Run and test migrations
        run: ./migrate && ./test-migrations
      - name: Remove temporary database
        uses: azure/CLI@v1
        with:
          azcliversion: latest
          inlineScript: |
            az sql db delete -g ${{ secrets.AZURE_RESOURCEGROUP }} -s ${{ secrets.SQL_SERVER_CI }} -n ${{ steps.dbid.outputs.name }} --no-wait -y
````
