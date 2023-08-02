| Application Name: |  **IBUtils - Interbase/Firebird Database Utilities**                                                                  |
|-------------------|-----------------------------------------------------------------------------------------------------------------------|
| File name:        |  IBUtils.exe                                                                                                          |
| Version:          |  0.9.8.2                                                                                                              |
| Platforms:        |  Windows 9x/NT/2000/XP                                                                                                |
| Author:           |  Ales Kahanek                                                                                                         |
| Country:          |  Czech Republic                                                                                                       |
| City:             |  Koprivnice                                                                                                           |
| E-mail:           | akahanek(at)seznam.cz   (try also: wanstadnik(at)gmail.com)                                                                 |
| Website:          |  www.unipals.cz/ibutils/ibutils.htm      (may not work)                                                               |


---

**Main Application Window**

![SS_IBUtils_Main](https://github.com/Hazaels/IBUtils/assets/3906754/b1541897-d55c-4fa3-9360-a6ab16179606)

---

**Brief Message**

This program was generously given to the Public Domain by its original author **Ales Kahanek** and I just uploaded it to GitHub in hope that it may be useful for anyone interested.

**Ales** is not interested in continuing developing this nice tool but he is willing that someone (with knowledge) will do it- so here it is.

By the end of this text file you will find some screenshots I took to show how it looks in comparation to some popular applications that does the same thing. I really think IBUtils has a better visual :)

There is the EXE available to be used (see in FILES). 

-Mario (wanstadnik(at)gmail.com)

---

The application **IBUtils** is designed for simplifying database design
for Interbase and Firebird databases by showing the links between the
tables in your database visually, like some CASE tools do. Every change
to the tables in your database made by other tools can be refreshed by
one mouse click. You can create tables and tables relations too. Changes
to database are logged into a file.  
  
