# `YEAR` Function

Returns the year part of a date/time string.

## Syntax

`YEAR` `(` *date* `)`

## Parameters

- *date* (date/time text): A text value that can be parsed into a date/time.

## Return Value

An integer representing the specified year.

## Examples

- Prints 2016.

    ```
    PRINT YEAR('2016-03-07');
    ```

- Prints 2015.

    ```
    PRINT YEAR('2015-07-23 22:06:53.742 -04:00');
    ```
