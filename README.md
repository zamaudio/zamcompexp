zamcompexp
==========

ZamCompExp - LV2 Compressor/Expander plugin

This is a clone of ZamCompX2 with an extra feature: an expander.
So it is a dual compressor/expander.
The knee setting has been removed, however. It only functions
using hard knee.  There are independent settings for the thresholds for both
expander (below which it kicks in) and the compressor (above which it kicks in)

Feel free to leave comments on my blog as all feedback is appreciated.

http://www.zamaudio.com/?p=870


Install instructions:

lv2-dev and lv2-c++-tools are required to compile this LV2 plugin

	make && sudo make install

