from howlongtobeatpy import HowLongToBeat
import sys

BOLD = "\033[1m"
RESET = "\033[0m"
RED = "\033[31m"
GREEN = "\033[32m"
YELLOW = "\033[33m"
BLUE = "\033[34m"
MAGENTA = "\033[35m"
CYAN = "\033[36m"

if len(sys.argv) == 1 or sys.argv[1] == "-h" or sys.argv[1] == "--help" or (sys.argv[1] == "-a" and len(sys.argv) == 2):
	print("Usage: " + sys.argv[0].split("/")[-1] + " [-a = all] <game_name> (quotes optional)")
	exit(0)

all = False
gameName = ' '.join(sys.argv[1:])
if sys.argv[1] == "-a":
	all = True
	gameName = ' '.join(sys.argv[2:])

print("Searching for game: " + gameName)

results = HowLongToBeat().search(gameName)

length = len(results)

if results == None or length == 0:
	print("No results")
	exit(1)

print("")

if not all and length > 5:
	results = results[:5]
	length = 5

for i, result in enumerate(results):
	print(f'{BOLD}{GREEN}{result.game_name}{RESET}')
	print(f'{BOLD}{BLUE}Main Story:{RESET}    {BOLD}{result.main_story}{RESET} hours')
	print(f'{BOLD}{CYAN}Main + Extra:{RESET}  {BOLD}{result.main_extra}{RESET} hours')
	print(f'{BOLD}{MAGENTA}Completionist:{RESET} {BOLD}{result.completionist}{RESET} hours')
	if not i == length - 1:
		print("")
