# `DAY` Function

Returns the day-of-month part of a date/time string.

## Syntax

`DAY` `(` *date* `)`

## Parameters

- *date* (date/time text): A text value that can be parsed into a date/time.

## Return Value

An integer representing the specified day of the month.

## Examples

- Prints 7.

    ```
    PRINT DAY('2016-03-07');
    ```

- Prints 23.

    ```
    PRINT DAY('2016-07-23 22:06:53.742 -04:00');
    ```
  
