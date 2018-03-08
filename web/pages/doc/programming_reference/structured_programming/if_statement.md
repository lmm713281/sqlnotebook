# `IF` Statement

Takes one code path or the other based on an SQL expression. The *condition* expression must evaluate to the integer 0 or 1.

## Syntax

<railroad-diagram>
Stack(
    Sequence(
        'IF',
        NonTerminal('condition'),
        Choice(0,
            Sequence(
                'BEGIN',
                ZeroOrMore(
                    NonTerminal('statement-if-true')
                ),
                'END'
            ),
            NonTerminal('statement-if-true')
        )
    ),
    Sequence(
        Optional(
            Sequence(
                'ELSE',
                Choice(0,
                    Sequence(
                        'BEGIN',
                        ZeroOrMore(
                            NonTerminal('statement-if-false')
                        ),
                        'END'
                    ),
                    NonTerminal('statement-if-false')
                )
            ),
            'skip'
        )
    )
)
</railroad-diagram>

## Parameters

- *condition* (integer, 0 or 1): If this expression evaluates to 1, then the *statement-if-true* statements are executed.  Otherwise, the *statement-if-false* statements are executed.
- *statement-if-true* (statement): The statements to execute if the condition is 1.  If more than one *statement-if-true* statement is desired, the `BEGIN` and `END` keywords must be used.
- *statement-if-false* (statement): The statements to execute if the condition is 0.  If more than one *statement-if-false* statement is desired, the `BEGIN` and `END` keywords must be used.

## Examples

- Prints "Hi".

    ```
    IF 1
        PRINT 'Hi';
    ```

- Prints nothing.

    ```
    IF 0
        PRINT 'Hi';
    ```

- Prints "Foo".

    ```
    IF 1 + 1 = 2
        PRINT 'Foo'
    ELSE
        PRINT 'Bar';
    ```

- Prints "C" and "D".

    ```
    IF 2 > 3 BEGIN
        PRINT 'A';
        PRINT 'B';
    END ELSE BEGIN
        PRINT 'C';
        PRINT 'D';
    END
    ```

- Prints whether the variable `@x` is "foo", "bar", or neither.

    ```
    IF @x = 'foo'
        PRINT 'x is foo'
    ELSE IF @x = 'bar'
        PRINT 'x is bar'
    ELSE
        PRINT 'x is neither foo nor bar'
    ```
