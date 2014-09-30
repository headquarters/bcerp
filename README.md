# BCERP Project
This project is a collaboration between the UNC School of Information and Library Science (SILS) and the UNC Breast Cancer and the Environment Research Program (BCERP). 

## Goals
The goal of the project is to increase the awareness of breast cancer risks among young, African-American women through a mobile-friendly website that works across devices.

## Technology
* Ruby
 * Gems
  * Sinatra
  * DataMapper
  * JSON
  * Rerun (for local development)
* SQLite3
* Zurb Foundation

### Technical Details
The schema for the SQLite database is in schema.rb. The DataMapper models are stored in models.rb.

If content in the database has to change, update schema.rb with the content changes and run `ruby schema.rb`. 

Questions are referenced with a group_id column, rather than their primary key. The reason for this is so that several questions can be fetched for displaying on a single page (URL), such as
asking users for height and weight. Each question POSTs its answer to the same URL used for the GET request. The POST data is sent in an array of answers[], where each key represents a
question_id and each value in the array is a question_option_id. The naming scheme follows from the DataMapper models, so "question_option_id"
represents the ID column of the QuestionOption model (or "question_options" table).

#### First Run
`ruby schema.rb`

`rerun app.rb`