# Mr.WARP

Mr.WARP is a small shooter video game developed by Tatsuya Koyama.
It is designed for benchmarking of TK's game framework **tkFramework**.

Mr.WARP is written in ActionScript3.0. Its architecture consists of **Adobe AIR**,
**Starling Framework**, and tkFramework. It runs on cross-platform including
web browser with FlashPlayer11 installed, ios devices (iPhone / iPod touch / iPad),
and Android devices with AIR runtime app installed.

## Build Steps

**Summary:**
  0. Use Mac
  1. Clone repository
  2. Set up Flex SDK
  3. Set up AIR SDK
  4. Get Starling Framework
  5. Link to Starling
  6. Build and Run as Flash
  7. Unit Test
  8. iPhone or Android?


----
### 0. Use Mac

* For simplicity, If you have not already done so, buy MacBook.


----
### 1. Clone repository

* Git-clone this repository.


----
### 2. Set up Flex SDK

* Download Flex SDK (I use *Flex 4.6.0 SDK* at 2012-03-07.)
  * http://www.adobe.com/devnet/flex/flex-sdk-download.html
* Extract files and place them to any directory.
* Set path.

    \# in ~/.bashrc for example
    export PATH=/path/to/flex_sdk/bin:$PATH


----
### 3. Set up AIR SDK

* Download AIR SDK (I use *AIR 3.3 SDK* at 2012-06-24.)
  * http://www.adobe.com/devnet/air/air-sdk-download.html
* Overwrite AIR SDK to Flex SDK
  * **[Note]** If you are Mac user, must not copy files on Finder.
    Finder replaces existing directory with source directory by default.
    So you should use *ditto* command to merge AIR SDK into Flex SDK.

    $ ditto air_sdk/ flex_sdk


----
### 4. Get Starling Framework

* Access Starling official web site and download Starling as zip file
  (I use *ver. 1.2* at 2012-09-22.)
  * http://gamua.com/starling/
* Extract files and place them to any directory.


----
### 5. Link to Starling

* Make symbolic link to starling source directory with file name 'starling_src'
  at root of Mr.WARP git repository.

    $ ln -s /path/to/starling-framework/src starling_src

* And make link to starling library directory with file name 'starling_bin'.

    $ ln -s /path/to/starling-framework/bin starling_lib


----
### 6. Build and Run

* Execute script to build swf:

    $ sh build_flash11.sh

* This command generates build/MrWARP.swf file.
  You can play it on your web browser with FlashPlayer11.

* To debug it from terminal, execute this script:

    $ sh run_on_adl.sh


----
### 7. Unit Test

* If you want to try testing, install FlexUnit.

* Download FlexUnit full project (I use FlexUnit 4.1 SDK at 2012-09-02.)
  * http://www.flexunit.org/?page_id=14

* Make link with file name 'flexunit_lib' at root of Mr.WARP git repository.

    $ ln -s /path/to/flexunit/ flexunit_lib

* Run script. If everything goes well, all-green test result is shown on Safari.

    $ sh run_test.sh


----
### 8. iPhone and Android?

* iOS development sucks. Android is relatively comfortable.
  I'm getting tired of explaining. Good luck.





