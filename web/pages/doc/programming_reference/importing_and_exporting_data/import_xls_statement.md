# `IMPORT` `XLS` Statement

Imports an Excel worksheet (in either `.XLS` or `.XLSX` format) from disk into a notebook table. This statement is the scripting equivalent of the visual import wizard accessed via the Import menu. If the workbook contains multiple worksheets, use the *which-sheet* argument to specify which worksheet to import. If needed, use the [`LIST_XLS_WORKSHEETS`](list_xls_worksheets_function.html) function to get a list of the worksheets in the workbook.

## Syntax

<railroad-diagram>
Stack(
    Sequence(
        'IMPORT',
        Choice(0,
            'XLS',
            'XLSX'
        ),
        NonTerminal('filename'),
        Optional(
            Sequence(
                'WORKSHEET',
                NonTerminal('which-sheet')
            )
        ),
        'INTO',
        NonTerminal('table-name')
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
        )
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

- *filename* (string): The absolute path to the Excel workbook (`.XLS` or `.XLSX`) to be imported.
- *which-sheet* (string or integer): If specified, this indicates which worksheet to import. If omitted, the first worksheet is imported. This value can be either the name of the worksheet or its 1-based index in the workbook.
- *table-name* (identifier or string): The name of the notebook table to import the worksheet into. If the table does not exist, it will be created. If it does exist, by default new rows will be appended, but the `TRUNCATE_EXISTING_TABLE` option can be used to overwrite the existing table data.
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

- `FIRST_ROW` (integer ≥ 1, default: 1): The number (starting at 1) of the first row of the data to read. If a row of column names is present (see the `HEADER_ROW` option), `FIRST_ROW` specifies the row containing the column names, with the data to follow on the next row. If no column names are present, then `FIRST_ROW` specifies the first row of data.
- `LAST_ROW` (integer ≥ 0, default: 0): Indicates how many rows of data to read. If a value of 0 is specified, then all available rows in the worksheet are imported. If a positive integer is specified, then it is the last row number (inclusive) to be imported.
- `FIRST_COLUMN` (integer ≥ 1 or string, default: 1): The leftmost column (inclusive) to import. This may be a column number (starting at 1) or a column string (A, B, C, ..., XFC, XFD).
- `LAST_COLUMN` (integer ≥ 0 or string, default: 0): The rightmost column (inclusive) to import. This may be a column number (starting at 1) or a column string (A, B, C, ..., XFC, XFD). If 0 is specified, then all available columns in the worksheet (after and including `FIRST_COLUMN`) are imported.
- `HEADER_ROW` (0-1, default: 1): Indicates whether the worksheet begins with a column header line. If the sheet contains a column header but not on the first line of the file, use the `FIRST_ROW` option to indicate how many rows to skip before the column header appears.
    - 0 = No column header. The generic column names `column1`, `column2`, etc. will be used.
    - 1 = A column header row exists.
- `TRUNCATE_EXISTING_TABLE` (0-1, default: 0): If the target table name exists, this option indicates whether the existing data rows should be deleted.
    - 0 = Keep existing rows and append new rows
    - 1 = Delete existing rows
- `TEMPORARY_TABLE` (0-1, default: 0): If the target table name does not exist, and therefore a new table will be created, this option indicates whether the new table will be a temporary table.
    - 0 = Use `CREATE TABLE`
    - 1 = Use `CREATE TEMPORARY TABLE`
- `IF_CONVERSION_FAILS` (1-3, default: 1): If data conversion fails (for instance, if a non-numeric value appears in the file in a column defined in the `IMPORT CSV` statement as `INTEGER`), this option controls what happens.
    - 1 = Import the value as plain text
    - 2 = Skip the data row
    - 3 = Abort with an error

## Examples

- Imports the first worksheet in "Workbook.xls" into a notebook table called `mytable`. Because no options are specified, it is assumed that the file has a column header on the first line. Because no column list is specified, all columns are imported as text and the original column names are preserved.

    ```
    IMPORT XLS 'C:\Workbook.xls' INTO mytable;
    ```

- The keywords `XLS` and `XLSX` are interchangeable and need not match the file's actual extension.

    ```
    IMPORT XLS 'C:\Workbook.xls' INTO tbl1;
    IMPORT XLSX 'C:\Workbook.xls' INTO tbl2;
    IMPORT XLS 'C:\Workbook.xlsx' INTO tbl3;
    IMPORT XLSX 'C:\Workbook.xlsx' INTO tbl4;
    ```

- Imports the first worksheet in the workbook.

    ```
    IMPORT XLS 'C:\Workbook.xls' WORKSHEET 1 INTO tbl1;
    ```

- Imports the worksheet named "Sheet1".

    ```
    IMPORT XLS 'C:\Workbook.xls' WORKSHEET 'Sheet1' INTO tbl1;
    ```

- The source columns (`foo, bar`) are explicitly specified. If the source file contains other columns besides those two, then they are not imported into the destination notebook table. If the source file does not contain the specified columns, then the import fails. If the destination table already exists and does not contain the specified column names, then the import fails.

    ```
    IMPORT XLS 'C:\Workbook.xls' INTO mytable (foo, bar);
    ```

- The source columns (`foo, bar`) and target columns (`aaa`, `bbb`) are explicitly specified.

    ```
    IMPORT XLS 'C:\Workbook.xls' INTO mytable (foo AS aaa, bar AS bbb);
    ```

- A data type conversion is specified for each source column. If the conversion fails (for instance, if a non-numeric value appears in the CSV file in the `bar` column), by default the value is imported as text. SQLite treats column types as suggestions, so the integer column can contain a text value.

    ```
    IMPORT XLS 'C:\Workbook.xls' INTO mytable (foo TEXT, bar INTEGER);
    ```

- A file that lacks a header row is imported with new names given to the unnamed source columns.

    ```
    IMPORT XLS 'C:\Workbook.xls' INTO mytable (column1 AS foo, column2 AS bar)
    OPTIONS (HEADER_ROW: 0);
    ```

- Various arguments to `IMPORT XLS` are provided in variables rather than using literal strings. This allows these names to be dynamically generated or otherwise determined at script runtime.

    ```
    IMPORT XLS @filename INTO @tablename (@old_col AS @new_col);
    ```
