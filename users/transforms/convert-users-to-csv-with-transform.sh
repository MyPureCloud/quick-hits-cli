# >> START convert-users-to-csv-with-transform Use the experimental transform feature in the CLI along with a Go template to create CSV file

########
#  This template file will be used to transform all users who have the title of Agent from a JSON to CSV format (Select fields)
#######

# Example transforms template.  Place this content into a file called users_to_csv.tmpl
{{printf "id,email,title,division,acdAutoAnswer\n" }}
{{- range . -}}{{if eq "Agent" .title}}{{printf "'%s','%s','%s','%s','%t'\n" .id .email .title .division.name .acdAutoAnswer}}{{end}}{{end}}

# GC CLI command invoking the template 
gc users list -a --transform code/users_to_csv.tmpl

>> END convert-users-to-csv-with-transform
