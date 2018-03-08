# `ARRAY_COUNT` Function

Returns the number of elements in a given array.

## Syntax

`ARRAY_COUNT` `(` *array* `)`

## Parameters

- *array* (blob): The array in question.

## Return Value

The number of elements in *array*.

## Examples

- Prints 3.

    ```
    DECLARE @a = ARRAY('A', 'B', 'C');
    PRINT ARRAY_COUNT(@a);
    ```
