# BCERP Project
This project is a collaboration between the UNC School of Information and Library Science and the UNC Breast Cancer and the Environment Research Program (BCERP).

## Goals
One goal of the project is to increase the awareness of breast cancer risks among young, African-American women. 

## Technology
* Ruby
 * Gems
  * Sinatra
  * DataMapper
  * JSON
* SQLite3

### Technical Details
The schema for the SQLite database is in schema.rb. The DataMapper models are stored in models.rb.

To rebuild the tables (and wipe the current data) in the database,
set the rebuild_tables flag to true. This will have to be set to false after that, in order to prevent clearing out the database every time the app starts. 

Questions are referenced with a group_id column, rather than their primary key. The reason for this is so that several questions can be fetched for displaying on a single page (URL), such as
asking users for height and weight. Each questions POSTs its answer to the same URL used for the GET request. The POST data is sent in an array of answers[], where each key represents a
question_id and each value in the array is a question_option_id. The naming scheme follows from the DataMapper models, so "question_option_id"
represents the ID column of the QuestionOption model (or "question_options" table).

###### Good to Know
The ruby gems rerun and shotgun do not work inside a Vagrant VM, as they won't pick up on file changes made on the host machine.