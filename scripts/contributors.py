#/usr/bin/env python3

# Find total contributors on all repositories of a github user (WIP)

# TODO
# 1. Add basic auth handlers (Done)
# 2. Generate & write reports to a file
# 3. Handle pagination
# 4. Clean up error handling
# 5. Fetch User's Organisation

import urllib.parse
import urllib.request
import json, sys

HEADERS = {"User-Agent": "Mozilla/5.0"}

base_url = "https://api.github.com"
repo_contributors_url = ""


def request(url):
    req = urllib.request.Request(url, headers=HEADERS)
    with urllib.request.urlopen(req) as response:
        res = json.loads(response.read().decode("utf-8"))
        if response.headers["link"] is not None:
            #print(response.headers["link"].split(";"))
            header_links = response.headers["link"].split(',')[0].split(';')
            if header_links[1] == ' rel="next"':
                print(header_links)
                next_url = header_links[0]
                next_url = next_url[1:len(next_url)]
        else:
            next_url = None

    return res, next_url

# with open('contributors.json', 'w') as file:
# 	json.dump(repo_list, file)

def handle_pagination(url):
    res_list = []
    res, next_url = request(url)
    res_list += res
    while next_url:
        res, next_url = request(next_url)
        if next_url is None:
            break
        else:
            print("got new url")
            res_list += res

    return res_list


def find_user_repos(user):
    repo_list = []
    try:
        repos = handle_pagination(
            f"{base_url}/users/{user}/repos?type=owner&per_page=100"
        )
        for repo in repos:
            if repo["fork"] is False:
                repo_list.append(repo)
    except urllib.error.HTTPError as e:
        if e.code == 403:
            print("GitHub API rate limit exceeded. Only 60 requests/hour")
            exit()
        else:
            pass

    return repo_list


def find_contributors(repo_list, user):
    contributor_list = []
    total_contributors = 0
    for repo in repo_list:
        try:
            contributors = handle_pagination(
                f"""{base_url}/repos/{user}/{repo["name"]}/contributors?per_page=100"""
            )
            ccon = 0
            for con in contributors:
                if con["login"] != user and con["type"] != "Bot":
                    ccon += 1
            print(f"""Contributors in {repo["name"]}: {ccon}""")
        except urllib.error.HTTPError as e:
            if e.code == 403:
                print("GitHub API rate limit exceeded. Only 60 requests/hour")
                exit()
            else:
                print(f"No contributors in {repo['name']}")
                pass
        total_contributors += ccon

    print(f"Total Contributors in {user}'s repos : {total_contributors}")

    return contributor_list


def find_first_contributors(contributors, user, user_repos):
    contributor_list = []
    for contrib in contributors:
        first_pr, paginate = request(
            f"{base_url}/search/issues?q=author%3A{user}+is:pr&sort=created&order=asc"
        )
        contributor_list.append(first_pr[0])

    for pr in contributor_list:
        if pr["repository_url"] in user_repos:
            count += 1

    print(
        f"Total Contributors who made their first ever PR in {user}'s repos : {count}"
    )


if __name__ == "__main__":
    # yeah i will use argparse later
    if len(sys.argv) < 2:
        print("Please provide Github username")
        exit()
    elif len(sys.argv) == 3:
        HEADERS["Authorization"] = f"token {sys.argv[2]}"
    else:
        print("No token provided, requests will be limited by GitHub")

    user = sys.argv[1]
    print(f"Fetching {user}'s repositories ...")
    repositories = find_user_repos(user)
    print(f"Fetching contributors ...")
    contributors = find_contributors(repositories, user)
