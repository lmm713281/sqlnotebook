# `LIST_XLS_WORKSHEETS` Function

Returns a table containing the names and index numbers of the worksheets in a particular Excel workbook. The workbook may be in `.XLS` or `.XLSX` format. This is a table-valued function that can be used in the `FROM` clause of a `SELECT` statement and can participate in `JOIN`s as if it were a table.

## Syntax

`LIST_XLS_WORKSHEETS` `(` *file-path* `)`

## Parameters

- *file-path* (text): The absolute path of the `.XLS` or `.XLSX` workbook to inspect.

## Return Value

A table with the following columns:

Column name | Description | Example value
--- | --- | ---
`number` | 1-based index | 1
`name` | Worksheet name | "Sheet1"

## Examples

- Returns a table listing all the worksheets in the "Workbook.xls" file.

    ```
    SELECT * FROM LIST_XLS_WORKSHEETS('C:\Workbook.xls');
    ```

- Returns the name of the second worksheet in "Workbook.xls", or an empty table if there are fewer than 2 worksheets in the workbook.

    ```
    SELECT name FROM LIST_XLS_WORKSHEETS('C:\Workbook.xls') WHERE number = 2;
    ```
