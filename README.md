# Redmine Issue Tags plugin [![Build Status](https://travis-ci.org/efigence/redmine_issue_tags.svg?branch=master)](https://travis-ci.org/efigence/redmine_issue_tags)

#### Plugin which adds tagging functionality to issues. Features:

* adding public/private tags
* displaying public/private tags in sidebar (issue page, project issues list, global issues list)
* filter by tags
* three new role permissions: `manage public tags`, `view public tags`, `manage private tags`

#### Requirements

Developed and tested on Redmine 3.0.3.

#### Installation

1. Go to your Redmine installation's plugins/ directory.
2. `git clone https://github.com/efigence/redmine_issue_tags`
3. Restart Redmine.

#### Usage

* view and add new tags from sidebar.
* click on a tag and you'll see a list of all issues with this tag.
* filter issues by multiple tags from native redmine filter menu (added `private tags` and `public tags` filters).
* `[public tags manager]` detach public tag from issue on issue page.
* `[public tags manager]` detach public tag from all issues in a project on project settings tags tab.
* `[private tags manager]` attach/detach private tags to a single issue.

#### Permissions

* Assign new permissions to desired roles in administration panel.
* `view public tags` -  view all public tags.
* `manage public tags` -  add and delete public taggings for a specific issue and project globally (issue sidebar / project settings -> tags tab)
* `manage private tags` - add private tags, see them globally, per project, per issue, delete them

#### License

    Redmine Issue Tags plugin
    Copyright (C) 2015  efigence S.A.

    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program.  If not, see <http://www.gnu.org/licenses/>.
