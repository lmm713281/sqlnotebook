# `ARRAY_GET` Function

Retrieves the element at the specified index in an array.

## Syntax

`ARRAY_GET` `(` *array* `,` *element-index* `)`

## Parameters

- *array* (blob): The array from which to read an element.
- *element-index* (integer): Zero-based index into the array.

## Return Value

The specified array element, or `NULL` if the index is outside the bounds of the array.

## Examples

- Prints 3.

    ```
    PRINT ARRAY_GET(ARRAY(1, 2, 3), 2);
    ```

- Assigns `NULL` to `@x`.

    ```
    DECLARE @x = ARRAY_GET(ARRAY(1, 2, 3), 10);
    ```
