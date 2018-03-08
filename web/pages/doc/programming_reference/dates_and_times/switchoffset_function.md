# `SWITCHOFFSET` Function

Changes the time zone offset of a date/time string without affecting the date and time parts. For instance, the string "2016-07-23 22:21:35.870 -04:00" can be converted to "2016-07-23 22:21:35.870 +05:30", using a new time zone offset of "+05:30". This function is intended for use when a date/time was wrongly imported with an incorrect time zone, and the user wishes to change the time zone offset without changing the date and time part of the string.

## Syntax

`SWITCHOFFSET` `(` *date* `,` *time-zone* `)`

## Parameters

- *date* (date/time text): A text value that can be parsed into a date/time with time zone offset. If no time zone is specified in the string, then the system's local time zone is assumed.
- *time-zone* (integer or text): The new time zone offset. If *time-zone* is an integer, then it is the total number of minutes in the offset (i.e. a time zone of "-04:00" is represented as -240). If *time-zone* is a string, then it is a time zone offset formatted like "-04:30" or "+05:15".

## Return Value

Returns a date/time string containing the original date and time with the new time zone offset.

## Examples

- Prints "2016-07-23 22:27:29.940 +04:00".

    ```
    PRINT SWITCHOFFSET('2016-07-23 22:27:29.940 -06:00', '+04:00');
    ```

- Prints "2016-07-23 22:27:29.940 -04:00".

    ```
    PRINT SWITCHOFFSET('2016-07-23 22:27:29.940 -06:00', -240);
    ```
