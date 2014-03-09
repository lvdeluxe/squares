@echo off

rem
rem  ADOBE CONFIDENTIAL
rem
rem  Copyright 2012 Adobe Systems Incorporated
rem  All Rights Reserved.
rem
rem  NOTICE: All information contained herein is, and remains
rem  the property of Adobe Systems Incorporated and its suppliers,
rem  if any. The intellectual and technical concepts contained
rem  herein are proprietary to Adobe Systems Incorporated and its
rem  suppliers and are protected by trade secret or copyright law.
rem  Dissemination of this information or reproduction of this material
rem  is strictly forbidden unless prior written permission is obtained
rem  from Adobe Systems Incorporated.
rem

rem
rem aasdoc.bat script for Windows.
rem This simply executes asdoc.exe in the same directory,
rem inserting the option +configname=air, which makes
rem asdoc.exe use air-config.xml instead of flex-config.xml.
rem On Unix, aasdoc is used instead.
rem

"%~dp0asdoc.bat" +configname=air %*

