#!/bin/sh

# なんか swf 消してやらないとリビルド時に Embed したクラスが
# not defined とか言われて困ったちゃん

rm -f build/MrWARP.swf

mxmlc -library-path+="starling_bin/starling.swc" \
      -library-path+="exlib/playerglobal.swc" \
      -source-path+="starling_src/" \
      -source-path+="tksrc/" \
      -swf-version=15 \
      -output="build/MrWARP.swf" \
      -debug=true \
      src/Main.as
