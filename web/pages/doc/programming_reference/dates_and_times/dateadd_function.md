# `DATEADD` Function

Returns a new date by adding a specified time interval to an existing date.

## Syntax

`DATEADD` `(` *date-part* `,` *number* `,` *date* `)`

## Parameters

- *date-part* (text): One of the following predefined strings. Each *date-part* has abbreviated aliases that can be used in place of the longer names without affecting the behavior.
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
- *number* (integer): The value added to the specified part of the date.
- *date* (date/time text): A text value that can be parsed into a date/time with time zone offset. If no time zone is specified in the string, then the system's local time zone is assumed.

## Return Value

A date/time with time zone offset (i.e. a string like "2016-07-23 21:13:23.350 -04:00"), calculated by adding *number* to the part of *date* that is specified by *date-part*.

## Examples

- Prints a date in the system's local time zone like "2016-08-23 00:00:00.000 -04:00".

    ```
    PRINT DATEADD('month', 1, '2016-07-23');
    ```
    
- Prints "2015-01-29 12:41:25.000 +05:00".

    ```
    PRINT DATEADD('day', -5, '2015-02-03 12:41:25 +5');
    ```
    
- Prints "2015-02-05 16:41:25.000 +02:30".

    ```
    PRINT DATEADD('hh', 52, '2015-02-03 12:41:25 +2:30');
    ```
