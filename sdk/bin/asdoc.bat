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
rem asdoc.bat script to launch asdoc.jar in Windows Command Prompt.
rem On OSX, Unix, or Cygwin, use the asdoc shell script instead.
rem

setlocal

if "x%FALCON_HOME%"=="x"  (set FALCON_HOME=%~dp0..) else echo Using Falcon codebase: %FALCON_HOME%

if "x%FLEX_HOME%"=="x" (set FLEX_HOME=%~dp0..) else echo Using Flex SDK: %FLEX_HOME%
@echo on
java -Dsun.io.useCanonCaches=false -Xms32m -Xmx512m -Dflexcompiler="%FALCON_HOME%" -Dflexlib="%FLEX_HOME%/frameworks" -Dflex.compiler.theme= -Xbootclasspath/p:"%FLEX_HOME%/asdoc/xalan.jar" -classpath "%FLEX_HOME%/lib/legacy/asdoc.jar" flex2.tools.ASDoc -compiler.fonts.local-fonts-snapshot= %*

