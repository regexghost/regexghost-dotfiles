from howlongtobeatpy import HowLongToBeat
import sys
import json

BOLD = "\033[1m"
RESET = "\033[0m"
RED = "\033[31m"
GREEN = "\033[32m"
YELLOW = "\033[33m"
BLUE = "\033[34m"
MAGENTA = "\033[35m"
CYAN = "\033[36m"


def printHelp():
	print("Usage: " + sys.argv[0].split("/")[-1] + " [-a = all] <game_name> (quotes optional)")

if len(sys.argv) == 1 or sys.argv[1] == "-h" or sys.argv[1] == "--help" or (sys.argv[1] == "-a" and len(sys.argv) == 2):
	printHelp()
	exit(0)

args = sys.argv[1:]

all = False
outputJson = False
while args[0].startswith("-"):
	if args[0] == "-a":
		all = True
	if args[0] == "-j":
		outputJson = True
	if len(args) == 1:
		printHelp()
		exit(1)
	args = args[1:]


gameName = ' '.join(args).rstrip()

if not outputJson:
	print("Searching for game: " + gameName)

results = HowLongToBeat().search(gameName)

length = len(results)

if results == None or length == 0:
	if outputJson:
		print("[]")
	else:
		print("No results")
	exit(1)

if not all and length > 5:
	results = results[:5]
	length = 5

if outputJson:
	output = []
	for result in results:
		game = {
			"game_name": result.game_name,
			"main_story": result.main_story,
			"main_extra": result.main_extra,
			"completionist": result.completionist,
		}
		output.append(game)
	print(json.dumps(output, indent=2, sort_keys=True, default=str))
else:
	print("")
	for i, result in enumerate(results):
		print(f'{BOLD}{GREEN}{result.game_name}{RESET}')
		print(f'{BOLD}{BLUE}Main Story:{RESET}    {BOLD}{result.main_story}{RESET} hours')
		print(f'{BOLD}{CYAN}Main + Extra:{RESET}  {BOLD}{result.main_extra}{RESET} hours')
		print(f'{BOLD}{MAGENTA}Completionist:{RESET} {BOLD}{result.completionist}{RESET} hours')
		if not i == length - 1:
			print("")
