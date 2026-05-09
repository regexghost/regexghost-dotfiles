#!/bin/sh

echo "Setup:"

make > /dev/null

[ -d testinput/ ] || mkdir testinput
[ -d testinput/subfolder ] || mkdir testinput/subfolder
[ -d testoutput/ ] || mkdir testoutput
[ -d testoutput/subfolder ] || mkdir testoutput/subfolder

echo "<p>
	<h1>h1</h1>
	<li>
		<ul>thing</ul>
		<ul>thing2</ul>
		<ul>thing3</ul>
		<!-- Start Substitute - HTML_Test -->
		<ul>one line</ul>
		<ul>two line</ul>
		<!-- End Substitute -->
		<ul>thing6</ul>
	</ul>
</p>
" > testinput/test.html

echo "bind -n C-Tab select-window -n
bind -n C-BTab select-window -p
# Start Substitute - tmux_Test
set -g mouse on
# End Substitute
set -g escape-time 0

# Start Substitute - Other
option 1
option 2
option 3
# End Substitute
option 4
option 5
" > testinput/subfolder/tmux.conf

./sub save test.html testinput/ testinput/test.html << EOF
sub1
EOF
echo ""
sed 's/two line/other line/g' testinput/test.html > /tmp/out && mv /tmp/out testinput/test.html
./sub save test.html testinput/ testinput/test.html << EOF
sub_2
EOF
echo ""

./sub save tmux.conf testinput/subfolder testinput/subfolder/tmux.conf << EOF
mouse_on
other_sub
EOF
echo ""
sed 's/mouse on/mouse off/g' testinput/subfolder/tmux.conf > /tmp/out && mv /tmp/out testinput/subfolder/tmux.conf
./sub save tmux.conf testinput/subfolder testinput/subfolder/tmux.conf << EOF
mouse_off
EOF
echo ""

./sub clean test.html testinput/ testinput/test.html testinput/test_clean.html
./sub clean tmux.conf testinput/subfolder testinput/subfolder/tmux.conf testinput/subfolder/tmux_clean.conf

./sub make test.html testinput/ testinput/test_clean.html testoutput/test_out.html << EOF
2
EOF
echo ""
./sub make tmux.conf testinput/subfolder testinput/subfolder/tmux_clean.conf testoutput/subfolder/tmux_out.conf << EOF
1
1
EOF
echo ""
echo ""


echo "Tests:"
echo "No output = all tests passed"

echo "		<!-- Start Substitute - HTML_Test -->
		<ul>one line</ul>
		<ul>two line</ul>
		<!-- End Substitute -->" > /tmp/testfile
diff /tmp/testfile testinput/HTML_Test-Substitution-sub1-test.html
echo "		<!-- Start Substitute - HTML_Test -->
		<ul>one line</ul>
		<ul>other line</ul>
		<!-- End Substitute -->" > /tmp/testfile
diff /tmp/testfile testinput/HTML_Test-Substitution-sub_2-test.html

echo "# Start Substitute - tmux_Test
set -g mouse on
# End Substitute" > /tmp/testfile
diff /tmp/testfile testinput/subfolder/tmux_Test-Substitution-mouse_on-tmux.conf
echo "# Start Substitute - tmux_Test
set -g mouse off
# End Substitute" > /tmp/testfile
diff /tmp/testfile testinput/subfolder/tmux_Test-Substitution-mouse_off-tmux.conf

echo "# Start Substitute - Other
option 1
option 2
option 3
# End Substitute" > /tmp/testfile
diff /tmp/testfile testinput/subfolder/Other-Substitution-other_sub-tmux.conf

echo "<p>
	<h1>h1</h1>
	<li>
		<ul>thing</ul>
		<ul>thing2</ul>
		<ul>thing3</ul>
		<!-- Start Substitute - HTML_Test -->
		<ul>thing6</ul>
	</ul>
</p>
" > /tmp/testfile
diff /tmp/testfile testinput/test_clean.html
echo "bind -n C-Tab select-window -n
bind -n C-BTab select-window -p
# Start Substitute - tmux_Test
set -g escape-time 0

# Start Substitute - Other
option 4
option 5
" > /tmp/testfile
diff /tmp/testfile testinput/subfolder/tmux_clean.conf
echo "<p>
	<h1>h1</h1>
	<li>
		<ul>thing</ul>
		<ul>thing2</ul>
		<ul>thing3</ul>
		<!-- Start Substitute - HTML_Test -->
		<ul>one line</ul>
		<ul>other line</ul>
		<!-- End Substitute -->
		<ul>thing6</ul>
	</ul>
</p>
" > /tmp/testfile
diff /tmp/testfile testoutput/test_out.html

echo "bind -n C-Tab select-window -n
bind -n C-BTab select-window -p
# Start Substitute - tmux_Test
set -g mouse off
# End Substitute
set -g escape-time 0

# Start Substitute - Other
option 1
option 2
option 3
# End Substitute
option 4
option 5
" > /tmp/testfile
diff /tmp/testfile testoutput/subfolder/tmux_out.conf

make clean > /dev/null
rm -rf testinput/
rm -rf testoutput/
