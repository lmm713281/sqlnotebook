# `ARRAY_APPEND` Function

Creates a new array by copying an existing array and appending one or more elements to the end. The existing array is not modified.

## Syntax

`ARRAY_APPEND` `(` *array* `,` *value* `,` ... `)`

## Parameters

- *array* (blob): The existing array to copy.
- *value*, ... : The values (one or more) to append to the array.

## Return Value

The new array, with the new values appended to the end.

## Examples

- Assigns a 4-element array containing 1, 2, 3, 4 to `@b`.

    ```
    DECLARE @a = ARRAY(1, 2);
    DECLARE @b = ARRAY_APPEND(@a, 3, 4)
    ```
