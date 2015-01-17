ZIMO (FontMagic)
================
Personal Chinese font generator

This system can convert user's hand writing of Chinese characters into a font
(typically a ttf file) which implements the GB2312 codec.

To obtain a complete GB2312 font, user needs to write in total 6763 Chinese 
characters and 26 English lower and capital characters as well as numbers and
all kinds of symbols.

User can accumulate the characters day by day, the system does not require the
user to complete all the writing in one time. We have a database which can 
store the entire history of each character for each user so that the user can 
track each version of every character to choose whichever version to use for
current font. 

The system will consist of two parts, the WEBSITE and a mobile APP to support
updating via mobile devices.

WEBSITE
============
User needs to download a font template to fill in the Chinese characters. There are
two different kinds of default templates, one for commonly used characters and one 
for less frequently used characters, the order of those characters is based on the
frequency of their usage. User can also customize the template they want to use by 
selecting the characters to write and also the size of the cell for the character.

After downloading the template, user needs to fill in the cells with hand writting 
characters, typically, user needs to print out the template and write with a pen.

User then needs to upload the filled templates via the website, the system supports 
multiple formats, like pdf, jpg, etc al. For the alpha version of the system, it is 
better for the users to scan the templates so that the template can be more clean.
But the users can also take a picture of the templates with a camera and upload the 
pictures.

The system will process the pictures uploaded by user and generate a font (ttf file).
If the user wants to store his/her font in our database, we will update the infomation
of the user so that he/she could continue updating his/her font during the time.

An additional function of the website will be added later. The website will be able to
let user modify their fonts via a webpage, like reposition some characters or remove 
stains and so on. There will also be a webpage for each user to display their writing.

ZIMOAPP
================
We also have a more convinent way for users to update their fonts. They can just download
our zimo app (which will be first supported on IOS devices) and update their font whenever,
wherever they want. They can simply write Chinese characters on any paper, and use the camera
of their mobile device to scan the character, then input the metadata i.e. which character 
this is. The user can also adjust the direction, the position, and even remove stains to make
the character clean enough, then they can submit the update request, and this character will
be updated. All the history version of this character will be remembered so that the user can
switch back if they want. In this way, the users can even track all the writing style of theirs
through the life. Every time, when the user uses this APP, we should remind them to finish more 
characters, like ten characters everyday so that the user can obtain a complete font during the
time.

Second function of this APP is to let user decorate their writings. I hope this function will be
like "Meituxiuxiu" for fonts which can be dubbed as "Meizixiuxiu". Bascically, there will be 
crystal effect, or charater in its hollow version.

Their function of this APP is you can authorize others to use your font or to get authorization from
others to use their fonts. 

Fourth function of this APP is to enjoy the art of calligraph from other people or show your own special
calligraph to the public.

USAGE
================
To create a font via website, please follow the specified steps:

1. generate a template using backend/template/generate_template.py
  ```
    python generate_template.py -h
  ```
  
  will tell you the information about the input and options.
  ```
    python generate_template.py gb2312.txt
  ```
  
  will use the default parameters to generate a comlete template for 6763 characters with cell size=20. The files black.png and fireflysung.ttf are required.
  
  Required Python modules: fpdf, qrcode

2.
