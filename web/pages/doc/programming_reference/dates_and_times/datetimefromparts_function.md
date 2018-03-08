# `DATETIMEFROMPARTS` Function

Returns a string formatted like "2015-12-25 06:54:47.152" based on the provided date and time values.

## Syntax

`DATETIMEFROMPARTS` `(` *year* `,` *month* `,` *day* `,` *hour* `,` *minute* `,` *second* `,` *millisecond* `)`

## Parameters

- *year* (integer): Four-digit year.
- *month* (integer, 1-12): Calendar month specified as a 1-based integer.
- *day* (integer, 1-31): Day of the month specified as a 1-based integer.
- *hour* (integer, 0-23): Clock hour expressed as a 0-based integer in 24-hour time.
- *minute* (integer, 0-59): Clock minute.
- *second* (integer, 0-59): Clock second.
- *millisecond* (integer, 0-999): Clock millisecond.

## Return Value

A date/time string (without time zone offset) formatted like "2015-01-02 05:45:30.123".

## Examples

- Prints "2015-01-02 05:45:30.123".

    ```
    PRINT DATETIMEFROMPARTS(2015, 1, 2, 5, 45, 30, 123)
    ```
