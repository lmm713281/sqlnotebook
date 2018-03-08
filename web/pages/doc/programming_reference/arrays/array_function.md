# `ARRAY` Function

Creates an array from the specified arguments. Arrays are encoded as blobs. They can be stored in tables and variables and passed as arguments to functions, just like any other value. Large arrays should be avoided for performance reasons; for large amounts of data, consider using a dedicated table.

## Syntax

`ARRAY` `(` *value* `,` ... `)`

## Parameters

- *value*, ... : The values to include in the array.

## Return Value

A blob value containing the encoded array.

## Examples

- Assigns a 3-item array to the variable `@data`.

    ```
    DECLARE @data = ARRAY(1, 2, 3);
    ```

- Prints 3.

    ```
    PRINT ARRAY_GET(ARRAY(1, 2, 3), 2)
    ```
