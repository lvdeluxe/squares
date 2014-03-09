@echo off

rem
rem  ADOBE CONFIDENTIAL
rem
rem  Copyright 2007-2012 Adobe Systems Incorporated
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
rem acompc.bat script to launch compc-cli.jar in Windows Command Prompt to
rem compile SWC libraries for Adobe AIR.
rem On OSX, Unix, or Cygwin, use the acompc shell script instead.
rem

"%~dp0compc.bat" +configname=air %*