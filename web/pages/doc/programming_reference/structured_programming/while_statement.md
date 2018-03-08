# `WHILE` Statement

Repeatedly executes the provided statements as long as the *condition* expression evaluates to the integer 1.  

The loop may be terminated without regard to the expression by using the [`BREAK`](break_statement.html) statement. The loop may be restarted by using the [`CONTINUE`](continue_statement.html) statement.

## Syntax

<railroad-diagram>
'WHILE',
NonTerminal('condition'),
Choice(0,
    Sequence(
        'BEGIN',
        ZeroOrMore(
            NonTerminal('statement')
        ),
        'END'
    ),
    NonTerminal('statement')
)
</railroad-diagram>

## Parameters

- *condition* (integer, 0 or 1): If this expression evaluates to 1, then the *statement* statements are executed.  Otherwise, the loop is terminated.
- *statement* (statement): The statements to execute if the condition is 1.  If more than one *statement* is desired, the `BEGIN` and `END` keywords must be used.

## Examples

- Prints the numbers 1 to 10 in increasing order.

    ```
    DECLARE @counter = 1;
    WHILE @counter <= 10 BEGIN
        PRINT @counter;
        SET @counter = @counter + 1;
    END
    ```
