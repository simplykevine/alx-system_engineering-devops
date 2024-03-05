#!/usr/bin/python3
"""docs"""
import requests


def recurse(subreddit, hot_list=[], after=None):
    """"Doc"""
    url = "https://www.reddit.com/r/{}/hot.json" \
        .format(subreddit)
    header = {'User-Agent': 'Mozilla/5.0'}
    param = {'after': after}
    resopnse = requests.get(url, headers=header, params=param)

    if resopnse.status_code != 200:
        return None
    else:
        json_res = resopnse.json()
        after = json_res.get('data').get('after')
        has_next = \
            json_res.get('data').get('after') is not None
        hot_articles = json_res.get('data').get('children')
        [hot_list.append(article.get('data').get('title'))
         for article in hot_articles]

        return recurse(subreddit, hot_list, after=after) \
            if has_next else hot_list
