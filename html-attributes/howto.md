- Google: "list of html attributes"

- On 2014-May-19, scraped the list from
  https://developer.mozilla.org/en-US/docs/Web/HTML/Attributes
  the following way: (this was on OS X)

- Copied the HTML of table.standard-table via Google Chrome "Inspect Element".

- Used Sublime Text to remove all '<p>...</p>' tags (just '<p>' and '</p>',
  not the content).

- Saved as html-attributes.html in this directory.

- Opened html-attributes.html (via Ctrl-O) in Chrome again.

- Copied the page content via Cmd-A, Cmd-C.

- In OpenRefine 2.6-beta.1, created a new project and imported the
  clipboard data as line-based text data.

- Proceded as per the undo history extracted in openrefine-history.json.

- Exported (via 'Templating') as a standard JSON file to html-attributes.json.

- Run convert-json.coffee to generate html-attributes-by-tag.json.
