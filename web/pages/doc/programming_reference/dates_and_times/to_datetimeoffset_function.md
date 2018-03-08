# `TO_DATETIMEOFFSET` Function

Attempts to convert the *input* value to a date/time string formatted like "2016-08-06 22:11:30.948 -04:00".

## Syntax

`TO_DATETIME` `(` *input* `)`

## Parameters

- *input* (text): The input string that can be parsed as a date and time.

## Return Value

A date string formatted like "2016-08-06 22:11:30.948 -04:00".

## Examples

- Prints "2016-05-09 17:39:00.000 -04:00" where the time zone is the system's local time zone.

    ```
    PRINT TO_DATETIMEOFFSET('2016/5/9 5:39 PM');
    ```

- Prints "2016-05-09 17:39:00.000 +03:00".

    ```
    PRINT TO_DATETIMEOFFSET('2016/5/9 5:39 PM +3');
    ```

- Raises an error because "foobar" is not recognized as a valid date/time format.

    ```
    PRINT TO_DATETIMEOFFSET('foobar');
    ```
