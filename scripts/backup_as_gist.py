# File Backup as Gist
# Script to backup files as a GitHub Gist with 0 dependency
#
# Usage:
# 1. Make sure you have a Personal Access Token with Gist Scope
# 2. Create a file named .env & save your token in it (just token, nothing else)
# 3. Run script: python backup_as_gist.py <file-to-backup>

import urllib.request
import json, sys, os
from pathlib import Path

HEADERS = {
    "Accept": "application/vnd.github.v3+json",
    "Content-Type": "application/json",
}
base_url = "https://api.github.com"

# By default upload gist as a Secret
content = {
    "description": "",
    "public": False,
    # "files": {"test": {"content": "# title"}},
}

def create(url, data):
    # Create a New File Backup
    req = urllib.request.Request(url, data=data, headers=HEADERS)
    with urllib.request.urlopen(req) as response:
        res = json.loads(response.read().decode("utf-8"))
        print("Success! 😃")

def get(filename):
    # Get Gist id if we already have a backup
    print("📦 Checking for backup ...")
    req = urllib.request.Request(f"{base_url}/gists", headers=HEADERS)
    with urllib.request.urlopen(req) as response:
        res = json.loads(response.read().decode("utf-8"))
    for gist in res:
        if filename in gist["files"]:
            print("Found File backup with id:", gist["id"])
            gid = gist["id"]
            break
        gid = None
    return gid

def update(gist_id, data):
    # Update gist file
    req = urllib.request.Request(f"{base_url}/gists/{gist_id}", data=data, headers=HEADERS)
    req.get_method = lambda: 'PATCH'
    with urllib.request.urlopen(req) as response:
        res = json.loads(response.read().decode("utf-8"))
        print("Success! 😃")

def read_token():
    env_path = Path.home() / ".env"
    if env_path.is_file():
        HEADERS["Authorization"] = f"token {env_path.read_text().rstrip()}"
    else:
        print("No .env file found in home directory")
        exit()


def controller(filepath):
    userfile = Path(filepath)
    filename = userfile.name
    file_content = userfile.read_text()
    content["files"] = {filename: {"content": file_content}}
    gist_id = get(filename)

    if gist_id is not None:
        print("Updating Gist:", filename)
        update(gist_id, json.dumps(content).encode("utf-8"))
    else:
        print(f"No backup found for file: {filename}")
        print("Creating Backup ...")
        create(f"{base_url}/gists", json.dumps(content).encode("utf-8"))

if __name__ == "__main__":
    if len(sys.argv) == 1:
        print("No file path provided 👀")
        exit()
    read_token()
    controller(sys.argv[1])
