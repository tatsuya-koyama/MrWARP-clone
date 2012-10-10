#!/bin/sh

rm -f build/MrWARP_forAIR.swf

amxmlc -library-path+="starling_bin/starling.swc" \
       -library-path+="exlib/playerglobal.swc" \
       -source-path+="starling_src/" \
       -source-path+="tksrc/" \
       -swf-version=15 \
       -output="build/MrWARP_forAIR.swf" \
       -debug=false \
       src/Main.as
