# `LIST_FILES` Function

Returns a table containing the files in a particular folder, optionally recursing into subfolders. If a folder cannot be accessed, then it is skipped silently. This function is used in the `FROM` clause of a `SELECT` statement and can participate in `JOIN`s as if it were a table.

## Syntax

`LIST_FILES` `(` *root-path* `,` *recursive* `)`

## Parameters

- *root-path* (text): The absolute path of the folder on disk in which to search for files.
- *recursive* (integer, optional): If specified as non-zero, then all files in all subdirectories, recursively, will be returned.

## Return Value

A table with the following columns:

Column name | Example value
--- | ---
`file_path` | "C:\\Temp\\file1.csv"
`folder` | "C:\\Temp"
`filename` | "file1.csv"
`extension` | ".csv"
`modified_date` | "2016-04-03 22:05:14.790 -04:00"

## Examples

- Returns a table listing all the files in the root C:\\ directory.

    ```
    SELECT * FROM LIST_FILES('C:\');
    ```

- Returns a table listing the first 50 file paths in the C:\Users\ directory and all subdirectories within it, recursively.

    ```
    SELECT file_path FROM LIST_FILES('C:\Users\', 1) LIMIT 50;
    ```
