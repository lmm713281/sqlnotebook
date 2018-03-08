# `TO_DATE` Function

Attempts to convert the *input* value to a date string formatted like "2016-07-23".

## Syntax

`TO_DATE` `(` *input* `)`

## Parameters

- *input* (text): The input string that can be parsed as a date.

## Return Value

A date string formatted like "2016-07-23".

## Examples

- Prints "2016-05-09".

    ```
    PRINT TO_DATE('2016/5/9 5:39 PM');
    ```

- Raises an error because "foobar" is not recognized as a valid date/time format.

    ```
    PRINT TO_DATE('foobar');
    ```
