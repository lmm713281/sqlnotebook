# `SET` Statement

Assigns a new value to a previously declared variable. The new value does not need to be of the same type as the previous value. It is an error to assign a value to an undeclared variable. Use the [`DECLARE`](declare_statement.html) statement to declare variables.

## Syntax

<railroad-diagram>
'SET',
NonTerminal('variable-name'),
'=',
NonTerminal('new-value')
</railroad-diagram>

## Parameters

- *variable-name* (variable identifier): A name beginning with an at sign (`@`), dollar sign (`$`), or colon (`:`). The name must have been previously declared in this script.
- *new-value*: The value to assign to the variable. It may be a scalar expression or a parentheses-enclosed `SELECT` statement.

## Examples

- Assign 3 to the previously-declared variable called `@myvar`.

    ```
    SET @myvar = 1 + 2;
    ```

- Sets the variable `@num` to the number of rows in `mytable`.

    ```
    SET @num = (SELECT COUNT(*) FROM mytable);
    ```
