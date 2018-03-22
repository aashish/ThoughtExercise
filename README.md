Thought Exercise:
=================

Requirement:
------------

Design and Describe a system to process a file/stream of JSON content in a non-serial manner, persist the records to a transactional data store, and log a “Finished” event upon persistence of the final record. The goal is to minimize processing time and actively recognize processing completion, without losing data. Communicate your design using any mediums you deem necessary or effective. (eg. Descriptive English language, Illustrations, Pseudocode, etc.)

- Assume you have control of the file/stream.
- Assume that the JSON total size is on the order of multiple gigabytes or larger, with variable record schema and size,
- Assume that the Transactional persistence mechanism may be intermittently unavailable and also when available has the potential to
reject individual records.
- Individual records can fail persistence. If they do fail, the process should continue and the failure facts should not be lost, in order to
attempt remediation.
- Please include a description of how the remediation process could work.
- Be sure to describe stack component expectations and feel free to make specific component recommendations that meet your needs. eg.
"This component should be an in-memory store. Redis would be a good choice."

Example of a JSON stream of records.  in the form:

```
[
{
“id”: 1,
“awesome_attribute”: “awesome attribute value”,
“dynamic_attribute”: “is lucky to be here”
},
{
“id”: 2,
“awesome_attribute”: “stellar attribute value”,
“tubular_attribute”: {
“has_tubes”: “Totally”,
“which_tubes”: [3,5,7,4]
}
},
...
]
```

(Record content specifics are given only as examples of structural potential in JSON. Aside from the “id” attribute they have no semantic bearing
on the problem other than that they are variable.)

Details of the approach to above requirement:
---------------------------------------------

The current code is basic implementation of processing very large json file to a transactional data store. For achieving the above requirement I choose MongoDB to store individual records. This code uses `gem 'json-stream'` to process large json data in chunks and `gem 'mongo'` to connect to MongoDB. Based on the format above of json file the code processes each record and saves it to MongoDB.
For Graphical illustration please open 'ThoughtExercise Illustration.png' file. Please download [companies.json](http://ge.tt/6MtEJ9p2)

Run:
----

```
$ ruby process.rb
```

Todo:
-----
Error and Exception handling
Connection pooling
DB clustering
