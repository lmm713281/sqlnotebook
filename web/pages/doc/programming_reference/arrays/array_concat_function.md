# `ARRAY_CONCAT` Function

Creates a string by concatenating the elements of an array together with an optional separator.

## Syntax

`ARRAY_CONCAT` `(` *array* `,` *separator* `)`

## Parameters

- *array* (blob): The array whose elements will be concatenated together.
- *separator* (string, optional): If provided, the array elements will be separated using this string. By default there is no separator.

## Return Value

A string formed by concatenating the elements of *array* using an optional *separator*.

## Examples

- Prints "ABC".

    ```
    DECLARE @a = ARRAY('A', 'B', 'C');
    PRINT ARRAY_CONCAT(@a);
    ```

- Prints "1|2|3".

    ```
    PRINT ARRAY_CONCAT(ARRAY(1, 2, 3), '|');
    ```
