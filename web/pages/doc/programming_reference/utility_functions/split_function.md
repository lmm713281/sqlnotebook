# `SPLIT` Function

Splits a string by a caller-specified separator and either returns the substrings as an array, or returns one specific substring.

## Syntax

`SPLIT` `(` *text* `,` *separator* `,` *which-substring* `)`

## Parameters

- *text* (text): The string to split up.
- *separator* (text): The string that separates each substring in *text*.
- *which-substring* (optional, non-negative integer): The index of the substring to return. A *which-substring* value of 0 will return the first substring, 1 will return the second substring, and so on. If no such substring exist in the original string, then `NULL` is returned.

## Return Value

If *which-substring* is provided, then the specified substring is returned. If it is not provided, then an array of all the substrings is returned.

## Examples

- Assigns "BBB" to the variable `@data`.

    ```
    DECLARE @data = SPLIT('AAA|BBB|CCC', '|', 1);
    ```

- Assigns `NULL` to the variable `@data`.

    ```
    DECLARE @data = SPLIT('AAA|BBB|CCC', '|', 5);
    ```

- Assigns 3 to the variable `@data`.

    ```
    DECLARE @data = ARRAY_COUNT(SPLIT('AAA|BBB|CCC', '|'));
    ```
