#!/usr/bin/env python3

# Utility to list a github user's pull requests in a nicely readable markdown file with 0 dependencies.
#
# Usage: ./my-prs.py <username>
# Note that you will need commonmarker to render this md file (or just paste it in github readme)
#
# TODO:
# - Handle Pagination (Done)
# - Concurrent requests

import urllib.parse
import urllib.request
import json, sys, os
from dateutil import parser

HEADERS = {"User-Agent": "Mozilla/5.0"}


def parse_link_header(link_header):
    header_links = link_header.split(",")[0].split(";")
    if header_links[1] == ' rel="next"':
        next_page = header_links[0]
        # yo why tf response headers are normal ?
        next_page = next_page[1 : len(next_page) - 1]
    else:
        next_page = None

    return next_page


def request(url):
    req = urllib.request.Request(url, headers=HEADERS)
    with urllib.request.urlopen(req) as response:
        res = json.loads(response.read().decode("utf-8"))
        if response.headers["link"] is not None:
            next_url = parse_link_header(response.headers["link"])
        else:
            next_url = None

    return res, next_url


def handle_pagination(url):
    res_list = []
    while True:
        res, next_url = request(url)
        res_list += res
        if next_url is None:
            break
        url = next_url

    return res_list


def get_user_repos(username):
    # Why ?, to eliminate contributions to self repos
    repo_list = []
    repos, paginate = handle_pagination(
        f"https://api.github.com/users/{username}/repos?type=owner&per_page=100"
    )
    for repo in repos:
        if repo["fork"] is False:
            repo_list.append(repo["url"])

    return repo_list


if __name__ == "__main__":
    if len(sys.argv) != 2:
        print("Needs a github username as an argument")
        exit()
    else:
        user = sys.argv[1]

    user_repos = []
    print("Fetching User Repositories ...")
    user_repos = get_user_repos(user)
    # get all pull requests of a user
    print("Fetching {0}'s Pull Requests ...".format(user))
    pull_requests, paginate = handle_pagination(
        f"https://api.github.com/search/issues?q=author%3A{user}+type%3Apr&per_page=100"
    )

    with open(f"{user}-pull-requests.md", "w") as file:
        file.write(
            f"## [{user}](https://github.com/{user})'s open source contributions 🌟\n\n"
        )
        file.write("<ol>")
        for pr in pull_requests["items"]:
            if pr["repository_url"] not in user_repos:
                created_date = parser.parse(pr["created_at"]).strftime("%d %b, %Y")
                file.write("\n<li>")
                file.write(
                    f"""<a target="_blank" href="{pr['html_url']}">{pr['title']}</a> in <b>{os.path.basename(pr['repository_url'])}</b> on <i>{created_date}</i> \n\n"""
                )
                file.write(f"<details><summary>Description</summary>\n\n")
                file.write(f"{pr['body']}\n</details>\n\n")
                file.write("</li>")
        file.write("</ol>\n\n")

    print(f"Saving context in {user}-pull-requests.md ✅")
