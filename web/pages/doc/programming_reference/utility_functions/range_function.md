# `RANGE` Function

Returns a table containing a list of *count* integers. The first number is *start*, and the following numbers are produced by successively incrementing by *step* (1 by default). This function is used in the `FROM` clause of a `SELECT` statement and can participate in `JOIN`s as if it were a table.

## Syntax

`RANGE` `(` *start* `,` *count* `,` *step* `)`

## Parameters

- *start* (integer): The first number.
- *count* (integer): Specifies how many rows to return in the table.
- *step* (integer, optional): Specifies the increment used to produce each new value in the list. By default, a step of 1 is used, which generates consecutive integers.

## Return Value

A table with a single column named `number`.

## Examples

- Returns a 10-row table containing the numbers 1 through 10 in ascending order.

    ```
    SELECT number FROM RANGE(1, 10);
    ```

- Returns a 10-row table containing the numbers 10 through 1 in descending order.

    ```
    SELECT number FROM RANGE(10, 10, -1);
    ```

- Another way to generate a 10-row table containing the numbers 10 through 1 in descending order.

    ```
    SELECT number FROM RANGE(1, 10) ORDER BY number DESC;
    ```
