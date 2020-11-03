#/usr/bin/env python3

# Find total contributors on all repositories of a github user (WIP)

# TODO
# 1. Add basic auth handlers
# 2. Generate & write reports to a file
# 3. Handle pagination
# 4. Clean up error handling

import urllib.parse
import urllib.request
import json

HEADERS = {"User-Agent": "Mozilla/5.0"}

# Add "?per_page=200" to find more contributors

base_url = "https://api.github.com"
repo_contributors_url = ""
pull_request = "https://api.github.com/search/issues?q=author%3A{username}+is:pr&sort=created&order=asc"


def request(url):
    req = urllib.request.Request(url, headers=HEADERS)
    with urllib.request.urlopen(req) as response:
        res = json.loads(response.read().decode("utf-8"))
        if response.headers["link"] is not None:
            paginate = response.headers["link"].split(";")
        else:
            paginate = None

    return res, paginate

# with open('contributors.json', 'w') as file:
# 	json.dump(repo_list, file)


def find_user_repos(user):
    repo_list = []
    try:
        repos, paginate = request(
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
            contributors, paginate = request(
                f"""{base_url}/repos/{user}/{repo["name"]}/contributors"""
            )
            ccon = 0
            for con in contributors:
                if con["login"] != user:
                    ccon += 1
            print(f"""Contributors in {repo["name"]}: {con}""")
        except urllib.error.HTTPError as e:
            if e.code == 403:
                print("GitHub API rate limit exceeded. Only 60 requests/hour")
                exit()
            else:
                print(f"No contributors in {repo['name']}")
                pass
        total_contributors += con

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
    user = "Bhupesh-V"
    print(f"Fetching {user}'s repositories ...")
    repositories = find_user_repos(user)
    print(f"Fetching contributors ...")
    contributors = find_contributors(repositories, user)
