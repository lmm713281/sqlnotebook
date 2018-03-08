# `CHOOSE` Function

Returns one of the arguments, as specified by numeric index in the first argument.

## Syntax

`CHOOSE` ( *index* `,` *value1* `,` *value2* `,` ... `)`

## Parameters

- *index* (integer): A 1-based index into the list of values to follow.
- *value1*, *value2*, ... : The values to choose from.

## Return Value

If *index* is between 1 and the number of *value* arguments, then the corresponding *value* argument is returned. If the *index* is out of bounds, `NULL` is returned.

## Examples

- Prints "A".

    ```
    PRINT CHOOSE(1, 'A', 'B');
    ```

- Prints 333.

    ```
    PRINT CHOOSE(3, 111, 222, 333);
    ```

- Assigns `NULL` to `@x`.

    ```
    DECLARE @x = CHOOSE(5, 111, 222, 333);
    ```
