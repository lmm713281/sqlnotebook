# `EXECUTE` Statement

Executes the script called *script-name*, which may be enclosed in quotes if the script name contains spaces or special characters. If a *result-variable* is specified, then that variable will contain the scalar value, if any, returned from the script. The *result-variable* does not need to be declared beforehand; the `EXECUTE` statement itself will declare the variable if it does not exist. If the script does not call `RETURN`, then the return value is `NULL`.  

A script may define its own input parameters using the [`DECLARE PARAMETER`](declare_statement.html) statement. If parameters are present in the script, then any `EXECUTE` statement that calls it must provide argument values for those parameters. The exception is if the `DECLARE PARAMETER` statement includes a default value. If so, then the `EXECUTE` statement may omit that parameter, or it may use the special keyword `DEFAULT`; in both cases, the default value defined by the `DECLARE PARAMETER` statement is used.  

## Syntax

<railroad-diagram>
Stack(
    Sequence(
        Choice(0, 'EXEC', 'EXECUTE'),
        Optional(
            Sequence(
                NonTerminal('result-variable'),
                '='
            ),
            'skip'
        ),
        NonTerminal('script-name')
    ),
    Sequence(
        Optional(
            OneOrMore(
                Sequence(
                    NonTerminal('parameter-name'),
                    '=',
                    Choice(0, NonTerminal('argument-value'), 'DEFAULT')
                ),
                ','
            ),
            'skip'
        )
    )
)
</railroad-diagram>

## Parameters

- *result-variable* (variable identifier): If provided, this is a variable name beginning with an at sign (`@`), dollar sign (`$`), or colon (`:`) that the return value of the script will be assigned to. The variable may be declared beforehand, but does not need to be. The `EXECUTE` statement acts as a variable declaration if the variable does not exist.
- *script-name* (script identifier or string): The name of the script to execute.
- *parameter-name* (variable identifier): The name of the parameter variable inside the script called *script-name* whose argument value is being set.
- *argument-value*: The value to pass to the script for the parameter called *parameter-name*.
- `DEFAULT` (keyword): If `DEFAULT` is specified instead of an *argument-value*, then the parameter will use its default value. This is equivalent to omitting the parameter.

## Examples

- Executes the script named "Script2" using default values for all parameters and ignoring the return value.

    ```
    EXECUTE Script2;
    ```

- Executes the script named "Script2" and stores the return value in the variable `@returnValue`.

    ```
    EXECUTE @returnValue = Script2;
    ```

- Executes the script named "My Script".

    ```
    EXECUTE 'My Script';
    ```

- Executes the script named "Script2" and passes two argument values.  `@foo` and `@bar` refer to parameters defined using `DECLARE PARAMETER` inside "Script2".

    ```
    EXECUTE Script2 @foo = 1, @bar = 2;
    ```
