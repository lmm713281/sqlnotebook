# `ARRAY_INSERT` Function

Creates a new array by copying an existing array and inserting one or more elements. The existing array is not modified.

## Syntax

`ARRAY_INSERT` `(` *array* `,` *element-index* `,` *value* `,` ... `)`

## Parameters

- *array* (blob): The existing array to copy.
- *element-index* (integer): Zero-based index into the array, specifying where to insert the new elements. If *element-index* equals the length of the array (i.e. one index past the last element) then the value is appended to the array.
- *value*, ... : The values to insert at the specified location.

## Return Value

The new array, with the new values inserted at index *element-index*.

## Examples

- Assigns a 4-element array containing 1, 2, 99, 3 to `@x`.

    ```
    DECLARE @x = ARRAY_INSERT(ARRAY(1, 2, 3), 2, 99);
    ```

- Assigns a 4-element array containing 1, 2, 3, 99 to `@x`.

    ```
    DECLARE @x = ARRAY_INSERT(ARRAY(1, 2, 3), 3, 99);
    ```

- Assigns a 4-element array containing 99, 1, 2, 3 to `@x`.

    ```
    DECLARE @x = ARRAY_INSERT(ARRAY(1, 2, 3), 0, 99);
    ```

- Raises an error because the *element-index* is out of the array's bounds.

    ```
    DECLARE @x = ARRAY_INSERT(ARRAY(1, 2, 3), 10, 5);
    ```
