# `ARRAY_SET` Function

Creates a new array by copying an existing array and replacing one of the elements. The existing array is not modified.

## Syntax

`ARRAY_SET` `(` *array* `,` *element-index* `,` *value* `)`

## Parameters

- *array* (blob): The existing array to copy.
- *element-index* (integer): Zero-based index into the array, specifying which element to replace.
- *value*: The replacement value.

## Return Value

The new array, with the element at index *element-index* replaced with *value*.

## Examples

- Assigns a 3-element array containing 1, 2, 5 to `@x`.

    ```
    DECLARE @x = ARRAY_SET(ARRAY(1, 2, 3), 2, 5);
    ```

- Raises an error because the *element-index* is out of the array's bounds.

    ```
    DECLARE @x = ARRAY_SET(ARRAY(1, 2, 3), 10, 5);
    ```
 
