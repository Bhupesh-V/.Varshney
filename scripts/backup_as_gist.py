#!/usr/bin/env python3

# File Backup as Gist
# Script to backup files as a GitHub Gist with 0 dependency

# Usage:
# 1. Make sure you have a Personal Access Token with Gist Scope
# 2. Create a file named .env.json in your home directory with contents:
# {"GITHUB_TOKEN": "<your-token>" }
# 3. Run script: python backup_as_gist.py <file-to-backup>

import urllib.request
import json, sys
from datetime import datetime
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


def request(url, data=None, method=None):
    if method == "PATCH":
        req = urllib.request.Request(url, data=data, headers=HEADERS)
        req.get_method = lambda: "PATCH"
    elif method == "POST":
        req = urllib.request.Request(url, data=data, headers=HEADERS)
    else:
        req = urllib.request.Request(url, headers=HEADERS)
    with urllib.request.urlopen(req) as response:
        res = json.loads(response.read().decode("utf-8"))
    return res, response.code


def get_backup(filename):
    # Get Gist id if we already have a backup
    print("📦 Checking for backup ...")
    res, _ = request(url=f"{base_url}/gists")
    for gist in res:
        if filename in gist["files"]:
            updated_date = datetime.strptime(
                gist["updated_at"], "%Y-%m-%dT%H:%M:%SZ"
            ).strftime("%d %b %Y")
            print(f"""✔️  Found File backup ({updated_date})""")
            gid = gist["id"]
            break
        gid = None
    return gid


def read_token():
    env_path = Path.home() / ".env.json"
    if env_path.is_file():
        secrets = json.loads(env_path.read_text())
        if "GITHUB_TOKEN" in secrets:
            HEADERS["Authorization"] = f"token {secrets['GITHUB_TOKEN']}"
        else:
            print("GITHUB_TOKEN not found in .env.json")
            exit()
    else:
        print("No .env.json file found in home directory")
        exit()


def controller(filepath):
    userfile = Path(filepath)
    content["files"] = {userfile.name: {"content": userfile.read_text()}}
    gist_id = get_backup(userfile.name)

    if gist_id is not None:
        print("📤 Updating ...")
        res, code = request(
            f"{base_url}/gists/{gist_id}", json.dumps(content).encode("utf-8"), "PATCH"
        )
    else:
        print(f"No backup found for file: {filepath}")
        print("Creating Backup ...")
        res, code = request(
            f"{base_url}/gists", json.dumps(content).encode("utf-8"), "POST"
        )
    if code == 200 or code == 201:
        print("Success! 😃")


if __name__ == "__main__":
    if len(sys.argv) == 1:
        print("No file path provided 👀")
        exit()
    read_token()
    controller(sys.argv[1])
