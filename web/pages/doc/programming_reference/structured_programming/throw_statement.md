# `THROW` Statement

Throws an error, causing code execution to jump to an enclosing [`CATCH`](try_catch_statement.html) block.

## Syntax

<railroad-diagram>
'THROW',
Optional(
    NonTerminal('error-message')
)
</railroad-diagram>

## Parameters

- *error-message* (optional): The values to be returned from the [`ERROR_MESSAGE`](error_message_function.html) function. If not provided, then the value from the last thrown error is retained; this allows a `CATCH` block to re-throw an error without changing it.

## Examples

- Throws an error such that `ERROR_MESSAGE()` returns "Oops".

    ```
    THROW 'Oops';
    ```

- Re-throws the last thrown error without changing it.

    ```
    THROW;
    ```
