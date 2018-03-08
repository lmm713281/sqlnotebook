# `ARRAY_MERGE` Function

Creates a new array by merging two or more arrays, in order.

## Syntax

`ARRAY_MERGE` `(` *array1* `,` *array2* `,` ... `)`

## Parameters

- *array1*, *array2*, ... (blob): The arrays to merge together.

## Return Value

A new array formed by merging the arrays together.

## Examples

- Assigns a 4-element array to `@x` containing 1, 2, 3, 4.

    ```
    DECLARE @x = ARRAY_MERGE(ARRAY(1, 2), ARRAY(3, 4));
    ```
