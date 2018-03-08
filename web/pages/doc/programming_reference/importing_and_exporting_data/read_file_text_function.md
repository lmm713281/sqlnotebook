# `READ_FILE_TEXT` Function

Reads the contents of a text file and returns it as a single string representing the whole file.

## Syntax

`READ_FILE_TEXT` `(` *filename* `,` *file-encoding* `)`

## Parameters

- *filename* (text): The absolute path to the text file to read.
- *file-encoding* (integer, optional, 0-65535, default: 0): Indicates the text encoding to use when reading the file. Specify 0 to detect the encoding automatically. Any nonzero integer is treated as a Windows code page number.

## Return Value

The text contents of the file.

## Examples

- Reads the contents of "MyFile.txt" into a text variable called `@data`. Because the _file-encoding_ parameter is not specified, the UTF-8 encoding is used to read the file.

    ```
    DECLARE @data = READ_FILE_TEXT('C:\MyFile.txt');
    ```

- Produces a 1-row query result containing the contents of "ShiftJIS.txt", which is read using the Japanese Shift-JIS encoding (code page 932).

    ```
    SELECT READ_FILE_TEXT('C:\ShiftJIS.txt', 932) AS data;
    ```
