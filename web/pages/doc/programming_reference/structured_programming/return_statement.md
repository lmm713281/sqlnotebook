# `RETURN` Statement

Ends script execution immediately. If an *expression* is provided, then that value is returned to the caller.  If no expression is provided, then `NULL` is returned.  

## Syntax

<railroad-diagram>
'RETURN',
Optional(
    NonTerminal('return-value')
)
</railroad-diagram>

## Parameters

- *expression* (optional): The value to be returned to the calling script, if any.

## Examples

- Ends the script and returns `NULL`.

    ```
    RETURN;
    ```

- Returns 3.

    ```
    RETURN 1 + 2;
    ```
