RGSS Decryptor CLI
===================

Command-Line RGSS<sup>1</sup> Decryptor

* Optional Shell Integration
* Optional Creation of Project File
* Info Dump Only Mode (No Extraction)

<sub><sup>1: RPG Maker XP/VX/VXAce Archives</sup></sub>

#### **Usage**
----
Either Call Via Command Line :

	RgssDecrypter.exe [options] <RgssArchive>

Or Simply Drag and Drop the RGSS Archive on the executable


#### **Options**
---

|Short|Full       |Description                        |
|-----|-----------|-----------------------------------|
|?    |help       |Displays Help Message              |
|d    |dump       |Dumps Archive Information Only     |
|o    |output     |Output Directory (Relative)        |
|p    |proj       |Creates Project File               |
|q    |quiet      |Supresses Output                   |
|r    |register   |Registers Context Menu Handler     |
|u    |unregister |Unregisters Context Menu Handler   |


### **Examples**
---

To Extract a Data File and Create the project file

	RgssDecrypter -p Game.rgss3a

To Extract a Data File under a Directory

	RgssDecrypter --output=Extracted Game.rgss3a

To Install the Shell Extension (Right Click -> Extract with RGSS Decryptor)

	RgssDecrypter --register

To Install the Shell Extension with Quiet and Project Flags

	RgssDecrypter -rqp

To Uninstall the Shell Extension

	RgssDecrypter --unregister




