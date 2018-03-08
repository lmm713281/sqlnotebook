## Explore and manipulate tabular data in a lightweight desktop app

Powered by a supercharged [SQLite](https://www.sqlite.org/) engine, **SQL Notebook** supports both [standard SQL](https://en.wikipedia.org/wiki/SQL-92) queries and [SQL Notebook-specific commands](/doc/programming_reference/index.html). Everything you need to answer analysis questions about your data, regardless of its format or origin, is built in.  SQL Notebook supports Windows, macOS, and Linux.

<div style="text-align: center; margin-top: 40px;">
<span style="font-size: 28px;">
[**Download SQL Notebook**](download.html)
</span>

![Screenshot of SQL Notebook](art/main_screenshot.png) 
</div>

<hr class="section-divider">

## Easily import and export data

CSV, JSON, and Excel files can be imported into the notebook as local SQLite tables. A graphical import wizard and `IMPORT` script commands are both available.

Microsoft SQL Server, PostgreSQL, and MySQL tables can be linked into the notebook and queried interchangeably with local tables. Remote data is not physically copied into the notebook file unless requested; instead, the data source is queried on-the-fly.

Tables and scripts can be exported in CSV format.

<div style="text-align: center;">
![Annotated screenshot of SQL Notebook's CSV import dialog.](art/annotated-import-screenshot.png)
</div>

<hr class="section-divider">

## Run quick queries or write sophisticated scripts

SQL Notebook offers two standard user interfaces for entering SQL queries:

* **Console**: A command prompt that is optimal for quick queries. Enter SQL commands interactively at the ">" prompt and see results inline. The command history and output log of each console are retained in the notebook file for the user's future reference.

* **Script**: Develop more complex scripts using a syntax-colored text editor. Run a script directly by pressing F5, or invoke it from consoles and other scripts using [`EXECUTE`](execute-stmt.html). The script may define input parameters using [`DECLARE PARAMETER`](declare-stmt.html).

Any combination of data sources can be used together in the same SQL query, including cross-file, cross-database, and cross-server queries.

<div style="text-align: center;">
![Annotated screenshot of SQL Notebook consoles and scripts](art/annotated-console-script-screenshot.png?version=2)
</div>

<hr class="section-divider">

## Document your work directly in the notebook

User-written documents are stored directly in notebook files alongside your SQL code and data. Standard word processing features are available: fonts, lists, text alignment, and tables. Console and script output can be copied into a note for annotation. By keeping your notes with your code, everything you need will be in one place should you need to revisit some work done in SQL Notebook.

<div style="text-align: center;">
![Annotated screenshot of SQL Notebook's note interface.](art/annotated-note-screenshot.png)
</div>

<hr class="section-divider">

## Use familiar programming constructs

Users with prior SQL or other programming language experience will feel right at home in SQL Notebook. Many common programming constructs from other programming languages are available.

<pre>
<span class="comment">-- SQL style</span>
SELECT
    CASE
        WHEN number % 3 = 0 AND number % 5 = 0 THEN 'FizzBuzz'
        WHEN number % 3 = 0 THEN 'Fizz'
        WHEN number % 5 = 0 THEN 'Buzz'
        ELSE number
    END
FROM RANGE(1, 100)

<span class="comment">-- Procedural style</span>
FOR :i = 1 TO 100
BEGIN
    IF :i % 3 = 0 AND :i % 5 = 0
        PRINT 'FizzBuzz'
    ELSE IF :i % 3 = 0
        PRINT 'Fizz'
    ELSE IF :i % 5 = 0
        PRINT 'Buzz'
    ELSE
        PRINT :i
END
</pre>

Learn more in the [documentation](/doc/index.html):

*   Variables ([`DECLARE`](declare-stmt.html), [`SET`](set-stmt.html))
*   Control flow ([`IF`/`ELSE`](if-stmt.html), [`FOR`](for-stmt.html), [`WHILE`](while-stmt.html))
*   Error handling ([`THROW`](throw-stmt.html), [`TRY`/`CATCH`](try-catch-stmt.html))
*   Stored procedures ([`EXECUTE`](execute-stmt.html))

<hr class="section-divider">

## Access a rich library of built-in functionality

SQL Notebook is a "batteries included" solution to everyday data analysis needs. A wide variety of functionality is immediately available out of the box.

<pre>
<span class="comment">-- Access the filesystem</span>
SELECT filename FROM LIST_FILES('C:\') WHERE extension IN ('.csv', '.xls');

<span class="comment">-- Parse CSV and other types of files on-the-fly</span>
SELECT * FROM READ_CSV('C:\MyData.csv');

<span class="comment">-- Import data files into new or existing tables</span>
IMPORT XLS 'C:\Workbook.xls' WORKSHEET 'Sheet2' INTO my_table;

<span class="comment">-- Manipulate dates and times with familiar built-in functions</span>
SELECT *, DATEADD('day', -1, date_col) AS previous_day FROM my_table;

<span class="comment">-- And more!</span>
</pre>

Learn more in the [documentation](/doc/index.html):

*   Full-featured import and export statements ([`IMPORT CSV`](import-csv-stmt.html), [`IMPORT XLS`](import-xls-stmt.html), [`EXPORT TXT`](export-txt-stmt.html))
*   Quick functions for reading files ([`LIST_FILES`](list-files-func.html), [`READ_CSV`](read-csv-func.html), [`READ_FILE`](read-file-func.html), [`DOWNLOAD`](download-func.html))
*   Date and time handling ([`DATEPART`](date-part-func.html), [`DATEADD`](date-add-func.html), [`DATEDIFF`](date-diff-func.html), [`GETDATE`](get-date-func.html))
*   Array values ([`ARRAY`](array-func.html), [`ARRAY_COUNT`](array-count-func.html), [`ARRAY_GET`](array-get-func.html), [`ARRAY_SET`](array-set-func.html))

<hr class="section-divider">

## It's free!

SQL Notebook is **free and open source** software available under the popular [MIT license](license.html).

[Download and install SQL Notebook now!](download.html)

Once you're up and running, browse the [online documentation](/doc/index.html) to get started!
