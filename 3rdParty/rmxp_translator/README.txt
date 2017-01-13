*** What is this? ***
  This is a translation tool for RPG Maker XP/VX/VX Ace (rmxp_translator.rb for
  XP, rmvx_translator.rb for VX and rmvxace_translator.rb for VX Ace). It can be
  used to dump the data files for a game to JSON, which can then be translated
  and applied to the data files to translate the game. The tool is also capable
  of updating the translation files if the data files are changed.

*** What do I need to use the tool? ***
  The tool is written in Ruby, because that makes it very easy to parse the RPG
  Maker data files (which are in Ruby marshal format). This means that you need
  a Ruby interpretor, see https://www.ruby-lang.org.

*** Do I need RPG Maker to use the tool? ***
  No, there's no need to have RPG Maker installed, the tool just parses and
  translates the data files. It might be useful to have RPG Maker, or at least
  some knowledge of how RPG Maker works, to better understand the translation
  files, but it's not required in any way.

*** How do I use it to translate a game? ***
  First of all you need to make sure that you have access to the data files for
  the game you wish to translate. Many games are encrypted, and the data files
  are contained in either Game.rgssad for XP, Game.rgss2a for VX or Game.rgss3a
  for VX Ace. In that case you need to decrypt this file and extract the data
  files. There are multiple tools on the internet that can do this. When you've
  decrypted the data files you should have a Data directory containing .rxdata
  files for XP, .rvdata for VX or .rvdata2 for VX Ace. You should then remove
  Game.rgssad/Game.rgss2a/Game.rgss3a, to avoid it being loaded instead of the
  decrypted data files.

  The next step is to create a new directory for the translation, and copy all
  the data files into that directory. These data files are now the control files
  used to check that the translation is ok. Then use the tool to dump the
  translation data to JSON files (all examples are for VX, for XP/VX Ace just
  change the commands as appropriate):

    ruby rmvx_translator.rb --dump=*.rvdata
    
  --dump takes a file pattern as argument, so *.rvdata will match all *.rvdata
  files. You can also dump a single file by using its name, or whatever pattern
  you wish (it's using Ruby's Pathname.glob). This will create a number of .json
  files alongside the control data files. You will get a warning for each .json
  file that already exists, to avoid overwriting a translation by mistake. There
  is also a --dest flag for setting the destination of the generated files that
  works with all commands, but it's not so useful for --dump since the .json
  files need to be in the same directory as the files they're created from.

  The next step is to translate the .json files. For this you just need a text
  editor that can open and save files using UTF-8 encoding. Something like
  Notepad++ should probably do the trick. The files use the JSON format, and the
  structure varies depending on what data they contain.  The thing to look out
  for is entries for TranslatableString and TranslatableArray, that for example
  looks like this for an Actor:

    {
      "json_class": "RPG::Actor",
      "name": {
        "json_class": "TranslatableString",
        "original   ": "レリカ",
        "translation": ""
      }
    }

  Simply insert the translation where it says translation, like this:

    {
      "json_class": "RPG::Actor",
      "name": {
        "json_class": "TranslatableString",
        "original   ": "レリカ",
        "translation": "Rerika"
      }
    }

  TranslatableArray:s are used for shown text, scripts and comments, and
  can represent multiple lines of text:

    {
      "json_class": "TranslatableArray",
      "original   ": [
        "some text",
        "some more text",
        "even more text"
      ],
      "translation": [
        "translated text",
        "more translated text",
      ]
    }

  As shown in the example above the number of lines in the translation does not
  need to match the number of lines in the original text, to account for
  translations that might be longer or shorter than the translated text.

  When you've translated something and wish to apply the translation to the
  game, use the --translate flag and set the destination to be the game's data
  directory (note that you should still use .rxdata/.rvdata/.rvdata2, not json):

    ruby rmvx_translator.rb --translate=*.rvdata --dump=<Insert game dir here>

  The tool will then load each data files that matches the pattern, and look for
  a .json file containing a translation in the same directory (any files that
  don't have a translation file will be ignored). It will then translate the
  data using the translation file and dump the translated data files in the
  destination directory.
  
  While translating it will check that the original string for each
  TranslateString entry matches the string in the loaded data file, otherwise it
  will abort the translation. This is done to make sure that the control data
  files haven't changed, since the translation would then be invalid. This is
  the reason for having a set of control data files which are not translated,
  since a translation can't be applied to an already translated data file (the
  tool will warn you if you try to overwrite any control data files). Any
  translation strings that are empty will simply be ignored, so it's not
  necessary to translate everything.
  
  If you accidentally change the original string instead of the translation
  string, or if you change the control data files without updating the
  translation, you will get an error like this:

    Error: Invalid translation element!
      Got translation for:
        Rerika
      Expected:
        レリカ
      Translation:
        
      from element RPG::Actor with index 1
      from element name

   This error means that the original string for the name of the first Actor in
   the json file was Rerika, but the corresponding string in the control data
   file was レリカ, and that the translation string was empty. This likely means
   that you've changed the original string instead of the translation string. In
   such case you can usually just copy the expected string back into the
   original string in the json file.

   One thing to look out for when translating is that RPG Maker commands in
   strings are escaped by JSON, so e.g.:

     "\AL[1]Some text"

   will become

     "\\AL[1]Some text"

   in the translation in the json files. It's important to keep this in mind
   when translating, since using only e.g. \AL[1] in the translation will mean
   that RPG Maker won't recognize this as a command (it will read it as AL[1]
   and display it as such in the text).


