# `MONTH` Function

Returns the month part of a date/time string, represented as an integer 1-12\.

## Syntax

`MONTH` `(` *date* `)`

## Parameters

- *date* (date/time text): A text value that can be parsed into a date/time.

## Return Value

An integer representing the month.

## Examples

- Prints 3.

    ```
    PRINT MONTH('2016-03-07');
    ```

- Prints 7.

    ```
    PRINT MONTH('2016-07-23 22:06:53.742 -04:00');
    ```
