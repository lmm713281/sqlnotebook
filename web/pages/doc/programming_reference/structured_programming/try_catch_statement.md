# `TRY` ... `CATCH` Statement

Executes the *statement-to-try* statements in order until successful completion or until one of the statements throws an error. If an error is thrown, then *statement-if-error* statements are executed. The statements in the `CATCH` block may use the [`ERROR_MESSAGE`](error_message_function.html) function to access the thrown error message.

## Syntax

<railroad-diagram>
Stack(
    Sequence(
        'BEGIN',
        'TRY',
        ZeroOrMore(
            NonTerminal('statement-to-try')
        ),
        'END',
        'TRY'
    ),
    Sequence(
        'BEGIN',
        'CATCH',
        ZeroOrMore(
            NonTerminal('statement-if-error')
        ),
        'END',
        'CATCH'
    )
)
</railroad-diagram>

## Parameters

- *statement-to-try* (statement): The statements to execute. These statements may [`THROW`](throw_statement.html) an error, causing execution to divert to the *statement-if-error* statements.
- *statement-if-error* (statement): The statements to execute if any *statement-to-try* throws an error. These statements may use the [`ERROR_MESSAGE`](error_message_function.html) function to access the thrown error message.

## Examples

- Prints "Foo".

    ```
    BEGIN TRY
        THROW 'Foo';
    END TRY
    BEGIN CATCH
        PRINT ERROR_MESSAGE();
    END CATCH
    ```