*** What about scripts? ***
  Scripts are a bit special, since they're not actually stored as RPG Maker data
  structures, but are rather compressed ruby scripts. JSON does not allow
  newlines in text though, which means that scripts become a single long line if
  dumped as JSON. To avoid this the scripts are dumped into separate files, and
  Scripts.json contain entries like this which say which file the script is in:

    {
      "json_class": "Script",
      "filename": "scripts/Script002.rb",
      "name": {
        "json_class": "TranslatableString",
        "original   ": "Vocab",
        "translation": ""
      }
    }

  In this case the script can be found in scripts/Script002.rb. The filenames
  pointed to by Scripts.json are the control files, while the files ending with
  _tran are the translation files. If nothing has been translated, then these
  files are identical. To translate a script, say scripts/Script002.rb, simply
  open scripts/Script002_tran.rb and make any changes you wish. These changes
  will then be applied when translating Scripts.rxdata/rvdata/rvdata2. Unlike the
  normal translation strings where an untranslated string is empty, the _tran.rb
  files are just copies of the control files.

  Take care when translating scripts and only translate strings that you know
  are displayed in the game. It's easy to break the game otherwise (but you can
  always just replace the translated Scripts data file with the control in that
  case).

*** How do I update a translation? ***
  If for example a new version of a game is released it will be necessary to
  update the translation, since the data files will have changed. Before doing
  this it's a good idea to make a backup of the translation files, in case
  something goes wrong.

  Then replace the control data files with the new data files, and update the
  translation files:

    ruby rmvx_translator.rb --update=*.rvdata

  The tool will then compare the translation data with the new control data, and
  it will add/remove anything that has been changed in the control data. If a
  string has changed it will remove the translation for that string, since the
  translation is no longer valid. A message will be printed out for each
  translation that's removed. This means that there's a chance that some parts
  of the translation is invalidated and removed, but since most games that are
  updated only receive new content or small bug fixes this shouldn't be a big
  problem.

  If all goes well the translation should now be compatible with the new data
  files, and any untranslated strings can be translated and applied.

*** Can I use this to continue translating a game? ***
  If a game has been partially translated using RPG Maker it's possible to use
  this tool to continue the translation, by just treating it as an untranslated
  game and then translating any untranslated strings. There will be issues if
  the translation is attempted to be updated to a new version of the game
  though, since any string translated in RPG Maker will not match the new data
  files and thus have it's translation removed.
