# `DATEFROMPARTS` Function

Returns a string formatted like "2015-12-25" based on the provided year, month, and day values.

## Syntax

`DATEFROMPARTS` `(` *year* `,` *month* `,` *day* `)`

## Parameters

- *year* (integer): Four-digit year.
- *month* (integer, 1-12): Calendar month specified as a 1-based integer.
- *day* (integer, 1-31): Day of the month specified as a 1-based integer.

## Return Value

A string formatted like "2015-12-25".

## Examples

- Prints "2015-01-02".

    ```
    PRINT DATEFROMPARTS(2015, 1, 2);
    ```
