# `EXPORT` `TXT` Statement

Writes a text file (.TXT) to disk from a `SELECT` query. If the query has multiple columns, they are concatenated together with no separator. The text is not escaped or quoted.

## Syntax

<railroad-diagram>
Stack(
    Sequence(
        'EXPORT',
        Choice(0,
            'TXT',
            'TEXT'
        ),
        NonTerminal('filename'),
        'FROM',
        '(',
        NonTerminal('select-statement'),
        ')',
    ),
    Sequence(
        Optional(
            Sequence(
                'OPTIONS',
                '(',
                OneOrMore(
                    Sequence(
                        NonTerminal('key'),
                        ':',
                        NonTerminal('value')
                    ),
                    ','
                ),
                ')'
            )
        )
    )
)
</railroad-diagram>

## Parameters

- *filename* (string): The absolute path to the text file to write. The file does not need to exist. If it does exist, by default new lines will be appended to it. Use the `TRUNCATE_EXISTING_FILE` option to overwrite the existing file.
- *select-statement* (statement): A `SELECT` statement that provides the rows to write to the file.

## Options

- `TRUNCATE_EXISTING_FILE` (0-1, default: 0): If the output file exists, this option indicates whether the existing file contents should be deleted.
    - 0 = Keep existing file data and append new lines
    - 1 = Delete existing file data
- `FILE_ENCODING` (0-65535, default: 0): Indicates the text encoding to use when writing the text file. Specify 0 to use UTF-8. Any nonzero integer is treated as a Windows code page number.

## Examples

- Writes the contents of `mytable` into a file called "MyFile.txt". Because no options are specified, the lines are appended to "MyFile.txt" and the UTF-8 encoding is used.

    ```
    EXPORT TXT 'C:\MyFile.txt'
    FROM (SELECT * FROM mytable);
    ```

- Overwrites "MyFile.txt" if it already exists.

    ```
    EXPORT TXT 'C:\MyFile.txt'
    FROM (SELECT * FROM mytable)
    OPTIONS (TRUNCATE_EXISTING_FILE: 1);
    ```