**Screenshots:**  
[<u>Main Application Screen</u>](https://github.com/Hazaels/IBUtils/assets/3906754/b1541897-d55c-4fa3-9360-a6ab16179606)  
[<u>Print Preview</u>](https://github.com/Hazaels/IBUtils/assets/3906754/61d13ce1-2701-4382-be1d-f4fcd8e38078)  
  
This app uses pure access to Interbase/Firebird with the excellent IB
Objects, without need to use BDE. Special thanks to Jason Wharton.  
  
**This application is TOTALLY FREE.**  
  
Note, that it is still beta version and need some testing. Comments are
welcome.  
  
  
**1. Registering database**  
First you need to register your database (menu Database/Register
Databases) so you do not have to type DB path and user name next time
again and again. Password is not saved and you need to retype it every
time (saving pwd is not secure).  
  
**2. Creating model**  
Press Ctrl+M, you will be prompted to choose from one of the registered
databases. Then you can add desired tables to the model (from menu or
press A). Tables links (according to foreign key constraints defined in
your DB) are added automatically.  
  
**3. Adjusting model**  
You can set some view properties as whether to show keys only, required
fields as bold, field domains, field types, colors and others. You can
save the model layout to your disk by Save command. Model is saved to
INI-like files with extensions \*.mdl, \*.tbl, \*.old (this is backup
file).

**4. Export & Print**  
You can Export the whole image of the database model to JPG or BMP
file. Another option is to Copy and Paste it to another application. The
Print Preview window allows you to save every separate page to a Windows
Metafile (\*.wmf).

**5. Other comments**  
The first intention was to create more complex tool , but as this is not
my fulltime job and I do it in my free time, I decided to focus on the
model utility. This tool was read only tool in the beginning, but on the
basis of the users requests some metadata creating features were added
recently. These features are just for convenience, do not expect complex
database managing set of features - there are some other IB/FB database
tools that do this job in an excellent manner.

I believe it can be appreciated by the IB/FB community.  
  
You are always welcome to send a message with
any comments or bug reports.  
  
Thank you for playing with IBUtils and sorry for its poor (none :o)
documentation and also for my poor English :)  
  
Good luck, Ales Kahanek  
  
---

**<u>Versions History:</u>**


**30-May-2007**
version 0.9.8.2

*New site  
*- **IB Utils has been moved to a new site of United Paladins** - No
version change :(

---

**19-Apr-2006**
version 0.9.8.2

*New features  
*- **Show Unique Keys** - Fields that are part of unique index are now
displayed with the grey "key" icon in the first column. Also when using
the "Keys only" option, such fields are always visible (you can use this
fields to establish a new foreign key).  The primary key is still
displayed with the yellow "key" icon (note, that primary keys are always
unique).  
- **General Options -** There is a new dialog (File / General Options
menu), just with one option only (more to come ... :).  
- **Load Last Opened Models After Start** - When this options is
checked, all models opened in the last session are loaded when starting
IBUtils next time.

*Bug fixes  
*- Fixed AV when deleting table from the model and the fields listbox
was focused.  
- After doing some changes in the values of "Databases" dialog (User,
Database or Alias, Metadata log) and clicking Replace and Connect
button  old values appeared in the IBUtils Login Dialog instead the new
values. Fixed.  
- A new table added to the model is now better resized.

---

**6-Apr-2006**
version 0.9.8.1

*New features  
*- **Import Model** - You can import model from \*.mdl file to existing
model. Right click to the point where you want to import the model,
select the *Import Model* menu item and choose the desired \*.mdl file.
All imported tables stay selected and it is easy to move the imported
model to a new location. Tables that already existed in the current
model are not imported.  
- **New Model From Selected -** Select some tables in the current model
a click *New Model From Selected* menu item. A new model is created and
only selected tables are copied into it.  
**- Adjust Width of Column(s) -** Select one or more tables and right
click the table and *Adjust Width of ...* or *Adjust All Widths* menu
item to adjust width of column(s) according to the longest text in the
column.  
**-** **Adjust Table Size -** Select one or more tables and right click
the table and *Adjust Table Size* menu item to adjust width the *Name*
column and width of table according to the longest text in the column;
height of the table is adujsted so that all field names become visible.

*Bug fixes  
*- The columns width was not preserverd when using other than 100% scale
after save-close-open multiple times.  
- Minor bug fixes

---

**21-Nov-2005**
version 0.9.8.0

*New features  
*- **Firebird 2.0 support** - IBUtils can now work with FB 2.0 Beta 1. I
do not use FB 2.0 regularly (still working with FB 1.5), but it seems
that everything works fine. In case of troubles with FB 2.0, do not
hesitate to contact me.

---

**20-Jul-2005**
version 0.9.7.0

*New features  
*- **Show Grid** - if you use Snap To Grid option, then you can find
usefull to show the grid (dotted matrix on the model background). This
option is set and saved to each model separately.  
- **Show System Domains** - there is new option in the Options dialog
"Show System Domains", that can show/hide system domains in the table
domain column. Generaly one does not care about the system domains like
RDB$1287 etc. When this options is unchecked, only user defined options
are showed (for example DM_BOOLEAN) and empty string is used for system
domains.  
- **Combined Types/Domains** - there is new option in the Options dialog
"Combined Types/Domains". When this option is checked then the Type is
displayed if the domain is "RDB$...", otherwise the Domain is displayed
in a single column.  
- **Edit descriptions** - you can double click the table title to show
"Description dialog" end edit the **table description**. Similarly
double click the field to edit **field description**.

---

**10-Jun-2005**
version 0.9.6.1

*Bug fixes  
*- The last version was not usable with Firebird 1.0 and Interbase 6.0
due to lack of COALESCE support. Now it is fixed and IBUtils does not
use the COALESCE function anymore.

---

**15-May-2005**
version 0.9.6.0

*New features  
*- **Create Indices** - there is a new option to display available
indices for every table in database. There is also \_very\_ easy and
fast **Create Index** function. Just select required field (or more
fields) and press **Shift+Ctrl+I** and **F9** (or use right mouse click
on the selected fields). That´s all! You can edit the Create Index
template to comply with your index naming conventions. This template can
prepare SQL script for you to create **both ascending and descending
index in one step** (this is default). Every index can be dropped too.

---

**28-Dec-2004**
version 0.9.5.0

*New features  
*- **Command line start** - IBUtils can be now started via command line
with specified filename, user and password.  
  Example 1: ibutils.exe -filename c:\\models\\mymodel.mdl  
  Example 2: ibutils.exe -filename c:\\models\\mymodel.mdl -user sysdba
-password masterkey  
  In the first example user is prompted for username and password. The
model is opened directly when the *user* and *password* switches are
specified.  
- **Password storage** - There is an option to store username and
password for each model in the **Model \| Options** dialog. When
username and password is saved, the login prompt is not displayed and
model is opened immediately. The password is jumbled in the \*.mdl file.
Saving password is not very safe, especialy for the SYSDBA user, but it
can be very handy sometimes.

*Bug fixes*  
- The mouse click outside the list of registered databases produced
unwanted exception.  
- Setting the "Keys only" option for a table with no primary and foreign
keys produced unwanted exception.

---

**6-Jun-2004**
version 0.9.4.0

*New features  
-* **Reorder table fields** - Table fields can be reordered (**Ctrl+Up**
or **Ctrl+Down** or by popup menu) and then the changes can be compiled
(**F9** or click Compile button). These changes are also logged in the
metadata log file if such file is specified for the database (in the
Registered databases dialog). *  
-* **Change database** - The path to database or database alias of the
model can be changed in the Model options dialog. *Note*: When the
database path or alias match some of the registered databases, the
corresponing Metadata log file and user name is used for this model.  
- **Browse and export** -You can browse table data (**F4** or by popup
menu) and edit, insert or delete records. Also convenient export to
Excel, Word, RTF, HTML, DBF, TXT, CSV, DIFF, Sylk, LaTeX, SQL or
Clipboard is available.  
- **Better creation of tables** - When new table is added or created in
the model, its **height** is automatically adjusted to display all
fields, its **width is automatically adjusted** according to width of
the longest field name, field type, field domain or computed by source
(which columns are displayed depends on the value of "Default columns
count" and other Default show options in the "Model options" dialog).  
- **Snap to grid** - tables are snapped to grid while resizing or moving
within the model. Size of the grid can be set in the "Model options"
dialog. Relations nodes can be snapped as well. Snapping of tables
and/or relations can be turned on/off.  
- **Run Script** dialog - you can quickly run SQL scripts against the
database. Run whole script or select portion of script in the memo and
run. The script is logged into the metadata log file.

*Bug fixes*  
- The CreateRelationTemplate did not work properly - changes to the
template were never used - the default temlate was used instead. Now you
can edit the template and IBUtils will use it properly.  
- When opening model with 0 tables, the "TProgressbar property out of
range" exception was raised. It´s fixed.  
- The tables cannot be minimized to zero height. - The "Drop field" or
"Drop relation" functions used parenthesis in DDL (for example 'ALTER
TABLE "MYTABLE" DROP ...'). Interbase 6.0 does not allow parenthesis in
DDL. Now parenthesis are not used anymore.  
- Field types NUMERIC, DECIMAL and BIGINT were incorectly reported as
INT64. It´s fixed.  
- Printing to landscape did not work. It´s fixed. Some users have
reported problems with printing to A3 paper size. This should be fixed
too, but I do not have A3 printer so I cannot test it.

---

**26-Mar-2004**
version 0.9.3.1

The last version was built with Czech resources, so the login dialog
caption, some labels captions was in czech language and therefore
"unreadable" for the rest of the world :-) etc. Version 0.9.3.1 is built
with english resource strings.

---

**24-Mar-2004**
version 0.9.3.0

It´s a long time from the last release date :-). There is a new version
with some new features to just say to world that this project is still
alive.

*New features*  
- Create field menu item (in the table popup menu) - not very
comfortable, but can be handy when working with IBUtils - you do not
need to switch to another tool  
- Drop field menu item  
- Create relation by simply dragging one field onto another field -
"Create relation" dialog is then invoked to create a short script for
you

*Bug fixes  
*- application raised exception when refreshing empty model

---

**11-Aug-2003**
version 0.9.2.8

*New features*  
- Scaling (zooming) was redesigned so now **it behaves as a real zoom**
(including proper font sizes).  
- new hot keys: F2 - zoom in, F3 - zoom out, F4 - zoom to 100%.  
- Relation names are shown in hint window while moving mouse over it.

*Bug fixes  
*- A table was not properly scaled when adding new table to model with
other scale than 100% until the model scale was changed*.  
*- fixed Note scaling.*  
-* Metadata changes were not written to log file when \*.mdl file from
previous version of IBUtils was used on some circumstances. The problem
did not arise when new model was created.  
- After dropping foreign constraint model did not behave correctly and
creating other constraint or custom link was very tricky (some AVs).  
- some other minor bugs.

The last version was pretty buggy :( , I believe this one is better :) .

---

**5-Aug-2003**
version 0.9.2.7

*New features  
*From now IBUtils is no longer a read only tool. On the basis of the
users requests I introduced following new features  
- **New foreign** key constraint can be created by several mouse
clicks - click on the "Create relation" tool button, then click on some
field of the first table, then click on some field of the second table
and a script is generated for you to create the relation. You can freely
modify this script to suit your needs and/or select the update or delete
rule for this constraint. There is also possibility to modify the script
template which is used as a basis for the resulting script (see the
"Create Relation" tabsheet).  
- **New table** can be created by right mouse click on the model - menu
item "Create Table". A "Create Table" form is shown with a template
script. You can supply table name and primary key name a click the
"Create Script" button. Then modify the script or directly click the
"Run Script" button. The template contains several "macros" which are
processed during the script generation. You can modify the template
according your needs. The standard template supplied with this
application creates table with primary key and some timestamp and user
fields, some insert and update triggers, primary key generator and some
privileges. This approach is very usefull when you want to have all
tables with some "standard" fields, the triggers and generators etc.
named properly by the same naming convention.  
- Every change to the database metadata (create/drop relation, create
table) can be **logged into a file** so your metadata changes are
reproduceable to another database. The desired filename can be entered
in the "Register Databases" dialog.

*Bug fixes  
-* Models are now opened and refreshed sligthly faster*.  
-* Custom nodes are now refreshed properly.  
- Foreign key icons are now painted properly.  
- When "Keys only" option was specified, all fields were shown. Now only
keys are displayed.

---

**28-May-2003**
version 0.9.2.6  
*New features  
-* **Notes** - you can add a custom "Note" directly to model to enter
some description, see the [<u> main window
screenshot</u>](https://github.com/Hazaels/IBUtils/assets/3906754/b1541897-d55c-4fa3-9360-a6ab16179606). Note can be
selected, moved, etc., it behaves in the same way as regular database
table object. Right click on the model desktop and choose "Add note"
menu item.  
- **Custom links** - you can now create your own links between tables
and even notes mentioned above, see the [<u>main window
screenshot</u>](https://github.com/Hazaels/IBUtils/assets/3906754/b1541897-d55c-4fa3-9360-a6ab16179606). Click on the
"Add custom link" toolbutton in the main toolbar - the cursor changes to
indicate the "Add custom link from" mode, then click on some field of
some table, cursor changes to "Add custom link to" mode, then click on
some field of another table and the custom link is now created. Custom
links are saved in the \*.tbl file.  
This is very handy when you do not use foreign key constraints in your
database and still want to show the link (obviously when the foreign key
index has low selectivity)  
- Link color can be now specified in the Options dialog box

*Bug fixes  
-* Fixed bug "Token unknown ..." when running against Interbase 6.0.  
- Fixed cursor flickering when table link was focused.

Because of the new "Notes" feature the object model has to be splitted
to general ancestor and *table* plus *note* descendant. This required
lots of code changes and there could be new bugs and the application can
be unstable.

---

**14-May-2003**
version 0.9.2.5  
*New features*  
- Border color can be specified in the Print Preview form.  
- Different background color for print output can be specified in the
Print Preview form. This option can save a lot of your printer´s ink
(use white color :-) .  
- Stretch to 1 page option is now available. This makes the model image
stretched to one printout page when the model consists of several pages.
However, text in the result could be hardly readable when the stretching
factor is too high - it is bitmap, not vector :( .  
- All Print Preview form properties are now remembered independently for
each model.  
- Some shortcuts were added to Print Preview form:

-    P or Ctrl+P ... Print,

-    S or Ctrl+S ... Save to WMF,

-    W ... Zoom to width,

-    H ... Zoom to height,

-    F4 ... Zoom to fit,

-    + ... Zoom in,

-    - ... Zoom out,

-    Esc ... Close Preview.

---

**23-Apr-2003**
version 0.9.2.4  
*Fixed bugs*  
- When one field of a table was involved in several foreign keys (or
duplicated foreign key was accidentaly entered into db), the "Multiple
rows in singleton select" error was generated. This is now fixed.
However this fix has enforced change of internal relationships naming
convention and thus change of the names of relationships saved in the
\*.tbl file. This change affected only those relationships with nodes -
when you open the old model with this new version, none of the nodes
will be restored from the \*.tbl file because of the old vs. new name
conflict. You have to define the nodes again yourself. This is the only
drawback of this change and I appologize for the inconvenience.

There are some new interesting feature requests pending, but
unfortunately I am very busy now and can promise to add these new
features not earlier than within 3-4 weeks.

---

**18-Feb-2003**
version 0.9.2.3  
*New features*  
- The table description is now retrieved from database. You can see it
as application hint of the Tablename label. Just point mouse on the
table name and read ...

---

**16-Dec-2002**
version 0.9.2.2  
*New features*  
- The table listboxes can have a resizeable header now, you can adjust
width of each column for each table independetly. The header for each
table can be toggled on/off simply by pressing 'H' key.

\- Opening existing model is now 30% faster.

\- Added new shortcuts to quickly change the appearance of model tables
(I, K, L, T, ...), see the table context menu. The 'A' shortcut for
"Select All" was changed to "Ctrl+A". The 'A' key is now shorcut for
"Add table". The 'T' key, previously shorcut for "Add table" is now
shorcut for toggle "Types visible/invisible" in the selected tables.

\- Run of some long lasting actions as Open model, Refresh model,
Refresh selected tables isnow indicated by progress bar.

\- Meaning of the "Show options" in the "Model options" dialog has
changed. Previously after the OK button click the corresponding show
options (icons, required, ...) of the **selected** tables were changed.
Because the same result can be achieved by table context menu, this is
not necessary here. The same checkboxes have another meaning now: these
are the default show options when adding new table to the model. New
table is displayed according to these settings. Existing tables in the
model are not affected. These options are saved independently for each
model.

*Fixed bugs  
-* When adding new tables on some circumstances some table links were
not added to the model until closing and reopening the model. Now this
works fine.

---

**23-Aug-2002**
version 0.9.2.1  
*New features*  
- Painting links between tables completely rewritten. The FK links are
now selectable objects and even more - you can define custom nodes on
every link and the link then consists of several lines instead of one
line only. [<u>See the screenshot of the Application
main window</u>](https://github.com/Hazaels/IBUtils/assets/3906754/b1541897-d55c-4fa3-9360-a6ab16179606) .All is done via
drag and drop, very user friendly. The nodes can be selected too and
dragged together with the selected tables to another location on the
model desktop.

\- New shortcuts added. For example Add Table shortcut was Ctrl+T, now
you can use only T (the old Ctrl+T works as well), similarly other
shortcuts (Export - Ctrl+E -> E and so on). Save your fingers, type
less! :o))

*Fixed bugs  
-* Fixed some MDI bugs (some "pointer" variables pointed to wrong
connection object to another MDI window in some occasion, now it should
be OK).

---

**4-Aug-2002**
version 0.9.1.3  
*New features*  
- More comfortable **Add Table** dialog:  
1. Incremental Searching  
When table list is focused, you can directly type letters to find
desired table.  
2. Immediate Filter  
You can specify immediate filter in filter combo box, for example
'MYTAB', then press Enter and all tables containing 'MYTAB' are
filtered.  
3. Permanent Filter  
In Model Options dialog you can specify Permanent filter condition, for
example  
(RDB$RELATION_NAME NOT CONTAINING '$') AND (RDB$RELATION_NAME LIKE
'MYTABLE%')  
or more complex condition using valid "SQL WHERE" syntax. The table list
is filtered according to this condition and can be quickly toggled
on/off.

*Fixed bugs  
-* Add Table dialog was showing wrong table list when dialog was invoked
from popup menu and when multiple models were opened

---

**1-Aug-2002**
version 0.9.1.2  
*New features*  
- Export image of the model to \*.jpg file, you can specify custom
compression quality (range 1..100, lower number means lower quality and
smaller file size)  
- Print Preview window can save every separate page to Windows Metafile
(\*.wmf)

---

**14-Jun-2002**
version 0.9.1.1  
*New features*  
- COMPUTED BY fields can be now indicated

---

**14-Apr-2002**
version 0.9.1  
*New features*  
- Model title (can be printed)  
- Print the model with print preview  
- Copy image of the model to the Clipboard (you can paste it to another
image processing app)  
- Export image of the model to \*.bmp file  
- Keys Up, Down, Right, Left can scroll the model in the window  
  
*Some little bugs repaired*

---

**5-Apr-2002**
version 0.9  
*First release of IBUtils*

---


**Comparation with some popular tools:**


IBExpert

![EDM_IBExpert](https://github.com/Hazaels/IBUtils/assets/3906754/cb72cbab-1b1c-4fd6-8c31-00adae02f8e8)

---

SQL Maestro

![EDM_Maestro](https://github.com/Hazaels/IBUtils/assets/3906754/e6a86ab1-1acd-4c53-9981-c27ebbbc967a)

---

IBUtils

![EDM_IBUtils](https://github.com/Hazaels/IBUtils/assets/3906754/7ae688f9-2625-4588-ac0c-de8d9db359a4)

---
