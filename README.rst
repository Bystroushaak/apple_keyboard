Apple keyboard alternative layout
=================================

Sources for wireless Apple keyboard layout modification.

``apple.sh`` will download your kernel sources, patch ``hid-apple.c`` source,
compile everything and put module into your system. There is also ``xmodmap``
file, which will patch your layout even more:

.. image:: http://www.abclinuxu.cz/images/screenshots/2/6/201562-apple-keyboard-and-linux-mint-13-4969945305787593375.png

Script was tested at ubuntu and is meant for the ubuntu based distributions.

See http://www.abclinuxu.cz/blog/bystroushaak/2013/11/apple-keyboard-and-linux-mint-13
for details.
