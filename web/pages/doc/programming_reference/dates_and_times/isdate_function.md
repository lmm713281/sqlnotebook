# `ISDATE` Function

Determines whether the specified value is a text string that can be parsed into a date/time with or without a time zone offset.

## Syntax

`ISDATE` `(` *value* `)`

## Parameters

- *value*: The value to inspect.

## Return Value

Returns 1 if *value* is a valid `DATE`, `DATETIME`, or `DATETIMEOFFSET` text, and returns 0 if not.

## Examples

- Prints 1.

    ```
    PRINT ISDATE('2016-03-07');
    ```

- Prints 0.

    ```
    PRINT ISDATE(1234);
    ```

- Prints 0.

    ```
    PRINT ISDATE('foo');
    ```

- Prints 1.

    ```
    PRINT ISDATE('2016-01-23 22:06:53.742 -04:00');
    ```
