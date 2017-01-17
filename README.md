# RPG Maker Auto Translator #

## What is it ##

The core of this tool is a ruby script called auto_translate.rb. The GUI app runs this script and hooks into its logs as well as providing functionality to edit settings and cached translations. It supports output into several languages supported by the underlying API.

It is this author's hope that a master cache translation file can be built up for each language allowing quick and easy translations in the future.

## Which RPG Maker versions are supported? ##

The tool supports RPG Maker XP, VX, and VX Ace. There is currently no extract or translation aid tool for MV.

## How does it work ##

There are three main dependencies for this tool that are included and one that is not. 

- Ruby 2.2 or above (not included)
- RgssDecrypter
- rmxp_translator
- http://transltr.org API

The script runs several steps which can be altered by the settings:

- Delete the existing output directory
- Copy the source directory to the output directory ([root_output]/[game_directory_name])
- Back up any original data files that exist in the original's Data directory (pre-translated)
- Extract all the data files and assets from the main data file
- Move the original data files back over
- Extract the json from the data files
- Run translation for all non-skipped files

Translation step works by:

- Loading a cache file for the output language if it exists
- Go through each json file line by line
- For each line check for an "original" tag
- Break the string for the original tag into "blocks" by only translating uninterrupted sequences of Japanese characters
- For each block check cache and return if it's cached already
- if it isn't cached hit translation API and cache result
- Put fully translated line into output
- Re-create the data files from the translated json files
- Move the main data file to a (.backup) version to force RPG Maker to load in the new files

## Known issues ##

- The behavior of the scrollbar is a little wonky when it's translating. If it starts snapping up then back down turn off auto scroll then turn it back on again to snap to last line.
- Partial translation is not clearly indicated to the user after a run. Best way to ensure a translation is complete is to look for all OK on the processing from JSON -> data files then a final log statement which looks like:
    
> Moving data file to backup
> 
> Processed 843440 lines in 17342.666943 seconds

## Originally planned but scrapped ##

The major feature that didn't make it in was keeping a record of the number of times each cache entry is hit. In this way after several games are run and the translation file starts getting large, the cache file could be pruned of all entries which were accessed less than X number of times.

## Troubleshooting ##

***I hit translate and it gave no output and stopped immediately, wtf?***

The most common reason this would happen is if your output directory does not exist. 

The other common reason for this both the source and the destination directory cannot contain Japanese anywhere in the path. Ruby in Windows cannot seem to handle the copy when Japanese chars exist in the path.

***I ran the translator but some text is still in Japanese, wtf?***

Certain games, especially those by OneOne1 read most of their dialog and text from different script engines not native to RPG Maker. The tool will run for these and recognize some common data files to automatically skip over but to translate the actual text requires you to work with those other scripting engines and is not currently possible.

Other caveats exist such as text lines which contain variables like "<text:text>" are skipped, translating bits of these lines has adverse affects so it errs on the side of caution. Game variable names themselves are also not translated to prevent script errors.  Sometimes text is hardcoded in scripts themselves as well which would require much more effort to translate since simple translating all strings would most likely break things.

***This is taking forever, wtf?***

Some larger games can have 10s of thousands of blocks to translate. If you start with a blank translation file for a new language or just are unfortunate in that whatever game you are translating needs to call the API a bunch, it will be slow. The API is one of the only free to use translation APIs and as such, to respect the API maintainer, its usage is throttled. 

The main part of the tool is also written in ruby which is not exactly known for its blazing speed. Even if you have 100% of the blocks pre-cached it will take several minutes to work through.

***I was playing a translated game and got an error message that closed the game, wtf?***

**First thing: CONFIRM THAT THE ORIGINAL, UNTRANSLATED GAME DOES NOT HAVE ANY ERRORS**

Sometimes games are coded in a way where a script will look up a choice by the actual Japanese string. In these cases the following procedure works best


1. Go to settings and turn CommonEvents filter to "Translate Single Lines". This will skip over String Arrays which are the source of these errors
2. Turn off "Delete Existing" in settings so that the directory is not wiped out
3. Turn on "Skip Extract from Main Data File"
4. Turn on "Skip Extract from json File"
5. Run again

If it's still failing repeat the above but change Scripts to "Translate Single Lines" also. If still broken change the above two files to "Skip" and try again. 

If it STILL occurs more investigation has to be done to figure out what is breaking. An easy way to do this is to back up your Data directory and copy over all the original data files from "ExtractedData". You can then replace the data from your backed up Data directory a file at a time until you find the offending file. 

***I hit translate and it stopped without finishing, wtf?***

Since the GUI tool merely hooks into the logs of the ruby script. If the ruby script crashes then that stack trace will not be shown in the output window of the GUI. In this case it's best to run the following in a cmd window from the tool's root directory:

`ruby auto_translate.rb "[PATH_TO_GAME_TO_TRANSLATE]"`

ex:
`ruby auto_translate.rb "c:\games\RJ123456"`

From this you can see the raw output. .Net did not want to play nicely with redirected output on the system command with the Japanese encoding so it must read the log instead.

***Where is my pet feature X, wtf?***

The source is open, be the change you want to see in the world.