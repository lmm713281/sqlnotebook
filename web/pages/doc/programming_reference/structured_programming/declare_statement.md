# `DECLARE` Statement

Creates a new variable. Variables must be declared before use. Variables have script scope. That is, the variable can be used anywhere else in the script, but it will not be visible to other scripts called using [`EXECUTE`](execute_statement.html), nor to the parent script if this script was itself called with `EXECUTE`. Variable names must begin with an at sign (`@`), dollar sign (`$`), or colon (`:`).

If the `PARAMETER` keyword is used, then the variable becomes a parameter to the script. If the script is called using `EXECUTE`, then the caller must provide a value for this parameter unless the `DECLARE PARAMETER` statement specifies an *initial-value*.

If the `DECLARE` statement does not include the `PARAMETER` keyword and does not specify an *initial-value*, then the variable takes the initial value of `NULL`.

Unlike other popular SQL scripting languages, SQL Notebook's `DECLARE` statement does not require a data type to be specified. Variables follow the SQLite convention of allowing any data type to be stored.

## Syntax

<railroad-diagram>
'DECLARE',
Optional('PARAMETER', 'skip'),
NonTerminal('variable-name'),
Optional(
    Sequence(
        '=',
        NonTerminal('initial-value')
    )
)
</railroad-diagram>

## Parameters

- `PARAMETER` (optional keyword): If specified, then the variable is a parameter to the script, for which callers using the `EXECUTE` statement can specify an argument value. If the *initial-value* argument is specified, then the parameter is optional and may be omitted by `EXECUTE` callers. If no *initial-value* is specified, then callers must provide an argument value for this parameter.
- *variable-name* (variable identifier): A name beginning with an at sign (`@`), dollar sign (`$`), or colon (`:`). The name must not have been previously declared in this script. To change the value of an existing variable, use the `SET` statement.
- *initial-value*: If provided, the variable will be assigned this value. It may be a scalar expression or a parentheses-enclosed `SELECT` statement. If not provided, the variable will be assigned a value of `NULL`. The value can be changed after declaration using the `SET` statement.

## Examples

- Creates a variable called `@myvar` and assigns it a value of 3.

    ```
    DECLARE @myvar = 1 + 2;
    ```

- Creates a variable called `@num` and sets it to the number of rows in `mytable`.

    ```
    DECLARE @num = (SELECT COUNT(*) FROM mytable);
    ```

- Creates a variable called `@foo` and sets it to `NULL`.

    ```
    DECLARE @foo;
    ```

- Creates a parameter variable called `@requiredParam`. Because there is no *initial-value* specified, the caller must provide a value for this parameter.

    ```
    DECLARE PARAMETER @requiredParam;
    ```

- Creates a parameter variable called `@optionalParam`. Because an *initial-value* of 5 is specified, the caller is not required to provide a value for this parameter, but may do so if it wants to override the default value.

    ```
    DECLARE PARAMETER @optionalParam = 5;
    ```
