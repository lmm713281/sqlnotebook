# `DATETIMEOFFSETFROMPARTS` Function

Returns a string formatted like "2015-12-25 06:54:47.152 -04:00" based on the provided date, time, and time zone offset values.

## Syntax

`DATETIMEOFFSETFROMPARTS` `(` *year* `,` *month* `,` *day* `,` *hour* `,` *minute* `,` *second* `,` *millisecond* `,`  
*hour-offset* `,` *minute-offset* `)`

## Parameters

- *year* (integer): Four-digit year.
- *month* (integer, 1-12): Calendar month specified as a 1-based integer.
- *day* (integer, 1-31): Day of the month specified as a 1-based integer.
- *hour* (integer, 0-23): Clock hour expressed as a 0-based integer in 24-hour time.
- *minute* (integer, 0-59): Clock minute.
- *second* (integer, 0-59): Clock second.
- *millisecond* (integer, 0-999): Clock millisecond.
- *hour-offset* (integer): The hour part of the time zone offset. May be positive or negative.
- *minute-offset* (integer): The minute part of the time zone offset. The sign of *minute-offset* must match the sign of *hour-offset*, or else an incorrect time zone offset will be calculated.

## Return Value

A date/time string with time zone offset formatted like "2015-01-02 05:45:30.123 -04:00".

## Examples

- Prints "2015-01-02 05:45:30.123 -05:30".

    ```
    PRINT DATETIMEOFFSETFROMPARTS(2015, 1, 2, 5, 45, 30, 123, -5, -30);
    ```
