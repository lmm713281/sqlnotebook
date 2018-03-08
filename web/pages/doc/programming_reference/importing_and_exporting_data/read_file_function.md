# `READ_FILE` Function

Reads a file line-by-line and returns it in a table. This function is used in the `FROM` clause of a `SELECT` statement and can participate in `JOIN`s as if it were a table.

## Syntax

`READ_FILE` `(` *filename* `,` *file-encoding* `)`

## Parameters

- *filename* (text): The absolute path to the text file to read.
- *file-encoding* (integer, optional, 0-65535, default: 0): Indicates the text encoding to use when reading the file. Specify 0 to detect the encoding automatically. Any nonzero integer is treated as a Windows code page number.

## Return Value

A table with the following columns:

Column name | Example value
--- | ---
`number` | 0
`line` | "First line of the file"

## Examples

- Returns a table containing the last 50 lines in "file.txt" in reverse order.

    ```
    SELECT * FROM READ_FILE('C:\temp\file.txt') ORDER BY number DESC LIMIT 50;
    ```

- Returns a table containing the contents of "ShiftJIS.txt", which is read using the Japanese Shift-JIS encoding (code page 932).

    ```
    SELECT * FROM READ_FILE('C:\ShiftJIS.txt', 932);
    ```
