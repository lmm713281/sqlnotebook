# `DATE_TRUNC` Function

Returns a new date by finding the nearest specified calendar or clock division prior to the specified source date.

## Syntax

`DATE_TRUNC` `(` *date-part* `,` *date* `)`

## Parameters

- *date-part* (text): One of the following predefined strings:
    - `year`, `yy`, `yyyy`
    - `quarter`, `qq`, `q`
    - `month`, `mm`, `m`
    - `dayofyear`, `dy`, `y`
    - `day`, `dd`, `d`
    - `week`, `wk`, `ww`
    - `weekday`, `dw`
    - `hour`, `hh`
    - `minute`, `mi`, `n`
    - `second`, `ss`, `s`
    - `millisecond`, `ms`
    - `tzoffset`, `tz`
- *date* (date/time text): A text value that can be parsed into a date/time with time zone offset. If no time zone is specified in the string, then the system's local time zone is assumed.

## Return Value

A date/time with time zone offset (i.e. a string like "2016-07-23 21:00:00.000 -04:00"), calculated by finding the nearest specified time division prior to the specified *date*.

## Examples

- Prints a date in the system's local time zone like "2016-07-01 00:00:00.000 -04:00".

    ```
    PRINT DATE_TRUNC('month', '2016-07-23 12:23:00');
    ```

- Prints "2015-08-02 00:00:00.000 +05:00".

    ```
    PRINT DATE_TRUNC('week', '2015-08-03 12:41:25 +5');
    ```

- Prints "2015-02-03 12:00:00.000 +02:30".

    ```
    PRINT DATE_TRUNC('hh', '2015-02-03 12:41:25 +2:30');
    ```
