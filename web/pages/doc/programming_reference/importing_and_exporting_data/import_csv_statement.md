# `IMPORT` `CSV` Statement

Imports a CSV (comma-separated values) file from disk into a notebook table. This statement is the scripting equivalent of the visual import wizard accessed via the Import menu.

## Syntax

<railroad-diagram>
Stack(
    Sequence(
        'IMPORT',
        'CSV',
        NonTerminal('filename'),
        'INTO',
        NonTerminal('table-name'),
    ),
    Sequence(
        Optional(
            Sequence(
                '(',
                OneOrMore(
                    Sequence(
                        NonTerminal('column-name'),
                        Optional(
                            Sequence(
                                'AS',
                                NonTerminal('target-column-name')
                            ),
                            'skip'
                        ),
                        Optional(
                            NonTerminal('data-type'),
                            'skip'
                        )
                    ),
                    ','
                ),
                ')'
            )
        ),
    ),
    Sequence(
        Optional(
            Sequence(
                'OPTIONS',
                '(',
                OneOrMore(
                    Sequence(
                        NonTerminal('key'),
                        ':',
                        NonTerminal('value')
                    ),
                    ','
                ),
                ')'
            )
        )
    )
)
</railroad-diagram>

## Parameters

- *filename* (string): The absolute path to the CSV file to be imported.
- *table-name* (identifier or string): The name of the notebook table to import the CSV file into. If the table does not exist, it will be created. If it does exist, by default new rows will be appended, but the `TRUNCATE_EXISTING_TABLE` option can be used to overwrite the existing table data.
- *column-name* (identifier or string): The name of a column in the source file to import. If this column name is not found in the source file, then the import operation fails with an error. If no column list is provided, then all columns are imported.
- *target-column-name* (identifier or string): If provided, this maps the source column to a different name in the destination table. If not provided, then the target column name is the same as the source column name. If multiple columns are mapped to the same target column name in this way, then the import operation fails with an error.
- *data-type* (enum): If provided, the column data will be parsed into the specified data type. *data-type* may be one of the following values:
    - `TEXT`: The input is imported without change (default)
    - `INTEGER`: A positive or negative integer
    - `REAL`: Any numeric value
    - `DATE`: Best-effort conversion into the text format: "YYYY-MM-DD"
    - `DATETIME`: Best-effort conversion into the text format: "YYYY-MM-DD hh:mm:ss.sss"
    - `DATETIMEOFFSET`: Best-effort conversion into the text format: "YYYY-MM-DD hh:mm:ss.sss +ZZ:ZZ"

## Options

- `SKIP_LINES` (non-negative, default: 0): Indicates how many initial lines should be skipped in the input file. This is used if the column header (or the data if there is no column header) does not appear on the first line of the file.
- `TAKE_LINES` (-1 or non-negative, default: -1): Indicates the maximum number of data lines to read from the file (not including the column header and any lines skipped due to the `SKIP_LINES` option). If -1 is specified, then the whole file is read.
- `HEADER_ROW` (0-1, default: 1): Indicates whether the CSV file begins with a column header line. If the file contains a column header but not on the first line of the file, use the `SKIP_LINES` option to indicate how many lines to skip before the column header appears.
    - 0 = No column header. The generic column names `column1`, `column2`, etc. will be used.
    - 1 = A column header row exists.
- `TRUNCATE_EXISTING_TABLE` (0-1, default: 0): If the target table name exists, this option indicates whether the existing data rows should be deleted.
    - 0 = Keep existing rows and append new rows
    - 1 = Delete existing rows
- `TEMPORARY_TABLE` (0-1, default: 0): If the target table name does not exist, and therefore a new table will be created, this option indicates whether the new table will be a temporary table.
    - 0 = Use `CREATE TABLE`
    - 1 = Use `CREATE TEMPORARY TABLE`
- `FILE_ENCODING` (0-65535, default: 0): Indicates the text encoding to use when reading the CSV file. Specify 0 to detect the encoding automatically. Any nonzero integer is treated as a Windows code page number.
- `IF_CONVERSION_FAILS` (1-3, default: 1): If data conversion fails (for instance, if a non-numeric value appears in the file in a column defined in the `IMPORT CSV` statement as `INTEGER`), this option controls what happens.
    - 1 = Import the value as plain text
    - 2 = Skip the data row
    - 3 = Abort with an error

## Examples

- Imports "MyFile.csv" into a notebook table called `mytable`. Because no options are specified, it is assumed that the file has a column header on the first line. Because no column list is specified, all columns are imported as text and the original column names are preserved.

    ```
    IMPORT CSV 'C:\MyFile.csv' INTO mytable;
    ```

- The source columns (`foo, bar`) are explicitly specified. If the source file contains other columns besides those two, then they are not imported into the destination notebook table. If the source file does not contain the specified columns, then the import fails. If the destination table already exists and does not contain the specified column names, then the import fails.

    ```
    IMPORT CSV 'C:\MyFile.csv' INTO mytable (foo, bar);
    ```

- The source columns (`foo, bar`) and target columns (`aaa`, `bbb`) are explicitly specified.

    ```
    IMPORT CSV 'C:\MyFile.csv' INTO mytable (foo AS aaa, bar AS bbb);
    ```

- A data type conversion is specified for each source column. If the conversion fails (for instance, if a non-numeric value appears in the CSV file in the `bar` column), by default the value is imported as text. SQLite treats column types as suggestions, so the integer column can contain a text value.

    ```
    IMPORT CSV 'C:\MyFile.csv' INTO mytable (foo TEXT, bar INTEGER);
    ```

- A file that lacks a header row is imported with new names given to the unnamed source columns.

    ```
    IMPORT CSV 'C:\MyFile.csv' INTO mytable (column1 AS foo, column2 AS bar)
    OPTIONS (HEADER_ROW: 0);
    ```

- Various arguments to `IMPORT CSV` are provided in variables rather than using literal strings. This allows these names to be dynamically generated or otherwise determined at script runtime.

    ```
    IMPORT CSV @filename INTO @tablename (@old_col AS @new_col);
    ```
