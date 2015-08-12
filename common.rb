REGEX = %r{github\.com/([^/]+/[^/]+)/issues/(\d+)}
# https://github.com/username/reponame/issues/2
# -> username/reponame, 2
def parse_issue_url(url)
  if md = REGEX.match(url)
    [md[1], md[2]]
  end
end
