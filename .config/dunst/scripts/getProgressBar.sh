#!/usr/bin/bash
# getProgressBar <Total Items> <Current Value> <Max Value>
# For example:
# getProgressBar 10 30 100
# ───|───────
# Note it is not advised to not use unconvential values for Total Items.
# Values such as 35 will not be able to perfectly divide into two sections.
# See https://en.wikipedia.org/wiki/Box-drawing_character

num_items="$1"
current_value="$2"
max_value="$3"

bar_section="─"
delimeter="|"

# Generate section of bar before delimeter
filled_percent=$(echo $current_value"/"$max_value | bc -l)
num_filled=$(printf "%.0f\n" $(echo $filled_percent"*"$num_items | bc -l))
start_bar=$(seq -s $bar_section 0 $num_filled | sed 's/[0-9]//g')
end_bar=""
for i in $(seq 1 $(($num_items-${#start_bar})))
do
	end_bar=$end_bar$bar_section
done
echo $start_bar$delimeter$end_bar
