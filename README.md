# IQ300 Frontend Static project
------

## Notes

active_admin.scss is not included (see main project)

## Development

`bundle install` first.

`bundle exec middleman` starts a server on `0.0.0.0:4567` (liveupdate included).

`bundle exec middleman build` builds a static site in `build` folder.

---

## Data and content

Data is stored in `data` folder in .yml files

Access data in templates with `= data.yml_file.key...` objects, like `= data.projects.first.title`

