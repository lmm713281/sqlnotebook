# `ISNUMERIC` Function

Determines whether a given value is or can be converted to a numeric data type.

## Syntax

`ISNUMERIC` `(` *value* `)`

## Parameters

- *value*: The value to inspect.

## Return Value

If the value can be converted to a numeric data type, then 1 is returned. If not, then 0 is returned.

## Examples

- Prints 0.

    ```
    PRINT ISNUMERIC('A');
    ```

- Prints 1.

    ```
    PRINT ISNUMERIC('123');
    ```

- Prints 1.

    ```
    PRINT ISNUMERIC(3.14);
    ```
