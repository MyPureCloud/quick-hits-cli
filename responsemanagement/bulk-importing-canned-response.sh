# >> START create_response_from_files An example of how create a canned response using the Genesys Cloud CLI

# This is an example of how to create a canned response using the Genesys Cloud CLI.
Step 1:  Create the Libraries: echo '{"name": "Bulk Example Library","version": 1}' | gc responsemgt libraries create | jq -r .id
Step 2: From the response, copy the Id generated for your new Library:

{
  "id": "1adacdea-9543-4b00-b48d-5776dr34c4fe",      <<<< Sample Id, use yours!!
  "name": "Bulk Example Library",
  "version": 1,
  "createdBy": {
    "id": "",
    "selfUri": ""
  },
  "dateCreated": "",
  "selfUri": ""
}

Step 3: Create your canned responses files using the following templates. 

{
   "name": "Response Name",
   "version": 1,
   "libraries": [
      {
         "id": "Your LibraryId ",
         "name": "",
         "selfUri": ""
      }
   ],
   "texts": [
      {
         "content": "Your Response text goes here",
         "contentType": "text/html"
      }
   ]
}

#Step 4> Create the Responses: 
for f in canned*;do cat "$f" | gc responsemgt responses create;done

# this command will read all the files created in Step3, in this example filename convention was canned1.js, canned2.js and so on. Feel free to use your own filenames.


# >> END create_response_from_files