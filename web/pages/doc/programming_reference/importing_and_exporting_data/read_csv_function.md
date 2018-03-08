# `READ_CSV` Function

Reads a CSV file line-by-line and returns it in a table.

This table-valued function is used in the `FROM` clause of a `SELECT` statement and can participate in `JOIN`s as if it were a table. However, it cannot be used in a `CREATE TRIGGER` statement. Internally, the `READ_CSV` function is translated into an `IMPORT CSV` statement that runs prior to the statement that contains the `READ_CSV` call.

## Syntax

`READ_CSV` `(` *file-path* `,` *has-header-row* `,` *skip-lines* `,` *file-encoding* `)`

## Parameters

- *file-path* (text): The absolute path to the CSV file to read.
- *has-header-row* (integer, optional, 0-1, default: 1): Indicates whether the CSV file begins with a column header line. If the file contains a column header but not on the first line of the file, use the *skip-lines* parameter to indicate how many lines to skip before the column header appears.
    - 0 = No column header. The generic column names `column1`, `column2`, etc. will be used.
    - 1 = A column header row exists.
- *skip-lines* (integer, optional, default: 0): Indicates how many initial lines should be skipped in the input file. This is used if the column header (or the data if there is no column header) does not appear on the first line of the file.
- *file-encoding* (integer, optional, 0-65535, default: 0): Indicates the text encoding to use when reading the file. Specify 0 to detect the encoding automatically. Any nonzero integer is treated as a Windows code page number.

## Return Value

A table with columns defined by the input file.

## Examples

- Returns a table containing the first 50 rows in "file.csv", with column names taken from the first line in the file.

    ```
    SELECT * FROM READ_CSV('C:\file.csv') LIMIT 50;
    ```

- Returns a table containing the contents of "ShiftJIS.csv", which is read using the Japanese Shift-JIS encoding (code page 932). The default values for *has-header-row* (1) and *skip-lines* (0) are used.  

    ```
    SELECT * FROM READ_CSV('C:\ShiftJIS.csv', 1, 0, 932);
    ```
