# `TO_DATETIME` Function

Attempts to convert the *input* value to a date/time string formatted like "2016-07-23 22:12:55.652".

## Syntax

`TO_DATETIME` `(` *input* `)`

## Parameters

- *input* (text): The input string that can be parsed as a date and time.

## Return Value

A date string formatted like "2016-07-23 22:12:55.652".

## Examples

- Prints "2016-05-09 17:39:00.000".

    ```
    PRINT TO_DATETIME('2016/5/9 5:39 PM');
    ```

- Raises an error because "foobar" is not recognized as a valid date/time format.

    ```
    PRINT TO_DATETIME('foobar');
    ```
