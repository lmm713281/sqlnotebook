# `DATEDIFF` Function

Returns the number of calendar or clock boundaries crossed between two dates. A calendar boundary is a transition from one day to the next, from one month to the next, etc. A clock boundary is a transition from one hour of the day to the next, one minute of the day to the next, etc.

## Syntax

`DATEDIFF` `(` *date-part* `,` *start-date* `,` *end-date* `)`

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
- *start-date* (date/time text): A text value that can be parsed into a date/time with time zone offset. If no time zone is specified in the string, then the system's local time zone is assumed.
- *end-date* (date/time text): A text value that can be parsed into a date/time with time zone offset. If no time zone is specified in the string, then the system's local time zone is assumed.

## Return Value

An integer representing the number of the specified *date-part* boundaries that are crossed between *start-date* and *end-date*.

## Examples

- Prints 1.

    ```
    PRINT DATEDIFF('day', '2016-03-04 03:53', '2016-03-05 11:53');
    ```
    
- Prints 1.

    ```
    PRINT DATEDIFF('hh', '2016-01-01 03:59', '2016-01-01 04:01');
    ```
    
- Prints 0.

    ```
    PRINT DATEDIFF('hh', '2016-01-01 03:50', '2016-01-01 03:52');
    ```
    
- Prints 2.

    ```
    PRINT DATEDIFF('hh', '2016-07-23 21:25 -04:00', '2016-07-23 21:25 -06:00');
    ```
