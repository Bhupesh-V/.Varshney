#!/usr/bin/env python3

# Utility to list a github user's pull requests in a nicely readable markdown file with 0 dependencies.
#
# Usage: ./my-prs.py <username>
# Note that you will need commonmarker to render this md file (or just paste it in github readme)
#

import urllib.request
import json, sys, os
from datetime import datetime
from collections.abc import Mapping

HEADERS = {"User-Agent": "Mozilla/5.0"}


def parse_link_header(link_header):
    header_links = link_header.split(",")[0].split(";")
    if header_links[1] == ' rel="next"':
        next_page = header_links[0]
        # yo why tf response headers are not normal ?
        next_page = next_page[1 : len(next_page) - 1]
    else:
        next_page = None

    return next_page


def request(url):
    req = urllib.request.Request(url, headers=HEADERS)
    with urllib.request.urlopen(req) as response:
        res = json.loads(response.read())
        if response.headers["link"] is not None:
            next_url = parse_link_header(response.headers["link"])
        else:
            next_url = None

    return res, next_url


def handle_pagination(url):
    res_list = []
    while True:
        res, next_url = request(url)
        if isinstance(res, Mapping):
            # check if response is dict like
            res_list += res["items"]
        else:
            res_list += res
        if next_url is None:
            break
        url = next_url

    return res_list


def get_user_repos(username):
    # eliminate contributions to self repos
    print("Fetching User Repositories ...")
    repos = handle_pagination(
        f"https://api.github.com/users/{username}/repos?type=owner&per_page=100"
    )
    repo_list = [repo["url"] for repo in repos]

    return repo_list


def get_user_prs(username):
    # get all pull requests of a user
    print(f"Fetching {username}'s Pull Requests ...")
    pull_requests = handle_pagination(
        f"https://api.github.com/search/issues?q=author%3A{username}+type%3Apr&per_page=100"
    )
    return pull_requests


def generate_report(repos, prs):
    with open(f"{user}-pull-requests.md", "w") as file:
        file.write(
            f"## [{user}](https://github.com/{user})'s open source contributions 🌟\n\n"
        )
        file.write("<ol>")
        for pr in prs:
            if pr["repository_url"] not in repos:
                created_date = datetime.strptime(
                    pr["created_at"], "%Y-%m-%dT%H:%M:%SZ"
                ).strftime("%d %b, %Y")
                file.write("\n<li>")
                file.write(
                    f"""<a target="_blank" href="{pr['html_url']}">{pr['title']}</a> in <b><a href="{pr['html_url'][:pr['html_url'].rfind('/pull/')]}">{os.path.basename(pr['repository_url'])}</a></b> on <i>{created_date}</i> \n\n"""
                )
                file.write(f"<details><summary>Description</summary>\n\n")
                file.write(f"{pr['body']}\n</details>\n\n")
                file.write("</li>")
        file.write("</ol>\n\n")

    print(f"Saving context in {user}-pull-requests.md ✅")


if __name__ == "__main__":
    if len(sys.argv) != 2:
        print("Needs a github username as an argument")
        exit()
    else:
        user = sys.argv[1]

    user_repos = get_user_repos(user)
    user_prs = get_user_prs(user)
    generate_report(user_repos, user_prs)
