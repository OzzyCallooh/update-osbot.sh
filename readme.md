# update-osbot.sh

by [agentcallooh](https://osbot.org/forum/profile/342261-agentcallooh/)

**[update-osbot.sh](update-osbot.sh)** is an easy-to-use bash script that updates the [OSBot](https://osbot.org) client, downloading new versions when necessary. Use it before running OSBot via its command-line interface (CLI) to ensure the client is up to date before you start it.

This script works out-of-the-box on most Linux distributions, such as Ubuntu. For Windows, you will need a bash interpretter, such Git BASH included with [gitforwindows](https://gitforwindows.org/#bash).

## Usage

```bash
# Create or update ~/OSBot/osbot.jar
$ bash update-osbot.sh
# Update an existing jar: 
$ bash path/to/osbot.jar
```

Run the script using [`bash`](https://en.wikipedia.org/wiki/Bash_(Unix_shell)). You can provide the name of an existing jarfile to be updated. If not provided, it assumes `~/OSBot/osbot.jar` and creates the directory if it doesn't exist.

Tip: Add the executable permission to the script and you can invoke the file by name easily!

```bash
$ chmod +x update-osbot.sh
$ ./update-osbot.sh
```

### Examples

For each of these, the current version was OSBot 2.5.83 ([download](http://osbot.org/devbuilds/osbot%202.5.75.jar)).

#### Running on Fresh Install

```bash
$ bash update-osbot.sh
```

#### Result

```
Creating directory: /home/ozzy/OSBot
Downloading from https://osbot.org/mvc/get to /home/ozzy/OSBot/osbot.jar...
Checking downloaded version...
Downloaded: 2.5.83
```

### Running on Existing Up-to-date Install

```bash
$ bash update-osbot.sh
```

#### Result

```
Checking version of /home/ozzy/OSBot/osbot.jar...
Up-to-date: 2.5.83
```

### Running on Existing Out-of-date Install

This command was run with OSBot 2.5.75 in `~/OSBot/osbot.jar`.

```bash
$ bash update-osbot.sh
```

#### Result

```
Checking version of /home/ozzy/OSBot/osbot.jar...
Out-of-date: 2.5.75
Backing up /home/ozzy/OSBot/osbot.jar to /home/ozzy/OSBot/osbot.jar-backups/2.5.75.jar
Downloading from https://osbot.org/mvc/get to /home/ozzy/OSBot/osbot.jar...
Checking downloaded version...
Downloaded: 2.5.83
```

## Notes

* The script will download using `curl` if available, otherwise it will use `wget`.
* The latest version is downloaded from `https://osbot.org/mvc/get`
* This script relies on OSBot's `-version` CLI argument, which was implemented in [OSBot 2.5.61](https://osbot.org/forum/topic/157318-dev-build-osbot-2561). Versions before this **cannot** be updated by this script. 
	* Additionally, the script relies on the format returned, which may change in the future. For this script to work, it must be of the form: `Current=2.5.75, Latest=2.5.83`

## License

This script is licensed under [CC BY-SA 4.0](https://creativecommons.org/licenses/by-sa/4.0/). Note: if you remix, transform or build upon the material, you must distribute your contrubtions under the same license as the original.
