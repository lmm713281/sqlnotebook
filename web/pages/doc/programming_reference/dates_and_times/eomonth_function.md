# `EOMONTH` Function

Returns the last day of the month containing the specified date.

## Syntax

`EOMONTH` `(` *date* `,` *months-to-add* `)`

## Parameters

- *date* (date/time text): A text value that can be parsed into a date/time.
- *months-to-add* (integer, optional): If specified, this number of months is added to *date* before calculating the last day of the containing month.

## Return Value

A date string formatted like "2016-02-29".

## Examples

- Prints "2016-03-31".

    ```
    PRINT EOMONTH('2016-03-07');
    ```

- Prints "2016-04-30".

    ```
    PRINT EOMONTH('2016-03-07', 1);
    ```

- Prints "2016-02-29".

    ```
    PRINT EOMONTH('2016-03-07', -1);
    ```
    
- Prints "2016-01-31".

    ```
    PRINT EOMONTH('2016-01-23 22:06:53.742 -04:00');
    ```
