#!/bin/sh

mxmlc -library-path+="starling_bin/starling.swc" \
      -library-path+="exlib/playerglobal.swc" \
      -library-path+="flexunit_lib/" \
      -source-path+="starling_src/" \
      -source-path+="tksrc/" \
      -swf-version=15 \
      -output="build/TestRunner.swf" \
      -debug=true \
      test/TestRunner.mxml

if [ $? = 0 ]; then
    open build/TestRunner.swf -a /Applications/Safari.app -n
fi
